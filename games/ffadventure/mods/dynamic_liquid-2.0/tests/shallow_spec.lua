-- Offline tests for shallow water.  See tests/README.md for how to run this.
--
-- Stubs enough of the Luanti API to run the real shallow.lua against a fake voxel
-- world, so the flow logic can be checked without booting a server.  The thing it
-- checks hardest is that water is never created or destroyed.

local MOD = (arg and arg[0] or ""):match("^(.*)tests/[^/]*$") or
	"/root/Documents/luanti-fdev-master/games/ffadventure/mods/dynamic_liquid-2.0/"

----------------------------------------------------------------------------- world
local world = {}   -- "x,y,z" -> {name=, param2=}
local timers = {}  -- "x,y,z" -> true if started
local registered = {}

local function key(p) return p.x .. "," .. p.y .. "," .. p.z end

-- The fake world is a sealed box: bedrock below y=-12 and stone past ±14, so water
-- can never escape the fixture and fake a conservation failure.
local function getnode(p)
	local n = world[key(p)]
	if n then return n end
	if p.y <= -12 or p.x < -14 or p.x > 14 or p.z < -14 or p.z > 14 then
		return {name = "default:stone", param2 = 0}
	end
	return {name = "air", param2 = 0}
end

----------------------------------------------------------------------------- api
minetest = {}
core = minetest
minetest.registered_nodes = registered

minetest.settings = {
	get = function() return nil end,
	get_bool = function(_, _, def) return def end,
}

function minetest.get_modpath(n) return (n == "default") and "/fake/default" or nil end
function minetest.get_current_modname() return "dynamic_liquid" end
function minetest.get_translator() return function(s) return s end end
function minetest.log(lvl, msg) print("[log " .. lvl .. "] " .. msg) end

function minetest.register_node(name, def) def.name = name; registered[name] = def end
function minetest.register_alias(name, target) registered[name] = registered[target] end
function minetest.register_lbm() end
function minetest.register_abm() end
function minetest.register_on_dignode() end
function minetest.register_on_placenode() end
function minetest.register_globalstep() end
function minetest.register_on_leaveplayer() end
function minetest.get_node(p) return getnode(p) end
function minetest.get_item_group(name, group)
	local def = registered[name]
	if not def or not def.groups then return 0 end
	return def.groups[group] or 0
end

function minetest.set_node(p, node)
	world[key(p)] = {name = node.name, param2 = node.param2 or 0}
	local def = registered[node.name]
	if def and def.on_construct then def.on_construct({x=p.x, y=p.y, z=p.z}) end
end

function minetest.remove_node(p) world[key(p)] = nil; timers[key(p)] = nil end
function minetest.swap_node(p, node)
	world[key(p)] = {name = node.name, param2 = node.param2 or 0}
end

-- Mirrors mapnode.cpp: CPT2_LEVELED reads param2 & 0x7F, and a level of 0 falls
-- back to the nodedef's static `leveled` value.
function minetest.get_node_level(p)
	local n = getnode(p)
	local def = registered[n.name]
	if not def then return 0 end
	if def.paramtype2 == "leveled" then
		local lv = (n.param2 or 0) % 128
		return lv ~= 0 and lv or (def.leveled or 0)
	end
	if def.liquidtype == "source" then return 8 end
	return 0
end

function minetest.set_node_level(p, level)
	local n = getnode(p)
	local def = registered[n.name]
	if def and def.paramtype2 == "leveled" then
		if level > (def.leveled_max or 127) then level = def.leveled_max or 127 end
		if level < 0 then level = 0 end
		n.param2 = level
	end
end

function minetest.get_node_timer(p)
	local k = key(p)
	return {
		start = function() timers[k] = true end,
		is_started = function() return timers[k] == true end,
		stop = function() timers[k] = nil end,
	}
end

----------------------------------------------------------------------------- fixtures
registered["air"] = {name = "air", buildable_to = true, walkable = false, floodable = true}
registered["default:stone"] = {name = "default:stone", walkable = true}
registered["default:water_source"] = {
	name = "default:water_source",
	liquidtype = "source",
	liquid_viscosity = 1,
	tiles = {"2anga1.png"},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	description = "Water Source",
}

dynamic_liquid = {config = {shallow_water = true}, shallow_variants = {}, registered_liquids = {["default:water_source"] = "default:water_flowing"}}
dofile(MOD .. "shallow.lua")

