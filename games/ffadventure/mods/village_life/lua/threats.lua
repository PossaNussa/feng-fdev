-- Threat sensing and the village alarm bus.
--
-- The naive shape of this is "every villager scans a radius for monsters".
-- With 150 villagers in a large village that is 150 get_objects_inside_radius
-- calls a second, and they all return overlapping answers.
--
-- Instead: one scan per *player* per second, because a mob only steps at all
-- inside the active block range of a player. The results are bucketed by
-- village, and everything downstream -- fleeing villagers, patrolling guards,
-- buff pigmen -- reads that shared answer.

local util = village_life.util
local threats = {}
village_life.threats = threats

--------------------------------------------------------------------------------
-- Classification
--------------------------------------------------------------------------------

-- Explicit yes/no by entity name; checked before any heuristic so a server can
-- correct a bad guess in either direction.
threats.by_name = {}

function village_life.register_threat(name, hostile)
	threats.by_name[name] = (hostile ~= false)
end

-- Predicates run in order; the first non-nil answer wins.
threats.predicates = {}

function village_life.register_threat_predicate(fn)
	table.insert(threats.predicates, fn)
end

-- Mobs redo. `type` is the mob's own declaration and is the single most
-- reliable signal in the game: every hostile mob mod sets it.
village_life.register_threat_predicate(function(ent)
	if not ent._cmi_is_mob then return end
	if ent.type == "monster" then
		-- Some critter mods register harmless flyers and bugs as "monster" --
		-- pixel_animals' hummingbird, for one, which had whole villages fleeing a
		-- bird the size of a thumb. A mob that has declared itself `passive`
		-- (mobs redo passive mobs never attack anything) and has not explicitly
		-- opted into attacking NPCs cannot actually hurt a villager, so it is no
		-- threat whatever it calls itself. Read from the registration, not the
		-- instance, for the same reason attack_npcs is, below.
		local def = minetest.registered_entities[ent.name]
		if def and rawget(def, "passive") == true
				and rawget(def, "attack_npcs") ~= true then
			return false
		end
		return true
	end

	-- A non-monster that has *explicitly* opted into attacking NPCs will
	-- happily kill a villager, whatever it calls itself.
	--
	-- Read from the registration with rawget, never from the instance:
	-- mob_class defaults `attack_npcs` to true, so `ent.attack_npcs` resolves
	-- through the metatable to true for every mob whose definition is silent
	-- on it. Testing that directly classified every cow and chicken in the
	-- game as a monster, which put villages on permanent alert.
	if ent.type ~= "animal" then
		local def = minetest.registered_entities[ent.name]
		if def and rawget(def, "attack_npcs") == true then return true end
	end

	return false
end)

-- Mobkit-based dinosaurs (paleotest) carry no type field. Carnivores fill in
-- `self.targets` at runtime with the names of everything they have decided to
-- eat, so ask whether we are on the menu rather than trying to recognise the
-- species.
village_life.register_threat_predicate(function(ent, self_name)
	local t = ent.targets
	if type(t) ~= "table" or #t == 0 then return end
	for _, n in ipairs(t) do
		if n == self_name then return true end
	end
	return nil
end)

-- Paleotest's larger carnivores, which are a threat to a village whether or
-- not they have got round to adding pigmen to their target list yet.
for _, n in ipairs({
	"carnotaurus", "dire_wolf", "sarcosuchus", "smilodon", "spinosaurus",
	"thylacoleo", "tyrannosaurus", "velociraptor",
}) do
	village_life.register_threat(n:find(":") and n or ("paleotest:" .. n))
end

local VILLAGER = "lottmobs:pigman_trader"

function threats.is_hostile(ent)
	if not ent or not ent.name then return false end
	local explicit = threats.by_name[ent.name]
	if explicit ~= nil then return explicit end
	for _, fn in ipairs(threats.predicates) do
		local answer = fn(ent, VILLAGER)
		if answer ~= nil then return answer end
	end
	return false
end

--------------------------------------------------------------------------------
-- Saying what it is
--------------------------------------------------------------------------------

-- Villagers have to be able to name what they are running from, and
-- "zombies:zombie" is not how anybody speaks. A server can override any of
-- these, and should for anything that reads badly with an article in front of
-- it -- a swarm, a proper name, a plural.
threats.labels = {}

function village_life.register_threat_label(name, label)
	threats.labels[name] = label
end

local VOWEL = {a = true, e = true, i = true, o = true, u = true}

function threats.article(word)
	if not word or word == "" then return word end
	return (VOWEL[word:sub(1, 1):lower()] and "an " or "a ") .. word
end

-- What a villager would call this thing out loud, with its article: "a
-- zombie", "an ogre". nil for anything that cannot be named -- a player, or a
-- mob that is not registered any more -- so the caller can fall back to
-- something vague rather than say a nonsense word in a sentence.
--
-- An override is returned exactly as written, article and all, because the
-- reason to write one is usually that the automatic article is wrong.
function threats.describe(name)
	if not name or name == "" or name == "player" then return end

	local override = threats.labels[name]
	if override then return override end

	-- mobs redo copies `description` onto every registered entity and defaults
	-- it to the entity name, so a description with a colon in it is the mob mod
	-- having said nothing rather than having named its mob.
	local def = minetest.registered_entities[name]
	local desc = def and rawget(def, "description")
	if type(desc) == "string" and desc ~= "" and not desc:find(":", 1, true) then
		return threats.article(desc:lower())
	end

	local word = (name:match("^[^:]+:(.+)$") or name):gsub("_", " ")
	return threats.article(word)
end

--------------------------------------------------------------------------------
-- The shared scan
--------------------------------------------------------------------------------

