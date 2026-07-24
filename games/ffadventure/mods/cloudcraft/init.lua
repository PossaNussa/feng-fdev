-- --------- --
--  GLOBALS  --
-- --------- --

cloudcraft = {
  modpath = core.get_modpath("cloudcraft"),
  storage = core.get_mod_storage(),
  settings = {
    clouds = {
      y_min = tonumber(core.settings:get("cloudcraft.clouds.y_min",100) or 100),
      y_max = tonumber(core.settings:get("cloudcraft.clouds.y_max",2000) or 2000),
    },
  },
  dependencies = (function()
    local deps = {}
    for _,mod in ipairs({
      "default",
      "abdecor",
      "climate_api",
    }) do
      deps[mod] = core.get_modpath(mod)
    end
    return deps
  end)(),
}

-- ------- --
--  FILES  --
-- ------- --

local mpath = cloudcraft.modpath
for _,file in ipairs({
  "nodes",
  "mapgen",
}) do
  dofile(mpath .. "/src/" .. file .. ".lua")
end

-- Disable engine-rendered graphical clouds for all players
core.register_on_joinplayer(function(player)
  player:set_clouds({density = 0})
end)
