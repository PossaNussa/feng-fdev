-- Somebody who has agreed to come with you.
--
-- They are not a pet and they are not a new mob. They are the same villager,
-- with the same identity key, the same bed row, the same family, the same
-- memory of you and the same opinions about their neighbours. Everything in
-- this mod that reads a villager still reads them; all that has changed is
-- where they are standing and who they are standing near.
--
-- That is the whole design, and it is why this file is mostly bookkeeping
-- rather than behaviour. The interesting parts:
--
--   * their bed is marked `away`, because otherwise the census sees an empty
--     bed and spawns a second copy of them;
--   * they are paid, and they notice when they are not;
--   * and being dragged about is wearing, so a companion who is never rested,
--     never paid and always bleeding will eventually go home -- which is the
--     part that makes hiring somebody a relationship rather than a purchase.

local util = village_life.util
local home = village_life.home

local companion = {}
village_life.companion = companion

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

-- Kept in `self.vl`, deliberately, and kept small.
--
-- mobs redo serialises every non-function field of `self` into the mapblock on
-- unload, so anything parked on the entity is written to disk forever. `vl` is
-- the one table that is meant to be there. Short keys for the same reason:
--
--   p     employer's name
--   since day count when they took service
--   wage  what they are owed per day
--   paid  day count they were last paid
--   order "follow" | "wait" | "home"
--   at    where they were told to wait
local function state(self)
	return self.vl and self.vl.h
end

function companion.hired_by(self)
	local h = state(self)
	return h ~= nil and h.p ~= nil
end

function companion.employer(self)
	local h = state(self)
	return h and h.p
end

function companion.order(self)
	local h = state(self)
	return (h and h.order) or "follow"
end

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

--------------------------------------------------------------------------------
-- The bed
--------------------------------------------------------------------------------

-- Marked in the bed row itself, exactly as a death is, because that row is the
-- authority on who lives where and everything else derives from it.
--
-- Without this, census.audit sees a bed that is `first_name and not dead and
-- not occupied` and refills it -- so walking your new companion out of the
-- village hands the village a second, identical copy of them. That is the same
-- trap permadeath had to solve and it is solved the same way.
local function set_away(village_id, plot_nr, bed_nr, pname)
	local bed = home.bed_data(village_id, plot_nr, bed_nr)
	if not bed then return end
	bed.away = pname
	if mg_villages.save_data then pcall(mg_villages.save_data) end
end

function companion.away(village_id, plot_nr, bed_nr)
	local bed = home.bed_data(village_id, plot_nr, bed_nr)
	return bed ~= nil and bed.away ~= nil
end

--------------------------------------------------------------------------------
-- Taking and leaving service
--------------------------------------------------------------------------------

-- What a day of somebody's time is worth, before their trade is taken into
-- account. Small on purpose: this is a wage, not a ransom, and it is meant to
-- be payable out of what a player finds rather than saved up for.
local BASE_WAGE = 6

function companion.wage_for(self)
	local r = home.resolve(self)
	local wage = BASE_WAGE
	if r and r.title and r.title ~= "" then wage = wage + 3 end
	if r and r.role == "guard" then wage = wage + 5 end
	return wage
end

function companion.engage(self, pname)
	local r = home.resolve(self)
	if not r then
		-- A bedless recruit -- a travelling adventurer or a wandering trader: no
		-- bed to mark away, no village to tell of it. They simply take service.
		-- `vl` is created here only to hold `h`; with no `v` in it they are still
		-- not a villager to the census.
		if not village_life.is_bedless_recruit(self) then return false end
		self.vl = self.vl or {}
		self.vl.h = {
			p = pname, since = today(), wage = companion.wage_for(self),
			paid = today(), order = "follow",
		}
		-- A bedless adventurer fights at your side and can be given gear; a
		-- bedded villager keeps their village role and is not armed here.
		companion.apply_loadout(self)
		village_life.log("action", (tostring(self.game_name or "adventurer")
				.. " took service with " .. pname))
		return true
	end
	if not self.vl then return false end

	self.vl.h = {
		p = pname,
		since = today(),
		wage = companion.wage_for(self),
		paid = today(),
		order = "follow",
	}

	set_away(r.village_id, r.plot_nr, r.bed_nr, pname)

	-- Somebody leaving with a stranger is news, and the village should hear it
	-- from whoever saw them go rather than from nowhere.
	if village_life.settings.gossip then
		village_life.events.raise({
			kind = "succession",
			village_id = r.village_id,
			pos = self.object and self.object:get_pos(),
			actor = pname,
			subject_name = r.name,
			detail = {title = "away with " .. pname},
		})
	end

	village_life.log("action", ("%s took service with %s"):format(
			village_life.memory.key_of(self) or "?", pname))
	return true
end