-- Height now lives in the node name, so there are eight variants; param2 is free for
-- the palette colour.  Build name<->units maps from the exposed table.
local UNITS = dynamic_liquid.shallow_units_by_name       -- name -> units (1..8)
assert(UNITS, "shallow units map was not exposed")
local HEIGHT = {}                                        -- units -> name
for name, u in pairs(UNITS) do HEIGHT[u] = name end
local FULL = dynamic_liquid.shallow_variants["default:water_source"]
assert(FULL and FULL == HEIGHT[8], "full-height variant was not registered")

local sdef = registered[FULL]
assert(sdef.node_box.type == "fixed", "must use a fixed nodebox (height is in the name now)")
assert(sdef.walkable == false, "must not be walkable")
assert(sdef.groups.water == 3, "must keep the water group")
-- The engine's own liquid flow must not be allowed to convert a puddle into a
-- transient flowing node, because that water is then no longer tracked by anyone.
assert(sdef.floodable == false, "shallow water must not be floodable")
-- This is what stopped the player jumping out of ankle-deep water.
assert(sdef.liquid_move_physics == false, "shallow water must not be swimmable")

-- units in a world node table, or nil if it is not one of our puddles
local function shallow_units(n) return UNITS[n.name] end
print("registered: " .. FULL .. " (+7 shorter variants)")

----------------------------------------------------------------------------- helpers
local function put(p, name, param2) world[key(p)] = {name = name, param2 = param2 or 0} end
-- Place shallow water of a given depth (1..8 units); height is chosen by node name.
local function put_units(p, units) world[key(p)] = {name = HEIGHT[units], param2 = 0} end

local function floor_at(y, x0, x1, z0, z1)
	for x = x0, x1 do for z = z0, z1 do put({x=x,y=y,z=z}, "default:stone") end end
end

local function total_units()
	local sum = 0
	for _, n in pairs(world) do
		local u = shallow_units(n)
		if u then
			sum = sum + u
		elseif n.name == "default:water_source" then
			sum = sum + 8
		end
	end
	return sum
end

-- Water in the world plus whatever rounding the merges into bodies of water have
-- owned up to.  Every test below holds THIS constant, so a puddle joining a lake
-- is allowed, but nothing may go missing quietly.
local function books()
	return total_units() - dynamic_liquid.shallow_merge_delta
end

