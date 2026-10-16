-- Admin controls. There is deliberately no item or block that summons a
-- tornado: the original prototype hung it off placing a stick, which meant one
-- misclick with a stick in hand ate somebody's house.

local S = tornado.settings

local function usage()
	return "usage: /tornado status | storm | now | spawn [strength] | stop"
end

minetest.register_chatcommand("tornado", {
	params = "status | storm | now | spawn [strength] | stop",
	description = "Inspect or drive the severe weather event",
	privs = { server = true },
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then return false, "you need to be in the world" end
		local pos = player:get_pos()

		local action, rest = param:match("^(%S*)%s*(.*)$")

		if action == "" or action == "status" then
			local event = tornado.event
			local lines = {}
			if not event then
				lines[#lines + 1] = "No event running."
			else
				local phase = ({ "build-up", "funnel on the ground" })[event.phase]
				lines[#lines + 1] = string.format(
					"Phase: %s, %ds in, epicenter %s, storm heading %s, funnel expected: %s",
					phase, math.floor(event.t),
					minetest.pos_to_string(vector.round(event.epicenter)),
					tornado.compass(event.dir), tostring(event.will_touch_down))
			end
			lines[#lines + 1] = string.format("Live funnels: %d, debris in the air: %d/%d",
				#tornado.get_funnels(), tornado.debris_count, S.max_debris)
			lines[#lines + 1] = string.format(
				"griefing=%s damage=%s protection=%s storm_chance=%s funnel_chance=%s",
				tostring(S.griefing), tostring(S.damage), tostring(S.respect_protection),
				tostring(S.storm_chance), tostring(S.funnel_chance))
			return true, table.concat(lines, "\n")
		end

		if action == "storm" then
			local ok, err = tornado.start_event(pos, { force_funnel = true })
			if not ok then return false, err end
			return true, "supercell building here; it will drop a funnel at the end"

		elseif action == "now" then
			local ok, err = tornado.start_event(pos, {
				force_funnel = true,
				skip_watch = true,
			})
			if not ok then return false, err end
			return true, "skipping the build-up; the funnel comes in upwind"

		elseif action == "spawn" then
			local strength = tonumber(rest)
			local funnel = tornado.spawn(pos, { peak = strength })
			if not funnel then return false, "could not place a funnel here" end
			return true, string.format("funnel spawned (strength %.2f)", funnel.peak)

		elseif action == "stop" then
			local removed = tornado.clear()
			tornado.end_event(0)
			tornado.clear_cooldown()
			return true, string.format("cleared %d funnel(s) and cancelled the event", removed)
		end

		return false, usage()
	end,
})