-- Leaving, for any reason. `walk_home` is what separates being dismissed at
-- the gate from quitting in a swamp: either way the bed is theirs again, but
-- one of them has a walk ahead of it.
function companion.release(self, reason)
	local h = state(self)
	if not h then return end
	local r = home.resolve(self)

	if r then
		local bed = home.bed_data(r.village_id, r.plot_nr, r.bed_nr)
		if bed then
			bed.away = nil
			if mg_villages.save_data then pcall(mg_villages.save_data) end
		end
	end

	self.vl.h = nil
	util.scratch(self).goal = nil
	village_life.log("action", ("%s left service (%s)"):format(
			village_life.memory.key_of(self) or "?", reason or "?"))
end

-- Settle a following companion into a bed in a player's town: they stop being
-- hired and become a resident there, keeping the same body, the same memory of
-- the player and the same opinions -- everything that reads a villager still
-- reads them, exactly as when they took service, only now they live somewhere
-- new. This is the walked-there other half of settlement.take_resident's
-- travel-yourself path (which spawns a fresh villager at the far end instead).
--
-- `home.bind` writes a new `self.vl = {v,p,b}` and so drops `self.vl.h`, which
-- is the release from service; there is no wage to settle because the same act
-- gives them a home.
function companion.settle(self, town_id, plot_nr, bed_nr)
	local bed = home.bed_data(town_id, plot_nr, bed_nr)
	if not bed then return false end

	-- Read who they are before anything is rewritten. A wandering trader carries
	-- its trade/gender/name off its species rather than a bed row, so fall back to
	-- that -- otherwise a dwarf who follows you home settles in with no name and no
	-- trade. Its species is recorded on the bed too, so a later respawn keeps it a
	-- dwarf (though a settled entity, being the same body, never needs respawning).
	local r = home.resolve(self)
	local sp = village_life.wanderer and village_life.wanderer.species(self)
	-- Roll and keep the trade its kind falls into (a mung as a hunter, say) before
	-- reading self.profession, so it settles as that rather than the flat "trader".
	if village_life.wanderer then village_life.wanderer.ensure_role(self) end
	local name = self.game_name or (r and r.name)
			or (sp and village_life.wanderer.name_for(self)) or "Someone"
	local title = (r and r.title) or self.profession or (sp and sp.title)
	-- An adventurer settles as its kind (a veteran stays a veteran), not the flat
	-- "adventurer" its self.profession carries -- that title also drives the skin.
	if self._adventurer and village_life.adventurer then
		title = village_life.adventurer.settle_title(self) or title
	end
	local gender = (r and r.gender) or self.gender or (sp and sp.gender) or "m"
	local generation = (r and r.generation) or 2

	-- Leave the old bed behind for good (an adventurer had none), and drop the
	-- old roster entry so the origin village reads the vacancy honestly.
	if home.is_villager(self) then
		local ob = home.bed_data(self.vl.v, self.vl.p, self.vl.b)
		if ob then village_life.settlement.clear_bed(ob) end
		home.check_out(self)
	end

	-- Write them into the new bed and rebind the living entity to it.
	village_life.settlement.clear_bed(bed)
	bed.first_name = name
	bed.title = title
	bed.gender = gender
	bed.generation = generation
	-- The species the census would revive them as, matching the travel-in path.
	bed.species = self.name

	home.bind(self, town_id, plot_nr, bed_nr)
	self.id = "vl_" .. home.key(town_id, plot_nr, bed_nr)
	self.game_name = name
	self.profession = title or self.profession
	home.check_in(self)
	if village_life.apply_role then village_life.apply_role(self) end
	if mg_villages.save_data then pcall(mg_villages.save_data) end

	village_life.log("action", ("%s settled in %s"):format(name, town_id))
	return true
end

--------------------------------------------------------------------------------
-- Wages
--------------------------------------------------------------------------------

-- Days of unpaid wages before they stop believing you.
local PATIENCE = 2

function companion.owed(self)
	local h = state(self)
	if not h then return 0 end
	local days = today() - (h.paid or today())
	if days <= 0 then return 0 end
	return days * (h.wage or BASE_WAGE), days
end

function companion.pay(self, pname)
	local h = state(self)
	if not h or h.p ~= pname then return false, "You owe me nothing." end

	local owed = companion.owed(self)
	if owed <= 0 then
		return false, "You're square with me. Keep it."
	end

	local player = minetest.get_player_by_name(pname)
	if not player then return false end
	local stack = player:get_wielded_item()
	if not stack or stack:is_empty() then
		return false, ("You're holding nothing. You owe me %d."):format(owed)
	end

	-- Priced the same way everything else in this mod is priced, so a coin is
	-- worth what the counter says a coin is worth.
	local per = village_life.economy.value_of(stack:get_name())
	local worth = per * stack:get_count()
	if worth < owed then
		return false, ("That's not %d, and you know it."):format(owed)
	end

	player:set_wielded_item(ItemStack(""))
	h.paid = today()

	village_life.memory.remember(self, pname, "gift")
	village_life.memory.nudge_mood(self, 8, "paid")
	return true, "Right. That's that, then. Where to?"
end

--------------------------------------------------------------------------------
-- Wear and tear
--------------------------------------------------------------------------------

