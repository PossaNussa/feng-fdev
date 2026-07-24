-- Loads the grid once generated

local function offset_conv(o)
	return (o + 0.5) * (1/256)
end

local grid = {
	dem = {bytes=2, signed=true},
	lakes = {bytes=2, signed=true},
	dirs = {bytes=1, signed=false},
	rivers = {bytes=4, signed=false},

	offset_x = {bytes=1, signed=true, conv=offset_conv},
	offset_y = {bytes=1, signed=true, conv=offset_conv},
}

local sfile = io.open(mapgen_rivers.data_path .. 'size', 'r')
assert(sfile, '[mapgen_rivers] Size file missing!')
local X, Z = sfile:read('*n'), sfile:read('*n')
assert(X and Z, '[mapgen_rivers] Unreadable size file!')

local sbyte = string.byte

local loader_mt = {
	__index = function(loader, i)
		if type(i) ~= 'number' then
			return
		end
		local file = loader.file
		local bytes = loader.bytes
		file:seek('set', (i-1)*bytes)
		local strnum = file:read(bytes)

		local n = sbyte(strnum, 1)
		if loader.signed and n >= 128 then
			n = n - 256
		end

		for j=2, bytes do
			n = n*256 + sbyte(strnum, j)
		end

		if loader.conv then
			n = loader.conv(n)
		end
		loader[i] = n
		return n
	end,
}

for name, map in pairs(grid) do
	local file = io.open(mapgen_rivers.data_path .. name, 'rb')
	assert(file, '[mapgen_rivers] Missing file "' .. name .. '".')
	local filesize = file:seek('end')
	assert(filesize >= X*Z*map.bytes, '[mapgen_rivers] File "' .. name .. '" appears to be truncated.')
	file:seek('set')

	map.file = file
	map.conv = map.conv or false
	setmetatable(map, loader_mt)
end

grid.size = {x=X, z=Z}

return grid
