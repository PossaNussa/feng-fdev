local blocos={
	{"farming:dry_soil"},
	{"farming:dry_soil_wet"},
	{"farming:soil"},
	{"farming:soil_wet"},
}

for i = 1, #blocos, 1 do
minetest.override_item(blocos[i][1], {
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	node_box = {
	type = "fixed",
	fixed = {
	{-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
	},
},
})
end