-- Mood is the morale bar; there is no second one. It already drifts back
-- towards a baseline set by their temperament, is already what decides whether
-- they will confide in you, and is already what colours everything they say --
-- so a tired, unpaid companion is audibly a tired, unpaid companion in every
-- line they speak, without a word of it being written twice.
local TICK = 20

function companion.tick(self, r, dtime)
	local h = state(self)
	if not h then return end

	if not util.every(self, "companion", TICK, dtime) then return end

	local pname = h.p
	local player = pname and minetest.get_player_by_name(pname)

	-- Their employer logged out. Not a betrayal, so no grudge: they wait.
	if not player then
		h.order = "wait"
		return
	end

	local pos = self.object and self.object:get_pos()
	local ppos = player:get_pos()

	-- Out after dark, in the rain, a long way from any bed. It is not cruelty,
	-- it is a long day, and it adds up.
	local hour = util.hour()
	if hour >= 21 or hour < 5 then
		village_life.memory.nudge_mood(self, -1.5, "kept out at night")
	end
	if pos and village_life.schedule.weather_severity(pos) == "severe"
			and not util.has_roof(pos) then
		village_life.memory.nudge_mood(self, -1, "out in the weather")
	end

	-- Hurt and not healing. rest.lua already does the healing; this is only
	-- how they feel about it.
	local hp_max = (self.prop and self.prop.hp_max) or self.hp_max or 25
	if self.health and self.health < hp_max * 0.4 then
		village_life.memory.nudge_mood(self, -2, "badly hurt")
	end

	local owed, days = companion.owed(self)
	if owed > 0 then
		village_life.memory.nudge_mood(self, -2 * (days or 1), "unpaid")
	end

	-- Enough. Two days unpaid, or worn down past the point where anybody would
	-- keep going, and they say so and walk home.
	local mood = village_life.memory.mood(self)
	local quit_reason
	if days and days > PATIENCE then
		quit_reason = "unpaid"
	elseif mood <= -42 then
		quit_reason = "worn out"
	end

	if quit_reason then
		companion.quit(self, quit_reason)
	end
end

local QUIT_LINES = {
	unpaid = "I've not seen a coin in days. I'm going home. Don't follow me.",
	["worn out"] = "I can't do this any more. I'm sorry. I'm going home.",
}

function companion.quit(self, reason)
	local h = state(self)
	if not h then return end
	local pname = h.p
	local r = home.resolve(self)

	if pname then
		minetest.chat_send_player(pname, "[NPC] <" ..
				(self.game_name or (r and r.name) or "Villager") .. "> " ..
				(QUIT_LINES[reason] or QUIT_LINES["worn out"]))
	end

	-- They keep nothing of yours: what you armed them with drops where they
	-- stand, so quitting is not the same as walking off with your sword.
	companion.drop_gear(self)

	-- Word gets round that you do not pay. This is the one place a companion's
	-- treatment reaches back to the village they came from.
	if village_life.settings.gossip and r and pname then
		village_life.events.raise({
			kind = "theft",
			village_id = r.village_id,
			pos = self.object and self.object:get_pos(),
			actor = pname,
			subject_name = r.name,
		})
	end

	companion.release(self, reason)
end

--------------------------------------------------------------------------------
-- Fighting, and the gear you give them
--------------------------------------------------------------------------------

-- What a companion is worth in a fight before you hand them anything, by the
-- kind of adventurer they are. A wayfarer is a traveller who can hold a knife;
-- a barbarian or a retired soldier is another thing entirely.
local SUBTYPE_COMBAT = {
	wayfarer  = {damage = 3, hp = 24},
	veteran   = {damage = 7, hp = 40},
	barbarian = {damage = 8, hp = 44},
	pirate    = {damage = 5, hp = 30},
	sailor    = {damage = 4, hp = 28},
}

-- A weapon adds to the swing. Read straight off the tool's own numbers so a
-- steel sword beats a stone one exactly as it does in a player's hand, scaled
-- down a little because a hireling is not a hero. Returns nil for anything that
-- is not a weapon.
local function weapon_bonus(name)
	if not name or name == "" then return nil end
	local def = minetest.registered_items[name]
	local caps = def and def.tool_capabilities
	local fleshy = caps and caps.damage_groups and caps.damage_groups.fleshy
	if not fleshy or fleshy <= 0 then return nil end
	return {damage = math.max(1, math.min(12, math.floor(fleshy * 0.7))), reach = 0.4}
end

-- Armour is worn as extra hide -- more to cut through -- rather than fighting
-- the mob framework's own damage model. The material sets how much, read from
-- the item name so this needs no table of every armour mod's internals.
local ARMOR_HP = {
	wood = 4, cactus = 5, leather = 5, bronze = 8, gold = 8, steel = 10,
	diamond = 14, mithril = 16, crystal = 16, nano = 18, carbon = 18,
}

local function is_armor(def)
	if not def or not def.groups then return false end
	for g in pairs(def.groups) do
		if g:sub(1, 6) == "armor_" then return true end
	end
	return false
end

local function armor_bonus(name)
	if not name or name == "" then return nil end
	local def = minetest.registered_items[name]
	if not is_armor(def) then return nil end
	local hp = 6
	for mat, v in pairs(ARMOR_HP) do
		if name:find(mat, 1, true) then hp = v ; break end
	end
	return {hp = hp}
