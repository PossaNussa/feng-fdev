minetest.register_node("default:mud", {
    description = "Mud",
    tiles = {"mud.png"},
    groups = {crumbly = 3, soil = 1},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:tilding", {
    description = "Tilding",
    tiles = {"tilding.png"},
    groups = {crumbly = 2, soil = 1},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	output = "default:flint",
	recipe = {
		{"default:gravel", "default:gravel"},
		{"default:gravel", "default:gravel"}
	}
})
minetest.register_craft({
	output = "default:tilding",
	recipe = {
		{"default:mud", "default:mud"},
		{"default:mud", "default:mud"}
	}
})

minetest.register_abm({
    nodenames = {"default:dirt", "default:tilding"},
    neighbors = {"group:water"},
    interval = 12.0, -- Run every 1 second
    chance = 1, -- Select every 1 in 1 nodes
    action = function(pos)
        minetest.set_node(pos, {name="default:mud"})
    end,
})

minetest.register_craftitem("default:mud_brick_item", {
	description = "Mud Brick",
	inventory_image = "mbrick.png",
})

minetest.register_craft({
	type = "cooking",
	output = "default:mud_brick_item",
	recipe = "default:tilding",
})

minetest.register_node("default:mud_brick", {
	description = "Mud Brick",
	tiles = {"mudbrick.png"},
	groups = {cracky = 3},  -- Weak stone-type properties
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "default:mud_brick",
	recipe = {
		{"default:mud_brick_item", "default:mud_brick_item"},
		{"default:mud_brick_item", "default:mud_brick_item"},
	},
})
local speed_multiplier = 1.5
local original_speeds = {}
local key_states = {}
local tap_intervals = {}
local fov_intervals = {}
local speed_intervals = {}
local double_tap_max_interval = 0.5
local default_fov = 70
local sprint_fov = default_fov + 30
local fov_step = 1
local sprint_time_max = 38
local cooldown_time_max = 19
local sprint_times = {}
local cooldown_times = {}
local idle_times = {}
local speed_step = 0.1
local max_speed = 1.5
local bhop_timers = {}
local bhop_speed_bonus = 0.2
local bhop_max_interval = 3
local jump_timers = {} -- To track jump key presses
local can_double_jump = {} -- Tracks if player can double jump
local has_double_jumped = {} -- Tracks if double jump has been used

minetest.register_on_joinplayer(function(player)
    player:set_fov(default_fov)
end)

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        local control = player:get_player_control()
        
        idle_times[player_name] = idle_times[player_name] or 0
        sprint_times[player_name] = sprint_times[player_name] or sprint_time_max
        cooldown_times[player_name] = cooldown_times[player_name] or 0
        speed_intervals[player_name] = speed_intervals[player_name] or 0
        bhop_timers[player_name] = bhop_timers[player_name] or 0
        tap_intervals[player_name] = tap_intervals[player_name] or {}
        jump_timers[player_name] = jump_timers[player_name] or 0
        can_double_jump[player_name] = can_double_jump[player_name] or true
        has_double_jumped[player_name] = has_double_jumped[player_name] or false

        -- Get the current time
        local now = minetest.get_us_time() / 1000000.0

        -- Handle movement (sprint, bhop, etc.)
        if control.up then
            if not key_states[player_name] then
                key_states[player_name] = true

                if tap_intervals[player_name].up and now - tap_intervals[player_name].up < double_tap_max_interval then
                    if not original_speeds[player_name] and cooldown_times[player_name] <= 0 then
                        original_speeds[player_name] = player:get_physics_override().speed or 1
                        speed_intervals[player_name] = speed_step
                        fov_intervals[player_name] = fov_step
                        sprint_times[player_name] = sprint_time_max
                    end
                end

                tap_intervals[player_name].up = now
            end

            idle_times[player_name] = 0
        else
            key_states[player_name] = false
            idle_times[player_name] = idle_times[player_name] + dtime

            if idle_times[player_name] >= cooldown_time_max and cooldown_times[player_name] <= 0 then
                sprint_times[player_name] = sprint_time_max
            end

            if original_speeds[player_name] then
                player:set_physics_override({speed = original_speeds[player_name]})
                original_speeds[player_name] = nil
                speed_intervals[player_name] = -speed_step
                fov_intervals[player_name] = -fov_step
            end
        end

        -- Handle jumping logic
        if control.jump then
            -- Double-tap jump detection
            if now - jump_timers[player_name] < double_tap_max_interval and can_double_jump[player_name] and not has_double_jumped[player_name] then
                -- Trigger double jump
                player:add_velocity({x = 0, y = 6, z = 0}) -- Add upward velocity for the double jump
                has_double_jumped[player_name] = true -- Mark the double jump as used
            elseif not has_double_jumped[player_name] then
                -- Regular jump
                jump_timers[player_name] = now
            end
        end

        -- Reset double jump if player is on the ground
        if player:get_velocity().y == 0 then
            has_double_jumped[player_name] = false -- Reset the double-jump flag when player lands
            can_double_jump[player_name] = true
        end

        -- Smooth transition of speed (unchanged)
        if speed_intervals[player_name] then
            local current_speed = player:get_physics_override().speed or 1
            local target_speed = original_speeds[player_name] and original_speeds[player_name] * speed_multiplier or max_speed
            local new_speed = current_speed + speed_intervals[player_name]

            if (speed_intervals[player_name] > 0 and new_speed >= target_speed) or 
               (speed_intervals[player_name] < 0 and new_speed <= (original_speeds[player_name] or 1)) then
                speed_intervals[player_name] = nil
                new_speed = target_speed
            end
            player:set_physics_override({speed = new_speed})
        end

        -- Smooth transition of FOV (unchanged)
        if fov_intervals[player_name] then
            local current_fov = player:get_fov() or default_fov
            local new_fov = current_fov + fov_intervals[player_name]

            if (fov_intervals[player_name] > 0 and new_fov >= sprint_fov) or (fov_intervals[player_name] < 0 and new_fov <= default_fov) then
                fov_intervals[player_name] = nil
            else
                player:set_fov(new_fov)
            end
        end

        -- Decrement sprint time if player is sprinting (unchanged)
        if sprint_times[player_name] and original_speeds[player_name] then
            sprint_times[player_name] = math.max(0, sprint_times[player_name] - dtime)
            if sprint_times[player_name] <= 0 then
                player:set_physics_override({speed = original_speeds[player_name]})
                original_speeds[player_name] = nil
                speed_intervals[player_name] = -speed_step
                fov_intervals[player_name] = -fov_step
                cooldown_times[player_name] = cooldown_time_max
            end
        end

        -- Decrement cooldown time (unchanged)
        if cooldown_times[player_name] then
            cooldown_times[player_name] = math.max(0, cooldown_times[player_name] - dtime)
        end
    end
end)




minetest.register_entity("default:fish", {
    physical = true,
    collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    visual = "sprite",
    visual_size = {x=0.5, y=0.5},
    textures = {"fish.png"},
    hp_max = 1,
    
    on_step = function(self, dtime)
        if not self.timer then self.timer = 0 end
        if not self.bob_timer then self.bob_timer = 0 end
        self.timer = self.timer + dtime
        self.bob_timer = self.bob_timer + dtime

        local pos = self.object:get_pos()
        local node = minetest.get_node(pos)

        local is_in_water = (node.name == "default:water_source")
        
        if not is_in_water then
            -- Subject to gravity when not in water
            local velocity = self.object:get_velocity()
            self.object:set_velocity({x = velocity.x, y = -9.8 * dtime, z = velocity.z})
        end

        if self.timer >= 1 then
            self.timer = 0
            local speed = 2
            local dir_x = (math.random() * 2 - 1) * speed
            local dir_y = (math.random() * 2 - 1) * speed
            local dir_z = (math.random() * 2 - 1) * speed

            if not is_in_water then
                dir_y = -9.8 * dtime  -- Gravity when not in water
            end

            -- Check for undesirable nodes in the vicinity
            local nearby_mud = minetest.find_node_near(pos, 3, {"default:liquid_mud_source"})
            
            -- Check for mosasaur entities
            local nearby_mosa = false
            for _, object in ipairs(minetest.get_objects_inside_radius(pos, 3)) do
                local ent = object:get_luaentity()
                if ent and ent.name == "default:mosasaurus" then
                    nearby_mosa = true
                    break
                end
            end
            
            if nearby_mud or nearby_mosa then
                dir_x = -dir_x
                dir_y = -dir_y
                dir_z = -dir_z
            end

            self.object:set_velocity({x = dir_x, y = dir_y, z = dir_z})
        end
    end,
    
    on_punch = function(self, puncher)
        if not puncher or not puncher:is_player() then
            return
        end
        if puncher:get_luaentity() and puncher:get_luaentity().is_mosa then
            -- If killed by a mosasaur, don't drop anything
        else
            puncher:get_inventory():add_item("main", "default:fish_item")
        end
        self.object:remove()
    end,
})

minetest.register_craftitem("default:fish_item", {
    description = "Speckfish",
    inventory_image = "fish.png",
})

global_trout_table = {}

-- Trout Entity
minetest.register_entity("default:trout", {
    physical = true,
    collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    visual = "sprite",
    visual_size = {x=0.5, y=0.5},
    textures = {"trout.png"},
    hp_max = 1,
    scale_factor = 1.0,

    
    on_step = function(self, dtime)
        if not self.timer then self.timer = 0 end
        if not self.bob_timer then self.bob_timer = 0 end
        self.timer = self.timer + dtime
        self.bob_timer = self.bob_timer + dtime

        local pos = self.object:get_pos()
        local node = minetest.get_node(pos)

        local is_in_water = (node.name == "default:water_source")
        
        if not is_in_water then
            local velocity = self.object:get_velocity()
            self.object:set_velocity({x = velocity.x, y = -9.8 * dtime, z = velocity.z})
        end

        if self.bob_timer >= 2 then
            self.bob_timer = 0
            local speed = 2
            local dir_x = (math.random() * 2 - 1) * speed
            local dir_y = (math.random() * 2 - 1) * speed
            local dir_z = (math.random() * 2 - 1) * speed
            self.object:set_velocity({x = dir_x, y = dir_y, z = dir_z})
        end

        if self.timer >= 1 then
            self.timer = 0
            local speed = 4  -- Increased speed
            local dir_x = (math.random() * 2 - 1) * speed
            local dir_y = (math.random() * 2 - 1) * speed
            local dir_z = (math.random() * 2 - 1) * speed

            if not is_in_water then
                dir_y = -9.8 * dtime
            end

            -- Attract towards other cod entities if they are not too close
            for _, object in ipairs(minetest.get_objects_inside_radius(pos, 9)) do
                local ent = object:get_luaentity()
                if ent and ent.name == "default:trout" then
                    local target_pos = object:get_pos()
                    local distance = vector.distance(pos, target_pos)
                    if distance > 8 then
                        dir_x = (target_pos.x - pos.x)
                        dir_y = (target_pos.y - pos.y)
                        dir_z = (target_pos.z - pos.z)
                        break
                    end
                end
            end

            self.object:set_velocity({x = dir_x, y = dir_y, z = dir_z})
        end
    end,
    
    on_punch = function(self, puncher)
        if not puncher or not puncher:is_player() then
            return
        end
        if puncher:get_luaentity() and puncher:get_luaentity().is_mosa then
            -- If killed by a mosasaur, don't drop anything
        else
            puncher:get_inventory():add_item("main", "default:trout_item")
        end
        self.object:remove()
    end,
})

minetest.register_craftitem("default:trout_item", {
    description = "Cod",
    inventory_image = "trout.png",
})
minetest.register_abm({
    nodenames = {"default:water_source"},
    neighbors = {"air"},
    interval = 200,
    chance = 1000,
    action = function(pos, node)
        local new_pos = {x = pos.x, y = pos.y, z = pos.z}
        local objects = minetest.get_objects_inside_radius(new_pos, 2)
        local count_fish = 0
        local count_trout = 0

        local spawn_cap_fish = 15
        local spawn_cap_trout = 15

        for _, obj in pairs(objects) do
            local luaentity = obj:get_luaentity()
            if luaentity then
                if luaentity.name == "default:fish" then
                    count_fish = count_fish + 1
                elseif luaentity.name == "default:trout" then
                    count_trout = count_trout + 1
                end
            end
        end

        if count_fish < spawn_cap_fish then
            minetest.add_entity(new_pos, "default:fish")
        end

        if count_trout < spawn_cap_trout then
            minetest.add_entity(new_pos, "default:trout")
        end
    end,
})
minetest.register_craftitem("default:trout_spawn_egg", {
    description = "Trout Egg",
    inventory_image = "egg.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local pos = pointed_thing.above

        if minetest.get_node(pos).name == "default:water_source" then
            pos.y = pos.y - 0.5
            minetest.add_entity(pos, "default:trout")

            if not minetest.is_creative_enabled(user:get_player_name()) then
                itemstack:take_item()
            end
        end
        
        return itemstack
    end,
})

