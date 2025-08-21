--This file adds crafting recipes depending on which dependencies are installed


if minetest.get_modpath("default") and
	minetest.get_modpath("bucket")
then
	minetest.register_craft(
	{
		output = "hot_air_balloons:item",
		recipe =
		{
			{"group:balloon", "group:balloon",      "group:balloon"},
			{"group:balloon", "bucket:bucket_oil", "group:balloon"},
			{"",              "group:wood",         ""             },
		},
	})
	return
end

	minetest.register_craft(
	{
		output = "hot_air_balloons:item",
		recipe =
		{
			{"group:balloon", "group:balloon",      "group:balloon"},
			{"group:balloon", "group:oil", "group:balloon"},
			{"",              "group:wood",         ""             },
		},
	})

	minetest.register_craft(
	{
		output = "hot_air_balloons:item",
		recipe =
		{
			{"group:balloon", "group:balloon",      "group:balloon"},
			{"group:balloon", "bucket:fuel", "group:balloon"},
			{"",              "group:wood",         ""             },
		},
	})
if minetest.get_modpath("mcl_buckets") and
	minetest.get_modpath("mcl_mobitems") and
	minetest.get_modpath("mcl_core")
then
	minetest.register_craft(
	{
		output = "hot_air_balloons:item",
		recipe =
		{
			{"mcl_mobitems:leather", "mcl_mobitems:leather", "mcl_mobitems:leather"},
			{"mcl_mobitems:leather", "bucket:bucket_lava",   "mcl_mobitems:leather"},
			{"mcl_mobitems:string",  "group:wood",           "mcl_mobitems:string" },
		},
	})
	return
end
--[[
minetest.register_craft(
{
	type = "aircraft"
}
]]

--make balloon work with mcl2 creative mode

--announce in chat if no crafting recipe was added.
minetest.after(2,
	function()
		minetest.chat_send_all("Optional dependencies for hot_air_balloons are missing so no crafting recipe was added.\n"..
		"Install either 'default' and 'bucket' or 'mcl_core', 'mcl_mobitems' 'and mcl_buckets' if this bothers you.\n"..
		"All other functions of the mod should be unaffected by this.")
	end)
