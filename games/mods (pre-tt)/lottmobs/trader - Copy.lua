--This code comes almost exclusively from the trader and inventory of mobf, by Sapier.
--The copyright notice bellow is from mobf:
-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup Inventory Inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

function lottmobs.allow_move(inv, from_list, from_index, to_list, to_index, count, player)
	if to_list ~= "selection" or
		from_list == "price" or
		from_list == "payment" or
		from_list == "takeaway" or
		from_list == "identifier" then
		return 0
	end
	-- forbid moving of parts of stacks
	local old_stack = inv.get_stack(inv, from_list, from_index)
	if count ~= old_stack.get_count(old_stack) then
		return 0;
	end
	return count
end

function lottmobs.allow_put(inv, listname, index, stack, player)
	if listname == "payment" then
		return 99
	end
	return 0
end

function lottmobs.allow_take(inv, listname, index, stack, player)
	if listname == "takeaway" or
		listname == "payment" then
		return 99
	else
		return 0
	end
end

function lottmobs.on_put(inv, listname, index, stack)
	if listname == "payment" then
		lottmobs.update_takeaway(inv)
	end
end

function lottmobs.on_take(inv, listname, count, index, stack, player)
	if listname == "takeaway" then
		local amount = inv:get_stack("payment",1):get_count()
		local price = inv:get_stack("price",1):get_count()
		local thing = inv:get_stack("payment",1):get_name()
		inv.set_stack(inv,"selection",1,nil)
		inv.set_stack(inv,"price",1,nil)
		inv.set_stack(inv,"takeaway",1,nil)
		inv.set_stack(inv,"payment",1,thing .. " " .. amount-price)
	end

	if listname == "payment" then
		if lottmobs.check_pay(inv,false) then
			local selection = inv.get_stack(inv,"selection", 1)
			if selection ~= nil then
				inv.set_stack(inv,"takeaway",1,selection)
			end
		else
			inv.set_stack(inv,"takeaway",1,nil)
		end
	end
end

function lottmobs.update_takeaway(inv)
	if lottmobs.check_pay(inv,false) then
		local selection = inv.get_stack(inv,"selection", 1)

		if selection ~= nil then
			inv.set_stack(inv,"takeaway",1,selection)
		end
	else
		inv.set_stack(inv,"takeaway",1,nil)
	end
end

function lottmobs.check_pay(inv,paynow)
	local now_at_pay = inv.get_stack(inv,"payment",1)
	local count = now_at_pay.get_count(now_at_pay)
	local name  = now_at_pay.get_name(now_at_pay)

	local price = inv.get_stack(inv,"price", 1)

	if price:get_name() == name then
		local price = price:get_count()
		if price > 0 and
			price <= count then
			if paynow then
				now_at_pay.take_item(now_at_pay,price)
				inv.set_stack(inv,"payment",1,now_at_pay)
				return true
			else
				return true
			end
		else
			if paynow then
				inv.set_stack(inv,"payment",1,nil)
			end
		end
	end

	return false
end
lottmobs.trader_inventories = {}

function lottmobs.add_goods(entity, race)
    local goods_to_add = nil
    for i = 1, 15 do
        if same_race == true then
            -- Check if race.items_race[i] exists before accessing it
            if race.items_race[i] and math.random(0, 100) > race.items_race[i][3] then
                lottmobs.trader_inventory.set_stack(lottmobs.trader_inventory, "goods", i, race.items_race[i][1])
            end
        else
            -- Check if race.items[i] exists before accessing it
            if race.items[i] and math.random(0, 100) > race.items[i][3] then
                lottmobs.trader_inventory.set_stack(lottmobs.trader_inventory, "goods", i, race.items[i][1])
            end
        end
    end
end

function lottmobs.face_pos(self,pos)
	local s = self.object:get_pos()
	local vec = {x=pos.x-s.x, y=pos.y-s.y, z=pos.z-s.z}
	local yaw = math.atan2(vec.z,vec.x)-math.pi/2
	if self.drawtype == "side" then
		yaw = yaw+(math.pi/2)
	end
	self.object:set_yaw(yaw)
	return yaw
