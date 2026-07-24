quests = {}

local MP = minetest.get_modpath("quests")
dofile(MP .. "/stages.lua")

-- =============================================================================
-- Player state helpers
-- =============================================================================

local function get_completed(player)
	local meta = player:get_meta()
	local raw = meta:get_string("quests:completed")
	if raw == "" then return {} end
	return minetest.deserialize(raw) or {}
end

local function set_completed(player, completed)
	local meta = player:get_meta()
	meta:set_string("quests:completed", minetest.serialize(completed))
end

local function is_quest_done(player, quest_id)
	return get_completed(player)[quest_id] == true
end

local function mark_quest_done(player, quest_id)
	local completed = get_completed(player)
	completed[quest_id] = true
	set_completed(player, completed)
end

-- Get the player's current stage (first incomplete one), or nil if all done
local function get_current_stage(player)
	local completed = get_completed(player)
	for _, stage in ipairs(quests.stages) do
		for _, q in ipairs(stage.quests) do
			if not completed[q.id] then
				return stage
			end
		end
	end
	return nil -- all stages complete
end

-- =============================================================================
-- HUD notifications
-- =============================================================================

local function show_hud_notification(player, text, duration)
	duration = duration or 4
	local hud_id = player:hud_add({
		hud_elem_type = "text",
		position = {x = 0.5, y = 0.15},
		offset = {x = 0, y = 0},
		text = text,
		alignment = {x = 0, y = 0},
		scale = {x = 100, y = 100},
		number = 0xFFFF00,
		size = {x = 2, y = 2},
		z_index = 1000,
	})
	if hud_id then
		minetest.after(duration, function()
			local p = minetest.get_player_by_name(player:get_player_name())
			if p then
				p:hud_remove(hud_id)
			end
		end)
	end
end

-- =============================================================================
-- Quest completion handler (shared by all triggers)
-- =============================================================================

local function on_quest_complete(player, q)
	mark_quest_done(player, q.id)
	show_hud_notification(player, "Quest complete: " .. q.desc)

	-- Check if the quest's stage just completed
	local completed = get_completed(player)
	for _, s in ipairs(quests.stages) do
		local has_quest = false
		local all_done = true
		for _, sq in ipairs(s.quests) do
			if sq.id == q.id then has_quest = true end
			if not completed[sq.id] then all_done = false end
		end
		if has_quest and all_done then
			minetest.after(2, function()
				local p = minetest.get_player_by_name(player:get_player_name())
				if p then
					local next_stage = get_current_stage(p)
					if next_stage then
						show_hud_notification(p, "New stage unlocked: " .. next_stage.title)
					else
						show_hud_notification(p, "All quests completed!")
					end
				end
			end)
			break
		end
	end
end

-- =============================================================================
-- i3 tab
-- =============================================================================

local esc = minetest.formspec_escape

-- Get the display item for a quest (for item_image in formspec)
local function quest_display_item(q)
	if q.items then return q.items[1] or "" end
	-- For group-based quests, find any registered item in that group
	if q.groups then
		for name, def in pairs(minetest.registered_nodes) do
			for _, g in ipairs(q.groups) do
				if minetest.get_item_group(name, g) > 0 then
					return name
				end
			end
		end
	end
	return ""
end

i3.new_tab("quests", {
	description = "Quests",
	image = "default_tool_stonesword.png",

	formspec = function(player, data, fs)
		local completed = get_completed(player)
		local current_stage = get_current_stage(player)

		local y = 1.0

		if not current_stage then
			fs("label[3,2;All quests completed!]")
			return
		end

		-- Stage header
		fs("label[0.5," .. y .. ";" .. esc("Stage: " .. current_stage.title) .. "]")
		y = y + 0.6

		-- Check if this stage is fully complete
		local stage_done = true
		for _, q in ipairs(current_stage.quests) do
			if not completed[q.id] then
				stage_done = false
				break
			end
		end

		-- Quest list
		for _, q in ipairs(current_stage.quests) do
			local done = completed[q.id] == true
			local check = done
				and minetest.colorize("#00FF00", "[X] ")
				or minetest.colorize("#888888", "[  ] ")

			-- Item image
			fs("item_image[0.5," .. (y - 0.2) .. ";0.6,0.6;" .. quest_display_item(q) .. "]")
			-- Checkbox + description
			local desc_color = done and "#00FF00" or "#FFFFFF"
			fs("label[1.3," .. y .. ";" .. esc(check .. minetest.colorize(desc_color, q.desc)) .. "]")
			y = y + 0.6
		end

		if stage_done then
			y = y + 0.3
			fs("label[0.5," .. y .. ";" .. esc(minetest.colorize("#FFD700", "Stage Complete!")) .. "]")
			local found_current = false
			for _, stage in ipairs(quests.stages) do
				if found_current then
					y = y + 0.6
					fs("label[0.5," .. y .. ";" .. esc("Next: " .. stage.title) .. "]")
					break
				end
				if stage.name == current_stage.name then
					found_current = true
				end
			end
		end
	end,

	fields = function(player, data, fields)
	end,
})

-- =============================================================================
-- Craft trigger
-- =============================================================================

-- Build lookup: item_name -> list of quest defs
local craft_triggers = {}
for _, stage in ipairs(quests.stages) do
	for _, q in ipairs(stage.quests) do
		if q.trigger == "craft" then
			for _, item_name in ipairs(q.items) do
				if not craft_triggers[item_name] then
					craft_triggers[item_name] = {}
				end
				table.insert(craft_triggers[item_name], q)
			end
		end
	end
end

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not player or not player:is_player() then return end
	local item_name = itemstack:get_name()
	local matching = craft_triggers[item_name]
	if not matching then return end

	for _, q in ipairs(matching) do
		if not is_quest_done(player, q.id) then
			on_quest_complete(player, q)
		end
	end
end)

-- =============================================================================
-- Dig trigger (group-based)
-- =============================================================================

-- Collect all dig-trigger quests with their groups
local dig_triggers = {}
for _, stage in ipairs(quests.stages) do
	for _, q in ipairs(stage.quests) do
		if q.trigger == "dig" and q.groups then
			table.insert(dig_triggers, q)
		end
	end
end

if #dig_triggers > 0 then
	minetest.register_on_dignode(function(pos, oldnode, digger)
		if not digger or not digger:is_player() then return end
		for _, q in ipairs(dig_triggers) do
			if not is_quest_done(digger, q.id) then
				for _, group in ipairs(q.groups) do
					if minetest.get_item_group(oldnode.name, group) > 0 then
						on_quest_complete(digger, q)
						break
					end
				end
			end
		end
	end)
end

-- =============================================================================
-- Join reminder
-- =============================================================================

minetest.register_on_joinplayer(function(player)
	minetest.after(3, function()
		local p = minetest.get_player_by_name(player:get_player_name())
		if not p then return end
		local stage = get_current_stage(p)
		if stage then
			show_hud_notification(p, "Press I \u{2192} Quests tab", 5)
		end
	end)
end)
