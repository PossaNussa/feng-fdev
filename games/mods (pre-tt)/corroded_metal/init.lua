local S = default.get_translator

local deltaInterval = 120 -- Runs every so often (seconds)
local deltaChance = 2 -- Choose one node to modify in each selection of...

local metals = {"steel", "tin", "bronze", "copper"}
local capitalMetals = {"Steel", "Tin", "Bronze", "Copper"}

--
-- ACIDS
--

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "corroded_metal:acid_source",
	wherein        = "default:stone",
	clust_scarcity = 24 * 24 * 24,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = -256,
	y_min          = -2048,
})

-- Source

minetest.register_node("corroded_metal:acid_source", {
	description = S("Acid Source"),
	drawtype = "liquid",
	tiles = {
		{
			name = "acid_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "acid_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 10,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "corroded_metal:acid_flowing",
	liquid_alternative_source = "corroded_metal:acid_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 2 * 2,
	post_effect_color = {a = 191, r = 54, g = 255, b = 0},
	groups = {acid = 3, liquid = 3},
})

-- Flow

minetest.register_node("corroded_metal:acid_flowing", {
	description = S("Flowing Acid"),
	drawtype = "flowingliquid",
	tiles = {"acid_icon.png"},
	special_tiles = {
		{
			name = "acid_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "acid_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 10,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "corroded_metal:acid_flowing",
	liquid_alternative_source = "corroded_metal:acid_source",
	liquid_viscosity = 4,
	liquid_renewable = false,
	damage_per_second = 2 * 2,
	post_effect_color = {a = 191, r = 54, g = 200, b = 0},
	groups = {acid = 3, liquid = 3, not_in_creative_inventory = 1},
})

--
-- METALS
--

for i = 1, #metals do
	minetest.register_node("corroded_metal:" .. metals[i], {
		description = S("Corroded " .. capitalMetals[i]),
		tiles = {"corroded" .. capitalMetals[i] .. ".png"},
		is_ground_content = false,
		groups = {cracky = 1, level = 2},
		sounds = default.node_sound_metal_defaults(),
	})

	minetest.register_abm({
		label = "Rust " .. metals[i],
		nodenames = {"default:" .. metals[i] .. "block"}, -- block(s) to be replaced
		neighbors = {"group:water"},
		interval = deltaInterval,
		chance = deltaChance,
		
		action = function(pos, node)
			if node.name == "default:" .. metals[i] .. "block" then
				minetest.set_node(pos, {name = "corroded_metal:" .. metals[i]})
			end
		end
	})
	
	minetest.register_abm({
		label = "Restore " .. metals[i],
		nodenames = {"corroded_metal:" .. metals[i]}, -- block(s) to be replaced
		neighbors = {"group:acid"},
		interval = deltaInterval,
		chance = deltaChance,
		
		action = function(pos, node)
			if node.name == "corroded_metal:" .. metals[i] then
				minetest.set_node(pos, {name = "default:" .. metals[i] .. "block"})
			end
		end
	})
end

--
-- BUCKET
--

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

bucket.register_liquid(
	"corroded_metal:acid_source",
	"corroded_metal:acid_flowing",
	"corroded_metal:bucket_acid",
	"bucket_acid.png",
	S("Acid Bucket"),
	{tool = 1}
)