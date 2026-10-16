-- Dynamic trees are placed by the mapgen as bare saplings and only grow into
-- trunks and branches later, long after the decoration pass that hangs twigs on
-- ordinary trees has run. So they get their twigs the same way they get the
-- rest of themselves: they grow them.

local branch_parts = {
	arm = true,
	elbow = true,
	fork = true,
	bend = true,
}

-- branch node name -> twig node it grows
local host_twig = {}

local dirs = {
	{ x =  1, y = 0, z =  0 },
	{ x = -1, y = 0, z =  0 },
	{ x =  0, y = 0, z =  1 },
	{ x =  0, y = 0, z = -1 },
	{ x =  0, y = -1, z = 0 }, -- dangling under the branch
}

core.register_on_mods_loaded(function()
	for name, def in pairs(core.registered_nodes) do
		local species, part = name:match("^dynamic_trees:(%a[%a_]-_tree)_(%a+)_")
		if species and branch_parts[part] then
			local twig = "twigs:" .. species .. "_twig"
			if core.registered_nodes[twig] then
				host_twig[name] = twig
				local groups = table.copy(def.groups or {})
				groups.twigs_host = 1
				core.override_item(name, { groups = groups })
			end
		end
	end
end)

core.register_abm({
	label = "Twigs grow on dynamic trees",
	nodenames = { "group:twigs_host" },
	neighbors = { "air" },
	interval = 60,
	chance = 30,
	catch_up = false,
	action = function(pos, node)
		local twig = host_twig[node.name]
		if twig == nil then return end

		-- keep the canopy from filling up solid with twigs
		if core.find_node_near(pos, 3, "group:twig") then return end

		local first = math.random(1, #dirs)
		for i = 0, #dirs - 1 do
			local dir = dirs[(first + i - 1) % #dirs + 1]
			local target = vector.add(pos, dir)
			if core.get_node(target).name == "air" then
				core.set_node(target, {
					name = twig,
					param2 = core.dir_to_wallmounted(vector.subtract(pos, target))
				})
				return
			end
		end
	end,
})