-- Flat list of {pos, obj, name} rebuilt each scan, and the same entries
-- bucketed by village id.
threats.list = {}
threats.by_village = {}

-- village_id -> {pos = ..., expires = util.now()}
threats.alarms = {}

local ALARM_HOLD = 25  -- seconds a village stays on alert after the last sighting

-- A hostile counts as "in the village" only if it is within this many nodes of
-- the village's build height, and no further out than the village radius. Both
-- bounds matter: without the height one, the caves under a village keep it on
-- permanent alert; without the tight radius, one monster in the outlying fields
-- locks down streets it will never reach.
threats.ALARM_MAX_DY = 10
threats.ALARM_MARGIN = 4

-- `name` is the entity name of whatever was seen, when the caller knows it.
-- It is carried on the alarm so a villager who is only running because someone
-- shouted can still say what was shouted about -- they were told, which is a
-- thing they are allowed to repeat.
function threats.raise(village_id, pos, name)
	if not village_id then return end
	local a = threats.alarms[village_id]
	local now = util.now()
	if a and a.expires > now then
		a.pos = pos
		a.expires = now + ALARM_HOLD
		-- The last thing seen, not the first: an alarm that runs on from a
		-- wolf to a zombie should be about the zombie.
		a.name = name or a.name
	else
		threats.alarms[village_id] = {pos = pos, expires = now + ALARM_HOLD,
				started = now, name = name}
		village_life.log("info", "alarm raised in village " .. village_id)

		-- A fresh alarm is somebody having seen something, which is exactly
		-- what a `sighting` is. events.KINDS declared the kind and gossip knew
		-- how to phrase it, but nothing ever raised one -- so the whole branch
		-- was dead and villagers had nothing to say about what was out there
		-- beyond the fields.
		--
		-- Only on a *new* alarm, never on the refresh above: one monster
		-- pacing the treeline for a minute is one thing that happened, not
		-- twenty.
		if village_life.settings.gossip and name then
			village_life.events.raise({
				kind = "sighting",
				village_id = village_id,
				pos = pos,
				detail = {what = threats.describe(name)},
			})
		end
	end
end

function threats.alarm(village_id)
	local a = village_id and threats.alarms[village_id]
	if not a then return end
	if a.expires <= util.now() then
		threats.alarms[village_id] = nil
		return
	end
	return a
end

-- Nearest hostile to a position, from the shared list. Cheap: the list is at
-- most a few dozen entries and is rebuilt once a second.
function threats.nearest(pos, radius)
	local r2 = radius * radius
	local best, best_d2
	for _, t in ipairs(threats.list) do
		local d2 = util.dist2(t.pos, pos)
		if d2 <= r2 and (not best_d2 or d2 < best_d2) then
			best, best_d2 = t, d2
		end
	end
	if best then return best, math.sqrt(best_d2) end
end

local scan_timer = 0

minetest.register_globalstep(function(dtime)
	scan_timer = scan_timer + dtime
	if scan_timer < 1 then return end
	scan_timer = 0

	local list = {}
	local by_village = {}
	local seen = {}
	local range = village_life.settings.active_range
	local home = village_life.home

	-- Shortlist of villages once per scan, not once per hostile: all_villages
	-- grows without limit as the world is explored.
	local shortlist = {}
	local players = minetest.get_connected_players()
	for _, player in ipairs(players) do
		local ppos = player:get_pos()
		if ppos then home.villages_near(ppos, range, shortlist) end
	end

	for _, player in ipairs(players) do
		local ppos = player:get_pos()
		if ppos then
			for _, obj in ipairs(minetest.get_objects_inside_radius(ppos, range)) do
				local ent = obj:get_luaentity()
				-- Objects near two players would otherwise be listed twice.
				if ent and not seen[ent] and threats.is_hostile(ent) then
					seen[ent] = true
					local pos = obj:get_pos()
					if pos then
						local entry = {pos = pos, obj = obj, name = ent.name}
						list[#list + 1] = entry
						local vid = home.village_in(shortlist, pos,
								threats.ALARM_MARGIN, threats.ALARM_MAX_DY)
						if vid then
							by_village[vid] = by_village[vid] or {}
							table.insert(by_village[vid], entry)
							threats.raise(vid, pos, ent.name)
						end
					end
				end
			end
		end
	end

	threats.list = list
	threats.by_village = by_village
end)

--------------------------------------------------------------------------------
-- Learning from damage
--------------------------------------------------------------------------------

-- Whatever actually hurt a villager is a threat by definition, even if none of
-- the heuristics above recognised it. This is how the mod copes with mob mods
-- it has never heard of.
function threats.note_attacker(self, hitter)
	if not hitter then return end
	-- The hitter may be a player, whose ObjectRef has get_luaentity but
	-- returns nil from it, or an arrow entity, or nothing recognisable.
	local ent = hitter.get_luaentity and hitter:get_luaentity()
	if ent and ent.name and threats.by_name[ent.name] == nil then
		-- Never auto-classify another villager or a buff pigman as a threat;
		-- friendly fire during a brawl would put a village into permanent
		-- lockdown.
		if ent.name ~= VILLAGER and ent.name ~= "zombies:buffpig" then
			village_life.register_threat(ent.name)
			village_life.log("info", "learned new threat: " .. ent.name)
		end
	end
	local pos = self.object:get_pos()
	if pos then
		local _, vid = village_life.home.village_at(pos, threats.ALARM_MARGIN,
				threats.ALARM_MAX_DY)
		if vid then
			threats.raise(vid, hitter:get_pos() or pos, ent and ent.name)
		end
	end
end
