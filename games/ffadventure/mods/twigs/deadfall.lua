--------------------------------------------------------------------------------
-- Arctic deadfall
--------------------------------------------------------------------------------
--
-- The main twigs decoration requires `spawn_by = {"group:tree"}` -- a twig only
-- appears next to a tree it could have fallen from. That is the right rule
-- almost everywhere, but it makes the cold extreme a progression dead end:
-- tundra and icesheet are treeless by design, the only stick recipe in the game
-- is `group:wood -> 4 sticks`, and wood only comes from trees. A player who
-- spawns or travels into the arctic has no route to a stick at all, and
-- therefore no route to any tool.
--
-- This places sparse twigs on cold ground without requiring an adjacent tree --
-- deadfall carried by wind and ice rather than dropped in place. It is
-- deliberately thin: enough that foraging a stretch of tundra yields a handful
-- of sticks, not enough to make the arctic comfortable.

local S = {
	enabled = core.settings:get_bool("twigs.arctic_deadfall") ~= false,
	-- Biomes at or below this heat_point count as cold enough to strand
	-- deadfall. Tundra sits at 5 and icesheet at 0 in MTG's own biome table.
	max_heat = tonumber(core.settings:get("twigs.arctic_deadfall_max_heat")) or 20,
	fill_ratio = tonumber(core.settings:get("twigs.arctic_deadfall_fill_ratio")) or 0.004,
}

if not S.enabled then return end

core.register_on_mods_loaded(function()

	-- Pick the twig to strand. Pine reads best on snow; anything with the twig
	-- group will do if this game has no pine sapling.
	local twig = core.registered_nodes["twigs:pine_twig"] and "twigs:pine_twig"

	if not twig then
		for name, def in pairs(core.registered_nodes) do
			if def.groups and def.groups.twig then twig = name ; break end
		end
	end

	if not twig then
		core.log("info", "[twigs] no twig node registered; skipping arctic deadfall")
		return
	end

	-- Cold biomes, and the ground they actually present at the surface. Reading
	-- node_top off the biome rather than hardcoding permafrost keeps this
	-- working for the biome mods that define their own arctic ground.
	local biomes, grounds, seen = {}, {}, {}

	for name, bdef in pairs(core.registered_biomes) do
		if bdef.heat_point and bdef.heat_point <= S.max_heat then
			biomes[#biomes + 1] = name

			local top = bdef.node_top
			if top and not seen[top] and core.registered_nodes[top] then
				seen[top] = true
				grounds[#grounds + 1] = top
			end
		end
	end

	if #biomes == 0 or #grounds == 0 then
		core.log("info", "[twigs] no cold biomes found; skipping arctic deadfall")
		return
	end

	core.register_decoration({
		name = "twigs:arctic_deadfall",
		deco_type = "simple",
		place_on = grounds,
		biomes = biomes,
		sidelen = 16,
		fill_ratio = S.fill_ratio,
		y_min = 1,
		y_max = 31000,
		decoration = twig,
		-- No spawn_by: the whole point is that there is no tree to fall from.
	})

	core.log("action", ("[twigs] arctic deadfall: %s on %d ground node(s) across %d cold biome(s)")
		:format(twig, #grounds, #biomes))
end)
