-- Mesecons integration for circuits
-- Makes circuits power nodes (levers, buttons, etc.) act as mesecon receptors,
-- so they can drive mesecons wires, lamps, pistons, and any other mesecons device.

if not core.get_modpath("mesecons") then return end

local c = circuits

core.register_on_mods_loaded(function()
	local processed = {}

	for name, def in pairs(core.registered_nodes) do
		local cd = def.circuits
		-- Only touch power sources (have powering function + base_node)
		if not cd or not cd.powering or not cd.base_node then goto continue end
		-- Each base_node has two registered variants (_on / _off); process once
		if processed[cd.base_node] then goto continue end
		processed[cd.base_node] = true

		local on_name  = cd.powered  -- e.g. "circuits_power:button_on"
		local off_name = cd.off      -- e.g. "circuits_power:button_off"

		-- Register both variants as mesecon receptors so the mesecons dig-service
		-- and is_powered checks work correctly.
		if on_name and core.registered_nodes[on_name] then
			core.override_item(on_name, {
				mesecons = {receptor = {
					state = mesecon.state.on,
					rules = mesecon.rules.default,
				}},
			})
		end
		if off_name and core.registered_nodes[off_name] then
			core.override_item(off_name, {
				mesecons = {receptor = {
					state = mesecon.state.off,
					rules = mesecon.rules.default,
				}},
			})
		end

		-- Wrap on_update (shared circuits table, so this runs once per base_node)
		-- to emit mesecon signals whenever the circuits node changes state.
		local old_on_update = cd.on_update
		if old_on_update then
			cd.on_update = function(npos, args, power_type)
				local changed = old_on_update(npos, args, power_type)
				if changed then
					local pos = vector.new(npos.x, npos.y, npos.z)
					if args == "on" then
						mesecon.receptor_on(pos, mesecon.rules.default)
					elseif args == "off" then
						mesecon.receptor_off(pos, mesecon.rules.default)
					end
				end
				return changed
			end
		end

		::continue::
	end
end)

-- Reverse bridge: mesecons switch → circuits wires, circuits wires → mesecons lightstones.
core.register_on_mods_loaded(function()

	-- ---- Lightstones as circuits consumers ----
	-- Allows circuits wires/levers/buttons to power mesecons lightstones directly.
	if core.get_modpath("mesecons_lightstone") then
		-- Standard consumer on_update: same logic as circuits built-in light.
		local function lightstone_on_update(npos)
			for _, node in ipairs(c.get_all_connected(npos)) do
				if c.is_powering(node, npos) then
					if not c.is_on(npos) then
						npos.node.name = c.get_powered(npos)
						core.swap_node(npos, npos.node)
						return true
					else
						return false
					end
				end
			end
			if c.is_on(npos) then
				npos.node.name = c.get_off(npos)
				core.swap_node(npos, npos.node)
				return true
			else
				return false
			end
		end

		local colours = {
			"red", "green", "blue", "gray", "darkgray",
			"yellow", "orange", "white", "pink", "magenta", "cyan", "violet",
		}
		for _, colour in ipairs(colours) do
			local base  = "mesecons_lightstone:lightstone_" .. colour
			local off_n = base .. "_off"
			local on_n  = base .. "_on"
			if not (core.registered_nodes[off_n] and core.registered_nodes[on_n]) then
				goto ls_next
			end

			local cd = {
				base_node     = base,
				powered       = on_n,
				off           = off_n,
				connects      = c.local_area,
				connects_to   = {"circuit_wire", "circuit_power"},
				store_connect = "meta",
				on_update     = lightstone_on_update,
			}

			for _, variant in ipairs{off_n, on_n} do
				local existing   = core.registered_nodes[variant]
				local new_groups = {}
				for k, v in pairs(existing.groups) do new_groups[k] = v end
				new_groups.circuit_consumer = 1
				core.override_item(variant, {
					groups   = new_groups,
					circuits = table.copy(cd),
					on_construct = function(pos)
						c.connect_all(c.npos({x=pos.x, y=pos.y, z=pos.z}))
					end,
					on_destruct = function(pos)
						c.disconnect_all(c.npos({x=pos.x, y=pos.y, z=pos.z}))
					end,
				})
			end
			::ls_next::
		end
	end

	-- ---- Mesecons switch as circuits power source ----
	-- Allows a mesecons switch to drive circuits wires.
	if not core.get_modpath("mesecons_switch") then return end
	local sw_off = "mesecons_switch:mesecon_switch_off"
	local sw_on  = "mesecons_switch:mesecon_switch_on"
	if not (core.registered_nodes[sw_off] and core.registered_nodes[sw_on]) then return end

	local sw_cd = {
		base_node     = "mesecons_switch:mesecon_switch",
		powered       = sw_on,
		off           = sw_off,
		connects      = c.local_area,
		connects_to   = {"circuit_wire"},
		store_connect = "meta",
		powering      = function(npos, rpos) return c.is_on(npos) end,
		-- Notify all directly connected wires to re-evaluate power state.
		on_update     = function(npos, args)
			local connected = c.get_all_connected(npos)
			if not connected then return true end
			for _, node in ipairs(connected) do
				if core.get_item_group(node.node.name, "circuit_wire") > 0 then
					c.update(node)
				end
			end
			return true
		end,
	}

	-- Capture the shared rightclick handler before we override anything.
	local orig_rightclick = core.registered_nodes[sw_off].on_rightclick

	for _, variant in ipairs{sw_off, sw_on} do
		local existing   = core.registered_nodes[variant]
		local new_groups = {}
		for k, v in pairs(existing.groups) do new_groups[k] = v end
		new_groups.circuit_power = 1
		core.override_item(variant, {
			groups   = new_groups,
			circuits = table.copy(sw_cd),
			on_construct = function(pos)
				c.connect_all(c.npos({x=pos.x, y=pos.y, z=pos.z}))
			end,
			on_destruct = function(pos)
				c.disconnect_all(c.npos({x=pos.x, y=pos.y, z=pos.z}))
			end,
			on_rightclick = function(pos, node, ...)
				-- Original: flips mesecons state and emits mesecon signal.
				orig_rightclick(pos, node, ...)
				-- Also trigger the circuits network on the next globalstep tick.
				c.power_update(c.npos({x=pos.x, y=pos.y, z=pos.z}), nil)
			end,
		})
	end
end)
