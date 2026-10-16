-- dynamic_trees/dt_world_generation.lua

--------------------------------------------------------------------------------
-- ffadventure: climate-graded biome bindings
--------------------------------------------------------------------------------
--
-- Every decoration below names its biomes explicitly, but only with stock
-- Minetest Game names -- pine is bound to {"taiga", "coniferous_forest"} and
-- nothing else. This game registers roughly a hundred biomes, so a species is
-- absent from every equivalent climate a biome mod contributes: taiga sits at
-- heat 25, which left awuuwa_biomes_shield (8, a biome literally described as
-- boreal shield), arctic (10), alpine (15) and balsa_woods (20) with no
-- conifers at all, and livingfloatlands' coldgiantforest -- a giant conifer
-- forest -- with no conifers either.
--
-- The first attempt at fixing that widened each decoration's biome list by a
-- flat heat margin and bolted every matched biome's node_top onto place_on.
-- That was wrong twice over. Heat alone ignores humidity, so a rainforest
-- species reached every equally hot biome no matter how dry, and folding the
-- node_tops into place_on destroyed the surface-node check that was supposed
-- to be doing the discriminating. Worst of all the density came along
-- unchanged: jungle and redwood are fill_ratio 0.1, tuned to carpet their home
-- biome, so every grassland and meadow inside the heat window became closed
-- forest, and the bamboo shoot -- place_on group:soil, peak density 0.29 --
-- coated half the world.
--
-- So instead of one widened list, each queued decoration is resolved into
-- graded tiers by distance in heat x humidity space from the climates it
-- actually names:
--
--   home    the biomes written below. Registered untouched, at the density the
--           species was tuned for.
--   kin     d <= KIN_RADIUS. Another mod's name for the same climate. Same
--           noise shape, density scaled down (and capped) so it reads as a
--           thinner version of the home forest, not a second one.
--   stray   d <= a band radius. Not this species' climate, but near enough
--           that the odd stand survives there. Density is replaced with a
--           sparse clustering noise: nothing across most of the biome, an
--           occasional grove where the noise peaks. Further band, rarer.
--
-- Beyond the last band the species simply does not occur, which is what keeps
-- a sakura or a redwood meaningful outside the biome named after it.

-- Distance in heat x humidity units. Both axes are 0..100, so these read as
-- percentage points of climate.
local KIN_RADIUS = 14

-- Stray bands, nearest first. `density` is a fraction of the species' home
-- peak density; it only sets how thick a cluster is, not how much ground the
-- clusters cover.
local STRAY_BANDS = {
	{radius = 24, density = 0.15},
	{radius = 32, density = 0.06},
	{radius = 40, density = 0.02},
}

-- Kin density as a fraction of home, and the absolute ceiling it may reach.
-- The cap is what stops the fill_ratio 0.1 species (jungle, redwood, sakura)
-- from turning a neighbouring climate into a second home biome.
local KIN_DENSITY  = 0.35
local KIN_PEAK_MAX = 0.02

-- Stray clustering. CLUSTER_SPREAD is the size of a grove in nodes; the offset
-- and scale factors below put roughly the top tenth of the noise field above
-- zero, so a stray species is absent from most of a biome and clumped where it
-- is present.
local CLUSTER_SPREAD    = 320
local CLUSTER_OFFSET_K  = -3.0
local CLUSTER_SCALE_K   = 4.0
local STRAY_PEAK_MAX    = 0.006
local STRAY_PEAK_MIN    = 0.0002

local queued_decos = {}