end

-- Which body slot a piece of armour fills, so a person wears a whole set -- a
-- helm AND a breastplate AND greaves -- rather than a single "armour" item that
-- the next piece replaces. Read from 3d_armor's own groups; an unrecognised
-- piece falls into one generic slot (so at least one of it can be worn).
local ARMOR_GROUPS = {
	"armor_head", "armor_torso", "armor_legs", "armor_feet", "armor_hands",
	"armor_shield",
}
local function armor_slot(name)
	local def = minetest.registered_items[name]
	if def and def.groups then
		for _, g in ipairs(ARMOR_GROUPS) do
			if (def.groups[g] or 0) > 0 then return g end
		end
	end
	return "armor"
end

-- A gearstore's armour, always as a list of item names. Migrates the old
-- single-string form (a world saved before the set existed) on read, so no
-- separate migration pass is needed.
local function armor_names(h)
	local a = h and h.armor
	if not a or a == "" then return {} end
	if type(a) == "string" then return {a} end
	return a
end

-- Total hide added by everything they are wearing.
local function total_armor_hp(h)
	local hp = 0
	for _, name in ipairs(armor_names(h)) do
		local ab = armor_bonus(name)
		if ab then hp = hp + ab.hp end
	end
	return hp
end

-- Public, so brain.lua's village_life.arm can fold a settled resident's kit into
-- their defence stats without duplicating the material tables.
companion.weapon_bonus = weapon_bonus
companion.armor_bonus = armor_bonus
companion.armor_names = armor_names
companion.armor_hp = function(h) return total_armor_hp(h) end

-- Where a person's kept gear lives. Someone in your service carries it on their
-- hire record; a settled townsperson carries it on their bed row, which
-- mg_villages serialises -- so their kit survives a restart and a respawn.
-- An adventurer with neither has nowhere to keep it, so it cannot be armed until
-- it takes service (which gives it a hire record).
function companion.gearstore(self)
	local h = state(self)
	if h then return h end
	local r = village_life.home.resolve(self)
	return (r and r.bed) or nil
end

-- Turn the companion's kind and whatever they are carrying into live combat
-- stats. Idempotent: it recomputes from the base every time, so removing gear
-- takes the bonus back off. Called when they are hired, whenever their gear
-- changes, and periodically from the follow step (entity fields reset on every
-- reload, so the loadout has to be re-asserted, not set once).
function companion.apply_loadout(self)
	local h = state(self)
	if not h then return end

	local sub = (village_life.adventurer and village_life.adventurer.subtype(self))
			or "wayfarer"
	local base = SUBTYPE_COMBAT[sub] or SUBTYPE_COMBAT.wayfarer

	local damage, reach, hp = base.damage, 2.4, base.hp
	local wb = weapon_bonus(h.weapon)
	if wb then damage = damage + wb.damage ; reach = reach + (wb.reach or 0) end
	hp = hp + total_armor_hp(h)

	-- Fights monsters at your side; never other players, never the animals you
	-- are out hunting yourself.
	self.attack_monsters = true
	self.attack_players = false
	self.attack_npcs = false
	self.attack_animals = false
	self.passive = false
	self.damage = damage
	self.reach = reach
	self.view_range = math.max(self.view_range or 0, 14)
	-- Keep up. The "dainty escort" feel was a companion ambling while you ran;
	-- give them a real pace and let the follow step choose walk or run.
	self.run_velocity = math.max(self.run_velocity or 0, 3.0)
	self.walk_velocity = math.max(self.walk_velocity or 0, 1.4)

	if hp and h.hp_max ~= hp then
		self.object:set_properties({hp_max = hp})
		if self.health and self.health < hp then self.health = hp end
		h.hp_max = hp
	end

	companion.update_visuals(self)
end

--------------------------------------------------------------------------------
-- Showing the gear: a weapon in the hand, armour on the body
--------------------------------------------------------------------------------

-- A held item is a small "wielditem" entity attached to the mob's right-hand
-- bone -- the same trick tph_wielditem plays for the player. It works on any mesh
-- whose right-hand bone is named "Arm_Right": the pigman villager (character.b3d),
-- the settled dwarf/human/elf traders (lottarmor_character.b3d) and the beastmen
-- (the zombie-family models the lion/cheetah/frog/gnoll folk are built on, all
-- verified to carry that bone). The mung (mobs_mc_villager.b3d) and the trolls
-- (troll_model.x) have their own skeletons with no such bone -- and a couple of
-- creatures use creatures_mob.x, whose bone is "Armature_Arm_Right" instead --
-- so those carry their kit in their stats but not in their hands, the one case
-- the player was told to expect. Attaching to a bone the mesh lacks would hang
-- the weapon at the mob's feet, so the gate is a strict allowlist, not a guess.
local WIELD_ENTITY = "village_life:held_weapon"
local HAND_MESHES = {
	["character.b3d"] = true,
	["lottarmor_character.b3d"] = true,
	["Zombielion.b3d"] = true,
	["zombie_normal.b3d"] = true,
}
-- Armour is drawn by compositing 3d_armor's own on-body textures over the mob's
-- skin, exactly as it is drawn on a player. That needs the mesh to share the
-- character.b3d UV map the armour textures were cut for -- and the beastmen do:
-- they are built on the same humanoid model as the villagers, cross-compatible
-- with the same skins, so the armour lands right on them too. Same for the
-- settled traders. Only the mung and the trolls, on their own skeletons, wear
-- their armour in their stats rather than on their skin.
local BODY_MESHES = {
	["character.b3d"] = true,
	["lottarmor_character.b3d"] = true,
	["zombie_normal.b3d"] = true,
	["Zombielion.b3d"] = true,
}

