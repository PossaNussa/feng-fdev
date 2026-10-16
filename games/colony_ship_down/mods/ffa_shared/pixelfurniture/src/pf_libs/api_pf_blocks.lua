--- STONES BLOCKS : ===============================================
-- stone  ( _mcl_hardness = 1.5,)
-- wood (_mcl_hardness = 2,

function pixelfurniture.register_glass (name,def)
core.register_node("pixelfurniture:"..name, {
    description = def.description,
    tiles = def.tiles,
    drawtype = "nodebox",
    walkable = true,
    paramtype = "light",
    sunlight_propagates = true,  
    use_texture_alpha = "blend",
    is_ground_content = false,
    paramtype2 = "wallmounted", 
    groups = {snappy = 3,glass=1}, 
    _mcl_hardness = 2,   
    node_box = {
        type = "fixed",
        fixed = {{-0.5, -0.5, -0.5, 0.5, 0.5 ,0.5}
    }}      
})
end

function pixelfurniture.register_node(name,def)
core.register_node("pixelfurniture:"..name, {
	description = def.description,
	tiles = def.tiles,
	groups = def.groups,
	_mcl_hardness = def._mcl_hardness,
	drop = "pixelfurniture:"..name,
	legacy_mineral = true,	
})

core.register_node("pixelfurniture:stair_"..name, {
	description = def.description.." Stair",
	tiles = def.tiles,
	drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
	groups = def.groups,
	_mcl_hardness = def._mcl_hardness,
	drop = "pixelfurniture:stair_"..name,
	legacy_mineral = true,		
	node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
            {-0.5, 0, 0, 0.5, 0.5, 0.5},
        },
       },
    
       on_place = core.rotate_node,
})

core.register_node("pixelfurniture:slab_"..name, {
	description = def.description.." Slab",
	tiles = def.tiles,
	drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
	groups = def.groups,
	_mcl_hardness = def._mcl_hardness,
	drop = "pixelfurniture:slab_"..name,
	legacy_mineral = true,	

	node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
        },
       },
    
})
end

function pixelfurniture.register_fence(name,def)
    core.register_node(name, {
	description = def.description,
	tiles = def.tiles,
	drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        connects_to = {"group:fence","group:wood","group:stone","group:tree","group:wall"},
	groups = def.groups,
	_mcl_hardness = def._mcl_hardness,
	drop = name,
	legacy_mineral = true,	

	node_box = {
	type = "connected",
	fixed = {-1/8, -1/2, -1/8, 1/8, 1/2, 1/8},

	connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/8 },
		        {-1/16, -5/16, -1/2,   1/16, -3/16, -1/8 }},
	connect_left =  {{-1/2,   3/16, -1/16, -1/8,   5/16,  1/16},
		        {-1/2,  -5/16, -1/16, -1/8,  -3/16,  1/16}},
	connect_back =  {{-1/16,  3/16,  1/8,   1/16,  5/16,  1/2 },
		        {-1/16, -5/16,  1/8,   1/16, -3/16,  1/2 }},
	connect_right = {{ 1/8,   3/16, -1/16,  1/2,   5/16,  1/16},
	                {1/8,  -5/16, -1/16,  1/2,  -3/16,  1/16}}
       },
    
})
end
