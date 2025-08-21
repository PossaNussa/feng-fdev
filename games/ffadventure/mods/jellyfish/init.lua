-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
function register_spawn(name, nodes,chanche)
	minetest.register_abm({
		nodenames = nodes,
		interval = 3000,
		chance = chanche,
		action = function(pos, node, _, active_object_count_wider)
			minetest.add_entity(pos, name)
		end
	})
end
minetest.register_craftitem("jellyfish:jelly", {
	description = "Jelly",
	inventory_image = "jelly.png",
	on_use = minetest.item_eat(10),
})
function register_jellyfish_advanced(name, def)
	local defbox = def.size/2
	local side2 = name .. "3.png"
	local side = name .. "2.png"
	local front = name .. "1.png"
	minetest.register_entity("jellyfish:" .. name,{
		initial_properties = {
			name = "jellyfish:" .. name,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "cube",
			textures = {side ,side , front , "empty.png" ,side2 ,side },
			collisionbox = {-defbox, -defbox, -defbox, defbox, defbox, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self)
			local pos = self.object:getpos()
			if self.object:get_hp() > 0 then return end
			local pos = self.object:getpos()
			pos.y = pos.y + 0.5
			self.object:remove()
			obj = minetest.add_item(pos, ItemStack("jellyfish:jelly " .. math.random(1, 3)))
			obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
		end,
		on_activate = function(self)
			targetvektor = {x=0, y = 0 , z = 0 }
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			timer = 0
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			timer = timer + dtime
			if timer > 1 then
				timer = 0
			end
			pos = self.object:getpos()
			if not(self.object:get_hp() > 0) then
				pos.y = pos.y + 0.5
				self.object:remove()
				obj = minetest.add_item(pos, ItemStack("jellyfish:jelly " .. math.random(1, 3)))
				obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
			if math.random(1,50) == 1 then
				targetvektor = {x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}
				targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
				targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)}
			end
			for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
				if entity:is_player() then
					target = entity:getpos()
					targetvektor = {x=target.x-pos.x,y=target.y-pos.y,z=target.z-pos.z}
					targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
					targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)*def.speed}
					if minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "default:water_source" then
						targetvektor.y = -1
					end
				end
			end
			if timer == 0 then
				for _,obj in ipairs(minetest.get_objects_inside_radius(pos,def.size*2)) do
					if obj:is_player() then
						obj:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
					end
				end
			end
			if minetest.get_node(pos).name ~= "default:water_source" then
				self.object:remove()
			end
			if targetvektor then
				self.object:setvelocity(targetvektor)
				self.object:set_properties({automatic_rotate = 0})
				self.object:setyaw(math.atan2(targetvektor.z,targetvektor.x))
			end
		end
	})
	register_spawn("jellyfish:" .. name, "default:water_source",def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		size = def.size,
		speed = 2 or def.speed,
		max_hp = def.max_hp,
		damage = def.damage,
		drops = {{name = "jellyfish:jelly",chanche = 1,min = 1,max = 3}},
		chanche = def.chanche
	})
end
register_jellyfish({
	name = "a",
	size = 0.25,
	max_hp = 5,
	reach = 2,
	damage = 5,
	chanche = 80000,
	speed = 3
})
register_jellyfish({
	name = "b",
	size = 0.3,
	max_hp = 7,
	damage = 4,
	reach = 2,
	chanche = 40000
})
register_jellyfish({
	name = "c",
	size = 0.5,
	max_hp = 12,
	reach = 2,
	damage = 2,
	chanche = 20000
})
register_jellyfish({
	name = "d",
	size = 0.25,
	max_hp = 5,
	reach = 2,
	damage = 1,
	chanche = 20000
})
register_jellyfish({
	name = "e",
	size = 0.2,
	reach = 2,
	max_hp = 5,
	damage = 5,
	chanche = 80000,
	speed = 1.5
})
register_jellyfish({
	name = "f",
	size = 0.1,
	max_hp = 2,
	damage = 4,
	reach = 2,
	chanche = 40000,
	speed = 1
})
register_jellyfish({
	name = "g",
	size = 0.75,
	max_hp = 10,
	reach = 2,
	damage = 2,
	chanche = 20000,
	speed = 2.5
})
register_jellyfish({
	name = "h",
	size = 0.75,
	max_hp = 10,
	reach = 2,
	damage = 5,
	chanche = 80000,
	speed = 3
})
