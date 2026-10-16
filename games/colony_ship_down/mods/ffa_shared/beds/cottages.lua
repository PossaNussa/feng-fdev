-- beds/cottages.lua
-- Let players actually sleep in the cottages mod's beds.
--
-- The cottages mod ships its own right-click handler (cottages.sleep_in_bed)
-- that only plays a sit/lay-down nap animation -- it never skips the night or
-- talks to the beds mod. Here we re-point the sleepable cottages nodes at
-- beds.on_rightclick so they behave like every other bed: lie down, show the
-- "N of M players are in bed" form, and skip time when everyone is asleep.
--
-- Loaded only when the cottages mod is present (optional dependency).

local function bed_rightclick(pos, node, clicker, itemstack, pointed_thing)
	if clicker and clicker:is_player() then
		beds.on_rightclick(pos, clicker)
	end
	return itemstack
end

-- Every cottages node that cottages.sleep_in_bed treated as a sleeping spot.
local sleepables = {
	"cottages:bed_head",
	"cottages:bed_foot",
	"cottages:sleeping_mat",
	"cottages:sleeping_mat_head",
	"cottages:straw_mat",
}

for _, name in ipairs(sleepables) do
	if minetest.registered_nodes[name] then
		minetest.override_item(name, {
			on_rightclick = bed_rightclick,
		})
	end
end
