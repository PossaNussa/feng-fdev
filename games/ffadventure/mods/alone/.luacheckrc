unused_args = false
allow_defined_top = true
max_line_length = false
redefined = false
ignore = {
	--this is used intentionally in the codebase sometimes
	"512", -- Loop can be executed at most once.
}
globals = {
	"core",
}


read_globals = {
	"DIR_DELIM",
	"dump",
	"dump2",
	"vector",
	"VoxelManip",
	"VoxelArea",
	"PseudoRandom",
	"PcgRandom",
	"PerlinNoise",
	"PerlinNoiseMap",
	"ItemStack",
	"Settings",
	"unpack",
	"loadstring",

	table = {
		fields = {
			update = { read_only = false },
			update_nil = { read_only = false },
			merge = { read_only = false },
			"copy",
			"indexof",
			"insert_all",
			"key_value_swap",
			"shuffle",
			reverse = { read_only = false },
		}
	},

	string = {
		fields = {
			"split",
			"trim",
		}
	},

	math = {
		fields = {
			"hypot",
			"sign",
			"factorial",
			"round",
		}
	},
	------
	--MODS
	------

	"named_waypoints",
	"tpad",

	-- Mineclonia
	"mcl_spawn",
	"mcl_structures",
	"mcl_util",
	"mcl_villages",
	"mcl_walls",
	--"mobs_mc",

	-- Minetest Game
	"beds",
	"spawn",

	-- VoxelLibre
	"settlements",
}
