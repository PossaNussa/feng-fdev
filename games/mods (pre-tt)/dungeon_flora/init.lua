-- See README.txt for licensing.

-- Namespace for functions
minetest.set_gen_notify({dungeon = true, temple = true})



minetest.register_on_generated(function(minp, maxp, blockseed)
	local gennotify = minetest.get_mapgen_object("gennotify")
	local get_node = minetest.get_node
	local is_wall = function(node)
		return node.name ~= "air" and node.name ~= "ignore" 
	end
	
	local flora = function(node)
		if 	node.name == "default:cobble" or node.name == "default:mossycobble" then
		local flora_type = math.random(1, 8)
		if flora_type <5 then return "default:grass_"..math.random(1, 5)
		elseif flora_type == 6 then return "flowers:mushroom_brown"
		elseif flora_type == 7 then return "flowers:mushroom_red"
		end
	return "default:grass_"..math.random(1, 5)
	end
	return "air"
	end
	

	local poslist = gennotify["dungeon"] or {}
	if #poslist == 0 then return end
	for i in ipairs(poslist) do

		local width = 18
		for k = 1, width do
		for j = 1, width do
			local bpos = vector.add(poslist[i], {x=k-9, y=0, z=j-9})
			local upos = vector.add(poslist[i], {x=k-9, y=-1, z=j-9})
			local node = get_node(bpos)
			local node2 = get_node(upos)
			if is_wall(node)== false then
				if is_wall(node2)==true and is_wall(node)~=true and math.random(1, 3) == 2 then
					minetest.add_node( bpos, {name = flora(node2)})
				end
			else width=k end
			
			--firefly
			local fpos = vector.add(poslist[i], {x=k-9, y=1, z=j-9})
			local node3 = get_node(fpos)
			if node3.name == "air" and math.random(1, 30) == 10 then
				minetest.add_node( fpos, {name = "fireflies:firefly"})
			end
			
		end 
		
	end

	end
end)