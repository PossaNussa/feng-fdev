--[[
	Mod Craft Table for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	Simple craft table
  ]]

-- Craft Table
minetest.register_node("craft_table:simple", {
	description = "Craft Table",
	tiles = {"craft_table_top.png", "default_wood.png", "craft_table_side.png",
		"craft_table_side.png", "craft_table_side.png", "craft_table_front.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = craft_table.on_rightclick,
})

-- Craft Table recipe (classic from MC)
minetest.register_craft({ 
	output = 'craft_table:simple',
	type = 'shapeless',
	recipe = {
		'group:wool',
		'group:wood',
	}
})