-- The mesh a mob is drawn with, read off its registered prototype.
local function mesh_of(self)
	local proto = minetest.registered_entities and minetest.registered_entities[self.name]
	return proto and proto.mesh
end

-- The wielditem ObjectRef lives in a runtime table keyed by the entity, never on
-- `self`: creaturemob serialises every plain field of self to disk on unload, and
-- an ObjectRef must not be written there. On reload apply_role re-asserts the
-- loadout, which rebuilds the visual from the stored gear.
local wield_objs = setmetatable({}, {__mode = "k"})

local function drop_wield(self)
	local obj = wield_objs[self]
	if obj and obj.get_pos and obj:get_pos() then obj:remove() end
	wield_objs[self] = nil
	self._vl_wield_item = nil
end
companion.drop_wield = drop_wield

function companion.update_wield(self)
	if not HAND_MESHES[mesh_of(self)] then return end
	if not minetest.add_entity then return end     -- headless test harness
	local weapon = (companion.gear(self))
	if not weapon or weapon == "" then
		drop_wield(self)
		return
	end
	local obj = wield_objs[self]
	if obj and obj.get_pos and obj:get_pos() and self._vl_wield_item == weapon then
		return                                      -- already showing this weapon
	end
	drop_wield(self)
	local pos = self.object and self.object:get_pos()
	if not pos then return end
	obj = minetest.add_entity(pos, WIELD_ENTITY, weapon)
	if not obj then return end
	obj:set_attach(self.object, "Arm_Right", {x = 0, y = 5.5, z = 3},
			{x = -90, y = 225, z = 90})
	wield_objs[self] = obj
	self._vl_wield_item = weapon
end

-- 3d_armor's on-body texture for an item: `def.texture`, else the item name with
-- ':' turned to '_', plus ".png" -- the same rule armor:set_player_armor uses.
local function armor_texture(name)
	local def = minetest.registered_items[name]
	local tex = (def and def.texture) or name:gsub(":", "_")
	return tex .. ".png"
end

