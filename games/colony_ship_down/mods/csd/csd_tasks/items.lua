-- Things tasks hand you and take from you.

local S = csd_tasks.S

core.register_craftitem("csd_tasks:ration", {
	description = S("Ration Pack") .. "\n" .. core.colorize("#9aa7c0", S("Made in the galley. Eat to heal a little.")),
	inventory_image = "csd_tasks_ration.png",
	on_use = core.item_eat(4),
	groups = {food = 1, food_ration = 1},
})

core.register_craftitem("csd_tasks:data_chip", {
	description = S("Data Chip") .. "\n" .. core.colorize("#9aa7c0", S("Take it to a Data Uplink.")),
	inventory_image = "csd_tasks_data_chip.png",
	stack_max = 8,
})

-- Each chip carries a snippet of the ship's logs (shown in its tooltip).
local LOG_LINES = {
	"NAV: course drift +0.003 deg, corrected",
	"CRYO: pod %d occupant snoring above threshold",
	"MESS: algae paste batch #%d rated 'acceptable'",
	"COMMS: ping from Earth (41y delay): 'did you feed the cat?'",
	"HULL: micrometeorite impact, section %d. No damage. Probably.",
	"LIFE: O2 at 20.9%%, CO2 scrubbers humming",
	"HYDRO: fern #%d has named itself 'Gerald'",
	"REACTOR: output nominal, coolant smells faintly of mint",
	"SEC: unauthorised sandwich in Bridge, confiscated",
	"ROBOT MOP-3: filed complaint #%d re: footprints",
	"CARGO: crate %d contains crates",
	"NAV: 212 years to destination. Are we there yet? No.",
	"ENG: flywheel %d spinning pleasantly",
	"MED: crew member reports 'space feels big'. Noted.",
	"COMMS: static on channel %d sounds like whale song",
	"SYS: reboot of toaster subsystem successful",
}

function csd_tasks.make_data_chip()
	local stack = ItemStack("csd_tasks:data_chip")
	local lines = {S("Data Chip"), core.colorize("#9aa7c0", S("Take it to a Data Uplink."))}
	local t = math.random(0, 86399)
	for _ = 1, 4 do
		t = t + math.random(3, 900)
		local line = LOG_LINES[math.random(#LOG_LINES)]:format(math.random(100, 9999))
		lines[#lines + 1] = core.colorize("#7dd8a0", ("[%02d:%02d:%02d] %s"):format(math.floor(t / 3600) % 24,
			math.floor(t / 60) % 60, t % 60, line))
	end
	stack:get_meta():set_string("description", table.concat(lines, "\n"))
	return stack
end

core.register_craftitem("csd_tasks:fuel_cell", {
	description = S("Fuel Cell") .. "\n" .. core.colorize("#9aa7c0", S("Take it to an Engine Fuel Port.")),
	inventory_image = "csd_tasks_fuel_cell.png",
	stack_max = 4,
})

core.register_craftitem("csd_tasks:scrap_metal", {
	description = S("Scrap Metal") .. "\n" .. core.colorize("#9aa7c0", S("Press it into a hull patch in the Machine Shop.")),
	inventory_image = "csd_tasks_scrap_metal.png",
})

core.register_craftitem("csd_tasks:hull_patch", {
	description = S("Hull Patch") .. "\n" .. core.colorize("#9aa7c0", S("Fixes damaged hull panels and seals breaches faster.")),
	inventory_image = "csd_tasks_hull_patch.png",
})

-- If the press isn't around, patches can still be made by hand (slowly: 3 scrap).
core.register_craft({
	output = "csd_tasks:hull_patch",
	recipe = {{"csd_tasks:scrap_metal", "csd_tasks:scrap_metal", "csd_tasks:scrap_metal"}},
})
