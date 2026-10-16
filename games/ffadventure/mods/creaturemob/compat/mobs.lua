-- creaturemob :: compat/mobs.lua
--
-- Serves the full `mobs.*` / `mobs:*` API (Mobs Redo).
--
-- The engine is upstream Mobs Redo 20260730, roughly two and a half years newer
-- than the fork this game was running, with the ffadventure fork's own features
-- ported forward on top -- persistence, swimmers, smart_path, biome and climate
-- spawn filters. The FSM is untouched: `do_states`, `self.state`, and every
-- private mob_class method keep their exact names and semantics, because five
-- mods in this game drive them directly (goblins, lottmobs, zombies-master,
-- spidermob, pixel_animals).
--
-- What changed is only what those functions *write to*. See mobs/api.lua and
-- grep for "creaturemob:" and "ffadventure fork:".

local path = creaturemob.path

dofile(path .. "/mobs/api.lua")

----------------------------------------------------------------------
-- Legacy surface
--
-- Upstream deleted these between 2023 and 2026. Every one of them is still
-- called by mods in this game, or by third-party mob mods written against the
-- older API, so they are restored here rather than pushed onto consumers.
----------------------------------------------------------------------

-- The invisibility table. Upstream replaced it with a private local plus
-- mobs:is_invisible(); goblins/mtg_compat.lua:100 still does
-- `goblins.invis = mobs.invis` and indexes the result by player name.
mobs.invis = core.global_exists("invisibility") and invisibility or {}

-- Positional spawn registration, superseded by the keyword-table mobs:spawn().
-- Still the entry point for 48 call sites across this game's mods.
function mobs:register_spawn(name, nodes, max_light, min_light, chance,
		active_object_count, max_height, day_toggle)

	mobs:spawn_specific(name, nodes, {"air"}, min_light, max_light, 30,
			chance, active_object_count, -31000, max_height, day_toggle)
end

-- Free functions that predate the mob_class methods of the same name.

function mobs:yaw(entity, yaw, delay)
	return mobs.mob_class.set_yaw(entity, yaw, delay)
end

function mobs:set_animation(entity, anim)
	return mobs.mob_class.set_animation(entity, anim)
end

function mobs:line_of_sight(entity, pos1, pos2, stepsize)
	return entity:line_of_sight(pos1, pos2, stepsize)
end

function mobs:yaw_to_pos(self, target, rot)
	return self:yaw_to_pos(target, rot)
end

-- Node-damaging explosion with the default TNT sound and texture.
function mobs:explosion(pos, radius)
	mobs:boom({sounds = {explode = "tnt_explode"}}, pos, radius, radius,
			"tnt_smoke.png")
end

----------------------------------------------------------------------
-- Notes on things deliberately *not* shimmed
--
-- * `follow_stop` -- the fork's flag that stopped a following mob drifting while
--   idle. Upstream reaches the same result with the fake "standing" state in
--   follow_target(), which do_states() matches no branch of. Adding the flag on
--   top would be a second mechanism for one behaviour.
--
-- * `check_for()`'s anchored "group:" match -- the fork's fix; upstream already
--   does the same thing with str:sub(1, 6).
--
-- * `base_colbox` in the hot paths -- the fork switched away from
--   get_properties() to avoid its per-call allocation. Upstream solved it
--   differently, caching into self.prop once a second, so the optimisation is
--   already there under a different name.
--
-- * the `pathfinder` mod integration -- that mod is not installed in this game,
--   and smart_mobs() now uses creaturemob's time-sliced A*/Theta* instead of a
--   blocking search.
--
-- `mobs.mod`, `mobs.version`, `mobs.node_snow` and `mobs.node_dirt` all still
-- exist upstream and are set in mobs/api.lua. Version now reads 20260730, which
-- clears goblins' `>= 20200516` gate and both `mod == "redo"` checks.
----------------------------------------------------------------------
