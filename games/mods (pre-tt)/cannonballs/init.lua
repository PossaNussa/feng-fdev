minetest.register_node("cannonballs:cannonball", {
	description = "Cannonball",
	tiles = {"(default_steel_block.png^[colorize:black:180)^cannonball.png"},
	groups = {cracky = 1, falling_node = 1},
	sounds = default.node_sound_metal_defaults(),
	on_blast = function() end,
        on_destruct = function () end,
})

minetest.register_craft( {
	output = "cannonballs:cannonball 8",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"default:steelblock", "tnt:gunpowder", "default:steelblock"},
		{"default:steelblock", "default:steelblock", "default:steelblock"},
	}
})

local falling_node = minetest.registered_entities["__builtin:falling_node"]

local old_on_step = falling_node.on_step

function falling_node.on_step(self, dtime, moveresult)

	if self.node.name == "cannonballs:cannonball" then
		if self.old_velocity == nil then self.old_velocity = vector.new() end
		local velocity = self.object:getvelocity()
		local velocity_change = velocity - self.old_velocity
			self.old_velocity = velocity

			if velocity_change.x + velocity_change.z < -30 then

				tnt.boom(self.object:getpos(), {radius = 3})						self.object:setvelocity(vector.new(velocity.x, 0, velocity.z))
			end

	end

	old_on_step(self, dtime, moveresult)

end