-- Sleep and recovery.
--
-- Two things a villager could not do. The schedule has always walked them to
-- the foot of their own bed at nightfall and then left them standing there,
-- because mobs redo has no notion of getting into one. And nothing ever healed
-- them: a villager mauled by a zombie in spring was still on two hit points in
-- autumn, so the first raid a village survived left it permanently one bite
-- from being wiped out.
--
-- Lying down is done exactly the way beds/functions.lua does it to a player --
-- the body centred between the two halves of the bed, just clear of the
-- mattress, turned along the bed and playing the `lay` animation of
-- character.b3d. It is the same mesh the player wears, so a villager in a bed
-- looks like a player in a bed.

local util = village_life.util
local nav  = village_life.nav

local rest = {}
village_life.rest = rest

--------------------------------------------------------------------------------
-- Tuning
--------------------------------------------------------------------------------

-- character.b3d's lying-down pose. player_api registers the same frames for
-- the player; mobs redo picks animations out of `self.animation` by name, so
-- these are written onto the prototype at load and used as "lay".
local LAY_START, LAY_END = 162, 166

-- Clear of the tallest bed nodebox (the simple bed's top face is at +0.0625),
-- the same figure beds/functions.lua uses to keep a player from sinking in.
local BED_Y = 0.07

-- How close a villager must already be before they will get into bed. Getting
-- in is a small teleport onto the mattress, and one that could cross a wall
-- would let a villager who never reached their room sleep in it anyway.
local BED_REACH = 3

-- Recovery. A wound has to be left alone before it closes, so a villager being
-- worn down in a fight does not heal through it.
local HURT_CALM = 20
local HEAL_TICK = 10
local HEAL_UP   = 1  -- on their feet
local HEAL_ABED = 3  -- asleep in their own bed

--------------------------------------------------------------------------------
-- The bed
--------------------------------------------------------------------------------

-- The bed node at a position, or nil. Group `bed` is 1 for the foot and 2 for
-- the head, which is how the two halves are told apart -- mg_villages records
-- the foot (its `cottages:bed_foot` is replaced by `beds:fancy_bed_bottom`),
-- but adopting a villager into a bed placed by hand should work either way.
local function bed_at(pos)
	if not pos then return end
	local node = minetest.get_node_or_nil(pos)
	if not node then return end
	local def = minetest.registered_nodes[node.name]
	local half = def and def.groups and def.groups.bed
	if not half then return end
	return node, half
end

-- Where the sleeper goes, and the facedir to turn them along, or nil if there
-- is no longer a bed there. A bed that was dug out, or a plot the player
-- rebuilt, leaves the villager standing beside where it used to be.
function rest.bed_slot(bed_pos)
	local node, half = bed_at(bed_pos)
	if not node then return end

	local p2 = (node.param2 or 0) % 4
	local dir = minetest.facedir_to_dir(p2)
	if not dir then return end

	-- The body lies across both halves, so it is centred half a node towards
	-- the other one: forwards from the foot, backwards from the head. If that
	-- half is missing the bed is broken and the one node we have will do.
	local step = (half == 2) and -0.5 or 0.5
	local mate = {
		x = bed_pos.x + dir.x * step * 2,
		y = bed_pos.y,
		z = bed_pos.z + dir.z * step * 2,
	}
	if not bed_at(mate) then step = 0 end

	return {
		x = bed_pos.x + dir.x * step,
		y = bed_pos.y + BED_Y,
		z = bed_pos.z + dir.z * step,
	}, p2
end

function rest.abed(self)
	return util.scratch(self).abed == true
end

--------------------------------------------------------------------------------
-- Getting in and out
--------------------------------------------------------------------------------

-- Hold the pose. nav.idle would put the stand animation back on the very next
-- step, so the sleeping branch never goes through it.
local function hold(self)
	self:set_velocity(0)
	self.state = "stand"
	self:set_animation("lay")
end

-- Called from the brain once a villager with a `sleep` goal has arrived.
-- Returns true when they are in bed, false when there is nothing to get into
-- and the caller should leave them standing.
function rest.sleep(self, r)
	local s = util.scratch(self)

	if s.abed then
		hold(self)
		return true
	end

	if not village_life.settings.rest then return false end

	local pos = self.object:get_pos()
	if not pos then return false end

	local slot, p2 = rest.bed_slot(r and r.bed_pos)
	if not slot or util.dist(pos, slot) > BED_REACH then return false end

	s.abed = true
	-- Drop whatever route is still live: the walk is over, and a stale one
	-- would keep nudging a sleeper across the mattress.
	nav.clear(self)
	self.object:set_pos(slot)
	-- Snapped rather than turned over a few steps, because the model is about
	-- to lie down and a body rotating in bed reads as a glitch.
	local dir = minetest.facedir_to_dir(p2)
	if dir then
		self:set_yaw(minetest.dir_to_yaw(dir) - (self.rotate or 0), 0)
	end
	hold(self)
	return true
end

-- Out of bed. Called whenever the goal stops being `sleep` -- morning, a raid,
-- a storm -- before anything tries to walk them anywhere.
--
-- They are not moved off the mattress: bed nodes are walkable and only ankle
-- high, so the first path of the morning starts from a spot a mob can stand in
-- and steps down off it. Teleporting them to the bedside instead risks putting
-- them through a wall in a room the schematic laid out more tightly than we
-- assume.
function rest.rise(self)
	local s = util.scratch(self)
	if not s.abed then return end
	s.abed = nil
	self:set_animation("stand", true)
end

--------------------------------------------------------------------------------
-- Recovery
--------------------------------------------------------------------------------

-- Anything that hurt them, from the brain's do_punch hook. Environmental
-- damage does not come through here, which is the right answer: a villager
-- standing in a fire should not be waiting out a cooldown, they should be
-- losing the race.
function rest.note_hurt(self)
	util.scratch(self).hurt_at = util.now()
end

-- Add health, the way mobs redo does when a mob is fed: `self.health` is the
-- real figure and the object's own hp is kept in step for the HUD. Returns the
-- amount actually given.
function rest.heal(self, amount, hp_max)
	if not self.health or not amount or amount <= 0 then return 0 end

	hp_max = hp_max or (self.prop and self.prop.hp_max) or self.hp_max
	if not hp_max or self.health >= hp_max then return 0 end

	local given = math.min(amount, hp_max - self.health)
	self.health = self.health + given
	if self.object.set_hp then self.object:set_hp(self.health) end
	-- The nametag is coloured by health and is only ever repainted when
	-- something takes a bite out of them; without this a villager who has
	-- recovered keeps a red name for the rest of their life.
	if self.update_tag then self:update_tag() end
	return given
end

function rest.tick(self, r, dtime)
	if not village_life.settings.rest then return end
	if not util.every(self, "heal", HEAL_TICK, dtime) then return end

	-- creaturemob refreshes self.prop once a second, but it does so *after*
	-- do_custom -- and the brain returns false from do_custom on every step, so
	-- for a villager that refresh never happens. hp_max would then read as
	-- whatever the entity activated with, and a guard promoted to 40 by
	-- apply_role would be clamped back to 25 by the first thing that hit them.
	local props = self.object.get_properties and self.object:get_properties()
	if props then self.prop = props end
	local hp_max = (props and props.hp_max) or (self.prop and self.prop.hp_max)
			or self.hp_max
	if not hp_max or not self.health or self.health >= hp_max then return end

	local s = util.scratch(self)
	if s.hurt_at and util.now() - s.hurt_at < HURT_CALM then return end

	rest.heal(self, s.abed and HEAL_ABED or HEAL_UP, hp_max)
end

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

-- The mob was registered without a lying-down animation because nothing ever
-- asked it to lie down. character.b3d has had the frames all along.
minetest.register_on_mods_loaded(function()
	local proto = minetest.registered_entities["lottmobs:pigman_trader"]
	if not proto or not proto.animation then return end

	proto.animation.lay_start = LAY_START
	proto.animation.lay_end   = LAY_END
	-- Held, not played: the five frames are one pose.
	proto.animation.lay_speed = 0
end)