-- Mirror of the hook in dynamic_liquids.lua, plus the column drop the ABM does
-- first.  Without this the harness cannot see the hand-off between the two halves.
local six = {{1,0,0},{-1,0,0},{0,0,1},{0,0,-1},{0,1,0},{0,-1,0}}
local function abm_pass()
	local sources = {}
	for k, n in pairs(world) do
		if n.name == "default:water_source" then sources[#sources+1] = k end
	end
	local acted = 0
	for _, k in ipairs(sources) do
		local x, y, z = k:match("(-?%d+),(-?%d+),(-?%d+)")
		local p = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
		if getnode(p).name == "default:water_source" then
			local below = {x = p.x, y = p.y - 1, z = p.z}
			if getnode(below).name == "air" then
				local ty = below.y
				while getnode({x=p.x, y=ty-1, z=p.z}).name == "air" do ty = ty - 1 end
				world[key(p)] = nil
				world[key({x=p.x, y=ty, z=p.z})] = {name = "default:water_source", param2 = 0}
				acted = acted + 1
			else
				-- mirrors has_liquid_nearby(): water within one cell in any
				-- direction, diagonals included, means this is not stranded
				local isolated = true
				for dx = -1, 1 do for dy = -1, 1 do for dz = -1, 1 do
					if not (dx == 0 and dy == 0 and dz == 0) and
							getnode({x=p.x+dx, y=p.y+dy, z=p.z+dz}).name == "default:water_source" then
						isolated = false
					end
				end end end
				if isolated and dynamic_liquid.settle_as_shallow(p, "default:water_source") then
					acted = acted + 1
				elseif not isolated then
					-- the ABM's sideways move: swap the source into an open neighbour.
					-- This is how water actually travels along a tunnel.
					local order = {{1,0},{-1,0},{0,1},{0,-1}}
					for i = #order, 2, -1 do
						local j = math.random(i)
						order[i], order[j] = order[j], order[i]
					end
					for _, d in ipairs(order) do
						local np = {x = p.x + d[1], y = p.y, z = p.z + d[2]}
						if getnode(np).name == "air" then
							world[key(np)] = {name = "default:water_source", param2 = 0}
							world[key(p)] = nil
							acted = acted + 1
							break
						end
					end
				end
			end
		end
	end
	return acted
end

local function tick()
	local pending = {}
	for k in pairs(timers) do pending[#pending+1] = k end
	local fired = 0
	for _, k in ipairs(pending) do
		local x, y, z = k:match("(-?%d+),(-?%d+),(-?%d+)")
		local p = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
		local def = registered[getnode(p).name]
		timers[k] = nil
		if def and def.on_timer then
			fired = fired + 1
			if def.on_timer(p, 0.25) then timers[k] = true end
		end
	end
	return fired
end

-- Run to a standstill, failing loudly the moment a single unit is created or
-- lost.  "Standstill" means the puddles have stopped: a lone source with an open
-- cell beside it wanders for as long as you care to watch it, which is plain
-- dynamic_liquid behaviour and not what this file is testing.  So the run also
-- ends once the puddles have been quiet for a while, and it is their silence,
-- not the ABM's, that the tests assert on.
local QUIET = 25

local function run(label, max_ticks)
	local start = books()
	local t, quiet = 0, 0
	while t < max_ticks do
		local puddles = tick()
		local acted = puddles + abm_pass()
		if acted == 0 then break end
		quiet = (puddles == 0) and (quiet + 1) or 0
		if quiet >= QUIET then break end
		t = t + 1
		local now = books()
		if now ~= start then
			error(string.format("%s: LEAK at tick %d: %d -> %d units", label, t, start, now))
		end
	end
	local settled = next(timers) == nil
	print(string.format("  %-30s ticks=%-4d volume=%-3d settled=%s",
		label, t, total_units(), tostring(settled)))
	assert(settled, label .. ": puddles never came to rest")
	return t, settled
end

local function slice(y, x0, x1, z)
	local out = {}
	for x = x0, x1 do
		local n = getnode({x=x, y=y, z=z})
		local u = shallow_units(n)
		if u then
			out[#out+1] = tostring(u)
		elseif n.name == "default:water_source" then out[#out+1] = "S"
		elseif n.name == "default:stone" then out[#out+1] = "#"
		else out[#out+1] = "." end
	end
	return table.concat(out)
end

local function lowest_water()
	local low = 99
	for k, n in pairs(world) do
		if shallow_units(n) or n.name == "default:water_source" then
			local _, y = k:match("(-?%d+),(-?%d+)")
			if tonumber(y) < low then low = tonumber(y) end
		end
	end
	return low
end

----------------------------------------------------------------------------- tests
print("\nflat ground")
world = {}; timers = {}
floor_at(0, -12, 12, -12, 12)
dynamic_liquid.settle_as_shallow({x=0,y=1,z=0}, "default:water_source")
print("  before: " .. slice(1, -6, 6, 0))
run("one block, flat", 60)
print("  after:  " .. slice(1, -6, 6, 0))

print("\nslope")
world = {}; timers = {}
for x = -8, 8 do for z = -2, 2 do
	for y = -11, -x do put({x=x,y=y,z=z}, "default:stone") end
end end
dynamic_liquid.settle_as_shallow({x=-6,y=7,z=0}, "default:water_source")
run("one block, slope", 400)
assert(lowest_water() < 7, "water on a slope must run downhill")
print("  ran down from y=7 to y=" .. lowest_water())

print("\nboxed in")
world = {}; timers = {}
floor_at(0, -3, 3, -3, 3)
for _, d in ipairs({{1,0},{-1,0},{0,1},{0,-1}}) do put({x=d[1],y=1,z=d[2]}, "default:stone") end
put_units({x=0,y=1,z=0}, 8)
timers[key({x=0,y=1,z=0})] = true
run("full, nowhere to go", 20)
assert(getnode({x=0,y=1,z=0}).name == "default:water_source",
	"a full boxed-in puddle should hand itself back to a source")
print("  became: " .. getnode({x=0,y=1,z=0}).name)

print("\nsettling costs nothing")
world = {}; timers = {}
floor_at(0, -12, 12, -12, 12)
dynamic_liquid.settle_as_shallow({x=0,y=1,z=0}, "default:water_source")
run("settle", 60)
assert(tick() == 0, "settled water must not keep ticking")
print("  timers firing after settling: 0")

print("\nmerging")
world = {}; timers = {}
floor_at(0, -12, 12, -12, 12)
dynamic_liquid.settle_as_shallow({x=-1,y=1,z=0}, "default:water_source")
dynamic_liquid.settle_as_shallow({x=2,y=1,z=0}, "default:water_source")
print("  before: " .. slice(1, -6, 6, 0))
run("two puddles", 100)
print("  after:  " .. slice(1, -6, 6, 0))

print("\ndraining")
world = {}; timers = {}
floor_at(0, -12, 12, -12, 12)
floor_at(-5, -12, 12, -12, 12)
for y = -4, 0 do world[key({x=1,y=y,z=0})] = nil end
dynamic_liquid.settle_as_shallow({x=0,y=1,z=0}, "default:water_source")
run("hole dug beside it", 200)
assert(lowest_water() <= -4, "water must drain into an adjacent hole")
print("  reached the bottom of the hole at y=" .. lowest_water())

print("\nleft alone")
world = {}; timers = {}
-- filled right up to the walls of the sealed box, so nothing at the rim has an
-- open side to shuffle into and the only movement left would be a real bug
floor_at(-5, -14, 14, -14, 14)
for x = -14, 14 do for z = -14, 14 do for y = -4, -1 do
	put({x=x,y=y,z=z}, "default:water_source")
end end end
local n_sources = 0
for _, n in pairs(world) do
	if n.name == "default:water_source" then n_sources = n_sources + 1 end
end
local acted = abm_pass()
local n_shallow = 0
for _, n in pairs(world) do if shallow_units(n) then n_shallow = n_shallow + 1 end end
print(string.format("  ocean: %d sources, %d converted, %d shallow created, %d timers",
	n_sources, acted, n_shallow, (function() local c=0; for _ in pairs(timers) do c=c+1 end; return c end)()))
assert(acted == 0 and n_shallow == 0 and next(timers) == nil,
	"a body of water must be left completely alone")

-- a real lake sits in a basin: dry ground on the far side is raised, not level with
-- the water, otherwise it is not a shore, it is a puddle waiting to happen
world = {}; timers = {}
floor_at(-1, -14, 14, -14, 14)
for x = 1, 14 do for z = -14, 14 do put({x=x,y=0,z=z}, "default:stone") end end
for x = -14, 0 do for z = -14, 14 do put({x=x,y=0,z=z}, "default:water_source") end end
acted = abm_pass()
n_shallow = 0
for _, n in pairs(world) do if shallow_units(n) then n_shallow = n_shallow + 1 end end
print(string.format("  lake shore: %d converted, %d shallow created", acted, n_shallow))
assert(n_shallow == 0, "a lake with a shore must not dissolve into puddles")

print("\ntunnel")
world = {}; timers = {}
for x = -12, 12 do for y = -9, 4 do for z = -2, 2 do
	put({x=x,y=y,z=z}, "default:stone")
end end end
for x = -12, 6 do world[key({x=x,y=0,z=0})] = nil end   -- horizontal bore
for y = -8, 0 do world[key({x=6,y=y,z=0})] = nil end    -- shaft down at the far end
for x = 6, 12 do world[key({x=x,y=-8,z=0})] = nil end   -- chamber at the bottom
for i = 0, 3 do put({x=-12+i, y=0, z=0}, "default:water_source") end
print("  poured in: " .. total_units() .. " units")
run("down a tunnel", 600)
print("  tunnel:  " .. slice(0, -12, 8, 0))
print("  chamber: " .. slice(-8, 4, 12, 0))
print("  deepest water at y=" .. lowest_water())

-- A lake filling a sealed basin: every rim cell is walled in, so the movement ABM
-- has nothing to shuffle into and anything that moves is the puddle code.
local function walled_lake(surface_y)
	floor_at(surface_y - 1, -14, 14, -14, 14)
	for x = -14, 14 do for z = -14, 14 do
		if x == 14 or x == -14 or z == 14 or z == -14 then
			put({x=x, y=surface_y, z=z}, "default:stone")
		else
			put({x=x, y=surface_y, z=z}, "default:water_source")
		end
	end end
end

print("\npuddle against a lake")
world = {}; timers = {}
walled_lake(0)
-- dry bed cut into the lake, one cell wide, with 5/8 of a node standing in it
world[key({x=0,y=0,z=0})] = nil
put_units({x=0,y=0,z=0}, 5)
timers[key({x=0,y=0,z=0})] = true
run("puddle beside a lake", 200)
print("  rests as: " .. getnode({x=0,y=0,z=0}).name .. ", ledger " ..
	dynamic_liquid.shallow_merge_delta)
-- New behaviour (see body_above): a thin sheet whose surface is lower than the body's
-- full-node top rests as shallows at the water's edge instead of being sucked back in.
-- The old sideways merge is what caused the "reabsorbs into source over and over" loop.
assert(shallow_units(getnode({x=0,y=0,z=0})),
	"a thin sheet must rest as shallows beside deeper water, not merge back into it")

print("\npuddle on top of a lake")
world = {}; timers = {}
walled_lake(0)
put_units({x=0,y=1,z=0}, 3)          -- 3/8 of a node, as if it had rained in
timers[key({x=0,y=1,z=0})] = true
local before = total_units()
run("splash landing on a lake", 200)
-- Water landing on a body is NEVER dissolved into it — that rounding into the
-- ledger, cell after cell, is what made lakes cascade away.  It rests on the
-- surface as a conserved film (the 1..8 gradient), riding on the water below.
assert(total_units() == before,
	"water landing on a lake must be conserved, never dissolved")
assert(dynamic_liquid.shallow_merge_delta == 0,
	"surface water must never be rounded away into the ledger")
local film = 0
for _, n in pairs(world) do if shallow_units(n) then film = film + 1 end end
assert(film > 0, "the splash must rest as a film on the surface, not vanish")
print(string.format("  rests as %d film cells on the surface, ledger 0, %d units kept",
	film, total_units()))

print("\nsource meeting a puddle")
-- A one-node channel with a puddle sitting in it: the source has to get past.
world = {}; timers = {}
for x = -14, 14 do for y = -3, 2 do for z = -2, 2 do put({x=x,y=y,z=z}, "default:stone") end end end
for x = -6, 6 do world[key({x=x,y=0,z=0})] = nil end
put({x=-6,y=0,z=0}, "default:water_source")
put_units({x=-4,y=0,z=0}, 2)   -- 2/8 of a node
timers[key({x=-4,y=0,z=0})] = true
print("  before: " .. slice(0, -6, 6, 0))
run("past a puddle in a channel", 300)
print("  after:  " .. slice(0, -6, 6, 0))
assert(getnode({x=-6,y=0,z=0}).name ~= "default:water_source",
	"a puddle must not dam a full water node in place")

print("\nbody below a film is never eaten")   -- regression: the lake-cascade bug
world = {}; timers = {}
floor_at(-2, -14, 14, -14, 14)
-- a walled two-deep pool: a real body at rest (walls 3 tall so the film on top is
-- contained and cannot just spill over the rim), water filling it to the brim.
for y = -1, 1 do for x = -4, 4 do for z = -4, 4 do
	if x == -4 or x == 4 or z == -4 or z == 4 then
		put({x=x,y=y,z=z}, "default:stone")
	elseif y <= 0 then
		put({x=x,y=y,z=z}, "default:water_source")
	end
end end end
-- drop a film on top of the deep water, as if it had rained or been settled there
put_units({x=0,y=1,z=0}, 4)
timers[key({x=0,y=1,z=0})] = true
local vol_before = total_units()
local src_before = 0
for _, n in pairs(world) do if n.name == "default:water_source" then src_before = src_before + 1 end end
run("film on two-deep water", 200)
local src_after = 0
for _, n in pairs(world) do if n.name == "default:water_source" then src_after = src_after + 1 end end
assert(total_units() == vol_before, "the film's water must be conserved to the unit")
assert(dynamic_liquid.shallow_merge_delta == 0, "nothing may dissolve into the ledger")
assert(src_after >= src_before, "the body of water underneath must never shrink")
print(string.format("  body sources %d -> %d, all %d units held, ledger 0",
	src_before, src_after, total_units()))

print("\nrandomised")
local worst = 0
for seed = 1, 40 do
	math.randomseed(seed)
	world = {}; timers = {}
	for x = -9, 9 do for z = -9, 9 do
		for y = -11, math.random(-2, 2) do put({x=x,y=y,z=z}, "default:stone") end
	end end
	for _ = 1, 6 do
		local x, z = math.random(-8, 8), math.random(-8, 8)
		for y = 4, -3, -1 do
			if getnode({x=x,y=y,z=z}).name == "default:stone" then
				if getnode({x=x,y=y+1,z=z}).name == "air" then
					put({x=x,y=y+1,z=z}, "default:water_source")
				end
				break
			end
		end
	end
	local start = books()
	local t, quiet = 0, 0
	while t < 600 do
		local puddles = tick()
		local acted2 = puddles + abm_pass()
		if acted2 == 0 then break end
		quiet = (puddles == 0) and (quiet + 1) or 0
		if quiet >= QUIET then break end
		t = t + 1
		if books() ~= start then
			error(string.format("seed %d: LEAK at tick %d: %d -> %d", seed, t, start, books()))
		end
	end
	assert(next(timers) == nil, string.format("seed %d never settled after %d ticks", seed, t))
	if t > worst then worst = t end
end
print(string.format("  40 worlds: volume held every tick, all settled (worst %d ticks)", worst))

print("\nall checks passed")