end
----

local function lottmobs_trader(self, clicker, entity, race, image, priv)
    lottmobs.face_pos(self, clicker:get_pos())
    local player = clicker:get_player_name()

    -- Initialize or update self.game_name
    if not self.game_name or self.game_name == "mob" then
        self.game_name = tostring(race.names[math.random(1, #race.names)])
    end    -- Ensuring self.id is properly initialized
    if not self.id or self.id == 0 then
        self.id = tostring(math.random(1, 1000) * math.random(1, 10000)) .. self.name .. tostring(math.random(1, 1000) ^ 2)
    end

    if self.game_name == "mob" then
        self.game_name = tostring(race.names[math.random(1, #race.names)])
        --self.nametag = self.game_name
    end

    local unique_entity_id = self.id

    if unique_entity_id then -- Check if unique_entity_id is not nil
        local is_inventory = minetest.get_inventory({ type = "detached", name = unique_entity_id })
        local same_race = false
        if minetest.get_player_privs(player)[priv] ~= nil then
            same_race = true
        end
        local move_put_take = {
            allow_move = lottmobs.allow_move,
            allow_put = lottmobs.allow_put,
            allow_take = lottmobs.allow_take,
		on_move = function(inventory, from_list, from_index, to_list, to_index, count, player)
			if from_list == "goods" and
			to_list == "selection" then
				local inv = inventory
				local moved = inv.get_stack(inv,to_list, to_index)
				local goodname = moved.get_name(moved)
				local elements = moved.get_count(moved)
				if( elements > count ) then
					-- remove the surplus parts
					inv.set_stack(inv,"selection", 1,goodname.." "..tostring( count ))
					-- the slot we took from is now free
					inv.set_stack(inv,"goods",from_index,
						goodname.." "..tostring( elements - count ))
					-- update the real amount of items in the slot now
					elements = count
				end
				local good = nil
				local good = nil
				if same_race == true then
					for i = 1,#race.items_race,1 do
						local stackstring = goodname .." " .. count
						if race.items_race[i][1] == stackstring then
							good = race.items_race[i]
						end
					end
				else
					for i = 1,#race.items,1 do
						local stackstring = goodname .." " .. count
						if race.items[i][1] == stackstring then
							good = race.items[i]
						end
					end
				end
				if good ~= nil then
					inventory.set_stack(inventory,"price", 1, good[2])
				else
					inventory.set_stack(inventory,"price", 1, nil)
				end
			lottmobs.update_takeaway(inv)
			end
		end,
		on_put = lottmobs.on_put,
		on_take = lottmobs.on_take
	}
	if is_inventory == nil then
		lottmobs.trader_inventory = minetest.create_detached_inventory(unique_entity_id, move_put_take)
		lottmobs.trader_inventory.set_size(lottmobs.trader_inventory,"goods",15)
		lottmobs.trader_inventory.set_size(lottmobs.trader_inventory,"takeaway",1)
		lottmobs.trader_inventory.set_size(lottmobs.trader_inventory,"selection",1)
		lottmobs.trader_inventory.set_size(lottmobs.trader_inventory,"price",1)
		lottmobs.trader_inventory.set_size(lottmobs.trader_inventory,"payment",1)
		lottmobs.add_goods(entity, race)
	end
	minetest.chat_send_player(player, "[NPC] <Trader " .. self.game_name .. "> Hello, " .. player .. ", have a look at my wares.")
	minetest.show_formspec(player, "trade",
		"size[8,10;]" ..
		 "background[5,5;1,1;" .. image .. ";true]" ..
		"label[0,0;Trader " .. self.game_name .. "'s stock:]" ..
		"list[detached:" .. unique_entity_id .. ";goods;.5,.5;3,5;]" ..
		"label[4.5,0.5;Selection]" ..
		"list[detached:" .. unique_entity_id .. ";selection;4.5,1;5.5,2;]" ..
		"label[6,0.5;Price]" ..
		"list[detached:" .. unique_entity_id .. ";price;6,1;7,2;]" ..
		"label[4.5,3.5;Payment]" ..
		"list[detached:" .. unique_entity_id .. ";payment;4.5,4;5.5,5;]" ..
		"label[6,3.5;Brought items]" ..
		"list[detached:" .. unique_entity_id .. ";takeaway;6,4;7.5,5.5;]" ..
		"list[current_player;main;0,6;8,4;]"
	)
    else
        -- Handle the case where unique_entity_id is nil
        minetest.log("error", "unique_entity_id is nil in lottmobs_trader.")
    end
end

mobs:register_mob("lottmobs:elf_trader", {
	type = "npc",
        race = "GAMEelf",
        hp_min = 20,
	hp_max = 50,
	collisionbox = {-0.3,-1.1,-0.3, 0.3,0.91,0.3},
	textures = {
		{"lottmobs_elf_trader.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
	},
	visual = "mesh",
	visual_size = {x=0.72, y=0.8},
	mesh = "lottarmor_character.b3d",
	view_range = 20,
	makes_footstep_sound = true,
	walk_velocity = 1.5,
	run_velocity = 5,
	damage = 6,
	armor = 200,
	drops = { },
	light_resistant = true,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 10,
	light_damage = 0,
	attack_type = "dogfight",
	follow = "default:corn",
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "mobs_slash_attack",
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
	on_rightclick = function(self, clicker)
		lottmobs_trader(self, clicker, entity, lottmobs.elf, "gui_elfbg.png", "GAMEelf")
	end,
})
mobs:register_spawn("lottmobs:elf_trader", {"default:dirt_with_grass"}, 20, 0, 1200000, 2, 31000)

mobs:register_mob("lottmobs:human_trader", {
	type = "npc",
        race = "GAMEman",
        hp_min = 15,
	hp_max = 35,
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	textures = {
		{"lottmobs_human_trader.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
	},
	visual = "mesh",
	mesh = "lottarmor_character.b3d",
	makes_footstep_sound = true,
	view_range = 12,
	walk_velocity = 1,
	run_velocity = 3,
	armor = 100,
	damage = 5,
	drops = { },
	light_resistant = true,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 10,
	light_damage = 0,
	attack_type = "dogfight",
	follow = "default:corn",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "default_punch2",
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
	on_rightclick = function(self, clicker)
		lottmobs_trader(self, clicker, entity, lottmobs.human, "gui_gondorbg.png", "GAMEman")
	end,
})
mobs:register_spawn("lottmobs:human_trader", {"biomes_island:dirt_with_island_litter"}, 20, -1, 600000, 2, 31000)
mobs:register_spawn("lottmobs:human_trader", {"default:dirt_with_grass"}, 20, -1, 600000, 2, 31000)

mobs:register_mob("lottmobs:dwarf_trader", {
	type = "npc",
        race = "GAMEdwarf",
        hp_min = 20,
	hp_max = 30,
	collisionbox = {-0.3,-.85,-0.3, 0.3,0.68,0.3},
	textures = {
		{"lottmobs_dwarf_trader.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
	},
	visual = "mesh",
	visual_size = {x=1.1, y=0.85},
	mesh = "lottarmor_character.b3d",
	view_range = 10,
	makes_footstep_sound = true,
	walk_velocity = 1,
	run_velocity = 2,
	armor = 200,
	damage = 4,
	drops = {},
	light_resistant = true,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	attack_type = "dogfight",
	follow = "default:corn",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "default_punch2",
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
    on_rightclick = function(self, clicker)
        lottmobs_trader(self, clicker, self, lottmobs.dwarf, "gui_angmarbg.png", "GAMEdwarf")
    end,
})
mobs:register_spawn("lottmobs:dwarf_trader", {"default:cobble"}, 20, -1, 120000, 3, 31000)