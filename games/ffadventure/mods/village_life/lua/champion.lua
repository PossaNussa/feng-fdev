-- Talking to a champion.
--
-- zombies:buffpig -- the big bulky pig the villages call a champion -- is a
-- village-bound defender (defence.lua anchors it, patrols it and answers the
-- alarm with it). It has no bed, no family and no shop, so it gets none of the
-- villagers' two-level conversation. What it gets is this: a short, blunt
-- exchange in keeping with something dumber and bulkier than the people it
-- guards. It knows only two things -- what it is, and what it has seen -- and
-- both are true, read from the same threat layer everything else reads.

local home    = village_life.home
local threats = village_life.threats

local champion = {}
village_life.champion = champion

local BUFFPIG = "zombies:buffpig"
local esc = minetest.formspec_escape

-- A champion has no name from mg_villages, so give it a plain one, seeded from
-- where it stands, stable for as long as it lives.
local NAMES = {
	"Grumble", "Bristle", "Tusk", "Snout", "Gnash",
	"Wallow", "Bramble", "Hodge", "Mudfoot", "Bellow",
}

local function champ_name(self)
	if self._champ_name then return self._champ_name end
	local pos = self.object and self.object:get_pos()
	local seed = pos and (math.floor(pos.x) * 31 + math.floor(pos.z)) or 0
	self._champ_name = NAMES[(math.abs(seed) % #NAMES) + 1]
	return self._champ_name
end

local function village_id_of(self)
	if self.vl_village then return self.vl_village end
	local pos = self.object and self.object:get_pos()
	if not pos then return end
	local _, vid = home.village_at(pos, 48)
	return vid
end

--------------------------------------------------------------------------------
-- What it says
--------------------------------------------------------------------------------

local GREETINGS = {
	"Hrm. You want something.",
	"You're not food. Good.",
	"Grr. Speak, little one.",
	"...What.",
}

local WHAT = {
	"Big. Strong. I guard these ones. That is all.",
	"I am the wall between the small ones and the dark. Nothing more.",
	"Champion. I hit what needs hitting. You do not.",
}

-- What has it seen? The village's live threat, or its own quiet.
function champion.report(self)
	local vid = village_id_of(self)
	local pos = self.object and self.object:get_pos()
	local threat = pos and threats.nearest(pos, 30)
	local alarm = vid and threats.alarm(vid)
	local name = (threat and threat.name) or (alarm and alarm.name)
	if name then
		local desc = threats.describe(name) or "something"
		return ("Aye. %s, close. I will break it. Stand behind me."):format(desc)
	end
	if alarm then
		return "Something was about. Quiet now. Stay near the houses."
	end
	return "Quiet. Nothing worth the swinging. Good."
end

--------------------------------------------------------------------------------
-- The window
--------------------------------------------------------------------------------

champion.talking = {}

local function form(self, line)
	local title = champ_name(self) .. ", champion"
	return table.concat({
		"size[8,4.6]",
		"label[0.3,0.2;", esc(title), "]",
		"textarea[0.4,0.7;7.4,2.4;;;", esc(line), "]",
		"button[0.4,3.1;3.6,0.8;what;What are you?]",
		"button[4.0,3.1;3.6,0.8;seen;Seen anything?]",
		"button_exit[0.4,3.95;7.2,0.6;bye;Leave it be]",
	})
end

function champion.open(self, player)
	if not player or not player.is_player or not player:is_player() then return end
	local pname = player:get_player_name()

	-- A champion of a village that has turned on you does not chat.
	if village_life.settings.reputation then
		local vid = village_id_of(self)
		if vid then
			local score = village_life.reputation.get(vid, pname)
			if village_life.reputation.flag(score, "hostile")
					or village_life.reputation.flag(score, "silent") then
				minetest.chat_send_player(pname, "[NPC] <" .. champ_name(self)
						.. "> ...Grrr.")
				return
			end
		end
	end

	champion.talking[pname] = self
	minetest.show_formspec(pname, "village_life:champion",
			form(self, GREETINGS[math.random(#GREETINGS)]))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "village_life:champion" then return end
	local pname = player:get_player_name()
	local self = champion.talking[pname]
	if not self or not self.object then
		champion.talking[pname] = nil
		return
	end

	if fields.bye or fields.quit then
		champion.talking[pname] = nil
		return
	end

	local line
	if fields.what then
		line = WHAT[math.random(#WHAT)]
	elseif fields.seen then
		line = champion.report(self)
	end
	if line then
		minetest.show_formspec(pname, "village_life:champion", form(self, line))
	end
end)

minetest.register_on_leaveplayer(function(player)
	champion.talking[player:get_player_name()] = nil
end)

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not village_life.settings.dialogue then return end
	local proto = minetest.registered_entities[BUFFPIG]
	if not proto then return end

	-- A buff pigman is now a recruitable wanderer (wanderer.SPECIES), so its
	-- right-click opens the full conversation -- name, job, and the settle/hire
	-- menus -- rather than the old blunt champion-only exchange. Its gruff voice
	-- survives as the champion race's greetings/introduce in wanderer.lua; the
	-- bespoke champion.open below stays available for any caller that wants it.
	if village_life.dialogue and village_life.wanderer
			and village_life.wanderer.SPECIES[BUFFPIG] then
		proto.on_rightclick = function(self, clicker)
			village_life.dialogue.open(self, clicker)
		end
	else
		proto.on_rightclick = function(self, clicker)
			champion.open(self, clicker)
		end
	end
	village_life.log("action", "champion dialogue attached to " .. BUFFPIG)
end)
