-----------------
-- Grow trees from saplings.
-- Make sure each tree has 2 schems, and schem name is e.g. Treename1.
local path = minetest.get_modpath("aotearoa")
local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

local random = math.random

-- Grow sapling.
function aotearoa.grow_sapling(pos, treename, stem)
	if default_loaded then
		if not default.can_grow(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Large trees that all use 15x15.
			pos = {x = pos.x - 7, y = pos.y-1, z = pos.z - 7}

			-- Place the schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	elseif zero_loaded then
		if not zr_wood.check_grow_tree(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Large trees that all use 15x15.
			pos = {x = pos.x - 7, y = pos.y-1, z = pos.z - 7}

			-- Place the schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	end
end

---------------------------
-- Grow shrub sapling.
function aotearoa.grow_shrub_sapling(pos, treename, stem)
	if default_loaded then
		if not default.can_grow(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Shrubs use 5x5.
			if treename == "mangrove" then
				pos = {x = pos.x - 7, y = pos.y-1, z = pos.z - 7}
			else
				pos = {x = pos.x - 2, y = pos.y-1, z = pos.z - 2}
			end

			-- Place schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	elseif zero_loaded then
		if not zr_wood.check_grow_tree(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Shrubs use 5x5.
			if treename == "mangrove" then
				pos = {x = pos.x - 7, y = pos.y-1, z = pos.z - 7}
			else
				pos = {x = pos.x - 2, y = pos.y-1, z = pos.z - 2}
			end

			-- Place schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	end
end

---------------------------
-- Grow bush sapling.
function aotearoa.grow_bush_sapling(pos, treename, stem)
	if default_loaded then
		if not default.can_grow(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Bushes use 3x3.
			pos = {x = pos.x - 1, y = pos.y-1, z = pos.z - 1}

			-- Place schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	elseif zero_loaded then
		if not zr_wood.check_grow_tree(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Correct position for placing based on which schem is used.
			-- Bushes use 3x3.
			pos = {x = pos.x - 1, y = pos.y-1, z = pos.z - 1}

			-- Place schematic.
			local chance = random(1,2)
			if chance == 1 then
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."1"..".mts", "random", "", false)
			else
				minetest.place_schematic(pos, path.. "/schematics/"..
						treename.."2"..".mts", "random", "", false)
			end
		end
	end
end


----------------------------------
-- Grow tree fern sapling (also palm style).
function aotearoa.grow_tree_fern_sapling(pos, treename, stem)
	if default_loaded then
		if not default.can_grow(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Place schematic from schematics file.
			local chance = random(1,2)
			local schem = nil
			if chance == 1 then
				minetest.place_schematic(pos, aotearoa[treename.."1"])
			else
				minetest.place_schematic(pos, aotearoa[treename.."2"])
			end
		end
	elseif zero_loaded then
		if not zr_wood.check_grow_tree(pos) then
			-- Try again 5 min. later.
			minetest.get_node_timer(pos):start(300)
			return
		else
			-- Remove sapling.
			minetest.set_node(pos, {name = stem})

			-- Place schematic from schematics file.
			local chance = random(1,2)
			local schem = nil
			if chance == 1 then
				minetest.place_schematic(pos, path[treename.."1"])
			else
				minetest.place_schematic(pos, path[treename.."2"])
			end
		end
	end
end