-- Paint the worn armour onto the body by overlaying its textures on the mob's
-- own skin, the way a player wears theirs. The clean skin is whatever the mob is
-- currently drawn with (apply_role has already re-forced the pigman's career
-- skin by the time this runs), so this reads it, stacks the armour on top, and
-- never writes the composite back into base_texture -- keeping the base clean so
-- the next call starts from the skin, not from skin-plus-armour-again.
function companion.update_worn(self)
	if not BODY_MESHES[mesh_of(self)] then return end
	if not self.object or not self.object.set_properties then return end
	local base = self.base_texture
	if type(base) == "table" then base = base[1] end
	if type(base) ~= "string" or base == "" then return end

	local _, worn = companion.gear(self)
	if not worn or #worn == 0 then
		-- Nothing worn: make sure we are showing the bare skin, but only if we had
		-- painted armour on before (otherwise leave the mob's textures alone).
		if self._vl_worn then
			self.object:set_properties({textures = {base}})
			self._vl_worn = nil
		end
		return
	end

	local tex = base
	for _, n in ipairs(worn) do tex = tex .. "^" .. armor_texture(n) end
	if self._vl_worn ~= tex then
		self.object:set_properties({textures = {tex}})
		self._vl_worn = tex
	end
end

-- Both at once: the weapon in the hand and the armour on the body. Everything
-- that changed the gear calls this.
function companion.update_visuals(self)
	companion.update_wield(self)
	companion.update_worn(self)
end

if minetest.register_entity then
	minetest.register_entity(WIELD_ENTITY, {
		initial_properties = {
			physical = false, pointable = false, visual = "wielditem",
			visual_size = {x = 0.25, y = 0.25, z = 0.25},
			collisionbox = {0, 0, 0, 0, 0, 0}, static_save = false,
		},
		on_activate = function(self, staticdata)
			if staticdata and staticdata ~= "" then
				self.object:set_properties({wield_item = staticdata})
			end
			self._age = 0
		end,
		-- If the villager holding it dies or unloads, the engine detaches this
		-- item and leaves it hanging in the air. Nobody else keeps a reference to
		-- it (the owner's is dropped on death), so it has to notice for itself:
		-- once it is no longer attached to anything, it is litter -- remove it.
		on_step = function(self, dtime)
			self._age = (self._age or 0) + dtime
			if self._age < 0.5 then return end
			self._age = 0
			local parent = self.object:get_attach()
			if not parent or not parent:get_pos() then self.object:remove() end
		end,
	})
end

-- A short, clean name for an item, for the line they say back.
local function item_label(name)
	local def = minetest.registered_items[name]
	local d = def and def.description
	if d and d ~= "" then
		if minetest.strip_colors then d = minetest.strip_colors(d) end
		return (d:gsub("\n.*$", ""))
	end
	return name
end

-- Hand the companion whatever you are holding, if it is a weapon or a piece of
-- armour. One is taken from your hand; anything they were already carrying in
-- that slot is handed back. Returns ok, line.
function companion.equip(self, pname)
	local h = companion.gearstore(self)
	if not h then return false, "" end
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "" end

	local stack = player:get_wielded_item()
	local name = stack and stack:get_name()
	if not name or name == "" then
		return false, "You're holding nothing. Put something in my hand."
	end

	-- A weapon fills the single hand slot; a piece of armour joins the worn set,
	-- displacing only the piece already in the same body slot (a new helm for the
	-- old helm, not for the breastplate). `old` is whatever came off, handed back.
	local is_weapon = weapon_bonus(name) ~= nil
	local is_armor = armor_bonus(name) ~= nil
	if not is_weapon and not is_armor then
		return false, "That's no use to me -- a blade, or armour, something I can fight in."
	end

	local old
	stack:take_item(1)
	player:set_wielded_item(stack)

	if is_weapon then
		old = h.weapon
		h.weapon = name
	else
		local slot = armor_slot(name)
		local kept = {}
		for _, worn in ipairs(armor_names(h)) do
			if armor_slot(worn) == slot then old = worn else kept[#kept + 1] = worn end
		end
		kept[#kept + 1] = name
		h.armor = kept
	end

	if old and old ~= "" then
		local over = player:get_inventory():add_item("main", ItemStack(old))
		if over and not over:is_empty() then minetest.add_item(player:get_pos(), over) end
	end

	-- Re-assert combat stats so the new kit takes effect at once: a hired follower
	-- keeps fighting at your side (apply_loadout), a settled resident has it folded
	-- into their defence role (apply_role -> arm) and the bed row is saved so the
	-- kit is not lost before the next autosave.
	if state(self) then
		companion.apply_loadout(self)
	elseif village_life.apply_role then
		village_life.apply_role(self)
		if mg_villages.save_data then pcall(mg_villages.save_data) end
	end

	if is_weapon then
		return true, ("A %s. Aye, that'll do -- I'll not go easy with it."):format(item_label(name))
	end
	return true, ("%s. Better than my own hide. Obliged to you."):format(item_label(name))
end

-- Re-assert combat stats after the gear changed, by the same rule equip uses:
-- a hire keeps its loadout applied, a settled resident folds it into their role.
local function reapply(self)
	if state(self) then
		companion.apply_loadout(self)
	elseif village_life.apply_role then
		village_life.apply_role(self)
		if mg_villages.save_data then pcall(mg_villages.save_data) end
	end
end

--------------------------------------------------------------------------------
-- The kit window: an inventory grid you drag gear onto, like a chest
--------------------------------------------------------------------------------
--
-- One weapon slot and five armour slots (head/torso/legs/feet/shield), plus your
-- own pack, so you drag items straight onto the person -- give one, give a whole
-- suit, take a piece back, all by hand. The grid is a per-player detached
-- inventory; the villager's real store (bed row or hire record) holds item names
-- and is the persistent truth, so the detached list is only ever a live view of
-- it. Every drag re-reads the grid into the store and re-asserts stats + visuals,
-- exactly as handing a single item over used to.

-- Body slot each armour grid cell accepts, by index. A slot only takes its own
-- kind, so you cannot stack three helmets for triple the hide.
local ARMOR_GRID = {"armor_head", "armor_torso", "armor_legs", "armor_feet",
		"armor_hands", "armor_shield"}

-- Who each player's kit window is currently editing: the entity, so its store can
-- be found again on every drag, and its name for the title.
companion.kit_editing = {}
local kit_made = {}     -- pname -> true once its detached inventory exists

local function kit_invname(pname) return "village_life:kit_" .. pname end

-- Does item `name` belong in list `listname` slot `index`?
function companion.kit_accepts(listname, index, name)
	if not name or name == "" then return false end
	if listname == "weapon" then return weapon_bonus(name) ~= nil end
	if listname == "armor" then
		local group = ARMOR_GRID[index]
		local def = group and minetest.registered_items[name]
		return def ~= nil and def.groups ~= nil and (def.groups[group] or 0) > 0
	end
	return false
end

-- Read the grid back into the villager's store and re-assert everything. Called
-- after every drag. Safe if the villager has wandered out of range: it simply
-- does nothing rather than arming a corpse.
function companion.kit_sync(pname)
	local e = companion.kit_editing[pname]
	local self = e and e.self
	if not self or not self.object or not self.object:get_pos() then return end
	local h = companion.gearstore(self)
	if not h then return end
	local inv = minetest.get_inventory({type = "detached", name = kit_invname(pname)})
	if not inv then return end

	local wname = inv:get_stack("weapon", 1):get_name()
	h.weapon = (wname ~= "" and wname) or nil

	local list = {}
	for i = 1, #ARMOR_GRID do
		local n = inv:get_stack("armor", i):get_name()
		if n ~= "" then list[#list + 1] = n end
	end
	h.armor = list

	reapply(self)
end

-- Create the player's kit inventory once, with the drag rules wired in. The
-- callbacks fire for whoever is dragging; they refuse anyone but the owner and
-- anything that does not belong in the slot, then sync on every accepted change.
local function ensure_kit_inv(pname)
	if kit_made[pname] then return end
	if not minetest.create_detached_inventory then return end   -- headless harness
	local function owns(player)
		return player and player:get_player_name() == pname
	end
	local inv = minetest.create_detached_inventory(kit_invname(pname), {
		allow_put = function(_, listname, index, stack, player)
			if not owns(player) then return 0 end
			return companion.kit_accepts(listname, index, stack:get_name()) and 1 or 0
		end,
		allow_take = function(_, _, _, stack, player)
			return owns(player) and stack:get_count() or 0
		end,
		allow_move = function(inv2, from_list, from_index, to_list, to_index, _, player)
			if not owns(player) then return 0 end
			local name = inv2:get_stack(from_list, from_index):get_name()
			return companion.kit_accepts(to_list, to_index, name) and 1 or 0
		end,
		on_put  = function() companion.kit_sync(pname) end,
		on_take = function() companion.kit_sync(pname) end,
		on_move = function() companion.kit_sync(pname) end,
	})
	inv:set_size("weapon", 1)
	inv:set_size("armor", #ARMOR_GRID)
	kit_made[pname] = true
end

-- Fill the grid from the villager's current store.
local function fill_kit_inv(self, pname)
	local inv = minetest.get_inventory({type = "detached", name = kit_invname(pname)})
	if not inv then return end
	local h = companion.gearstore(self)
	inv:set_stack("weapon", 1, ItemStack((h and h.weapon) or ""))
	for i = 1, #ARMOR_GRID do inv:set_stack("armor", i, ItemStack("")) end
	if h then
		for _, name in ipairs(armor_names(h)) do
			-- Drop each worn piece into the slot for its body part.
			for i, group in ipairs(ARMOR_GRID) do
				local def = minetest.registered_items[name]
				if def and def.groups and (def.groups[group] or 0) > 0
						and inv:get_stack("armor", i):is_empty() then
					inv:set_stack("armor", i, ItemStack(name))
					break
				end
			end
		end
	end
end

local KIT_FORM = "village_life:kit"

-- Open the kit window for `self` in front of `pname`.
function companion.open_kit(self, pname)
	local h = companion.gearstore(self)
	if not h then return false end
	ensure_kit_inv(pname)
	companion.kit_editing[pname] = {self = self, name = self.game_name}
	fill_kit_inv(self, pname)

	local who = self.game_name or "them"
	local dn = kit_invname(pname)
	local esc = minetest.formspec_escape
	-- One label per armour cell, in ARMOR_GRID order.
	local labels = {"Head", "Body", "Legs", "Feet", "Hands", "Shield"}
	local armour_labels = {}
	for i = 1, #ARMOR_GRID do
		armour_labels[#armour_labels + 1] =
				("label[%s,1.05;%s]"):format(2.2 + (i - 1) * 1.25, esc(labels[i] or ""))
	end
	minetest.show_formspec(pname, KIT_FORM, table.concat({
		"formspec_version[4]",
		"size[11.5,10.9]",
		("label[0.5,0.5;%s]"):format(esc("Kitting out " .. who)),
		"label[0.5,1.05;Weapon]",
		("list[detached:%s;weapon;0.5,1.4;1,1]"):format(dn),
		table.concat(armour_labels),
		("list[detached:%s;armor;2.2,1.4;%d,1]"):format(dn, #ARMOR_GRID),
		"label[0.5,3.1;Your pack]",
		"list[current_player;main;0.5,3.5;8,4]",
		("listring[detached:%s;weapon]"):format(dn),
		"listring[current_player;main]",
		("listring[detached:%s;armor]"):format(dn),
		"listring[current_player;main]",
		"button_exit[9.4,9.9;1.6,0.7;done;Done]",
	}))
	return true
end

-- Tidy up when the window is closed or the player leaves: sync one last time so
-- nothing dragged in the final moment is lost, then forget the edit.
if minetest.register_on_player_receive_fields then
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= KIT_FORM then return end
		local pname = player:get_player_name()
		if fields.quit or fields.done then
			companion.kit_sync(pname)
			companion.kit_editing[pname] = nil
		end
		return true
	end)
end
if minetest.register_on_leaveplayer then
	minetest.register_on_leaveplayer(function(player)
		companion.kit_editing[player:get_player_name()] = nil
	end)
end

-- Give back everything they are carrying and strip the bonuses -- for a clean
-- dismissal, when the player is standing right there. Falls to the ground only
-- if their hands are full.
function companion.return_gear(self, pname)
	local h = companion.gearstore(self)
	if not h then return end
	local player = pname and minetest.get_player_by_name(pname)
	local give_back = {}
	if h.weapon and h.weapon ~= "" then give_back[#give_back + 1] = h.weapon end
	for _, name in ipairs(armor_names(h)) do give_back[#give_back + 1] = name end
	for _, name in ipairs(give_back) do
		if player then
			local over = player:get_inventory():add_item("main", ItemStack(name))
			if over and not over:is_empty() then minetest.add_item(player:get_pos(), over) end
		elseif self.object then
			minetest.add_item(self.object:get_pos(), ItemStack(name))
		end
	end
	h.weapon, h.armor = nil, nil
	if state(self) then
		companion.apply_loadout(self)
	elseif village_life.apply_role then
		village_life.apply_role(self)
		if mg_villages.save_data then pcall(mg_villages.save_data) end
	end
end

-- Spill their gear where they fell or stormed off, so it is recoverable when
-- the parting was not on good terms (death, or quitting unpaid).
function companion.drop_gear(self)
	local h = state(self)
	if not h then return end
	local pos = self.object and self.object:get_pos()
	if pos then
		if h.weapon and h.weapon ~= "" then minetest.add_item(pos, ItemStack(h.weapon)) end
		for _, name in ipairs(armor_names(h)) do minetest.add_item(pos, ItemStack(name)) end
	end
	h.weapon, h.armor = nil, nil
	companion.drop_wield(self)
end

-- What they are carrying, for the orders / kit menu to describe. Reads the same
-- store equip writes to, so it works for a settled resident as well as a hire.
-- Returns the weapon (a string, or nil) and the worn armour (a list of names,
-- or nil when nothing is worn).
function companion.gear(self)
	local h = companion.gearstore(self)
	if not h then return end
	local worn = armor_names(h)
	return h.weapon, (#worn > 0 and worn or nil)
end

--------------------------------------------------------------------------------
-- Where they go
--------------------------------------------------------------------------------

-- How close they try to stand, and how far they will let the player get before
-- breaking into a run. Kept short: a companion that only breaks into a run once
-- you are fourteen nodes gone spends the whole time trailing you at a walk.
local NEAR = 3.0
local RUN_AT = 7

-- The goal for a hired villager, or nil if they are not one. Consulted at the
-- very top of schedule.decide, because somebody who has taken service is no
-- longer living their village's day -- they do not go to the forge at nine and
-- they do not run to their own front door when something growls, because their
-- front door is half a valley away.
function companion.goal(self, r, pos)
	local h = state(self)
	if not h then return end

	local order = h.order or "follow"

	if order == "wait" then
		return {kind = "wait", pos = h.at or pos, speed = "walk",
				companion = true}
	end

	if order == "home" then
		-- A bedless adventurer has no home to walk to: "go home" is simply the
		-- parting of ways, and they are released on the spot.
		if not r then
			companion.release(self, "parted ways")
			return
		end
		-- Walking themselves back. On arrival they simply stop being hired,
		-- and the village schedule has them again.
		if r.sleep_pos and util.dist_flat(pos, r.plot_centre or r.sleep_pos) < 8 then
			companion.release(self, "came home")
			return
		end
		return {kind = "gohome", pos = r.plot_centre or r.sleep_pos,
				speed = "walk", companion = true}
	end

	local player = h.p and minetest.get_player_by_name(h.p)
	if not player then
		return {kind = "wait", pos = pos, speed = "walk", companion = true}
	end

	local ppos = player:get_pos()
	if not ppos then return end

	local d = util.dist_flat(ppos, pos)
	if d < NEAR then
		-- Close enough. Stand, and face them, which is what a person does.
		return {kind = "attend", pos = pos, face_pos = ppos, speed = "walk",
				companion = true}
	end

	return {
		kind = "follow",
		pos = ppos,
		speed = d > RUN_AT and "run" or "walk",
		companion = true,
	}
end

--------------------------------------------------------------------------------
-- Dying in service
--------------------------------------------------------------------------------

-- They trusted you and it killed them. Their village is told, with your name on
-- it, and succession takes the bed as it would for any other death -- so the
-- consequence is the ordinary one, arriving through the ordinary machinery.
function companion.on_death(self, killer_name)
	local h = state(self)
	if not h then return end
	local r = home.resolve(self)
	local pname = h.p

	-- Their gear falls with them, for you to take back off the body.
	companion.drop_gear(self)

	-- The bed has to stop being "away" before succession is told, or the row
	-- carries both marks and the census cannot tell which it is.
	companion.release(self, "died in service")

	if not village_life.settings.reputation or not r or not pname then return end

	-- Killed by something else while in your employ is not murder, but it is
	-- your fault they were there. Killed by you is exactly what it looks like.
	local blame = (killer_name == pname) and 1.0 or 0.4
	village_life.reputation.adjust(r.village_id, pname,
			-50 * blame, "companion died in service")
end

return companion
