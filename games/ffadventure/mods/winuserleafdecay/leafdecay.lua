



if minetest.get_modpath("livingjungle") then

winuserleafdecay.register_winleafdecay({
	trunks = {"livingjungle:samauma_trunk"},
	leaves = {"livingjungle:samauma_leaves", "livingjungle:lianaleaves", "livingjungle:lianabranch", "livingjungle:lianabranch3"},
	radius = 9
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingjungle:liana_stem"},
	leaves = {"livingjungle:lianaleaves", "livingjungle:lianabranch", "livingjungle:lianabranch3"},
	radius = 6
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingjungle:mangrove_root2", "livingjungle:mangrove_stem"},
	leaves = {"livingjungle:mangrove_leaves"},
	radius = 5
})

end

if minetest.get_modpath("livingdesert") then

winuserleafdecay.register_winleafdecay({
	trunks = {"livingdesert:date_palm_trunk"},
	leaves = {"livingdesert:date_palm_leaves", "livingdesert:date_palm_fruits"},
	radius = 3
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingdesert:euphorbia_trunk"},
	leaves = {"livingdesert:euphorbia_leaves"},
	radius = 3
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingdesert:figcactus_trunk"},
	leaves = {"livingdesert:figcactus_flower", "livingdesert:figcactus_fruit"},
	radius = 3
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingdesert:saxaul_trunk"},
	leaves = {"livingdesert:saxaul_leaves"},
	radius = 3
})

winuserleafdecay.register_winleafdecay({
	trunks = {"livingdesert:pine_trunk"},
	leaves = {"livingdesert:pine_leaves", "livingdesert:pine_leaves2", "livingdesert:pine_leaves3"},
	radius = 3
})

end
