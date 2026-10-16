-- Awards for keeping the ship running (only loaded with the awards mod).

local S = csd_tasks.S

local milestones = {
	{1,   "csd_first_task", S("Reporting for Duty"), S("Complete your first task.")},
	{10,  "csd_tasks_10",   S("Crew Member"),        S("Complete 10 tasks.")},
	{50,  "csd_tasks_50",   S("Old Hand"),           S("Complete 50 tasks.")},
	{200, "csd_tasks_200",  S("Backbone of the Ship"), S("Complete 200 tasks.")},
}

for _, m in ipairs(milestones) do
	awards.register_award(m[2], {
		title = m[3],
		description = m[4],
		icon = "csd_tasks_award.png",
	})
end

awards.register_award("csd_green_garden", {
	title = S("Green Thumb"),
	description = S("Water the plants in hydroponics."),
	icon = "csd_tasks_award.png",
})

csd_tasks.register_on_task_complete(function(player, task_id, total)
	local name = player:get_player_name()
	for _, m in ipairs(milestones) do
		if total >= m[1] then
			awards.unlock(name, m[2])
		end
	end
	if task_id == "water_plants" then
		awards.unlock(name, "csd_green_garden")
	end
end)