minetest.register_craftitem("default:fish_spawn_egg", {
    description = "Fish Egg",
    inventory_image = "egg.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            -- only spawn entity on node
            return
        end

        local pos = pointed_thing.above

        if minetest.get_node(pos).name == "default:water_source" then
            pos.y = pos.y - 0.5  -- Adjust to spawn inside water, near the bottom
            minetest.add_entity(pos, "default:fish")

            if not minetest.is_creative_enabled(user:get_player_name()) then
                itemstack:take_item() -- reduce the itemstack by 1 if creative mode is not enabled
            end
        end
        
        return itemstack
    end,
})

minetest.register_entity("default:yeti", {
    hp_max = 200,
    physical = true,
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    visual = "mesh",
    visual_size = {x=6.5, y=7.5},
    mesh = "EndlessYeti.b3d",
    textures = {"yeti.png"},
    makes_footstep_sound = true,
    view_range = 15,
    state = "wander",
    timer = 0,
    drown_timer = 0,  -- For drowning
    attack_timer = 0,  -- Added attack timer
    direction = {x=0, y=0, z=0},  -- Default direction set to negative Z-axis
    target = nil,
	drops = {
		{name = "animalia:beef_raw", min = 1, max = 3},
		{name = "animalia:leather", min = 1, max = 3}
		},
    animations = {
        walk = {x=0, y=24},
    },
    animation_timer = 0,

    on_activate = function(self)
        self.object:set_acceleration({x=0, y=-9.8, z=0})  -- Gravity
        self.timer = math.random(0, 15)
        self.attack_timer = 0  -- Initialize attack timer
        self.drown_timer = 0  -- Initialize drown timer
    end,

    on_step = function(self, dtime)
        self.object:set_acceleration({x=0, y=-9.8, z=0})  -- Consistent Gravity
        self.timer = self.timer + dtime
        self.attack_timer = self.attack_timer + dtime  -- Update attack timer
        self.drown_timer = self.drown_timer + dtime  -- Update drown timer
        local pos = self.object:get_pos()

        -- Drowning mechanics
        local node = minetest.get_node(pos).name
        if node == "default:water_source" then
            if self.drown_timer >= 10 then
                self.object:punch(self.object, 1.0, {
                    full_punch_interval = 1.0,
                    damage_groups = {fleshy = 5},
                }, nil)
            end
        else
            self.drown_timer = 0
        end

        -- State machine
        -- State machine
        if self.state == "idle" then
            if self.timer >= 9 then
                self.timer = 0
                if self.target then
                    self.state = "attack"
                else
                    self.state = "wander"
                    self.direction = {x=0, y=0, z=0}
                end
            else
                self.object:set_animation({x=0, y=0}, 30, 0)
                -- Simplified player detection
                local all_objects = minetest.get_objects_inside_radius(pos, 10)
                for _, obj in ipairs(all_objects) do
                    if obj:is_player() then
                        self.target = obj
                        local dir = vector.direction(pos, obj:get_pos())
                        local yaw = minetest.dir_to_yaw(-dir)
                        self.object:set_yaw(yaw)
                        break
                    end
                end
            end

        elseif self.state == "wander" then
            if self.timer >= 9 then
                self.timer = 0
                self.state = "idle"
                self.object:set_velocity({x=0, y=0, z=0})
            else
                if self.direction.x == 0 and self.direction.z == 0 then
                    self.direction = {x = math.random() - 0.5, y = 0, z = math.random() - 0.5}
                end
                local yaw = minetest.dir_to_yaw(self.direction)
                self.object:set_yaw(yaw + math.pi + (math.random() - 0.5) * 0.3)
                local new_vel = vector.multiply(vector.normalize(self.direction), 2)
                self.object:set_velocity(new_vel)
                self.object:set_animation({x=0, y=23}, 30, 0)
            end

        elseif self.state == "attack" then
            if self.target and self.target:is_player() then
                local current_velocity = self.object:get_velocity()  -- Get current velocity
                local dir = vector.direction(pos, self.target:get_pos())
                local dist = vector.distance(pos, self.target:get_pos())
                
                local speed_multiplier = 2  -- Speed boost when attacking
                local new_vel = vector.multiply(vector.normalize(dir), 2 * speed_multiplier)
                
                -- Preserve the y-component of the velocity to not interrupt gravity
                new_vel.y = -9 
                
                self.object:set_velocity(new_vel)
                
                local yaw = minetest.dir_to_yaw(-dir)
                self.object:set_yaw(yaw)  -- Face the player
                self.object:set_animation({x=0, y=23}, 30, 0)  -- Make attack animation same as wander animation
                

                if dist > 15 then
                    self.state = "wander"
                    self.target = nil
                else
                    if dist <= 2 and self.attack_timer >= 1.0 then  -- Slow down attack
                        self.target:punch(self.object, 1.0, {
                            full_punch_interval = 1.0,
                            damage_groups = {fleshy = 4},
                        }, nil)
                        self.attack_timer = 0  -- Reset attack timer
                    end
                end
            else
                self.state = "wander"
                self.timer = 0
                self.target = nil
            end
        end

    -- Simplified Jump Logic
    local vel = self.object:get_velocity()
    if vel then
        local look_ahead = {x = pos.x + vel.x, y = pos.y, z = pos.z + vel.z}
        local node_in_front = minetest.get_node(look_ahead).name
        local node_below_front = minetest.get_node({x = look_ahead.x, y = look_ahead.y - 0.3, z = look_ahead.z}).name

        if node_in_front ~= "air" or node_below_front ~= "air" then  -- If any obstacle, doesn't matter if walkable or not
            self.object:set_velocity({x = vel.x, y = 5, z = vel.z})
        end

    -- Fall Damage
    if vel.y < -10 then
        self.object:punch(self.object, 1.0, {
            full_punch_interval = 1.0,
            damage_groups = {fleshy = 5},
        }, nil)
    end
end
end,

    on_punch = function(self, hitter)
        if hitter:is_player() then
            self.target = hitter
            self.state = "attack"
            self.timer = 0
        end
    end,

})


minetest.register_craftitem("default:yeti_spawn_egg", {
	description = "Baby Yeti",
	inventory_image = "byeti.png", -- replace with your spawn egg texture
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			-- only spawn yeti on node
			return
		end

		local pos = minetest.get_pointed_thing_position(pointed_thing, true) -- get position of the pointed node
		if pos then
			pos.y = pos.y + 1 -- make sure the yeti is spawned above the node
			minetest.add_entity(pos, "default:yeti")
		end

		if not minetest.is_creative_enabled(user:get_player_name()) then
			-- decrease itemstack by 1 if not in creative mode
			itemstack:take_item()
		end
		return itemstack
	end,
})

-- Function to determine if it's currently day or night
local function is_night()
    local time_of_day = minetest.get_timeofday()
    return time_of_day < 0.2 or time_of_day > 0.8
end

-- Register the Yeti spawn ABM (Active Block Modifier)
minetest.register_abm({
    nodenames = {
        "default:snowblock",
        "default:snow",
        "default:dirt_with_snow",
        "default:ice",
        "default:cave_ice"
    },
    interval = 60,  -- Every 60 seconds
    chance = 6000,  -- Very rare chance of 1 in 6000
    catch_up = false,  -- Do not perform this ABM on previously unloaded blocks
action = function(pos, node)
    -- Check if there is already a Yeti within 100 nodes
    local objects = minetest.get_objects_inside_radius(pos, 100)
    local yeti_exists = false
    for _, obj in pairs(objects) do
        local ent = obj:get_luaentity()
        if ent and ent.name == "default:yeti" then
            yeti_exists = true
            break
        end
    end

    if yeti_exists then return end

    -- Check for daylight condition
    local spawn_chance_multiplier = 1
    if is_night() then
        spawn_chance_multiplier = 2
    end

    -- Use random number to determine if we should spawn Yeti
    local spawn_probability = 1  -- Adjust this to set the base chance (1 in 100 here)
    if math.random(1, 100) <= spawn_probability * spawn_chance_multiplier then
        minetest.add_entity(pos, "default:yeti")
    end
end,
})

local function has_vertical_support(pos)
    local below_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
    local below_node = minetest.get_node(below_pos)
    return minetest.get_item_group(below_node.name, "wood") > 0 or below_node.name ~= "air"
end

local function has_diagonal_support(pos)
    local diagonals = {
        {x = 1, z = 1}, {x = 1, z = -1},
        {x = -1, z = 1}, {x = -1, z = -1}
    }
    for _, diag in pairs(diagonals) do
        local check_pos = {x = pos.x + diag.x, y = pos.y, z = pos.z + diag.z}
        local node = minetest.get_node(check_pos)
        if minetest.get_item_group(node.name, "wood") > 0 then
            local support_pos = {x = check_pos.x + diag.x, y = check_pos.y, z = check_pos.z + diag.z}
            if has_vertical_support(support_pos) then
                local second_diag_pos = {x = pos.x + 2 * diag.x, y = pos.y, z = pos.z + 2 * diag.z}
                local second_node = minetest.get_node(second_diag_pos)
                if minetest.get_item_group(second_node.name, "wood") > 0 then
                    return true
                end
            end
        end
    end
    return false
end

local function has_sufficient_horizontal_support(pos)
    -- Check every position within a radius of 3 around the block.
    for dx = -3, 3 do
        for dz = -3, 3 do
            -- If the distance to the position is within 3, then check for vertical support.
            if math.sqrt(dx * dx + dz * dz) <= 3 then
                local check_pos = {x = pos.x + dx, y = pos.y, z = pos.z + dz}
                if has_vertical_support(check_pos) then
                    return true
                end
            end
        end
    end
    return false
end


minetest.register_entity("default:item_on_table", {
    initial_properties = {
        visual = "wielditem",
        visual_size = {x = 0.20, y = 0.20},
        textures = {"air"},
        collisionbox = {0},
        physical = false,
    },
    itemname = "",
    rotation = 0,

on_activate = function(self, staticdata)
    local data = minetest.deserialize(staticdata) or {}
    self.itemname = data.itemname or ""
    local pos = self.object:get_pos()
    local node_pos = {x = pos.x, y = pos.y - 0.5, z = pos.z}
    local meta = minetest.get_meta(node_pos)
    self.rotation = meta:get_float("rotation") or 0
    self.y_rotation = meta:get_float("y_rotation") or 0
    local type = meta:get_string("type")  -- Read the type from metadata

    if self.itemname ~= "" then
        self.object:set_properties({textures = {self.itemname}})
        if type == "weapon_stand" then
            self.object:set_rotation({x = 0, y = self.y_rotation, z = self.rotation})
        elseif type == "table" then
            self.object:set_rotation({x = math.pi/2, y = self.rotation, z = 0})
        end
    end
end,

get_staticdata = function(self)
    return minetest.serialize({
        itemname = self.itemname,
        rotation = self.rotation,
        y_rotation = self.y_rotation
    })
end,
})