local function queue_decoration(def)
	queued_decos[#queued_decos + 1] = def
end

-- Peak density a decoration reaches in its home biomes. For noise decorations
-- the noise value *is* the fill ratio, so the peak is the top of the noise
-- range: sum of the octave amplitudes is 1 + p + p^2 for three octaves.
local function home_peak(def)
	if def.fill_ratio then return def.fill_ratio end

	local np = def.noise_params
	if not np then return 0 end

	local p, amp = np.persist or 0.5, 0
	for i = 0, (np.octaves or 3) - 1 do amp = amp + p ^ i end

	return math.max(0, (np.offset or 0) + math.abs(np.scale or 0) * amp)
end

-- Scaling both offset and scale by the same positive factor leaves the noise's
-- zero crossings exactly where they were -- the species keeps its footprint
-- and only thins out inside it.
local function scale_density(def, k)
	if def.fill_ratio then
		def.fill_ratio = def.fill_ratio * k
	elseif def.noise_params then
		def.noise_params.offset = (def.noise_params.offset or 0) * k
		def.noise_params.scale  = (def.noise_params.scale  or 0) * k
	end
end

local function climate_points(names)
	local pts = {}

	for _, name in ipairs(names) do
		local b = minetest.registered_biomes[name]
		if b and b.heat_point then
			pts[#pts + 1] = {h = b.heat_point, u = b.humidity_point or 50}
		end
	end

	return pts
end

local function climate_distance(pts, b)
	local h, u = b.heat_point, b.humidity_point or 50
	local best

	for _, p in ipairs(pts) do
		local dh, du = h - p.h, u - p.u
		local d = math.sqrt(dh * dh + du * du)
		if not best or d < best then best = d end
	end

	return best
end

local function y_overlaps(def, b)
	local dmin, dmax = def.y_min or -31000, def.y_max or 31000
	local bmin, bmax = b.y_min  or -31000, b.y_max  or 31000
	return dmin <= bmax and bmin <= dmax
end

local function place_on_list(def)
	local po = def.place_on
	if type(po) == "string" then po = {po} end
	return po or {}
end

-- Whether this species was written to stand on sand. Only those may follow a
-- climate match onto a sand-topped biome; without this a conifer graded into a
-- cold beach would sprout out of the shore.
local function accepts_sand(def)
	for _, n in ipairs(place_on_list(def)) do
		local nd = minetest.registered_nodes[n]
		if n == "group:sand" or (nd and (nd.groups.sand or 0) > 0) then
			return true
		end
	end
	return false
end

-- Adding each biome's node_top to place_on is what lets a species reach ground
-- another mod invented, but it also retires the surface check that used to be
-- the only constraint -- so the top node has to be something the species could
-- plausibly root in. Snowblock, ice and permafrost tops fail here, which is
-- what keeps pine out of the icesheet it is otherwise climatically near.
local function plantable_top(top, sand_ok, original)
	if not top then return false end
	if original[top] then return true end

	local nd = minetest.registered_nodes[top]
	if not nd then return false end

	if (nd.groups.soil or 0) > 0 then return true end
	if (nd.groups.sand or 0) > 0 then return sand_ok end

	return false
end

-- place_on for a tier: whatever the decoration already stood on, plus the top
-- node of each biome in that tier. Safe here in a way the old blanket version
-- was not, because the biome list this accompanies is climate-matched and the
-- tops were filtered by plantable_top.
local function ground_for(def, biome_names)
	local seen, list = {}, {}

	for _, n in ipairs(place_on_list(def)) do
		if not seen[n] then seen[n] = true; list[#list + 1] = n end
	end

	for _, name in ipairs(biome_names) do
		local top = minetest.registered_biomes[name].node_top
		if top and minetest.registered_nodes[top] and not seen[top] then
			seen[top] = true
			list[#list + 1] = top
		end
	end

	return list
end

-- Stable per-species noise seed so two species do not clump in the same spots.
local function name_seed(s)
	local h = 0
	for i = 1, #s do h = (h * 31 + s:byte(i)) % 1000003 end
	return h
end

minetest.register_on_mods_loaded(function()

	for index, deco in ipairs(queued_decos) do

		-- Home tier: exactly as written below.
		minetest.register_decoration(deco)

		local pts  = type(deco.biomes) == "table" and climate_points(deco.biomes) or {}
		local peak = home_peak(deco)

		-- If none of the stated biomes exist in this game there is no climate
		-- to measure from, so the decoration stays home-only rather than being
		-- spread on a guess. A decoration whose noise never crosses zero does
		-- not place at home either, and has nothing to spread.
		if #pts > 0 and peak > 0 then

			local home, tiers = {}, {}
			for _, name in ipairs(deco.biomes) do home[name] = true end

			local original = {}
			for _, n in ipairs(place_on_list(deco)) do original[n] = true end
			local sand_ok = accepts_sand(deco)

			for name, b in pairs(minetest.registered_biomes) do
				if not home[name] and b.heat_point and y_overlaps(deco, b)
				and plantable_top(b.node_top, sand_ok, original) then

					local d = climate_distance(pts, b)
					local tier

					if d <= KIN_RADIUS then
						tier = 0
					else
						for i, band in ipairs(STRAY_BANDS) do
							if d <= band.radius then
								tier = i
								break
							end
						end
					end

					if tier then
						tiers[tier] = tiers[tier] or {}
						table.insert(tiers[tier], name)
					end
				end
			end

			-- Two decorations below share a name (apple and dry tree each have
			-- a second, sparser registration), so derived names carry the queue
			-- index to stay distinguishable in mapgen logs.
			local label = (deco.name or "dtrees") .. " #" .. index
			local seed  = name_seed(label)

			for tier, names in pairs(tiers) do
				local c = table.copy(deco)
				c.biomes   = names
				c.place_on = ground_for(deco, names)

				if tier == 0 then
					local k = math.min(KIN_DENSITY, KIN_PEAK_MAX / peak)

					c.name = label .. " (kin)"
					scale_density(c, k)
					minetest.register_decoration(c)
				else
					local p = math.min(peak * STRAY_BANDS[tier].density, STRAY_PEAK_MAX)

					-- A species already too rare at home has nothing to spare
					-- for the strays.
					if p >= STRAY_PEAK_MIN then
						c.name = label .. " (stray " .. tier .. ")"
						c.fill_ratio = nil
						-- The engine takes one noise sample per sidelen block
						-- and scatters that many decorations inside it, so the
						-- species carrying sidelen 80 (jungle, redwood) would
						-- get clusters with 80-node square edges. 16 traces the
						-- cluster outline properly.
						c.sidelen = 16
						c.noise_params = {
							offset  = CLUSTER_OFFSET_K * p,
							scale   = CLUSTER_SCALE_K * p,
							spread  = {x = CLUSTER_SPREAD, y = CLUSTER_SPREAD, z = CLUSTER_SPREAD},
							seed    = 9000 + seed % 4000 + tier * 97,
							octaves = 3,
							persist = 0.6,
						}
						minetest.register_decoration(c)
					end
				end
			end
		end
	end
end)



	-- Acacia tree and log

	queue_decoration({
		name = "default:acacia_tree",
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		decoration = "dynamic_trees:acacia_tree_sapling",
	})
	-- The islands are already carpeted with palms by three decorations in
	-- biomes_island, so this one exists to give palms a climate rather than an
	-- island. Bound to islands it also had one, but the wrong one: the temperate
	-- "islands" biome sits at heat 72 humidity 72, close enough to deciduous
	-- forest that grading from it put palm trees in oak woodland. Hot wet shore
	-- is the climate palms actually state.
	queue_decoration({
		name = "default:palm_tree",
		deco_type = "simple",
		place_on = {"biomes_island:dirt_with_island_litter", "group:sand"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"naturalbiomes:palmbeach", "islands_hot"},
		y_max = 31000,
		y_min = 1,
		decoration = "dynamic_trees:palm_tree_sapling",
	})
	queue_decoration({
		name = "default:apple_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:apple_tree_sapling",
	})

	queue_decoration({
		name = "default:apple_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.0015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:apple_tree_sapling",
	})
	-- Aspen tree and log

	queue_decoration({
		name = "default:aspen_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0,
			scale = -0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:aspen_tree_sapling",
	})
	queue_decoration({
		name = "default:aspen_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0,
			scale = -0.0015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:aspen_tree_sapling",
	})
	-- Cactus

	queue_decoration({
		name = "default:cactus",
		deco_type = "simple",
		place_on = {"default:desert_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert"},
		y_max = 31000,
		y_min = 4,
	decoration = "dynamic_trees:cactus_seedling",
	})


	-- Emergent jungle tree
	-- Due to 32 node height, altitude is limited and prescence depends on chunksize

	local chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
	if chunksize >= 5 then
		queue_decoration({
			name = "default:emergent_jungle_tree",
			deco_type = "simple",
			place_on = {"default:dirt_with_rainforest_litter"},
			sidelen = 80,
			noise_params = {
				offset = 0.0,
				scale = 0.0025,
				spread = {x = 250, y = 250, z = 250},
				seed = 2685,
				octaves = 3,
				persist = 0.7
			},
			biomes = {"rainforest"},
			y_max = 32,
			y_min = 1,

	decoration = "dynamic_trees:jungle_tree_sapling",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
		})
	end
	


	-- Jungle tree and log

	queue_decoration({
		name = "default:jungle_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_rainforest_litter"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"rainforest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:jungle_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})
	
	queue_decoration({
		name = "default:redwood_tree",
		deco_type = "simple",
		place_on = {"redw:dirt_with_grass"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"redwood_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:redwood_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Swamp jungle trees

	queue_decoration({
		name = "default:jungle_tree(swamp)",
		deco_type = "simple",
		place_on = {"default:dirt"},
		sidelen = 16,
		-- Noise tuned to place swamp trees where papyrus is absent
		noise_params = {
			offset = 0.0,
			scale = -0.1,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 1,
			persist = 0.5
		},
		biomes = {"rainforest_swamp"},
		y_max = 0,
		y_min = -1,
	decoration = "dynamic_trees:jungle_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Taiga and temperate coniferous forest pine tree, small pine tree and log

	queue_decoration({
		name = "default:pine_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest"},
		y_max = 31000,
		y_min = 4,
	decoration = "dynamic_trees:pine_tree_sapling",
		flags = "place_center_x, place_center_z",
	})

	queue_decoration({
		name = "default:small_pine_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = -0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest"},
		y_max = 31000,
		y_min = 4,
	decoration = "dynamic_trees:pine_tree_sapling",
		flags = "place_center_x, place_center_z",
	})

-- Bamboo belongs to the two bamboo biomes. It used to be bound to rainforest
-- and deciduous_forest at peak density 0.29 on group:soil, which meant a
-- quarter of every temperate and tropical surface node was a bamboo shoot.
-- Bound to its own biomes instead, the grading above hands it to rainforest as
-- kin and lets it stray into the wet temperate forests in clumps.
queue_decoration({
	name = "Dynamic Trees Bamboo Shoot",
	deco_type = "simple",
	place_on = {"group:soil"},
	sidelen = 16,
	noise_params = {
		offset = -0.03,
		scale = 0.06,
		spread = {x = 240, y = 240, z = 240},
		seed = 6566,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"bamboo_forest", "bambooforest"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:bamboo_shoot",
})

-- Adds The Dry Sapling To The Deserts.
-- The original noise put dead trees across roughly a quarter of every desert at
-- one per twenty nodes, which is a forest, not a desert. Thinned to scattered
-- stands; the deserts keep the species, they just stop being wooded.
queue_decoration({
	name = "Dynamic Trees Dry Tree Sapling",
	deco_type = "simple",
	place_on = {"group:soil","group:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.05,
		scale = 0.06,
		spread = {x = 400, y = 400, z = 400},
		seed = 3628,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"desert", "sandstone_desert", "cold_desert"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:dry_tree_sapling",
})

queue_decoration({
	name = "Dynamic Trees Dry Tree Sapling",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.00015,
		spread = {x = 500, y = 500, z = 500},
		seed = 3628,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"grove"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:dry_tree_sapling",
})
-- Function to set walkable property to false for all leaves
local function make_leaves_non_walkable()
    for name, def in pairs(minetest.registered_nodes) do
        if def.groups.leaves then
            minetest.override_item(name, {
                walkable = false
            })
        end
    end
end

-- Run the function shortly after server starts
minetest.after(0, make_leaves_non_walkable)

minetest.register_chatcommand("replace_trees", {
    params = "<radius>",
    description = "Replace the bottom-most logs of regular trees within a radius with dynamic tree saplings",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local radius = tonumber(param)
        if not radius then
            return false, "Invalid radius"
        end

        local pos = player:get_pos()
        local minp = vector.subtract(pos, radius)
        local maxp = vector.add(pos, radius)

        local nodes_to_replace = {
            ["default:tree"] = "dynamic_trees:apple_tree_sapling",
            ["default:jungletree"] = "dynamic_trees:jungle_tree_sapling",
            ["default:pine_tree"] = "dynamic_trees:pine_tree_sapling",
            ["default:acacia_tree"] = "dynamic_trees:acacia_tree_sapling",
            ["default:aspen_tree"] = "dynamic_trees:aspen_tree_sapling"
        }

        local total_replaced = 0

        for node_name, new_node_name in pairs(nodes_to_replace) do
            local positions = minetest.find_nodes_in_area(minp, maxp, {node_name})
            local bottom_most_logs = {}

            for _, p in ipairs(positions) do
                local y = p.y
                local is_bottom = true

                while true do
                    y = y - 1
                    local below_pos = {x = p.x, y = y, z = p.z}
                    local node_below = minetest.get_node_or_nil(below_pos)

                    if node_below and node_below.name == node_name then
                        is_bottom = false
                        break
                    else
                        break
                    end
                end

                if is_bottom then
                    bottom_most_logs[minetest.hash_node_position(p)] = p
                end
            end

            for _, bottom_pos in pairs(bottom_most_logs) do
                minetest.set_node(bottom_pos, {name = new_node_name})
                total_replaced = total_replaced + 1
            end

            for _, p in ipairs(positions) do
                if not bottom_most_logs[minetest.hash_node_position(p)] then
                    minetest.remove_node(p)

                    for dx = -2, 2 do
                        for dy = -2, 2 do
                            for dz = -2, 2 do
                                local leaf_pos = {x = p.x + dx, y = p.y + dy, z = p.z + dz}
                                local node = minetest.get_node_or_nil(leaf_pos)
                                if node and minetest.get_item_group(node.name, "leaves") > 0 then
                                    minetest.remove_node(leaf_pos)
                                end
                            end
                        end
                    end
                end
            end
        end

        return true, "Replaced " .. total_replaced .. " bottom-most tree logs with dynamic tree saplings."
    end
})

-- NOTE: The old "sapling_replacer" here (override_item + one-time LBM +
-- on_generated swap) is no longer needed. dt_crafting.lua now uses
-- register_alias_force to unregister the default saplings outright and alias
-- default:sapling / junglesapling / pine_sapling / acacia_sapling /
-- aspen_sapling / emergent_jungle_sapling to their Dynamic Trees equivalents.
-- The engine resolves those aliases for freshly placed nodes, existing map
-- nodes, drops, recipes and decorations, so no runtime replacement pass is
-- required.
