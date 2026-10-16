-- Colony Ship Down launcher main menu.
--
-- Replaces builtin/mainmenu/init.lua in the launcher package (see
-- launcher/package.sh). One screen: your name/password, the server (the
-- official one pre-filled), a list of Colony Ship Down servers from the
-- public server list, Play / Register, Settings and Quit. It reuses the
-- engine's own settings dialog, registration dialog and server list fetcher.

MAIN_TAB_W = 15.5
MAIN_TAB_H = 7.1
TABHEADER_H = 0.85
GAMEBAR_H = 1.25
GAMEBAR_OFFSET_DESKTOP = 0.375
GAMEBAR_OFFSET_TOUCH = 0.15

local menupath = core.get_mainmenu_path()
local basepath = core.get_builtin_path()
defaulttexturedir = core.get_texturepath_share() .. DIR_DELIM .. "base" ..
					DIR_DELIM .. "pack" .. DIR_DELIM

dofile(basepath .. "common" .. DIR_DELIM .. "menu.lua")
dofile(basepath .. "common" .. DIR_DELIM .. "filterlist.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "buttonbar.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "dialog.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "tabview.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "ui.lua")
dofile(menupath .. DIR_DELIM .. "async_event.lua")
dofile(menupath .. DIR_DELIM .. "common.lua")
dofile(menupath .. DIR_DELIM .. "serverlistmgr.lua")
dofile(menupath .. DIR_DELIM .. "game_theme.lua")
dofile(menupath .. DIR_DELIM .. "content" .. DIR_DELIM .. "init.lua")
dofile(basepath .. "common" .. DIR_DELIM .. "settings" .. DIR_DELIM .. "init.lua")
dofile(menupath .. DIR_DELIM .. "dlg_register.lua")
dofile(menupath .. DIR_DELIM .. "dlg_rebind_keys.lua")
dofile(menupath .. DIR_DELIM .. "dlg_version_info.lua")

local GAME_ID = "colony_ship_down"
local OFFICIAL = {
	name = "Colony Ship Down - Official",
	description = "The official CSV Meridian server.",
	address = core.settings:get("csd_official_address") or "45.143.196.182",
	port = tonumber(core.settings:get("csd_official_port")) or 30000,
	official = true,
}

local state = {address = nil, port = nil, selected = 1, lookup = {}}

local function esc(s) return core.formspec_escape(s or "") end