-- Function to register a table node
local function register_table(name, description, texture)
    minetest.register_node("default:table_" .. name, {
        description = description .. " Table",
        drawtype = "mesh",
		visual_scale = 0.5,
        mesh = "table.obj", -- Ensure this is correct and the model exists in your mod folder.
        tiles = {texture},
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        overlay_tiles = {"blank.png"}, -- Start with a blank overlay.
        paramtype = "light",
        paramtype2 = "facedir",
after_place_node = function(pos, placer, itemstack, pointed_thing)
    local meta = minetest.get_meta(pos)
    meta:set_string("item", "")
    meta:set_float("rotation", 0)
    meta:set_string("type", "table")  -- Add this line
end,

        on_rightclick = function(pos, node, clicker, itemstack)
            local meta = minetest.get_meta(pos)
            local item = meta:get_string("item")

            -- Read and update the rotation angle
            local current_rotation = meta:get_float("rotation")
            local new_rotation = current_rotation + math.pi/4
            meta:set_float("rotation", new_rotation)

            if item and item ~= "" then
                -- If an item exists, find and update its rotation
                for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                    if obj and obj:get_luaentity() and obj:get_luaentity().name == "default:item_on_table" then
                        obj:set_rotation({x = math.pi/2, y = new_rotation, z = 0})
                        return itemstack
                    end
                end
            else
                -- Else place a new item on the table
                local wield_item = clicker:get_wielded_item()
                local wield_item_name = wield_item:get_name()

                if wield_item:is_empty() or not wield_item_name then return end

                meta:set_string("item", wield_item_name)
                local item_entity = minetest.add_entity({x = pos.x, y = pos.y + 0.5, z = pos.z}, "default:item_on_table")
    if item_entity then
        item_entity:set_rotation({x = math.pi/2, y = new_rotation, z = 0})
        local lua_entity = item_entity:get_luaentity()
        if lua_entity then
            lua_entity.itemname = wield_item_name
            lua_entity.rotation = new_rotation
            item_entity:set_properties({textures = {wield_item_name}})
        end
    end
    meta:set_float("rotation", new_rotation)  -- Store rotation in node's metadata


                itemstack:take_item(1)
                clicker:set_wielded_item(itemstack)
            end

            return itemstack
        end,

		on_punch = function(pos, node, puncher, pointed_thing)
			local meta = minetest.get_meta(pos)
			local item = meta:get_string("item")

			if not item or item == "" then return end

			puncher:get_inventory():add_item("main", item)
			meta:set_string("item", "")

    for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
        if obj and obj:get_luaentity() and obj:get_luaentity().name == "default:item_on_table" then
            obj:remove()
        end
    end
    meta:set_float("rotation", 0)  -- Reset rotation in node's metadata
		end,
	})
end


-- Register crafts for a given wood type
local function register_table_craft(name, node_name)
    minetest.register_craft({
        output = "default:table_" .. name,
        recipe = {
            {node_name, node_name, node_name},
            {"", node_name, ""},
            {"", node_name, ""}
        }
    })
end

-- Function to register a display stand node
local function register_weapon_stand(name, description, texture)
    minetest.register_node("default:weapon_stand_" .. name, {
        description = description .. " Weapon Stand",
        drawtype = "mesh",
        mesh = "weaponstand.obj", -- Make sure this model exists in your mod folder.
		visual_scale = 0.6,
        tiles = {texture},
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        paramtype = "light",
        paramtype2 = "facedir",
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local meta = minetest.get_meta(pos)
			meta:set_string("item", "")
            meta:set_float("rotation", 0)
			meta:set_float("z_rot", 3)
    meta:set_float("y_rotation", 0)
    meta:set_string("type", "weapon_stand")  -- Add this line
end,

on_rightclick = function(pos, node, clicker, itemstack)
    local meta = minetest.get_meta(pos)
    local item = meta:get_string("item")
    local current_rotation = meta:get_float("rotation") or 0
	local zcurrot = meta:get_float("z_rot")
    local y_rotation = meta:get_float("y_rotation") or 0
	local newcurrot = zcurrot + math.pi/4
    local new_rotation = current_rotation + math.pi/4
    local new_y_rotation = y_rotation + math.pi/4

    local player_dir = minetest.dir_to_facedir(clicker:get_look_dir())

    if item and item ~= "" then
        for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
            if obj and obj:get_luaentity() and obj:get_luaentity().name == "default:item_on_table" then
                if player_dir == 0 or player_dir == 2 then
                    obj:set_rotation({x = current_rotation, y = new_y_rotation, z = newcurrot})
                    meta:set_float("y_rotation", new_y_rotation)
                else
                    obj:set_rotation({x = new_rotation, y = y_rotation, z = zcurrot})
                    meta:set_float("rotation", new_rotation)
                end
                return itemstack
            end
        end
    else
        local wield_item = clicker:get_wielded_item()
        local wield_item_name = wield_item:get_name()

        if wield_item:is_empty() or not wield_item_name then return end

        meta:set_string("item", wield_item_name)
        local item_entity = minetest.add_entity({x = pos.x, y = pos.y + 0.5, z = pos.z}, "default:item_on_table")
        if item_entity then
            item_entity:set_rotation({x = math.pi/2, y = 0, z = 0})
            local lua_entity = item_entity:get_luaentity()
            if lua_entity then
                lua_entity.itemname = wield_item_name
                lua_entity.rotation = 0
                item_entity:set_properties({textures = {wield_item_name}})
            end
        end
        meta:set_float("rotation", 0)
        meta:set_float("y_rotation", 0)
        itemstack:take_item(1)
        clicker:set_wielded_item(itemstack)
    end

    return itemstack
end,



        on_punch = function(pos, node, puncher, pointed_thing)
            local meta = minetest.get_meta(pos)
            local item = meta:get_string("item")

            if not item or item == "" then return end

            puncher:get_inventory():add_item("main", item)
            meta:set_string("item", "")
            meta:set_float("rotation", 0)
            meta:set_float("y_rotation", 0)

            for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                if obj and obj:get_luaentity() and obj:get_luaentity().name == "default:item_on_table" then
                    obj:remove()
                end
            end
        end,
    })
end

-- Function to register crafts for weapon stand
local function register_weapon_stand_craft(name, node_name)
    minetest.register_craft({
        output = "default:weapon_stand_" .. name,
        recipe = {
            {node_name, node_name, node_name},
            {"group:stick", "", "group:stick"},
            {"group:stick", "group:stick", "group:stick"}
        }
    })
end

-- Loop through all registered nodes to find wood types and register corresponding tables, weapon stands, and crafts
for node_name, def in pairs(minetest.registered_nodes) do
    if def.groups and def.groups.wood and not def.groups.not_in_craft_guide then
        local wood_type = node_name:match(":([^:]+)$") -- Extracts the wood type from the node name
        if wood_type then
            local description = def.description or "Wooden"
            local texture = def.tiles and def.tiles[1] or "unknown_texture.png"
            
            -- Register tables
            register_table(wood_type, description, texture)  -- Existing function to register the table
            register_table_craft(wood_type, node_name)  -- Updated function to register the table craft
            
            -- Register weapon stands
            register_weapon_stand(wood_type, description, texture)  -- Existing function to register the weapon stand
            register_weapon_stand_craft(wood_type, node_name)  -- Updated function to register the weapon stand craft
        end
    end
end
-- Define the painting entity
local paintings = {
    {texture = "default_painting1.png", size = {x=1, y=1}},
    {texture = "default_painting2.png", size = {x=2, y=2}},
    {texture = "default_painting3.png", size = {x=2, y=1}},
    {texture = "default_painting4.png", size = {x=1, y=1}},
    {texture = "default_painting5.png", size = {x=1, y=2}},
    {texture = "default_painting6.png", size = {x=1.5, y=1.5}},
    {texture = "default_painting7.png", size = {x=1.5, y=1.5}},
    {texture = "default_painting8.png", size = {x=3, y=1.5}},
    {texture = "default_painting9.png", size = {x=3, y=3}},
    {texture = "default_painting10.png", size = {x=1.5, y=2}},
    {texture = "default_painting11.png", size = {x=1, y=1}},
    {texture = "default_painting12.png", size = {x=1, y=1}},
	{texture = "default_painting13.png", size = {x=2, y=2}},
	{texture = "default_painting14.png", size = {x=2, y=2}},
	{texture = "default_painting15.png", size = {x=1.5, y=1.5}},
	{texture = "tof.png", size = {x=1.5, y=1.5}},
	{texture = "monkeypaw.png", size = {x=1.5, y=1.5}},
	{texture = "tof.png", size = {x=1.5, y=1.5}},
	{texture = "stillmarch.png", size = {x=1.5, y=1.5}},
	{texture = "stillwater.png", size = {x=1.5, y=1.5}},
    {texture = "hdall.png", size = {x=2, y=2}},
    {texture = "cano.png", size = {x=2, y=1.5}},
    {texture = "attuned.png", size = {x=1.5, y=2}},
    {texture = "mtscarab.png", size = {x=1.5, y=2}},
	{texture = "semblem.png", size = {x=1, y=1}},
    {texture = "akal.png", size = {x=1.5, y=2}},
    {texture = "yterrova.png", size = {x=1.5, y=2}},
    {texture = "spiderstrikes.png", size = {x=2, y=1}},
	{texture = "dfort.png", size = {x=2, y=2}},
    {texture = "default_painting16.png", size = {x=2, y=2}},
    {texture = "default_painting17.png", size = {x=1.5, y=1.5}},
    {texture = "default_painting18.png", size = {x=1.5, y=1.5}},
    {texture = "default_painting19.png", size = {x=1, y=2}},
    {texture = "default_painting20.png", size = {x=1.5, y=1.5}},
    {texture = "default_painting21.png", size = {x=1, y=2}},
    {texture = "yetipaint.png", size = {x=1.5, y=2}},
    {texture = "default_painting22.png", size = {x=1.5, y=1.5}},
}

