--= Ghost for Creatures MOB-Engine (cme) =--
-- Copyright (c) 2015-2016 BlockMen <blockmen2015@gmail.com>
--
-- init.lua
--
-- This software is provided 'as-is', without any express or implied warranty. In no
-- event will the authors be held liable for any damages arising from the use of
-- this software.
--
-- Permission is granted to anyone to use this software for any purpose, including
-- commercial applications, and to alter it and redistribute it freely, subject to the
-- following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
-- claim that you wrote the original software. If you use this software in a
-- product, an acknowledgment in the product documentation is required.
-- 2. Altered source versions must be plainly marked as such, and must not
-- be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--
local ghost_textures = {
	"creatures_ghost.png",
	"wraith1.png",
	"wraith2.png",
	}
	
local function get_random_texture(self)
    self.base_texture = ghost_textures[math.random(#ghost_textures)]
    self.object:set_properties({textures = {self.base_texture}})
end

mobs:register_mob("ghosts:ghost", {
    -- Basic properties
    type = "monster",
    passive = false,
    attack_type = "dogfight",
    damage = 2,
    reach = 0.9,
    hp_min = 12,
    hp_max = 12,
    armor = 100,
    collisionbox = {-0.25, 0, -0.3, 0.25, 1.3, 0.3},
    visual = "mesh",
    mesh = "creatures_ghost.b3d",
    textures = {ghost_textures[1]},
    on_spawn = get_random_texture,
    makes_footstep_sound = false,
    sounds = {
        random = "creatures_ghost",
        damage = "creatures_ghost_hit",
        death = "creatures_ghost_death",
    },
    
    -- Movement and flying properties
    walk_velocity = 2,
    run_velocity = 2.6,
    jump = true,
    floats = 1,
    fly = true,
    fly_in = "air",  -- Assuming ghost flies in air
    view_range = 12,

    -- Combat properties
    water_damage = 0,
    lava_damage = 0,
    light_damage = 1,  -- Assuming ghost takes damage in light
    fall_damage = 0,  -- Ghosts don't take fall damage
    knock_back = true,  -- Ghosts can be knocked back

    -- Animation properties
    animation = {
        speed_normal = 15,
        speed_run = 25,
        stand_start = 0,
        stand_end = 80,
        walk_start = 102,
        walk_end = 122,
        run_start = 102,
        run_end = 122,
        punch_start = 102,
        punch_end = 122,
    },
	})


mobs:register_spawn("ghosts:ghost", {"bones:bones", "default:sand", "default:dirt_with_coniferous_litter", "default:dirt_with_grass"}, 15, 0, 15000, 5, 31000, false)