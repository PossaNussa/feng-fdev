--[[
    X Bows. Adds bow and arrows with API.
    Copyright (C) 2023 SaKeL <juraj.vajda@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to juraj.vajda@gmail.com
--]]

XBows:register_particle_effect('arrow', {
    amount = 3,           -- More particles (was 1)
    time = 0.1,
    minexptime = 0.3,
    maxexptime = 0.5,
    minsize = 3,          -- Bigger (was 2)
    maxsize = 5,          -- Bigger (was 2)
    texture = 'x_bows_arrow_particle.png',
    animation = {
        type = 'vertical_frames',
        aspect_w = 8,
        aspect_h = 8,
        length = 1,
    },
    glow = 4,             -- More glow (was 1)
    minvel = { x = -0.5, y = -0.3, z = -0.5 },
    maxvel = { x = 0.5, y = 0.1, z = 0.5 },
    minacc = { x = 0, y = -0.5, z = 0 },
    maxacc = { x = 0, y = -0.5, z = 0 }
})

XBows:register_particle_effect('arrow_crit', {
    amount = 5,           -- More particles for crit (was 1)
    time = 0.1,
    minexptime = 0.4,
    maxexptime = 0.7,
    minsize = 4,          -- Bigger (was 2)
    maxsize = 7,          -- Bigger (was 2)
    texture = 'x_bows_arrow_particle.png^[colorize:#FF4400:180',  -- Brighter orange-red
    animation = {
        type = 'vertical_frames',
        aspect_w = 8,
        aspect_h = 8,
        length = 1,
    },
    glow = 10,            -- Strong glow for crits (was 1)
    minvel = { x = -1, y = -0.5, z = -1 },
    maxvel = { x = 1, y = 0.5, z = 1 },
    minacc = { x = 0, y = -0.3, z = 0 },
    maxacc = { x = 0, y = -0.3, z = 0 }
})

XBows:register_particle_effect('arrow_fast', {
    amount = 4,           -- More particles (was 1)
    time = 0.1,
    minexptime = 0.3,
    maxexptime = 0.5,
    minsize = 3,          -- Bigger (was 2)
    maxsize = 6,          -- Bigger (was 2)
    texture = 'x_bows_arrow_particle.png^[colorize:#00AAFF:100',  -- Brighter blue
    animation = {
        type = 'vertical_frames',
        aspect_w = 8,
        aspect_h = 8,
        length = 1,
    },
    glow = 8,             -- More glow (was 1)
    minvel = { x = -0.8, y = -0.4, z = -0.8 },
    maxvel = { x = 0.8, y = 0.3, z = 0.8 },
    minacc = { x = 0, y = -0.4, z = 0 },
    maxacc = { x = 0, y = -0.4, z = 0 }
})

XBows:register_particle_effect('bubble', {
    amount = 1,
    time = 1,
    minvel = { x = 1, y = 1, z = 0 },
    maxvel = { x = 1, y = 1, z = 0 },
    minacc = { x = 1, y = 1, z = 1 },
    maxacc = { x = 1, y = 1, z = 1 },
    minexptime = 0.2,
    maxexptime = 0.5,
    minsize = 0.5,
    maxsize = 1,
    texture = 'x_bows_bubble.png'
})

-- Impact effects for satisfying hit feedback
XBows:register_particle_effect('impact', {
    amount = 12,
    time = 0.1,
    minexptime = 0.2,
    maxexptime = 0.5,
    minsize = 1,
    maxsize = 3,
    texture = 'x_bows_arrow_particle.png^[colorize:#FFFFFF:200',
    glow = 5,
    minvel = { x = -4, y = 1, z = -4 },
    maxvel = { x = 4, y = 6, z = 4 },
    minacc = { x = 0, y = -12, z = 0 },
    maxacc = { x = 0, y = -12, z = 0 }
})

XBows:register_particle_effect('impact_crit', {
    amount = 20,
    time = 0.1,
    minexptime = 0.3,
    maxexptime = 0.7,
    minsize = 2,
    maxsize = 5,
    texture = 'x_bows_arrow_particle.png^[colorize:#FF2200:220',
    glow = 14,
    minvel = { x = -6, y = 2, z = -6 },
    maxvel = { x = 6, y = 10, z = 6 },
    minacc = { x = 0, y = -10, z = 0 },
    maxacc = { x = 0, y = -10, z = 0 }
})

XBows:register_particle_effect('impact_node', {
    amount = 8,
    time = 0.1,
    minexptime = 0.15,
    maxexptime = 0.4,
    minsize = 1,
    maxsize = 2,
    texture = 'x_bows_arrow_particle.png^[colorize:#888888:180',
    glow = 2,
    minvel = { x = -3, y = 0.5, z = -3 },
    maxvel = { x = 3, y = 4, z = 3 },
    minacc = { x = 0, y = -14, z = 0 },
    maxacc = { x = 0, y = -14, z = 0 }
})