minetest.register_entity("default:painting", {
    initial_properties = {
        visual = "upright_sprite",
        visual_size = {x = 1.0, y = 1.0},
        textures = {"default_canvas.png"},
        collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        physical = false,
    },
    on_activate = function(self, staticdata)
        self.object:set_armor_groups({immortal = 1})
        if staticdata and staticdata ~= "" then
            local data = minetest.deserialize(staticdata)
            self.selected_painting = data.selected_painting
            self.original_pos = data.original_pos
        else
            self.selected_painting = nil  -- Start as a default canvas
            self.original_pos = self.object:get_pos()
        end
        self:update_painting()
    end,
    get_staticdata = function(self)
        local data = {
            selected_painting = self.selected_painting,
            original_pos = self.original_pos,
        }
        return minetest.serialize(data)
    end,
update_painting = function(self, dir)
    if self.selected_painting then
        local selected = paintings[self.selected_painting]
        self.object:set_properties({
            textures = {selected.texture},
            visual_size = selected.size
        })

        local new_pos = table.copy(self.original_pos)  -- Copy original position

        if selected.size.x == 1 and selected.size.y == 2 then
            -- Special case for 1x2 paintings
            new_pos.y = self.original_pos.y + 0.5
        elseif selected.size.x == 2 and selected.size.y == 1 then
            -- Special case for 2x1 paintings
            if dir == 0 or dir == 2 then  -- Facing Z direction
                new_pos.x = self.original_pos.x + 0.5
            elseif dir == 1 or dir == 3 then  -- Facing X direction
                new_pos.z = self.original_pos.z + 0.5
            end
        elseif selected.size.x == 3 and selected.size.y == 3 then
        elseif math.floor(selected.size.x) == selected.size.x and math.floor(selected.size.y) == selected.size.y and not (selected.size.x == 1 and selected.size.y == 1) then
            if dir == 0 or dir == 2 then  -- Facing Z direction
                new_pos.x = self.original_pos.x + 0.5
                new_pos.y = self.original_pos.y + 0.5
            elseif dir == 1 or dir == 3 then  -- Facing X direction
                new_pos.z = self.original_pos.z + 0.5
                new_pos.y = self.original_pos.y + 0.5
            end
        elseif selected.size.x % 1 ~= 0 or selected.size.y % 1 ~= 0 then
            -- If the painting has decimal dimensions, it should be centered and no offset should be applied.
        else
            -- For 1x1 paintings, no offset should be applied.
        end

        self.object:set_pos(new_pos)
    else
        self.object:set_properties({
            textures = {"default_canvas.png"},
            visual_size = {x = 1, y = 1}
        })
    end
end,
on_rightclick = function(self, clicker)
    local formspec = "formspec_version[4]"
    formspec = formspec .. "size[8,8]"
    formspec = formspec .. "label[0.5,0.5;Select a Painting:]"
    formspec = formspec .. "checkbox[0.5,7;centered;Centered;false]"

    local x, y = 0.5, 1
    for i, painting in ipairs(paintings) do
        formspec = formspec .. "image_button["..x..","..y..";1,1;"..painting.texture..";painting_"..i..";]"
        x = x + 1.2
        if x > 6 then
            x = 0.5
            y = y + 1.2
        end
    end

    minetest.show_formspec(clicker:get_player_name(), "default:painting_selection", formspec)
end,
    on_punch = function(self, puncher)
        self.object:remove()
        if puncher and puncher:is_player() then
            puncher:get_inventory():add_item("main", "default:canvas")
        end
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "default:painting_selection" then
        local centered = fields.centered == "true"
        for i, _ in ipairs(paintings) do
            if fields["painting_"..i] then
                local player_pos = player:get_pos()
                local nearby_objects = minetest.get_objects_inside_radius(player_pos, 3)
                for _, obj in ipairs(nearby_objects) do
                    local lua_entity = obj:get_luaentity()
                    if lua_entity and lua_entity.name == "default:painting" then
                        local dir = minetest.dir_to_facedir(player:get_look_dir())
                        lua_entity.selected_painting = i
                        lua_entity.centered = centered
                        lua_entity:update_painting(dir)
                        break
                    end
                end
            end
        end
    end
end)




-- Canvas item
minetest.register_craftitem("default:canvas", {
    description = "Canvas",
    inventory_image = "default_canvas.png",
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local dir = minetest.dir_to_facedir(placer:get_look_dir())
        local pos = pointed_thing.above

        local offset = {x = 0, y = 0, z = 0}
        if dir == 0 then
            offset.z = 0.45
        elseif dir == 1 then
            offset.x = 0.45
        elseif dir == 2 then
            offset.z = -0.45
        elseif dir == 3 then
            offset.x = -0.45
        end
        local adjusted_pos = vector.add(pos, offset)

        local entity = minetest.add_entity(adjusted_pos, "default:painting")
        if entity then
            entity:get_luaentity().initial_offset = offset
            entity:set_yaw(math.pi*2 - dir * math.pi/2)
        end

        itemstack:take_item(1)
        return itemstack
    end,
})

minetest.register_craft({
    output = 'wool:dark_green 1',  -- Adjust 'dark_green' to the desired wool color
    recipe = {
        {'group:grass', 'group:grass'},
        {'group:grass', 'group:grass'},
    },
})
-- Loop through all registered nodes to find nodes in the "tree" group
for name, def in pairs(minetest.registered_nodes) do
    if def.groups and def.groups.tree then
        -- Copy the original definition into a new table
        local new_def = table.copy(def)

        -- Modify the new definition to add the required behaviors
        new_def.falling_node = true  -- Make the node fall like sand

        new_def.can_dig = function(pos, player)
            -- Get the wielded item
            local wield_item = player:get_wielded_item():to_string()

            -- Check if the wielded item has "axe" in its name (excluding "pickaxe")
            local is_axe = false
            if string.find(wield_item, "axe") and not string.find(wield_item, "pickaxe") then
                is_axe = true
            end

            return is_axe
        end

        -- Re-register the node to overwrite the original definition
        minetest.register_node(":" .. name, new_def)
    end
end

minetest.register_tool("default:axe_flint", {
	description = ("Flint Axe"),
	inventory_image = "flintaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=2.50, [3]=1.50}, uses=3, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1, flammable = 2}
})

minetest.register_craft({
	output = "default:axe_flint",
	recipe = {
		{"group:grass", "default:flint"},
		{"default:stick", "default:flint"},
	},
})

minetest.register_tool("default:machete", {
	description = ("Jason's Machete"),
	inventory_image = "jmachete.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})
	minetest.register_craft({
		output = "default:machete",
		recipe = {
			{"","", "default:steel_ingot"},
			{"", "default:steel_ingot", ""},
			{"group:stick", "", ""}
		}
	})
	
	minetest.register_craft({
	output = "default:granitile 1",
	recipe = {
		{"default:granite"},
	}
})

minetest.register_craft({
	output = "default:granitebrick 4",
	recipe = {
		{"default:granitile", "default:granitile"},
		{"default:granitile", "default:granitile"},
	}
})

minetest.register_craft({
	output = "default:graniteflagstone 4",
	recipe = {
		{"default:granitecobble", "default:granitecobble"},
		{"default:granitecobble", "default:granitecobble"},
	}
})

	minetest.register_craft({
	output = "default:gneisstile 1",
	recipe = {
		{"default:gneiss"},
	}
})

minetest.register_craft({
	output = "default:gneissbrick 4",
	recipe = {
		{"default:gneisstile", "default:gneisstile"},
		{"default:gneisstile", "default:gneisstile"},
	}
})

minetest.register_craft({
	output = "default:gneissflagstone 4",
	recipe = {
		{"default:gneisscobble", "default:gneisscobble"},
		{"default:gneisscobble", "default:gneisscobble"},
	}
})
	
	minetest.register_craft({
	output = "default:pumtile 1",
	recipe = {
		{"default:pumice"},
	}
})

minetest.register_craft({
	output = "default:prick 4",
	recipe = {
		{"default:pumtile", "default:pumtile"},
		{"default:pumtile", "default:pumtile"},
	}
})

minetest.register_craft({
	output = "default:pflag 4",
	recipe = {
		{"default:pumcobble", "default:pumcobble"},
		{"default:pumcobble", "default:pumcobble"},
	}
})
minetest.register_node("default:limecobble", {
	description = ("Cobbled Limestone"),
	tiles = {"default_limecobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartzcobble", {
	description = ("Cobbled Quartz"),
	tiles = {"default_qcobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shobble", {
	description = ("Cobbled Shale"),
	tiles = {"shobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:scobble", {
	description = ("Cobbled Sandstone"),
	tiles = {"scobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:marblecobble", {
	description = ("Cobbled Marble"),
	tiles = {"default_marblecobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:onyxcobble", {
	description = ("Cobbled Onyx"),
	tiles = {"default_ocobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:rhyolitecobble", {
	description = ("Cobbled Rhyolite"),
	tiles = {"default_rhyolite_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:rhyoliteflagstone", {
	description = ("Rhyolite Flagstone"),
	tiles = {"default_rhyolite_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:rhyolitebrick", {
	description = ("Rhyolite Brick"),
	tiles = {"default_rhyolite_brick.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:rhyolitetile", {
	description = ("Rhyolite Tile"),
	tiles = {"default_rhyolite_tile.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slatecobble", {
	description = ("Cobbled Slate"),
	tiles = {"default_slate_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slateflagstone", {
	description = ("Slate Flagstone"),
	tiles = {"default_slate_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slatebrick", {
	description = ("Slate Brick"),
	tiles = {"default_slate_brick.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slatetile", {
	description = ("Slate Tile"),
	tiles = {"default_slate_tile.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:limecobble", {
	description = ("Cobbled Limestone"),
	tiles = {"default_limecobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granitecobble", {
	description = ("Cobbled Granite"),
	tiles = {"default_granite_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basaltcobble", {
	description = ("Cobbled Basalt"),
	tiles = {"default_basaltcobble.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:gneisscobble", {
	description = ("Cobbled Gneiss"),
	tiles = {"default_gneisscobble.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:limestonebrick", {
	description = ("Limestone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_limestone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shobbletile", {
	description = ("Shale Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_shobble_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shobbleflagstone", {
	description = ("Shale Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_shobble_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shobblebrick", {
	description = ("Shale Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_shobble_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:scobblebrick", {
	description = ("Sandstone Cobble Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_scobble_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartzbrick", {
	description = ("Quartz Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_quartz_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartztile", {
	description = ("Quartz Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_quartztile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:quartzflagstone", {
	description = ("Quartz Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_quartz_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:onyxbrick", {
	description = ("Onyx Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_onyx_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:onyxtile", {
	description = ("Onyx Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_onyx_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:onyxflagstone", {
	description = ("Onyx Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_onyx_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:limetile", {
	description = ("Limestone Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_lime_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:limeflagstone", {
	description = ("Limestone Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_lime_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:marblebrick", {
	description = ("Marble Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_marble_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:marbletile", {
	description = ("Marble Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_marble_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:scobbletile", {
	description = ("Sandstone Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_scobble_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:schistile", {
	description = ("Schist Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_schistile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:schistbrick", {
	description = ("Schist Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_schist_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:schisfbrick", {
	description = ("Schist Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_schist_fbrick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:schistcob", {
	description = ("Schist Cobble"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_schist_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:marbleflagstone", {
	description = ("Marble Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_marble_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basaltbrick", {
	description = ("Basalt Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_basalt_brick.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:basaltile", {
	description = ("Basalt Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_basalt_tile.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:basaltflagstone", {
	description = ("Basalt Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_basalt_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:gneissbrick", {
	description = ("Gneiss Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_gneiss_brick.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:gneisstile", {
	description = ("Gneiss Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_gneiss_tile.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:gneissflagstone", {
	description = ("Gneiss Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_gneiss_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granitebrick", {
	description = ("Granite Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_granite_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:graniteflagstone", {
	description = ("Granite Flagstone"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_granite_flagstone.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granitile", {
	description = ("Granite Tile"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_granite_tile.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sstonebrick", {
	description = ("Smooth Stone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_sstone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type  =  "cooking",
	recipe  = "default:stonebrick",
	output = "default:sstonebrick",
})

minetest.register_craft({
	type = "cooking",
	recipe = "default:quartzcobble",
	output = "mesecons_materials:silicon",
})
minetest.register_craft({
	output = "default:stonebrick 4",
	recipe = {
		{"default:cobble", "default:cobble"},
		{"default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "default:shobblebrick 4",
	recipe = {
		{"default:shobbletile", "default:shobbletile"},
		{"default:shobbletile", "default:shobbletile"},
	}
})

minetest.register_craft({
	output = "default:quartzbrick 4",
	recipe = {
		{"default:quartztile", "default:quartztile"},
		{"default:quartztile", "default:quartztile"},
	}
})

minetest.register_craft({
	output = "default:quartzflagstone 4",
	recipe = {
		{"default:quartzcobble", "default:quartzcobble"},
		{"default:quartzcobble", "default:quartzcobble"},
	}
})

minetest.register_craft({
	output = "default:quartztile 1",
	recipe = {
		{"default:quartz"},
	}
})


minetest.register_craft({
	output = "default:shobbleflagstone 4",
	recipe = {
		{"default:shobble", "default:shobble"},
		{"default:shobble", "default:shobble"},
	}
})

minetest.register_craft({
	output = "default:shobbletile 2",
	recipe = {
		{"default:shale", "default:shale"},
	}
})

minetest.register_craft({
	output = "default:onyxbrick 4",
	recipe = {
		{"default:onyxtile", "default:onyxtile"},
		{"default:onyxtile", "default:onyxtile"},
	}
})

minetest.register_craft({
	output = "default:onyxflagstone 4",
	recipe = {
		{"default:onyxcobble", "default:onyxcobble"},
		{"default:onyxcobble", "default:onyxcobble"},
	}
})

minetest.register_craft({
	output = "default:onyxtile 1",
	recipe = {
		{"default:onyx"},
	}
})

minetest.register_craft({
	output = "default:schistile 1",
	recipe = {
		{"default:schist"},
	}
})

minetest.register_craft({
	output = "default:schistbrick 4",
	recipe = {
		{"default:schistile", "default:schistile"},
		{"default:schistile", "default:schistile"},
	}
})

minetest.register_craft({
	output = "default:schisfbrick 4",
	recipe = {
		{"default:schistcob", "default:schistcob"},
		{"default:schistcob", "default:schistcob"},
	}
})


minetest.register_craft({
	output = "default:slatetile 1",
	recipe = {
		{"default:slate"},
	}
})

minetest.register_craft({
	output = "default:slatebrick 4",
	recipe = {
		{"default:slatetile", "default:slatetile"},
		{"default:slatetile", "default:slatetile"},
	}
})

minetest.register_craft({
	output = "default:slateflagstone 4",
	recipe = {
		{"default:slatecobble", "default:slatecobble"},
		{"default:slatecobble", "default:slatecobble"},
	}
})

minetest.register_craft({
	output = "default:rhyolitetile 1",
	recipe = {
		{"default:stone"},
	}
})

minetest.register_craft({
	output = "default:rhyolitebrick 4",
	recipe = {
		{"default:rhyolitetile", "default:rhyolitetile"},
		{"default:rhyolitetile", "default:rhyolitetile"},
	}
})

minetest.register_craft({
	output = "default:rhyoliteflagstone 4",
	recipe = {
		{"default:rhyolitecobble", "default:rhyolitecobble"},
		{"default:rhyolitecobble", "default:rhyolitecobble"},
	}
})
minetest.register_craft({
	output = "default:marblebrick 4",
	recipe = {
		{"default:marbletile", "default:marbletile"},
		{"default:marbletile", "default:marbletile"},
	}
})

minetest.register_craft({
	output = "default:limestonebrick 4",
	recipe = {
		{"default:limetile", "default:limetile"},
		{"default:limetile", "default:limetile"},
	}
})

minetest.register_craft({
	output = "default:limetile",
	recipe = {
		{"default:limestone"},
	}
})

minetest.register_craft({
	output = "default:marbleflagstone 4",
	recipe = {
		{"default:marblecobble", "default:marblecobble"},
		{"default:marblecobble", "default:marblecobble"},
	}
})

minetest.register_craft({
	output = "default:marbletile 1",
	recipe = {
		{"default:marble"},
	}
})

minetest.register_craft({
	output = "default:limeflagstone 4",
	recipe = {
		{"default:limecobble", "default:limecobble"},
		{"default:limecobble", "default:limecobble"},
	}
})

minetest.register_craft({
	output = "default:limetile 1",
	recipe = {
		{"default:limestone"},
	}
})

minetest.register_craft({
	output = "default:scobblebrick 4",
	recipe = {
		{"default:scobbletile", "default:scobbletile"},
		{"default:scobbletile", "default:scobbletile"},
	}
})

minetest.register_craft({
	output = "default:scobbletile 3",
	recipe = {
		{"default:sandstone", "default:sandstone"},
		{"default:sandstone", ""},
	}
})

minetest.register_craft({
	output = "default:basaltflagstone 4",
	recipe = {
		{"default:basaltcobble", "default:basaltcobble"},
		{"default:basaltcobble", "default:basaltcobble"},
	}
})

minetest.register_craft({
	output = "default:basaltile 1",
	recipe = {
		{"default:obsidian"},
	}
})


minetest.register_craft({
	output = "default:basaltbrick 4",
	recipe = {
		{"default:basaltile", "default:basaltile"},
		{"default:basaltile", "default:basaltile"},
	}
})

	minetest.register_craft({
	output = "default:granitebrick 4",
	recipe = {
		{"default:granitecobble", "default:granitecobble"},
		{"default:granitecobble", "default:granitecobble"},
	}
})
	


	-- Register hammers for different materials
local hammer_materials = {
	{"flint", 10},
	{"wood", 20},
	{"bone", 28},
	{"stone", 40},
	{"copper", 60},
	{"bronze", 80},
	{"iron", 120},
	{"steel", 160},
	{"gold", 40},
	{"diamond", 320},
}


local function has_wood_neighbor(pos)
    for x = -1, 1 do
        for y = -1, 1 do
            for z = -1, 1 do
                local neighbor_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                local neighbor_node = minetest.get_node_or_nil(neighbor_pos)
                if neighbor_node then
                    local neighbor_def = minetest.registered_nodes[neighbor_node.name]
                    if neighbor_def and neighbor_def.groups and neighbor_def.groups.wood then
                        return true
                    end
                end
            end
        end
    end
    return false
end

for _, material in pairs(hammer_materials) do
    local name, uses = unpack(material)
    minetest.register_tool("default:hammer_"..name, {
        description = name:gsub("^%l", string.upper).." Hammer",
        inventory_image = "default_hammer_"..name..".png",
        tool_capabilities = {
            full_punch_interval = 1.0,
            groupcaps={
                cracky = {times={[1]=2.4, [2]=1.2, [3]=0.6}},
            },
        },
        on_use = function(itemstack, user, pointed_thing)
            local pos = pointed_thing.under
            if not pos then
                return itemstack
            end

            local node = minetest.get_node_or_nil(pos)
            if not node then
                return itemstack
            end

            local node_def = minetest.registered_nodes[node.name]
            if not node_def then
                return itemstack
            end

            -- Define the drops based on node type
            local drops = {
                ["default:shale"] = "default:shobble",
                ["default:limestone"] = "default:limecobble",
                ["default:stone"] = "default:rhyolitecobble",
                ["default:marble"] = "default:marblecobble",
                ["default:gneiss"] = "default:gneisscobble",
                ["default:obsidian"] = "default:basaltcobble",
                ["default:granite"] = "default:granitecobble",
                ["default:quartz"] = "default:quartzcobble",
                ["default:schist"] = "default:schistcob",
                ["default:shobblebrick"] = "default:shobblebrick",
                ["default:limestonebrick"] = "default:limestonebrick",
                ["default:stonebrick"] = "default:stonebrick",
                ["default:stone_brick"] = "default:stone_brick",
                ["default:marblebrick"] = "default:marblebrick",
                ["default:gneissbrick"] = "default:gneisscobblebrick",
                ["default:basaltbrick"] = "default:basaltbrick",
                ["default:granitebrick"] = "default:granitebrick",
                ["default:quartzbrick"] = "default:quartzbrick",
                ["default:schistbrick"] = "default:schistbrick",
		["default:slate"] = "default:slatecobble",
		["default:sandstone"] = "default:scobble",
                ["default:onyx"] = "default:onyxcobble",
		["default:pumice"] = "default:pumcobble",
		["default:slatebrick"] = "default:slatebrick",
		["default:scobble"] = "default:scobblebrick",
                ["default:onyxbrick"] = "default:onyxbrick",
		["default:bricks"] = "default:bricks",
		["default:prick"] = "default:prick"
            }

            -- Handle wood and other drops
            if node_def.groups.wood or node_def.groups.tree then
                if has_wood_neighbor(pos) then
                    local meta = minetest.get_meta(pos)
                    meta:set_int("hammer_hit", 1)
                    itemstack:add_wear(65535 / uses)
                else
                    minetest.chat_send_player(user:get_player_name(), "Y!")
                end
            elseif drops[node.name] then
                minetest.remove_node(pos)
                minetest.add_item(pos, drops[node.name])
                itemstack:add_wear(65535 / uses)
            end

            return itemstack
        end,
    })
end



-- Register on place node to set metadata for player-placed wood nodes
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    local node_def = minetest.registered_nodes[newnode.name]
    if node_def and node_def.groups and node_def.groups.wood then
        local meta = minetest.get_meta(pos)

        if placer and placer:is_player() then
            meta:set_string("placed_by_player", "true")
            meta:set_int("hammer_hit", 0)
        meta:set_int("just_placed", 1)
        minetest.after(5, function()
            meta:set_int("just_placed", 0)
        end)
        else
            meta:set_string("placed_by_player", "false")
            meta:set_int("hammer_hit", 1)
        end
    end
end)

-- ABM for falling wood behavior
minetest.register_abm({
    nodenames = {"group:wood"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        local meta = minetest.get_meta(pos)
        local just_placed = meta:get_int("just_placed")
        local placed_by_player = meta:get_string("placed_by_player")
        local hammer_hit = meta:get_int("hammer_hit")

        if just_placed == 1 then
            return
        end

        if placed_by_player == "true" and hammer_hit == 0 then
            local below_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
            local below_node = minetest.get_node_or_nil(below_pos)
            if below_node and below_node.name == "air" then
                minetest.remove_node(pos)
                local falling_wood = minetest.add_entity(pos, "default:falling_wood_entity")
                if falling_wood then
                    falling_wood:set_properties({textures = {node.name}})
                    falling_wood:get_luaentity().original_node = node.name
                end
            end
        end
    end,
})

-- Register falling_wood entity
minetest.register_entity("default:falling_wood_entity", {
    initial_properties = {
        physical = true,
        collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        visual = "wielditem",
        visual_size = {x = 0.5, y = 0.5},
        textures = {},
    },
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        
        if pos == nil then
            return
        end
        
        local rounded_pos_below = {x = math.floor(pos.x + 0.5), y = math.floor(pos.y - 1.5), z = math.floor(pos.z + 0.5)}
        local node_below = minetest.get_node(rounded_pos_below)

        if node_below == nil or node_below.name == nil then
            return
        end
        
        if self.original_node == nil then
            return
        end
        
        if node_below.name ~= "air" and minetest.get_item_group(node_below.name, "water") == 0 then
            -- If the node below is not air and not water, place the original node on top of the solid node it hits
            minetest.set_node({x = rounded_pos_below.x, y = rounded_pos_below.y + 1, z = rounded_pos_below.z}, {name = self.original_node})

            -- Check if there's a water node above the solid node the wood just landed on
            local above_solid_node = {x = rounded_pos_below.x, y = rounded_pos_below.y + 1, z = rounded_pos_below.z}
            local node_above_solid = minetest.get_node(above_solid_node)
            
            if node_above_solid == nil or node_above_solid.name == nil then
                return
            end
            
            if minetest.get_item_group(node_above_solid.name, "water") > 0 then
                -- Replace the water node with the original node
                minetest.set_node(above_solid_node, {name = self.original_node})
            end

            self.object:remove()
            return
        end

        self.object:set_velocity({x = 0, y = -9.81, z = 0})
    end,
})

local craft_ingreds = {
	wood = "group:wood",
	bone = "bonemeal:bone",
	stone = "group:stone",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	iron = "default:ironbar",
	copper = "default:copper_ingot",
	gold = "default:gold_ingot",
	flint = "default:flint",
	diamond = "default:diamond"
}
-- Register recipes for each hammer
for _, material in pairs(hammer_materials) do
    local name = material[1]
    minetest.register_craft({
        output = 'default:hammer_'..name,
        recipe = {
            {'', craft_ingreds[name], craft_ingreds[name]},
            {'', craft_ingreds[name], craft_ingreds[name]},
            {'', 'default:stick', ''}
        }
    })
end

-- Rope Mod for Minetest

-- Register farming:string crafting from grass
minetest.register_craft({
    output = "farming:string 2",
    recipe = {
        {"", "group:grass", ""},
        {"group:grass", "", ""}
    },
})

-- Rope crafting from farming:string
minetest.register_craft({
    output = "default:rope 2",
    recipe = {
        {"farming:string", "", "farming:string"},
        {"", "farming:string", ""},
        {"farming:string", "", "farming:string"}
    }
})





-- Define a Mosasaurus spawn egg
minetest.register_craftitem("default:mosasaurus_spawn_egg", {
    description = "Mosasaurus Spawn Egg",
    inventory_image = "egg.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "node" then
            local pos = pointed_thing.under
            if pos and minetest.get_node(pos).name == "default:sand" then
                -- Spawn the Mosasaurus entity slightly above the sand
                pos.y = pos.y + 1
                minetest.add_entity(pos, "default:mosasaurus")
                itemstack:take_item()
                return itemstack
            end
        end
    end,
})


-- Register the fishing net item
minetest.register_craftitem("default:fishing_net", {
    description = "Fishing Net",
    inventory_image = "your_fishing_net_bottom_texture.png",
    on_use = function(itemstack, user, pointed_thing)
        local pos = user:get_pos()
        local dir = user:get_look_dir()
        local obj = minetest.add_entity({x = pos.x + dir.x, y = pos.y + 1.5, z = pos.z + dir.z}, "default:fishing_net_entity")
        obj:set_velocity({x = dir.x * 10, y = dir.y * 10, z = dir.z * 10})
        obj:set_acceleration({x = 0, y = -9.8, z = 0}) -- Gravity
        obj:get_luaentity().thrower_name = user:get_player_name()

        if not minetest.is_creative_enabled(user:get_player_name()) then
            itemstack:take_item()
        end
        return itemstack
    end,
})

-- Register the fishing net entity
minetest.register_entity("default:fishing_net_entity", {
    physical = true,
    collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    visual = "cube",
    textures = {"blank.png", "your_fishing_net_bottom_texture.png", "blank.png", "blank.png", "blank.png", "blank.png"},
    thrower_name = "",
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        local node_below = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name

        if node_below == "default:water_source" then
            self.object:remove()

            local user = minetest.get_player_by_name(self.thrower_name)
            if not user then return end

            for x = -1, 1 do
                for z = -1, 1 do
                    local net_pos = {x = pos.x + x, y = pos.y, z = pos.z + z}
                    minetest.set_node(net_pos, {name = "default:fishing_net_node"})
                end
            end

            minetest.after(3, function()
                for dx = -2, 2 do
                    for dy = -15, 15 do
                        for dz = -2, 2 do
                            local check_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
                            local objs = minetest.get_objects_inside_radius(check_pos, 1)

                            for _, obj in pairs(objs) do
                                local lua_entity = obj:get_luaentity()
                                local entity_name = lua_entity and lua_entity.name or ""
                                local obj_pos = obj:get_pos()
                                obj:set_pos({x = obj_pos.x, y = pos.y + 1, z = obj_pos.z})

                                if entity_name == "default:fish" then
                                    obj:remove()
                                    user:get_inventory():add_item("main", "default:fish_item")
                                end

                                if entity_name == "default:trout" then
                                    obj:remove()
                                    user:get_inventory():add_item("main", "default:trout_item")
                                end

                                if entity_name == "default:mosasaurus" then
                                    obj:punch(obj, 1.0, {
                                        full_punch_interval = 1.0,
                                        damage_groups = {fleshy = 2},
                                    }, nil)
                                end
                            end
                        end
                    end
                end

                for x = -1, 1 do
                    for z = -1, 1 do
                        local net_pos = {x = pos.x + x, y = pos.y, z = pos.z + z}
                        minetest.remove_node(net_pos)
                    end
                end

                if user and not minetest.is_creative_enabled(user:get_player_name()) then
                    local inv = user:get_inventory()
                    local worn_net = ItemStack("default:fishing_net")
                    worn_net:add_wear(65535 / 9)
                    inv:add_item("main", worn_net)
                end
            end)
        end
    end,
})

-- Register the fishing net node
minetest.register_node("default:fishing_net_node", {
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
    },
    tiles = {"your_fishing_net_bottom_texture.png", "blank.png", "blank.png", "blank.png", "blank.png", "blank.png"},
    pointable = false,
    walkable = true,
    diggable = false,
    sunlight_propagates = true,
    paramtype = "light",
    groups = {not_in_creative_inventory = 1},
})
-- Crafting recipe for fishing net
minetest.register_craft({
    output = "default:fishing_net",
    recipe = {
        {"farming:string", "farming:string", "farming:string"},
        {"farming:string", "farming:string", "farming:string"},
        {"farming:string", "farming:string", "farming:string"}
    }
})

-- Register the Wooden Spear item
minetest.register_tool("default:wooden_spear", {
	description = "Javelin",
	inventory_image = "default_wooden_spear.png",
	range = 6.0,
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			snappy = {times={[3]=0.80, [2]=0.60, [1]=0.40}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	on_use = function(itemstack, user, pointed_thing)
		minetest.after(3, function()
			local pos = user:get_pos()
			pos.y = pos.y + 1.5
			local dir = user:get_look_dir()
			local obj = minetest.add_entity(pos, "default:thrown_spear")
			if obj then
				obj:set_velocity(vector.multiply(dir, 19))
				obj:set_acceleration({x=0, y=-9.81, z=0})
			end
			itemstack:take_item()  -- Remove one item from stack
			return itemstack
		end)
		return itemstack  -- Important to return the itemstack
	end
})

-- Crafting recipe
minetest.register_craft({
	output = "default:wooden_spear",
	recipe = {
		{'', 'default:stick', ''},
		{'', '', 'default:stick'},
		{'default:stick', '', ''},
	}
})

-- Register Thrown Spear Entity
minetest.register_entity("default:thrown_spear", {
	visual = "sprite",
	textures = {"default_wooden_spear.png"},
	visual_size = {x=1, y=1},
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		local objs = minetest.get_objects_inside_radius(pos, 1)
		for _, obj in pairs(objs) do
			local lua_entity = obj:get_luaentity()
			if not lua_entity or lua_entity.name ~= "default:thrown_spear" then  -- This prevents the spear from removing itself
				local damage = 5
				if obj:is_player() then
					obj:set_hp(obj:get_hp() - damage)
				elseif lua_entity then
					lua_entity.object:set_hp(lua_entity.object:get_hp() - damage)
					if lua_entity.object:get_hp() <= 0 then
						lua_entity.object:remove()
					end
				end
				self.object:remove()
				return
			end
		end
	end,
})

-- Register an entity that represents a stick on the ground
minetest.register_entity("default:ground_stick", {
    initial_properties = {
        physical = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        visual = "wielditem",
        visual_size = {x = 0.20, y = 0.20},
        textures = {"default:stick"},
    },
    on_activate = function(self, staticdata)
        self.object:set_rotation({x = 0, y = math.random(0, 360), z = 0})
    end,
})

-- Place a stick on the ground when right-clicked with a default stick
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if itemstack:get_name() == "default:stick" then
        minetest.add_entity({x = pos.x, y = pos.y + 1, z = pos.z}, "default:ground_stick")
        itemstack:take_item(1)
        return itemstack
    end
end)

-- Function to manage fire and stick consumption
local function manage_fire(pos)
    local sticks = {}
    for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
        if obj:get_luaentity() and obj:get_luaentity().name == "default:ground_stick" then
            table.insert(sticks, obj)
        end
    end
    if #sticks > 0 then
        sticks[1]:remove()
        minetest.after(30, manage_fire, pos)
    else
        minetest.remove_node(pos)
    end
end


-- Register the campfire node
minetest.register_node("default:campfire", {
    description = "Campfire",
    tiles = {"default_cobble.png"},
    on_rightclick = function(pos, node, clicker, itemstack)
        local item_name = itemstack:get_name()

        if item_name == "fire:flint_and_steel" then
            minetest.add_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "fire:basic_flame"})
            minetest.after(30, manage_fire, {x = pos.x, y = pos.y + 1, z = pos.z})
            itemstack:add_wear(1000)
            return itemstack
        elseif item_name == "fire:bowdrill" then
            minetest.add_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "fire:basic_flame"})
            minetest.after(30, manage_fire, {x = pos.x, y = pos.y + 1, z = pos.z})
            itemstack:add_wear(100)  -- Assuming bowdrill has significantly less wear
            return itemstack
        end
    end,
})

minetest.register_chatcommand("rend", {
    description = "Remove all entities of the specified type",
    params = "<entitytype>",
    privs = {server=true},
    func = function(name, param)
        local entitytype = param
        if entitytype == "" then
            return false, "You need to specify an entity type."
        end
        
        local objects = minetest.get_objects_inside_radius({x=0, y=0, z=0}, 31000)
        local count_removed = 0
        for _, obj in pairs(objects) do
            local luaentity = obj:get_luaentity()
            if luaentity and luaentity.name == entitytype then
                obj:remove()
                count_removed = count_removed + 1
            end
        end

        return true, "Removed " .. count_removed .. " entities of type " .. entitytype .. "."
    end
})
-- Function to find the next position for the gas to move to
-- Function to find the next position for the gas to move to
local function find_next_gas_position(pos)
    for dy = 1, 1 do
        local new_pos = {x = pos.x, y = pos.y + dy, z = pos.z}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    for dx = -1, 1 do
        local new_pos = {x = pos.x + dx, y = pos.y, z = pos.z}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    for dz = -1, 1 do
        local new_pos = {x = pos.x, y = pos.y, z = pos.z + dz}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    return nil
end

-- Function to move gas
local function move_gas(pos)
    local current_node = minetest.get_node(pos)
    elapsed_time = elapsed_time or 0  -- initialize if nil
    if current_node.name ~= "default:gas" then
        return
    end

    if elapsed_time >= 300 then  -- 300 seconds = 5 minutes
        minetest.remove_node(pos)
        return
    end

    local next_pos = find_next_gas_position(pos)
    
    if next_pos then
        minetest.remove_node(pos)
        minetest.set_node(next_pos, {name = "default:gas"})
        minetest.after(3.0, function() move_gas(next_pos) end)
    else
        minetest.after(3.0, function() move_gas(pos) end)
    end
end

-- Register the gas node
minetest.register_node("default:gas", {
    description = "Gas",
    drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
    tiles = {"default_gas.png"},
    groups = {gas = 1},
    walkable = false,
    pointable = false,
    buildable_to = true,
    after_destruct = function(pos)
        minetest.after(0.1, function()
            local neighbors = minetest.find_nodes_in_area(
                {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                {"default:gas"}
            )
            if #neighbors >= 3 then
                tnt.boom(pos, {radius = 3})
            end
        end)
    end,
})

-- Function to handle gas logic when it neighbors "_with_coal" node
local function spawn_gas(pos)
    minetest.set_node(pos, {name = "default:gas"})
    minetest.after(1.0, function() move_gas(pos) end)
end

-- Register callback when any "_with_coal" node is dug
minetest.register_on_dignode(function(pos, oldnode, digger)
    if string.find(oldnode.name, "_with_coal") then
        spawn_gas(pos)
    end
end)

-- ABM for checking gas neighbors
minetest.register_abm({
    label = "Check Gas Neighbors",
    nodenames = {"default:gas"},
    interval = 1,
    chance = 1,
    action = function(pos)
        local current_node = minetest.get_node(pos)
        if current_node.name ~= "default:gas" then
            return
        end
        
        local fire_neighbors = minetest.find_nodes_in_area(
            {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
            {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
            {"default:torch", "fire:basic_flame", "default:wall_torch"}
        )
        
        if #fire_neighbors > 0 then
            local neighbors = minetest.find_nodes_in_area(
                {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
                {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
                {"default:gas"}
            )
            for _, gas_node in ipairs(neighbors) do
                minetest.set_node(gas_node, {name = "fire:basic_flame"})
            end
        end
    end,
})
-- Execute after all other mods are loaded
minetest.after(0, function()
    -- Loop through all registered nodes
    for nodename, def in pairs(minetest.registered_nodes) do
        -- Check if the node is in group:tree
        if def.groups and def.groups.tree then
            -- Copy existing groups to a new table so we don't modify the original
            local new_groups = table.copy(def.groups)
            
            -- Update the choppy and oddly_breakable_by_hand group values
            new_groups.choppy = 2
            new_groups.oddly_breakable_by_hand = 0
            
            -- Override the item to require an axe for mining
            minetest.override_item(nodename, {
                groups = new_groups,  -- Set updated groups
                digtime = def.digtime or 3  -- Set dig time (retaining original if it exists)
            })
        end
    end
end)

-- Utility function to copy a table (used for copying group tables)
function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
	end
	
local river_noise = {
    offset = 0,
    scale = 1,
    spread = {x = 300, y = 200, z = 100},
    seed = 575959,
    octaves = 3,
    persist = 0.6
}








-- Define a noise parameter for aquifer generation
local aquifer_noise_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 12345,
    octaves = 3,
    persist = 0.6,
    lacunarity = 2.0,
}

-- Function to check if a position should be an aquifer
local function is_aquifer_position(pos)
    -- Check if y-coordinate is within the desired range (adjust to your needs)
    if pos.y >= -340 and pos.y <= -30 then
        local noise = minetest.get_perlin(aquifer_noise_params):get_2d({x = pos.x, y = pos.z})
        return noise > 0.5 -- Adjust the threshold as needed for aquifer density
    else
        return false -- Outside the specified y-coordinate range
    end
end

-- Function to determine if a node is eligible to be an aquifer
local function is_eligible_for_aquifer(node_name)
    local eligible_nodes = {
        ["default:gravel"] = true,
        ["default:limestone"] = true,
        ["default:saprolite"] = true
    }
    return eligible_nodes[node_name] ~= nil
end

-- Function to check if a node is exposed to air
local function is_exposed_to_air(pos)
    local sides = {{x=1, y=0, z=0}, {x=-1, y=0, z=0}, {x=0, y=0, z=1}, {x=0, y=0, z=-1}, {x=0, y=1, z=0}, {x=0, y=-1, z=0}}
    for _, side in pairs(sides) do
        if minetest.get_node(vector.add(pos, side)).name == "air" then
            return true
        end
    end
    return false
end

local function process_aquifer(pos)
    local meta = minetest.get_meta(pos)
    local water_level = meta:get_int("water_level")

    if water_level > 0 then
        local sides = {{x=1,y=0,z=0}, {x=-1,y=0,z=0}, {x=0,y=0,z=1}, {x=0,y=0,z=-1}}
        local water_expelled = false

        -- Expel water to adjacent air or flowing water nodes
        for _, side in ipairs(sides) do
            local side_pos = vector.add(pos, side)
            local side_node = minetest.get_node(side_pos).name
            if side_node == "air" or side_node == "default:water_flowing" then
                minetest.set_node(side_pos, {name = "default:water_source"})
                water_level = water_level - 1
                meta:set_int("water_level", water_level)
                water_expelled = true
                break
            end
        end

        -- Pull water from adjacent aquifer nodes if water was expelled
        if water_expelled then
            for _, side in ipairs(sides) do
                local side_pos = vector.add(pos, side)
                local side_node = minetest.get_node(side_pos).name
                if is_eligible_for_aquifer(side_node) then
                    local side_meta = minetest.get_meta(side_pos)
                    local side_water_level = side_meta:get_int("water_level")
                    if side_water_level > 0 then
                        side_meta:set_int("water_level", side_water_level - 1)
                        water_level = water_level + 1
                        meta:set_int("water_level", water_level)
                        break
                    end
                end
            end
        end
    elseif water_level == 0 then
        meta:set_string("infotext", "This aquifer is dry.")
    end
end

local function process_aquifers()
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local minp = vector.subtract(pos, 10)
        local maxp = vector.add(pos, 10)
        local nodes = minetest.find_nodes_in_area(minp, maxp, {"default:gravel", "default:limestone", "default:saprolite"})
        for _, node_pos in ipairs(nodes) do
            if is_aquifer_position(node_pos) then
                process_aquifer(node_pos)
            end
        end
    end
    minetest.after(60, process_aquifers)
end

minetest.after(60, process_aquifers)

-- Function to process aquifer nodes in batches
local function process_aquifer_batch(player_pos, radius, batch_size, step_callback, start_pos)
    local total_processed = 0
    local processed_this_step = 0
    local start_x, start_y, start_z = unpack(start_pos)

    for x = start_x, start_x + batch_size - 1 do
        for y = start_y, start_y + batch_size - 1 do
            for z = start_z, start_z + batch_size - 1 do
                local check_pos = {x = player_pos.x + x, y = player_pos.y + y, z = player_pos.z + z}
                local node_name = minetest.get_node(check_pos).name

                if is_eligible_for_aquifer(node_name) and is_aquifer_position(check_pos) then
                    local meta = minetest.get_meta(check_pos)
                    if meta:get_int("water_level") == 0 then
                        meta:set_int("water_level", 100)  -- Assign default water level
                        processed_this_step = processed_this_step + 1

                        if processed_this_step >= batch_size then
                            minetest.after(0.1, step_callback, player_pos, radius, batch_size, {x, y, z})
                            return
                        end
                    end
                end
            end
        end
    end

    minetest.chat_send_all("Finished processing aquifers in current batch. Total processed: " .. (total_processed + processed_this_step))
end

-- Function to retroactively assign water_level to existing aquifers in the world
minetest.register_chatcommand("generate_aquifers", {
    description = "Retroactively waterlog existing aquifers in the world",
    privs = {server=true},  -- Restrict this to server operators
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found."
        end

        local pos = player:get_pos()  -- Get player's position
        local radius = 100  -- Set the radius around the player for scanning nodes
        local total_waterlogged = 0  -- Keep track of how many aquifers were updated

        -- Scan in a radius around the player's position
        for x = -radius, radius do
            for y = -radius, radius do
                for z = -radius, radius do
                    local check_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                    local node_name = minetest.get_node(check_pos).name

                    -- Check if the node is eligible to be an aquifer
                    if is_eligible_for_aquifer(node_name) and is_aquifer_position(check_pos) then
                        local meta = minetest.get_meta(check_pos)

                        -- Check if the aquifer already has a water_level assigned
                        if meta:get_int("water_level") == 0 then
                            -- Assign a default water_level, e.g., 1 for waterlogged
                            meta:set_int("water_level", 1)
                            total_waterlogged = total_waterlogged + 1
                        end
                    end
                end
            end
        end

        -- Send a summary message with the total number of aquifers updated
        return true, "Aquifers retroactively waterlogged: " .. total_waterlogged
    end
})
-- Register on_generated callback for aquifers
minetest.register_on_generated(function(minp, maxp, seed)
    if minp.y < -30 and maxp.y > -340 then
        for z = minp.z, maxp.z do
            for y = minp.y, maxp.y do
                for x = minp.x, maxp.x do
                    local pos = {x = x, y = y, z = z}
                    local node_name = minetest.get_node(pos).name
                    if is_eligible_for_aquifer(node_name) and is_aquifer_position(pos) then
                        -- Assign water_level = 100 to all newly generated aquifers
                        local meta = minetest.get_meta(pos)
                        meta:set_int("water_level", 100)  -- Full water level
                    end
                end
            end
        end
    end
end)


-- Chat command to teleport to the nearest aquifer
minetest.register_chatcommand("tp_aquifer", {
    description = "Teleport to the nearest aquifer",
    privs = {teleport=true},  -- Adjust privileges as needed
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            local aquifer_pos = find_nearest_aquifer(pos)
            if aquifer_pos then
                player:set_pos(aquifer_pos)
                return true, "Teleported to the nearest aquifer."
            else
                return false, "No aquifer found within the search radius."
            end
        else
            return false, "Player not found."
        end
    end
})

-- Register the dowsing rod item
minetest.register_craftitem("default:dowsing_rod", {
    description = "Dowsing Rod",
    inventory_image = "default_stick.png",
    on_use = function(itemstack, user, pointed_thing)
        -- Check if the pointed_thing is a node
        if pointed_thing.type == "node" then
            local pos = pointed_thing.under
            -- Define the range for checking aquifers
            local horizontal_range = 32
            local vertical_range = 300  -- Increased vertical range for deep aquifers
            local found_aquifer = false

            -- Check if there is an aquifer in the specified range
            for x = -horizontal_range, horizontal_range do
                for z = -horizontal_range, horizontal_range do
                    for y = -vertical_range, vertical_range do
                        local check_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                        if is_eligible_for_aquifer(minetest.get_node(check_pos).name) and is_aquifer_position(check_pos) then
                            found_aquifer = true
                            break
                        end
                    end
                    if found_aquifer then
                        break
                    end
                end
                if found_aquifer then
                    break
                end
            end

            -- Display message to player
            if found_aquifer then
                minetest.chat_send_player(user:get_player_name(), "There is an aquifer here.")
            else
                minetest.chat_send_player(user:get_player_name(), "There is not an aquifer here.")
            end
        end
        return itemstack
    end,
})

-- Craft recipe for the dowsing rod (2 sticks)
minetest.register_craft({
    output = "default:dowsing_rod",
    recipe = {
        {"", "default:stick", ""},
        {"", "default:stick", ""},
    }
})

-- Delay setting "hammer_hit" metadata for wood nodes after world generation
minetest.register_on_generated(function(minp, maxp, seed)
    minetest.after(1, function()
        for x = minp.x, maxp.x do
            for y = minp.y, maxp.y do
                for z = minp.z, maxp.z do
                    local pos = {x = x, y = y, z = z}
                    local node_name = minetest.get_node(pos).name
                    
                    -- Check if the node belongs to the group:wood
                    if minetest.get_item_group(node_name, "wood") > 0 then
                        local meta = minetest.get_meta(pos)
                        
                        -- Set the "hammer_hit" metadata to 1
                        meta:set_int("hammer_hit", 1)
                    end
                end
            end
        end
    end)
end)

-- Register the /identify command
minetest.register_chatcommand("identify", {
    description = "Identifies the item you are holding",
    func = function(name)
        -- Get the player object
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        -- Get the player's wielded item
        local item = player:get_wielded_item():get_name()

        -- If the player is holding an item, return its name
        if item and item ~= "" then
            return true, "You are holding: " .. item
        else
            return false, "You are not holding an item."
        end
    end
})
-- Function to check if a string is a valid number
local function is_number(str)
    return tonumber(str) ~= nil
end

-- Command to set server spawn point
minetest.register_chatcommand("serverspawn", {
    params = "<x> <y> <z>",
    description = "Set the world's spawn point to the given coordinates",
    privs = { server = true }, -- Requires server privileges
    func = function(name, param)
        local x, y, z = string.match(param, "^(-?%d+) (-?%d+) (-?%d+)$")

        -- Check if the coordinates are valid numbers
        if not (is_number(x) and is_number(y) and is_number(z)) then
            return false, "Invalid coordinates. Usage: /serverspawn <x> <y> <z>"
        end

        -- Set the new spawn point
        local pos_str = x..","..y..","..z
        local settings = minetest.settings
        settings:set("static_spawnpoint", pos_str)

        return true, "Spawn point set to ("..x..", "..y..", "..z..")"
    end,
})

minetest.register_chatcommand("teleport_to_node", {
    params = "<node_name>",
    description = "Teleport to the nearest node of the specified type",
    privs = {teleport=true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        if param == "" then
            return false, "Please specify a node name."
        end

        local pos = player:get_pos()
        local max_volume = 4096000  -- Maximum allowed volume
        local found_pos = nil
        local min_distance = nil

        local radius = 1
        while true do
            local minp = vector.subtract(pos, radius)
            local maxp = vector.add(pos, radius)

            -- Calculate the volume of the search area
            local volume = (maxp.x - minp.x + 1) * (maxp.y - minp.y + 1) * (maxp.z - minp.z + 1)
            if volume > max_volume then
                break  -- Stop if the volume exceeds the limit
            end

            local nodes = minetest.find_nodes_in_area(minp, maxp, {param})
            for _, node_pos in ipairs(nodes) do
                local distance = vector.distance(pos, node_pos)
                if not min_distance or distance < min_distance then
                    min_distance = distance
                    found_pos = node_pos
                end
            end

            if found_pos then
                break
            end

            radius = radius + 1
            if radius > max_volume^(1/3) then  -- Ensure we don't exceed cube root of max_volume
                break
            end
        end

        if found_pos then
            player:set_pos(found_pos)
            return true, "Teleported to the nearest " .. param
        else
            return false, "No node of type " .. param .. " found within the search limits."
        end
    end,
})

minetest.register_craft({
	output = "farming:string 4",
	recipe = {
		{"group:wool"},
	}
})


minetest.register_craft({ 
	output = 'craft_table:simple',
	recipe = {
		{'group:wood', 'group:wood'},
		{'default:stick', 'default:stick'},
	}
})

local function has_wood_nearby(pos, radius)
    local minp = vector.subtract(pos, radius)
    local maxp = vector.add(pos, radius)
    local wood_nodes = minetest.find_nodes_in_area(minp, maxp, "group:wood")
    return #wood_nodes > 0
end

local function replace_with_gravel(pos, radius)
    local minp = vector.subtract(pos, radius)
    local maxp = vector.add(pos, radius)
    local stone_nodes = minetest.find_nodes_in_area(minp, maxp, "group:stone")
    
    for _, node_pos in ipairs(stone_nodes) do
        minetest.set_node(node_pos, {name = "default:gravel"})
        minetest.check_for_falling(node_pos)
    end
end

minetest.register_on_dignode(function(pos, oldnode, digger)
    if minetest.get_item_group(oldnode.name, "stone") > 0 then
        if not has_wood_nearby(pos, 12) and math.random() < 0.15 then
            local face_centers = {
                {x = pos.x + 2, y = pos.y, z = pos.z},
                {x = pos.x - 2, y = pos.y, z = pos.z},
                {x = pos.x, y = pos.y + 2, z = pos.z},
                {x = pos.x, y = pos.y - 2, z = pos.z},
                {x = pos.x, y = pos.y, z = pos.z + 2},
                {x = pos.x, y = pos.y, z = pos.z - 2},
            }
            local center = face_centers[math.random(#face_centers)]
            replace_with_gravel(center, 2)
        end
    end
end)
local function replace_with_falling_dirt(pos, radius)
    local minp = vector.subtract(pos, radius)
    local maxp = vector.add(pos, radius)
    local dirt_nodes = minetest.find_nodes_in_area(minp, maxp, {"default:dirt", "group:soil"})
    
    for _, node_pos in ipairs(dirt_nodes) do
        -- Trigger the fall for each dirt node
        minetest.spawn_falling_node(node_pos)
    end
end

-- Register action for when dirt is mined
minetest.register_on_dignode(function(pos, oldnode, digger)
    if minetest.get_item_group(oldnode.name, "soil") > 0 then
        -- 15% chance for dirt cave-in
        if math.random() < 0.15 then
            local face_centers = {
                {x = pos.x + 2, y = pos.y, z = pos.z},
                {x = pos.x - 2, y = pos.y, z = pos.z},
                {x = pos.x, y = pos.y + 2, z = pos.z},
                {x = pos.x, y = pos.y - 2, z = pos.z},
                {x = pos.x, y = pos.y, z = pos.z + 2},
                {x = pos.x, y = pos.y, z = pos.z - 2},
            }
            local center = face_centers[math.random(#face_centers)]
            replace_with_falling_dirt(center, 2)
        end
    end
end)

-- Function to process nodes in smaller chunks
local function process_in_chunks(minp, maxp, node_names, action_func)
    local step = 50  -- Size of the chunks
    for x = minp.x, maxp.x, step do
        for y = minp.y, maxp.y, step do
            for z = minp.z, maxp.z, step do
                local chunk_minp = {x = x, y = y, z = z}
                local chunk_maxp = {
                    x = math.min(x + step - 1, maxp.x),
                    y = math.min(y + step - 1, maxp.y),
                    z = math.min(z + step - 1, maxp.z)
                }

                local nodes = minetest.find_nodes_in_area(chunk_minp, chunk_maxp, node_names)

                for _, p in ipairs(nodes) do
                    action_func(p)
                end
            end
        end
    end
end

-- deletenode Command
minetest.register_chatcommand("deletenode", {
    params = "<node_name>",
    description = "Delete all nodes of the given name within a big area",
    privs = {server=true},
    func = function(name, param)
        local node_name = param

        if not node_name then
            return false, "Invalid usage. Correct format: /deletenode <node_name>"
        end

        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found."
        end

        local pos = player:get_pos()
        local area_size = 200  -- Keeping the size of the area at 200
        local minp = vector.subtract(pos, area_size)
        local maxp = vector.add(pos, area_size)

        local nodes_removed = 0

        process_in_chunks(minp, maxp, {node_name}, function(p)
            minetest.set_node(p, {name = "air"})
            nodes_removed = nodes_removed + 1
        end)

        return true, "Deleted " .. nodes_removed .. " nodes of type " .. node_name .. "."
    end,
})

-- melt_ice Command
minetest.register_chatcommand("melt_ice", {
    description = "Melt all ice into water within a big area",
    privs = {server=true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found."
        end

        local pos = player:get_pos()
        local area_size = 200  -- Keeping the size of the area at 200
        local minp = vector.subtract(pos, area_size)
        local maxp = vector.add(pos, area_size)

        local nodes_changed = 0

        process_in_chunks(minp, maxp, {"default:ice"}, function(p)
            minetest.set_node(p, {name = "default:water_source"})
            nodes_changed = nodes_changed + 1
        end)

        return true, "Melted " .. nodes_changed .. " ice nodes into water."
    end,
})

local function has_nearby_node(pos, node_names, range)
    for x = -range, range do
        for y = -range, range do
            for z = -range, range do
                local check_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                local node = minetest.get_node(check_pos)
                for _, name in ipairs(node_names) do
                    if node.name == name then
                        return true
                    end
                end
            end
        end
    end
    return false
end


-- Function to find the next position for the steam to move to
local function find_next_steam_position(pos)
    for dy = 1, 1 do
        local new_pos = {x = pos.x, y = pos.y + dy, z = pos.z}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    for dx = -1, 1 do
        local new_pos = {x = pos.x + dx, y = pos.y, z = pos.z}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    for dz = -1, 1 do
        local new_pos = {x = pos.x, y = pos.y, z = pos.z + dz}
        local node = minetest.get_node(new_pos)
        if node.name == "air" then
            return new_pos
        end
    end
    
    return nil
end

-- Function to move steam and check for deletion conditions
local function move_steam(pos, start_time)
    local current_node = minetest.get_node(pos)
    if current_node.name ~= "default:steam" then
        return
    end

    local elapsed_time = minetest.get_us_time() - start_time
        -- Check if there is a node above the steam
    local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    local above_node = minetest.get_node(above_pos)
    local is_blocked = above_node.name ~= "air"

    -- If 10 seconds have passed and the steam is not blocked, remove it
    if elapsed_time >= 10000000 and not is_blocked then
        minetest.remove_node(pos)
        return
    end
    local next_pos = find_next_steam_position(pos)
    if next_pos then
        minetest.remove_node(pos)
        minetest.set_node(next_pos, {name = "default:steam"})
        minetest.after(3.0, function() move_steam(next_pos, start_time) end)
    else
        minetest.after(3.0, function() move_steam(pos, start_time) end)
    end
end

-- Register the steam node
minetest.register_node("default:steam", {
    description = "Steam",
    drawtype = "glasslike",
    use_texture_alpha = true,
    is_ground_content = false,
    paramtype = "light",
    tiles = {"default_smoke.png^[colorize:white:128"},  -- Colorize the smoke texture to make it 50% whiter
    groups = {steam = 1},
    walkable = false,
    pointable = false,
    buildable_to = true,
})

-- Function to handle steam logic
local function spawn_steam(pos)
    minetest.set_node(pos, {name = "default:steam"})
    minetest.sound_play("default_furnace_active", {pos = pos, max_hear_distance = 10, gain = 0.5})
    local start_time = minetest.get_us_time()  -- Record the time when the steam node is spawned
    minetest.after(1.0, function() move_steam(pos, start_time) end)
end

-- Function to check if a 3x3x3 cube of compressed steam exists
local function check_for_compressed_steam_cube(pos)
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                local check_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
                local node = minetest.get_node(check_pos)
                if node.name ~= "default:compressed_steam" then
                    return false  -- If any position in the 3x3x3 cube isn't compressed steam, return false
                end
            end
        end
    end
    return true  -- If all positions are compressed steam, return true
end

-- Function to create an explosion effect and remove the compressed steam nodes
local function trigger_explosion(pos)
    -- Remove all compressed steam nodes in the 3x3x3 area
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                local explode_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
                minetest.remove_node(explode_pos)
            end
        end
    end
    
    -- Play explosion sound
    minetest.sound_play("tnt_explode", {pos = pos, gain = 1.5, max_hear_distance = 50})
    
    -- Create particles to simulate an explosion
    minetest.add_particlespawner({
        amount = 100,
        time = 0.5,
        minpos = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
        maxpos = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
        minvel = {x = -10, y = -10, z = -10},
        maxvel = {x = 10, y = 10, z = 10},
        minacc = {x = 0, y = -10, z = 0},
        maxacc = {x = 0, y = -10, z = 0},
        minexptime = 0.1,
        maxexptime = 1.0,
        minsize = 4,
        maxsize = 8,
        texture = "tnt_smoke.png",
    })
    
    -- Damage nearby nodes
    minetest.after(0.1, function()
        minetest.set_node(pos, {name = "air"})
        minetest.remove_node(pos)
        minetest.dig_node(pos)
    end)
end

-- Function to move compressed steam and check for the 3x3x3 cube
local function move_compressed_steam(pos, start_time)
    local current_node = minetest.get_node(pos)
    if current_node.name ~= "default:compressed_steam" then
        return
    end

    -- Calculate the elapsed time since the steam node was spawned
    local elapsed_time = minetest.get_us_time() - start_time
    
    -- Check if there is a node above the compressed steam
    local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    local above_node = minetest.get_node(above_pos)
    local is_blocked = above_node.name ~= "air"

    -- If 10 seconds have passed and the steam is not blocked, remove it
    if elapsed_time >= 10000000 and not is_blocked then
        minetest.remove_node(pos)
        return
    end

    -- Check for the 3x3x3 compressed steam cube and trigger explosion if found
    if check_for_compressed_steam_cube(pos) then
        trigger_explosion(pos)
        return
    end

    -- Attempt to move compressed steam up, swapping with normal steam if needed
    if above_node.name == "default:steam" then
        minetest.swap_node(above_pos, {name = "default:compressed_steam"})
        minetest.set_node(pos, {name = "default:steam"})
        minetest.after(3.0, function() move_compressed_steam(above_pos, start_time) end)
    else
        local next_pos = find_next_steam_position(pos)
        if next_pos then
            minetest.remove_node(pos)
            minetest.set_node(next_pos, {name = "default:compressed_steam"})
            minetest.after(3.0, function() move_compressed_steam(next_pos, start_time) end)
        else
            minetest.after(3.0, function() move_compressed_steam(pos, start_time) end)
        end
    end
end
-- Register the compressed steam node
minetest.register_node("default:compressed_steam", {
    description = "Compressed Steam",
    drawtype = "glasslike",
    use_texture_alpha = true,
    is_ground_content = false,
    paramtype = "light",
    tiles = {"default_smoke.png^[colorize:white:192"},  -- Compressed steam, whiter than normal steam
    groups = {compressed_steam = 1},
    walkable = false,
    pointable = false,
    buildable_to = true,
})

-- Function to handle compressed steam logic
local function spawn_compressed_steam(pos)
    minetest.set_node(pos, {name = "default:compressed_steam"})
    minetest.sound_play("default_furnace_active", {pos = pos, max_hear_distance = 10, gain = 0.7})
    local start_time = minetest.get_us_time()
    minetest.after(1.0, function() move_compressed_steam(pos, start_time) end)
end

-- Modify the existing function to spawn compressed steam when necessary
local function spawn_multiple_steam(pos, remaining_spawns)
    local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    local above_node = minetest.get_node(above_pos)

    if above_node.name == "air" then
        spawn_steam(pos)
    elseif above_node.name == "default:steam" then
        spawn_compressed_steam(above_pos)  -- Convert the steam above to compressed steam
    end

    if remaining_spawns > 1 then
        minetest.after(5.0, function()
            local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            local node = minetest.get_node(above_pos)
            if node.name == "air" then
                spawn_multiple_steam(above_pos, remaining_spawns - 1)
            end
        end)
    end
end

-- Modify the existing ABM to account for compressed steam creation
minetest.register_abm({
    label = "Lava creates Steam or Compressed Steam",
    nodenames = {"default:water_source", "default:water_flowing"},
    interval = 1,
    chance = 1,
    action = function(pos)
        if has_nearby_node(pos, {"default:lava_source", "default:lava_flowing"}, 2) then
            local steam_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            local node = minetest.get_node(steam_pos)
            if node.name == "air" then
                spawn_steam(steam_pos)  -- Create steam once, as before
                minetest.remove_node(pos)  -- Remove the water node
            elseif node.name == "default:steam" then
                spawn_compressed_steam(steam_pos)  -- Convert existing steam into compressed steam
                minetest.remove_node(pos)  -- Remove the water node
            end
        end
    end,
})

-- ABM to spawn steam or compressed steam when interacting with fire or torches
minetest.register_abm({
    label = "Fire/Torches create Steam or Compressed Steam",
    nodenames = {"default:water_source", "default:water_flowing"},
    interval = 30,
    chance = 1,
    action = function(pos)
        if has_nearby_node(pos, {"fire:basic_flame", "default:torch"}, 2) then
            local steam_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            local node = minetest.get_node(steam_pos)
            if node.name == "air" then
                spawn_multiple_steam(steam_pos, 3)  -- Create steam 3 times
                minetest.remove_node(pos)  -- Remove the water node after creating steam
            elseif node.name == "default:steam" then
                spawn_compressed_steam(steam_pos)  -- Convert existing steam into compressed steam
                minetest.remove_node(pos)  -- Remove the water node after creating compressed steam
            end
        end
    end,
})



minetest.register_chatcommand("tpent", {
    params = "<modname:entityname>",
    description = "Teleport to the nearest instance of the specified entity within 300 blocks",
    func = function(player_name, param)
        local player = minetest.get_player_by_name(player_name)
        if not player then
            return false, "Player not found"
        end
        
        if param == "" then
            return false, "You must specify an entity in the format modname:entityname"
        end

        local entity_name = param
        local pos = player:get_pos()
        local found_pos = nil
        
        -- Iterate in 50 block chunks up to 300 blocks
        for dist = 50, 300, 50 do
            -- Define the search area
            local minp = vector.subtract(pos, dist)
            local maxp = vector.add(pos, dist)
            
            -- Find entities within the area
            local objects = minetest.get_objects_inside_radius(pos, dist)
            for _, obj in ipairs(objects) do
                if not obj:is_player() then
                    local entity = obj:get_luaentity()
                    if entity and entity.name == entity_name then
                        found_pos = obj:get_pos()
                        break
                    end
                end
            end
            
            -- If entity found, break the loop
            if found_pos then
                break
            end
        end

        if found_pos then
            player:set_pos(found_pos)
            return true, "Teleported to the nearest " .. entity_name
        else
            return false, "No " .. entity_name .. " found within 300 blocks"
        end
    end,
})
-- Register wet sand as a persistent item
-- Register wet sand as a persistent item
minetest.register_node("default:wet_sand", {
    description = "Wet Sand",
    tiles = {"default_sand.png^[colorize:olive:80"},
    groups = {crumbly = 3, wet_sand = 1},
    on_destroy = function(pos)

    minetest.set_node(pos, {name = "default:water_flowing"})
    end,
    -- No sounds to avoid crashes
})

minetest.register_craft({
	type  =  "cooking",
	recipe  = "default:wet_sand",
	output = "default:sand",
})
