--[[
	Mod Craft Table for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.

	Simple craft table
  ]]

-- All 15 wool-coloured variants, red included
local color_defs = {
	{"red",        "wool:red",        "Red"},
	{"white",      "wool:white",      "White"},
	{"grey",       "wool:grey",       "Grey"},
	{"dark_grey",  "wool:dark_grey",  "Dark Grey"},
	{"black",      "wool:black",      "Black"},
	{"orange",     "wool:orange",     "Orange"},
	{"yellow",     "wool:yellow",     "Yellow"},
	{"green",      "wool:green",      "Green"},
	{"dark_green", "wool:dark_green", "Dark Green"},
	{"cyan",       "wool:cyan",       "Cyan"},
	{"blue",       "wool:blue",       "Blue"},
	{"violet",     "wool:violet",     "Violet"},
	{"magenta",    "wool:magenta",    "Magenta"},
	{"pink",       "wool:pink",       "Pink"},
	{"brown",      "wool:brown",      "Brown"},
}

for _, c in ipairs(color_defs) do
	local cname, citem, cdesc = c[1], c[2], c[3]
	-- Red uses the original textures (no _red suffix generated)
	local top   = cname == "red" and "craft_table_top.png"   or "craft_table_top_"   .. cname .. ".png"
	local side  = cname == "red" and "craft_table_side.png"  or "craft_table_side_"  .. cname .. ".png"
	local front = cname == "red" and "craft_table_front.png" or "craft_table_front_" .. cname .. ".png"

	minetest.register_node("craft_table:simple_" .. cname, {
		description = "Craft Table (" .. cdesc .. ")",
		tiles = {top, "default_wood.png", side, side, side, front},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, craft_table=1},
		legacy_facedir_simple = true,
		is_ground_content = false,
		sounds = default.node_sound_wood_defaults(),
		on_rightclick = craft_table.on_rightclick,
		on_construct = craft_table.on_construct,
		on_destruct = craft_table.on_destruct,
		can_dig = craft_table.can_dig,
	})

	minetest.register_craft({
		output = "craft_table:simple_" .. cname,
		type = "shapeless",
		recipe = {citem, "group:tree"},
	})
end

-- Backward-compat alias so any craft_table:simple already in the world loads as red
minetest.register_alias("craft_table:simple", "craft_table:simple_dark_green")
