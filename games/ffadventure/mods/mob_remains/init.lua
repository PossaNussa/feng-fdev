-- mob_remains
--
-- village_life gave killed villagers a body: a `bones:bones` node with their
-- name on it and the things they carried inside. Every other humanoid in the
-- world just puffed a few loose drops and vanished. This mod extends the same
-- courtesy to them -- zombies, gnolls, sea-monsters, the mung and men of
-- lottmobs, and anything else flagged humanoid: when one dies it leaves a named
-- skeleton holding whatever it would have dropped.
--
-- Two deliberate constraints:
--
--   * The loot is unchanged. We do NOT invent a drop table. mobs redo has
--     already rolled each `drops` entry at its own chance -- honouring looting
--     level, the killed-by-player gate on rare items, and the cook-on-hot-death
--     rule -- by the time it hands us the result. We only decide where those
--     items go: into a body instead of scattered on the floor. A zombie's bones
--     hold exactly what a zombie drops, no more likely and no less.
--
--   * The body is individual. The node stores a display name so the reclaimed
--     bones item reads "Thorn's Bones" or "Zombie's Bones" -- see
--     bones.place_corpse / corpse_item in the bones mod, which does the stamping.
--
-- The single hook is in creaturemob's mob_class:item_drop(): for a humanoid it
-- collects the rolled stacks and calls mob_remains.place() rather than throwing
-- them on the ground. Non-humanoids are untouched.

mob_remains = {}

local enabled = minetest.settings:get_bool("mob_remains_enable") ~= false

--------------------------------------------------------------------------------
-- Who leaves a skeleton
--------------------------------------------------------------------------------
--
-- "Humanoid" here means flesh-and-bone people-shaped things. Golems are
-- constructs and animals aren't people-shaped, so neither is in the list; a
-- stone golem leaving a rib cage would be absurd. The list is explicit rather
-- than a heuristic precisely so it never misfires on those.
--
-- To extend it: a mob def can set `humanoid = true` (or `false` to opt a listed
-- mob out), which wins over everything here. Otherwise a name is matched against
-- this set, then these patterns. `lottmobs:pigman_trader` is intentionally
-- absent -- village_life already gives those their own richer body, and adding a
-- second here would bury two corpses for one death.

local HUMANOID = {}
for _, name in ipairs({
	-- zombies mod: the undead and the beast-men. Golems, hamsters, parrots,
	-- fish and axolotls from the same mod are deliberately left out.
	"zombies:zombie", "zombies:1arm", "zombies:crawler", "zombies:normal",
	"zombies:draugr", "zombies:seazombie", "zombies:seamonster", "zombies:mummy",
	"zombies:undeadknight", "zombies:badguy", "zombies:gnoll", "zombies:cyclops",
	"zombies:bigape", "zombies:buffpig", "zombies:froghman", "zombies:frarcher",
	"zombies:lionman", "zombies:lion_warrior", "zombies:cheetahman",
	"zombies:cheetahwarrior", "zombies:cheetarcher",
	-- lottmobs: the peoples of Middle-earth. pigman_trader omitted on purpose.
	"lottmobs:dwarf", "lottmobs:dwarf_trader", "lottmobs:elf", "lottmobs:elf_trader",
	"lottmobs:human_trader", "lottmobs:mung_guard", "lottmobs:mung_trader",
	"lottmobs:nune_guard", "lottmobs:troll", "lottmobs:battle_troll",
}) do
	HUMANOID[name] = true
end

-- Broader rules for whole families where an exact list would rot as the mod
-- grows. Kept short and specific.
local HUMANOID_PATTERNS = {}

-- Never, regardless of the above -- constructs have no bones to leave.
local NOT_HUMANOID_PATTERNS = {
	"golem",
}

local function name_matches(name, patterns)
	for _, pat in ipairs(patterns) do
		if name:find(pat) then return true end
	end
	return false
end

-- Should this mob leave a skeleton on death?
function mob_remains.is_humanoid(self)
	if not self or not self.name then return false end
	-- Explicit per-mob decision wins.
	if self.humanoid ~= nil then return self.humanoid end
	if self._skeleton ~= nil then return self._skeleton end
	local name = self.name
	if name_matches(name, NOT_HUMANOID_PATTERNS) then return false end
	if HUMANOID[name] then return true end
	return name_matches(name, HUMANOID_PATTERNS)
end

-- The hook creaturemob's item_drop calls to decide whether to collect drops
-- into a body instead of scattering them.
function mob_remains.should_collect(self)
	return enabled and mob_remains.is_humanoid(self)
end

--------------------------------------------------------------------------------
-- What to call the body
--------------------------------------------------------------------------------

-- "zombies:seamonster" -> "Seamonster", "lottmobs:mung_guard" -> "Mung Guard".
local function prettify(name)
	local short = name:match(":([%w_]+)$") or name
	short = short:gsub("_", " ")
	return short:gsub("(%a)([%w]*)", function(first, rest)
		return first:upper() .. rest
	end)
end

-- The name stamped on the body. An individual's own name if it has one -- a
-- village_life villager, a tamed pet, a named goblin -- otherwise the kind of
-- thing it was.
function mob_remains.display_name(self)
	local named = self.game_name        -- village_life
			or (self._nametag and self._nametag ~= "" and self._nametag)   -- tamed / named
			or self.secret_name          -- goblins
	if named and named ~= "" then return named end

	-- A real description if the def gave one; otherwise prettify the entity name.
	-- (mobs redo defaults self.description to the entity name when none is set,
	-- so guard against getting "zombies:zombie" back out.)
	if self.description and self.description ~= "" and self.description ~= self.name then
		return self.description
	end
	return prettify(self.name)
end

--------------------------------------------------------------------------------
-- Placing the body
--------------------------------------------------------------------------------

-- Called from item_drop with the stacks it rolled. A player kill always leaves
-- a body -- that is the corpse you walk up to and loot. A death nobody caused
-- (dawn burning a horde of zombies, a mob drowning off-screen) leaves a body
-- only if it was actually carrying something, so environmental mass-deaths don't
-- carpet the ground with empty skeletons no one will ever visit.
function mob_remains.place(self, pos, items)
	if not enabled then return end
	items = items or {}

	local by_player = self.cause_of_death and self.cause_of_death.puncher
			and self.cause_of_death.puncher:is_player()
	if not by_player and #items == 0 then return end

	if not (bones and bones.place_corpse) then
		-- bones mod absent: don't lose the loot, scatter it the old way.
		for _, it in ipairs(items or {}) do minetest.add_item(pos, it) end
		return
	end

	local display = mob_remains.display_name(self)
	local spot = bones.place_corpse(pos, {
		display = display,
		items = items,
	})

	if not spot then
		-- No room for a body (buried in solid ground, say). The loot must still
		-- land somewhere.
		for _, it in ipairs(items or {}) do minetest.add_item(pos, it) end
	end
end
