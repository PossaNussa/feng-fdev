-- Angled Walls: shape definitions and per-block variant registration.
--
-- A "variant" is a mesh copy of an ordinary cubic node with 45 degree corner
-- chamfers.  Variants are never craftable and never show up in the creative
-- inventory: you get them by placing the ordinary block while standing at an
-- angle (see place.lua), and digging one gives the ordinary block back.

local STEP = 0.125

-- Collision approximation: X-strips clipped to the chamfer planes.  Each strip
-- uses the tightest bounds valid across its whole width, so the collision shape
-- always sits inside the mesh -- you can clip a hair into a chamfer, but you
-- never walk into thin air.
local function strip_collision(two_chamfers)
	local boxes = {}
	for i = 0, (1 / STEP) - 1 do
		local x0 = -0.5 + i * STEP
		local x1 = x0 + STEP
		-- chamfer planes: Z >= X - 0.5 (SE) and, for the wall, Z <= X + 0.5 (NW)
		local zmin = math.max(-0.5, x1 - 0.5)
		local zmax = two_chamfers and math.min(0.5, x0 + 0.5) or 0.5
		if zmax - zmin > 0.001 then
			boxes[#boxes + 1] = {x0, -0.5, zmin, x1, 0.5, zmax}
		end
	end
	return {type = "fixed", fixed = boxes}
end

-- Both meshes are chamfered cubes authored in node space; see
-- models/.dev/gen_angled_models.py.  facedir 0 has the chamfer(s) facing SE.
-- param2(sx, sz) takes the signs of the player's look direction and returns the
-- rotation that turns a chamfer towards the player.
angledwalls.shapes = {
	diag = {
		mesh = "angledwalls_diag.obj",
		suffix = "Angled",
		collision_box = strip_collision(true),
		-- Two opposite chamfers, so the shape is 180 degree symmetric and has
		-- only two distinct rotations: 0 faces SE/NW, 1 faces SW/NE.
		param2 = function(sx, sz)
			return sx == sz and 1 or 0
		end,
	},
	corner = {
		mesh = "angledwalls_diag_corner.obj",
		suffix = "Angled Corner",
		collision_box = strip_collision(false),
		-- One chamfer: 0 faces SE, 1 SW, 2 NW, 3 NE.
		param2 = function(sx, sz)
			if sz > 0 then
				return sx < 0 and 0 or 1
			end
			return sx < 0 and 3 or 2
		end,
	},
}

-- source node name -> {diag = <node>, corner = <node>, colordiv = <n>}
angledwalls.variants = {}

local ALPHA_MODES = core.features.use_texture_alpha_string_modes

-- Groups that would let some other mod's ABM or callback swap the node for a
-- full cube, or make it fall or decay, silently undoing the shape.
local STRIP_GROUPS = {
	attached_node = true,
	cultivatable = true,
	falling_node = true,
	leafdecay = true,
	leafdecay_drop = true,
	not_in_creative_inventory = true,
	soil = true,
	spreading_dirt_type = true,
}

local DRAWTYPES = {
	normal = true,
	glasslike = true,
	glasslike_framed = true,
	glasslike_framed_optional = true,
	allfaces = true,
	allfaces_optional = true,
}

-- Nodes that keep state or react to being used are machines, not building
-- blocks: a mesh copy would lose the behaviour, so they are left alone.
local STATEFUL = {
	"on_construct", "on_destruct", "after_destruct", "on_timer",
	"on_rightclick", "on_receive_fields", "mesecons", "digiline",
	"allow_metadata_inventory_put", "allow_metadata_inventory_take",
	"allow_metadata_inventory_move", "on_metadata_inventory_put",
	"on_metadata_inventory_take", "on_metadata_inventory_move",
}

-- param2 the variant uses, and the divisor that isolates the palette bits of a
-- coloured node (colour lives in the high bits, rotation in the low ones).
local PARAMTYPE2 = {
	[""] = {"facedir"},
	none = {"facedir"},
	facedir = {"facedir"},
	["4dir"] = {"4dir"},
	colorfacedir = {"colorfacedir", 32},
	color4dir = {"color4dir", 4},
}

function angledwalls.paramtype2_for(def)
	return PARAMTYPE2[def.paramtype2 or ""]
end

-- Is this node an ordinary cubic building block we can chamfer?
function angledwalls.is_eligible(name, def)
	if not def or not def.tiles or #def.tiles == 0 then
		return false
	end
	if name:sub(1, 12) == "angledwalls:" then
		return false
	end
	if not DRAWTYPES[def.drawtype or "normal"] or def.node_box or def.mesh then
		return false
	end
	if not angledwalls.paramtype2_for(def) then
		return false -- leveled, wallmounted, plain colour, ... cannot hold a rotation
	end
	if def.walkable == false or def.pointable == false or def.diggable == false
			or def.buildable_to or def.floodable then
		return false
	end
	if def.liquidtype and def.liquidtype ~= "none" then
		return false
	end
	if not def.description or def.description == "" then
		return false -- unnamed nodes are technical, not building blocks
	end
	local groups = def.groups or {}
	if groups.not_in_creative_inventory or groups.angled then
		return false
	end
	for _, field in ipairs(STATEFUL) do
		if def[field] then
			return false
		end
	end
	return true
end

local function variant_tiles(def)
	local tiles = def.tiles
	if (def.drawtype or "normal") ~= "normal" then
		-- glasslike/allfaces nodes use tiles 2+ for framing detail rather than
		-- for the bottom and the sides
		return {tiles[1], tiles[1], tiles[1]}
	end
	-- Luanti order is +Y, -Y, +X, -X, +Z, -Z with the last entry repeating; the
	-- meshes have one buffer each for top, bottom and sides.
	local function tile(i)
		return tiles[math.min(i, #tiles)]
	end
	return {tile(1), tile(2), tile(3)}
end

local function variant_alpha(def)
	if def.use_texture_alpha ~= nil then
		return def.use_texture_alpha
	end
	if (def.drawtype or "normal") == "normal" then
		return ALPHA_MODES and "opaque" or false
	end
	return ALPHA_MODES and "clip" or true
end

-- Register one shape variant of `source`.  Returns the new node name, or nil
-- plus a reason.
function angledwalls.register_variant(source, shape_name)
	local def = core.registered_nodes[source]
	local shape = angledwalls.shapes[shape_name]
	if not def or not shape then
		return nil, "unknown node or shape"
	end

	local name = "angledwalls:" .. shape_name .. "_" .. source:gsub("[^%w_]", "_")
	if core.registered_items[name] then
		return nil, "name taken by " .. name
	end

	local groups = {}
	for group, value in pairs(def.groups or {}) do
		if not STRIP_GROUPS[group] then
			groups[group] = value
		end
	end
	groups.angled = 1
	groups.not_in_creative_inventory = 1

	local p2 = angledwalls.paramtype2_for(def)
	if not p2 then
		return nil, "paramtype2 '" .. def.paramtype2 .. "' cannot hold a rotation"
	end
	local paramtype2, colordiv = p2[1], p2[2]

	core.register_node(":" .. name, {
		description = (def.description or source) .. " (" .. shape.suffix .. ")",
		drawtype = "mesh",
		mesh = shape.mesh,
		tiles = variant_tiles(def),
		use_texture_alpha = variant_alpha(def),
		paramtype = def.paramtype,
		paramtype2 = paramtype2,
		palette = def.palette,
		color = def.color,
		light_source = def.light_source,
		damage_per_second = def.damage_per_second,
		sunlight_propagates = def.sunlight_propagates,
		is_ground_content = false,
		groups = groups,
		sounds = def.sounds,
		-- Behaviour deliberately stops at looks: digging one hands back
		-- whatever the plain block drops.
		drop = def.drop or source,
		collision_box = shape.collision_box,
	})

	local entry = angledwalls.variants[source] or {colordiv = colordiv}
	entry[shape_name] = name
	angledwalls.variants[source] = entry
	return name
end
