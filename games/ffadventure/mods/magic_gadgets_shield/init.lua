minetest.register_node("magic_gadgets_shield:magic_shield", {
    description = "Magic Shield Block",
    tiles = {"magic_gadgets_shield_shield_node.png"},
    drawtype = "glasslike",
    diggable = false,
    walkable = true,
    pointable = true,
    sunlight_propagades = true,
    drop = "",
    light_source = 8,
    groups = {not_in_creative_inventory = 1},
    sounds = default.node_sound_stone_defaults(),
    on_timer = function(pos, elapsed)
        minetest.add_particlespawner({
            amount = 8,
            time = 0.05,
            minpos = {x=pos.x-0.25, y=pos.y, z=pos.z-0.25},
            maxpos = {x=pos.x+0.25, y=pos.y+0.5, z=pos.z+0.25},
            minvel = {x=-1, y=-1, z=-1},
            maxvel = {x=1, y=1, z=1},
            minacc = {x=0, y=2, z=0},
            maxacc = {x=0, y=2, z=0},
            minexptime = 1,
            maxexptime = 4,
            minsize = 2,
            maxsize = 4,
            glow = 14,
            texture = "magic_gadgets_shield_shield_particle.png",
        })
        minetest.set_node(pos, {name = "air"})
    end
})

gadgets.register_gadget({
      name = "magic_gadgets_shield:tome_shield",
      description = "Tome Of Shielding",
      texture = "magic_gadgets_shield_tome_shield.png",
      mana_per_use = 100,
      use_sound = "magic_gadgets_spell_cast",
      use_sound_gain = 1,

      custom_on_use = function(itemstack, user, pointed_thing)

	 local height_main = 5
	 local width_main = 3
	 local height_side = 5
	 local width_top = 3
	 local timeout = 30

	 local pos = user:get_pos()
	 local bpos = {x = pos.x, y = pos.y - 2, z = pos.z}
	 local name = user:get_player_name()

	 local dir = user:get_look_dir()
	 local facedir = minetest.dir_to_facedir(dir)
	 local dirvec = {}
	 if facedir == 0 then
	    dirvec = {x = 0, y = 0, z = 1}
	 elseif facedir == 1 then
	    dirvec = {x = 1, y = 0, z = 0}
	 elseif facedir == 2 then
	    dirvec = {x = 0, y = 0, z = -1}
	 elseif facedir == 3 then
	    dirvec = {x = -1, y = 0, z = 0}
	 end
	 for i = 1,height_main do
	    for j = -math.floor(width_main/2),math.floor(width_main/2) do
	       local temppos = {x = bpos.x + (j * dirvec.z) + 3 * dirvec.x --[[(j * dirvec.z)]], y = bpos.y + i, z = bpos.z + (j * dirvec.x) + 3 * dirvec.z --[[+ (j * dirvec.x)]]}
	       if not minetest.is_protected(temppos, name) then
		  local node = minetest.get_node_or_nil(temppos)
		  if node and node.name == "air" then
		     minetest.set_node(temppos, {name = "magic_gadgets_shield:magic_shield"})
		     minetest.get_node_timer(temppos):start(timeout)
		     minetest.add_particlespawner({
			   amount = 8,
			   time = 0.05,
			   minpos = {x=temppos.x-0.25, y=temppos.y, z=temppos.z-0.25},
			   maxpos = {x=temppos.x+0.25, y=temppos.y+0.5, z=temppos.z+0.25},
			   minvel = {x=-1, y=-1, z=-1},
			   maxvel = {x=1, y=1, z=1},
			   minacc = {x=0, y=2, z=0},
			   maxacc = {x=0, y=2, z=0},
			   minexptime = 1,
			   maxexptime = 4,
			   minsize = 2,
			   maxsize = 4,
			   glow = 14,
			   texture = "magic_gadgets_shield_shield_particle.png",
		     })
		  end
	       end
	    end  
	 end
	 for i = 1,height_side do
	    for _, j in pairs({-2, 2}) do
	       local temppos = {x = bpos.x + (j * dirvec.z) + 2 * dirvec.x --[[(j * dirvec.z)]], y = bpos.y + i, z = bpos.z + (j * dirvec.x) + 2 * dirvec.z --[[+ (j * dirvec.x)]]}
	       if not minetest.is_protected(temppos, name) then
		  local node = minetest.get_node_or_nil(temppos)
		  if node and node.name == "air" then
		     minetest.set_node(temppos, {name = "magic_gadgets_shield:magic_shield"})
		     minetest.get_node_timer(temppos):start(timeout)
		     minetest.add_particlespawner({
			   amount = 8,
			   time = 0.05,
			   minpos = {x=temppos.x-0.25, y=temppos.y, z=temppos.z-0.25},
			   maxpos = {x=temppos.x+0.25, y=temppos.y+0.5, z=temppos.z+0.25},
			   minvel = {x=-1, y=-1, z=-1},
			   maxvel = {x=1, y=1, z=1},
			   minacc = {x=0, y=2, z=0},
			   maxacc = {x=0, y=2, z=0},
			   minexptime = 1,
			   maxexptime = 4,
			   minsize = 2,
			   maxsize = 4,
			   glow = 14,
			   texture = "magic_gadgets_shield_shield_particle.png",
		     })
		  end
	       end
	    end  
	 end
	 for i = -math.floor(width_top/2),math.floor(width_top/2) do
	       local temppos = {x = bpos.x + (i * dirvec.z) + 2 * dirvec.x --[[(j * dirvec.z)]], y = bpos.y + 6, z = bpos.z + (i * dirvec.x) + 2 * dirvec.z --[[+ (j * dirvec.x)]]}
	       if not minetest.is_protected(temppos, name) then
		  local node = minetest.get_node_or_nil(temppos)
		  if node and node.name == "air" then
		     minetest.set_node(temppos, {name = "magic_gadgets_shield:magic_shield"})
		     minetest.get_node_timer(temppos):start(timeout)
		     minetest.add_particlespawner({
			   amount = 8,
			   time = 0.05,
			   minpos = {x=temppos.x-0.25, y=temppos.y, z=temppos.z-0.25},
			   maxpos = {x=temppos.x+0.25, y=temppos.y+0.5, z=temppos.z+0.25},
			   minvel = {x=-1, y=-1, z=-1},
			   maxvel = {x=1, y=1, z=1},
			   minacc = {x=0, y=2, z=0},
			   maxacc = {x=0, y=2, z=0},
			   minexptime = 1,
			   maxexptime = 4,
			   minsize = 2,
			   maxsize = 4,
			   glow = 14,
			   texture = "magic_gadgets_shield_shield_particle.png",
		     })
		  end
	       end
	    end
      end,
      recipe = {
	 {
            {"magic_materials:ice_rune", "magic_materials:energy_rune", "magic_materials:ice_rune"},
            {"", "magic_materials:enchanted_book", ""},
            {"", "", ""}
	 },
      },
})
