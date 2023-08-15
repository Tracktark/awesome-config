local awful = require "awful"
local gears = require "gears"
local popup = require "lib.popup"
local volume = require "system.volume"

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

local light_popup = popup {
  image = icon_path .. "brightness.svg",
  max_value = 100,
}

awful.screen.connect_for_each_screen(function(s)
   s.backlight:connect_signal("property::brightness", function(_, value)
      light_popup.screen = s
      light_popup.value = value
      light_popup:show()
   end)
end)

local volume_popup = popup {
  image = function()
    if volume.muted then return icon_path .. "volume_mute.svg" end

    if volume.volume < 33 then return icon_path .. "volume_min.svg" end
    if volume.volume < 66 then return icon_path .. "volume_mid.svg" end
    return icon_path .. "volume_max.svg"
  end,
  value = function() return volume.volume end,
  max_value = 100,
}

volume:connect_signal("change", function()
   volume_popup:show()
end)
