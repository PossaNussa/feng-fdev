-- Sheep Mod for Mobs Redo

-- Sheep Wool Colors
local wool_colors = {"white", "grey", "black", "brown"}

local function get_sheep_textures(color)
    return {"creatures_sheep.png^creatures_sheep_" .. color .. ".png"}
end

-- Registering Sheep Mob
mobs:register_mob("sheep:sheep", {
    type = "animal",
    passive = true,
    hp_min = 8,
    hp_max = 10,
    armor = 200,
    collisionbox = {-0.5, -0.01, -0.55, 0.5, 1.1, 0.55},
    visual = "mesh",
    mesh = "creatures_sheep.b3d",
    textures = get_sheep_textures("white"),  -- default texture
    makes_footstep_sound = true,
    walk_velocity = 1.3,
    run_velocity = 2,
    jump = true,
    sounds = {
        random = "creatures_sheep",
        damage = "creatures_sheep",
        death = "creatures_sheep",
    },
    drops = {
        {name = "creatures:flesh", chance = 1, min = 1, max = 2},
        {name = "wool:white", chance = 1, min = 1, max = 2} -- Adjust wool color based on sheep color
    },
    animation = {
        speed_normal = 15,
        speed_run = 18,
        stand_start = 0,
        stand_end = 60,
        walk_start = 81,
        walk_end = 101,
        run_start = 81,
        run_end = 101,
        punch_start = 107,
        punch_end = 170,
        eat_start = 107,
        eat_end = 170,
    },
    follow = {"farming:wheat"},
    view_range = 8,
    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        local name = item:get_name()
        if name == "sheep:shears" and self.has_wool then
            -- Shearing logic
            self.has_wool = false
            -- Update wool drop logic to match color
            local pos = self.object:get_pos()
            minetest.add_item(pos, "wool:" .. self.wool_color)
            -- Play shearing sound
            minetest.sound_play("sheep_shears", {object = self.object})
            item:add_wear(65535/100) -- Wear out shears
            clicker:set_wielded_item(item)
            -- Update texture to remove wool
            self.object:set_properties({textures = get_sheep_textures(self.wool_color)})
        end
    end,
    on_replace = function(self, pos, oldnode, newnode)
        self.object:set_animation({x = 107, y = 170})  -- Trigger eating animation
        minetest.after(2, function()
            self.has_wool = true -- Regrow wool
            -- Update texture to have wool
            self.object:set_properties({textures = get_sheep_textures(self.wool_color)})
        end)
    end,
    on_spawn = function(self)
        self.wool_color = wool_colors[math.random(#wool_colors)]
        self.object:set_properties({textures = get_sheep_textures(self.wool_color)})
        self.has_wool = true
    end,
    on_activate = function(self, staticdata, dtime_s)
        if self.wool_color == nil then
            self.wool_color = wool_colors[math.random(#wool_colors)]
            self.object:set_properties({textures = get_sheep_textures(self.wool_color)})
        end
        if self.has_wool == nil then
            self.has_wool = true
        end
    end,
})

-- Shears Tool
minetest.register_tool("sheep:shears", {
    description = "Shears",
    inventory_image = "creatures_shears.png",
    -- Tool capabilities and other properties
})

-- Shears Crafting
minetest.register_craft({
    output = "sheep:shears",
    recipe = {
        {"", "default:steel_ingot"},
        {"default:steel_ingot", "default:stick"}
    }
})

-- Register Spawn
mobs:register_spawn("sheep:sheep", {"default:dirt_with_grass"}, 20, 10, 15000, 2, 31000)

-- Spawn Eggs and Spawners (optional)
mobs:register_egg("sheep:sheep", "Sheep Spawn Egg", "creatures_egg_sheep.png", 0)
