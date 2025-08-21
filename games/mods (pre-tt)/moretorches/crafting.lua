---mtg

minetest.register_craft({
	output = "moretorches:acaciatorch 4",
	recipe = {
		{"default:coal_lump"},
		{"default:acacia_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:acaciatorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:aspentorch 4",
	recipe = {
		{"default:coal_lump"},
		{"default:aspen_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:aspentorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:pinetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"default:pine_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:pinetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:jungletorch 4",
	recipe = {
		{"default:coal_lump"},
		{"default:junglewood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:jungletorch",
	burntime = 4,
})


---livingdesert

if minetest.get_modpath("livingdesert") then

minetest.register_craft({
	output = "moretorches:pinewoodtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingdesert:pine_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:pinewoodtorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:saxaultorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingdesert:saxaul_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:saxaultorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:datepalmtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingdesert:date_palm_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:datepalmtorch",
	burntime = 4,
})
end

---livingfloatlands

if minetest.get_modpath("livingfloatlands") then

minetest.register_craft({
	output = "moretorches:clubmosstorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:paleojungle_clubmoss_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:clubmosstorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:coniferetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:paleojungle_conifere_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:coniferetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:joshuatorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:paleodesert_joshua_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:joshuatorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:norwaysprucetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:coldsteppe_pine2_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:norwaysprucetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:paleooaktorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:giantforest_paleooak_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:paleooaktorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:paleopalmtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:paleojungle_paleopalm_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:paleopalmtorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:paleopinetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:paleodesert_paleopine_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:paleopinetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:paleoredwoodtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:giantforest_paleoredwood_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:paleoredwoodtorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:redpinetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:coldsteppe_pine_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:redpinetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:siberianlarixtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingfloatlands:coldsteppe_pine3_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:siberianlarixtorch",
	burntime = 4,
})
end

---livingjungle

if minetest.get_modpath("livingjungle") then

minetest.register_craft({
	output = "moretorches:livingjungletorch 4",
	recipe = {
		{"default:coal_lump"},
		{"livingjungle:samauma_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:livingjungletorch",
	burntime = 4,
})
end

---naturalbiomes

if minetest.get_modpath("naturalbiomes") then

minetest.register_craft({
	output = "moretorches:aldertorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:alder_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:aldertorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:alpinepine1torch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:alppine1_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:alpinepine1torch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:alpinepine2torch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:alppine2_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:alpinepine2torch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:bambootorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:bamboo_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:bambootorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:bananatorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:banana_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:bananatorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:birchtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:heath_birch_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:birchtorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:eukalyptustorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:outback_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:eukalyptustorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:junipertorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:heath_juniper_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:junipertorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:medpinetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:pine_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:medpinetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:olivetorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:olive_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:olivetorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:savannaacaciatorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:acacia_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:savannaacaciatorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:savannapalmtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:palm_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:savannapalmtorch",
	burntime = 4,
})

minetest.register_craft({
	output = "moretorches:willowtorch 4",
	recipe = {
		{"default:coal_lump"},
		{"naturalbiomes:heath_willow_wood"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "moretorches:willowtorch",
	burntime = 4,
})
end