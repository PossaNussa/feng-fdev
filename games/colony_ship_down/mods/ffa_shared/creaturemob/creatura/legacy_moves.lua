-- creaturemob :: creatura/legacy_moves.lua
--
-- creatura.get_next_move / get_next_move_3d, deleted upstream in the Dec 2025
-- release. Nothing in this game calls them, but they were public API for two
-- years and third-party creatura mobs do, so they are restored verbatim from
-- the Dec 2023 release rather than dropped.
--
-- Loaded after the rest of the API, so the locals below resolve to the shared,
-- bug-fixed implementations in core/world.lua.

local fast_ray_sight = creatura.fast_ray_sight
local vec_dist = vector.distance
local vec_add = vector.add
local vec_equals = vector.equals
local floor = math.floor
local abs = math.abs

local function clamp(val, min_n, max_n)
	if val < min_n then return min_n end
	if max_n < val then return max_n end
	return val
end

local function vec_raise(v, n)
	if not v then return end
	return {x = v.x, y = v.y + n, z = v.z}
end

local function vec_center(v)
	return {x = floor(v.x + 0.5), y = floor(v.y + 0.5), z = floor(v.z + 0.5)}
end

function creatura.get_next_move(self, pos2)
	local last_move = self._movement_data.last_move
	local width = self.width
	local height = self.height
	local pos = self.object:get_pos()
	pos = {
		x = floor(pos.x),
		y = pos.y + 0.01,
		z = floor(pos.z)
	}
	pos.y = pos.y + 0.01
	if last_move
	and last_move.pos then
		local last_call = minetest.get_position_from_hash(last_move.pos)
		last_move = minetest.get_position_from_hash(last_move.move)
		if vec_equals(vec_center(last_call), vec_center(pos)) then
			return last_move
		end
	end
	local neighbors = {
		vec_add(pos, {x = 1, y = 0, z = 0}),
		vec_add(pos, {x = 1, y = 0, z = 1}),
		vec_add(pos, {x = 0, y = 0, z = 1}),
		vec_add(pos, {x = -1, y = 0, z = 1}),
		vec_add(pos, {x = -1, y = 0, z = 0}),
		vec_add(pos, {x = -1, y = 0, z = -1}),
		vec_add(pos, {x = 0, y = 0, z = -1}),
		vec_add(pos, {x = 1, y = 0, z = -1})
	}
	local _next
	table.sort(neighbors, function(a, b)
		return vec_dist(a, pos2) < vec_dist(b, pos2)
	end)
	for i = 1, #neighbors do
		local neighbor = neighbors[i]
		local can_move = fast_ray_sight(pos, neighbor)
		if vec_equals(neighbor, pos2) then
			can_move = true
		end
		if can_move
		and not moveable(neighbor, width, height) then
			can_move = false
			if moveable(vec_raise(neighbor, 0.5), width, height) then
				can_move = true
			end
		end
		if can_move
		and not self:is_pos_safe(neighbor) then
			can_move = false
		end
		if can_move then
			_next = vec_raise(neighbor, 0.1)
			break
		end
	end
	if _next then
		self._movement_data.last_move = {
			pos = minetest.hash_node_position(pos),
			move = minetest.hash_node_position(_next)
		}
		_next = {
			x = floor(_next.x),
			y = _next.y,
			z = floor(_next.z)
		}
	end
	return _next
end

function creatura.get_next_move_3d(self, pos2)
	local last_move = self._movement_data.last_move
	local width = self.width
	local height = self.height
	local scan_width = width * 2
	local pos = self.object:get_pos()
	pos.y = pos.y + 0.5
	if last_move
	and last_move.pos then
		local last_call = minetest.get_position_from_hash(last_move.pos)
		last_move = minetest.get_position_from_hash(last_move.move)
		if vec_equals(vec_center(last_call), vec_center(pos)) then
			return last_move
		end
	end
	local neighbors = {
		vec_add(pos, {x = scan_width, y = 0, z = 0}),
		vec_add(pos, {x = scan_width, y = 0, z = scan_width}),
		vec_add(pos, {x = 0, y = 0, z = scan_width}),
		vec_add(pos, {x = -scan_width, y = 0, z = scan_width}),
		vec_add(pos, {x = -scan_width, y = 0, z = 0}),
		vec_add(pos, {x = -scan_width, y = 0, z = -scan_width}),
		vec_add(pos, {x = 0, y = 0, z = -scan_width}),
		vec_add(pos, {x = scan_width, y = 0, z = -scan_width})
	}
	local next
	table.sort(neighbors, function(a, b)
		return vec_dist(a, pos2) < vec_dist(b, pos2)
	end)
	for i = 1, #neighbors do
		local neighbor = neighbors[i]
		local can_move = fast_ray_sight({x = pos.x, y = neighbor.y, z = pos.z}, neighbor)
		if not moveable(vec_raise(neighbor, 0.6), width, height) then
			can_move = false
		end
		if vec_equals(neighbor, pos2) then
			can_move = true
		end
		if can_move then
			next = neighbor
			break
		end
	end
	if next then
		self._movement_data.last_move = {
			pos = minetest.hash_node_position(pos),
			move = minetest.hash_node_position(next)
		}
	end
	return vec_raise(next, clamp((pos2.y - pos.y) + -0.6, -1, 1))
end