-- The official server first, then any other Colony Ship Down servers.
local function server_rows()
	local rows = {OFFICIAL}
	for _, s in ipairs(serverlistmgr.servers or {}) do
		if (s.gameid == GAME_ID or s.game_id == GAME_ID)
				and not (s.address == OFFICIAL.address and tonumber(s.port) == OFFICIAL.port) then
			rows[#rows + 1] = s
		elseif s.address == OFFICIAL.address and tonumber(s.port) == OFFICIAL.port then
			-- live data (players online) for the official server
			OFFICIAL.clients, OFFICIAL.clients_max, OFFICIAL.ping = s.clients, s.clients_max, s.ping
		end
	end
	return rows
end

local function get_formspec()
	local name = core.settings:get("name") or ""
	state.address = state.address or core.settings:get("address")
	if not state.address or state.address == "" then state.address = OFFICIAL.address end
	state.port = state.port or tonumber(core.settings:get("remote_port")) or OFFICIAL.port

	local rows = server_rows()
	state.lookup = rows
	local cells = {}
	for _, s in ipairs(rows) do
		local players = s.clients and ("%d/%d"):format(s.clients, s.clients_max or 0) or "-"
		cells[#cells + 1] = esc(s.official and "#9fe8ff" or "#ffffff")
		cells[#cells + 1] = esc(s.name or (s.address .. ":" .. s.port))
		cells[#cells + 1] = esc(players)
	end

	return table.concat({
		"formspec_version[6]size[16,10]",
		"bgcolor[#050810e0;true]",
		"style_type[label;font_size=*1.1]",
		"label[0.6,0.6;", esc(core.colorize("#9fe8ff", "COLONY SHIP DOWN")), "]",
		"label[0.6,1.1;", esc(core.colorize("#9aa7c0", "Join the crew of the CSV Meridian.")), "]",

		-- left: who and where
		"label[0.6,2.0;", esc(fgettext("Name")), "]",
		"field[0.6,2.3;6.2,0.8;te_name;;", esc(name), "]",
		"label[0.6,3.5;", esc(fgettext("Password")), "]",
		"pwdfield[0.6,3.8;6.2,0.8;te_pwd;]",
		"label[0.6,5.0;", esc(fgettext("Server")), "]",
		"field[0.6,5.3;4.6,0.8;te_address;;", esc(state.address), "]",
		"field[5.3,5.3;1.5,0.8;te_port;;", esc(tostring(state.port)), "]",
		"field_close_on_enter[te_name;false]field_close_on_enter[te_pwd;false]",
		"style[btn_play;bgcolor=#2a6a8a;font_size=*1.4]",
		"button[0.6,6.6;6.2,1.1;btn_play;", esc(fgettext("Play")), "]",
		"button[0.6,7.9;3,0.8;btn_register;", esc(fgettext("Register")), "]",
		"label[3.8,8.3;", esc(core.colorize("#9aa7c0", "New here? Register.")), "]",

		-- right: servers
		"label[7.6,2.0;", esc(fgettext("Colony Ship Down servers")), "]",
		"tablecolumns[color;text,width=18;text,align=right]",
		"table[7.6,2.3;7.8,5.6;servers;", table.concat(cells, ","), ";", state.selected, "]",
		"button[7.6,8.0;3.8,0.8;btn_refresh;", esc(fgettext("Refresh")), "]",

		-- bottom
		"button[0.6,9.0;3,0.7;btn_settings;", esc(fgettext("Settings")), "]",
		"button[12.4,9.0;3,0.7;btn_quit;", esc(fgettext("Quit")), "]",
	})
end

local function read_fields(fields)
	if fields.te_name then core.settings:set("name", fields.te_name) end
	if fields.te_address and fields.te_address ~= "" then state.address = fields.te_address:trim() end
	if fields.te_port and tonumber(fields.te_port) then state.port = tonumber(fields.te_port) end
end

local function connect(fields, this)
	read_fields(fields)
	local name = core.settings:get("name") or ""
	if name == "" then
		gamedata.errormessage = fgettext_ne("Missing name")
		return true
	end
	local server = state.lookup[state.selected]
	if server and server.address == state.address and tonumber(server.port) == state.port
			and server.proto_min and not is_server_protocol_compat_or_error(server.proto_min, server.proto_max) then
		return true
	end
	gamedata.playername = name
	gamedata.password = fields.te_pwd or ""
	gamedata.address = state.address
	gamedata.port = state.port
	gamedata.selected_world = 0
	gamedata.servername = server and server.name or ""
	gamedata.serverdescription = server and server.description or ""
	core.settings:set("address", state.address)
	core.settings:set("remote_port", tostring(state.port))
	serverlistmgr.add_favorite({address = state.address, port = state.port})
	core.start()
	return true
end

local function buttonhandler(this, fields)
	if fields.servers then
		local event = core.explode_table_event(fields.servers)
		local s = state.lookup[event.row]
		if s then
			state.selected = event.row
			state.address, state.port = s.address, tonumber(s.port)
			if event.type == "DCL" then return connect(fields, this) end
		end
		read_fields({te_name = fields.te_name})
		return true
	end
	if fields.btn_play or fields.key_enter then
		return connect(fields, this)
	end
	if fields.btn_register then
		read_fields(fields)
		local dlg = create_register_dialog(state.address, state.port, state.lookup[state.selected])
		dlg:set_parent(this)
		this:hide()
		dlg:show()
		return true
	end
	if fields.btn_refresh then
		read_fields(fields)
		serverlistmgr.sync()
		return true
	end
	if fields.btn_settings then
		read_fields(fields)
		local dlg = create_settings_dlg()
		dlg:set_parent(this)
		this:hide()
		dlg:show()
		return true
	end
	if fields.btn_quit then
		core.close()
		return true
	end
	read_fields(fields)
	return false
end

local function eventhandler(event)
	if event == "MenuQuit" then
		core.close()
		return true
	end
	if event == "Refresh" then
		ui.update()
		return true
	end
	return false
end

local function init()
	gamedata.worldindex = 0
	menudata.worldlist = filterlist.create(core.get_worlds, compare_worlds,
		function(element, uid) return element.name == uid end,
		function(element, gameid) return element.gameid == gameid end)

	mm_game_theme.init()
	mm_game_theme.set_engine()
	core.set_clouds(false)
	local bg = menupath .. DIR_DELIM .. "csd_menu_bg.png"
	core.set_background("background", bg, false)
	core.set_background("header", menupath .. DIR_DELIM .. "csd_header.png")
	core.set_topleft_text("Colony Ship Down")

	local dlg = dialog_create("csd_launcher", get_formspec, buttonhandler, eventhandler)
	ui.set_default("csd_launcher")
	dlg:show()
	serverlistmgr.sync()
	ui.update()
end

assert(os.execute == nil)
init()
