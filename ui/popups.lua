local awful = require "awful"
local gears = require "gears"
local popup = require "lib.popup"
local audio = require "system.audio"

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

local light_popup = popup {
  image = icon_path .. "brightness.svg",
  max_value = 100,
}

awful.screen.connect_for_each_screen(function(s)
   s.backlight.brightness:subscribe(function(value)
      light_popup.screen = s
      light_popup.value = value
      light_popup:show()
   end)
end)

local audio_popup = popup {
   image = function()
      if audio.muted() then return icon_path .. "volume_mute.svg" end
      if audio.volume() < 33 then return icon_path .. "volume_min.svg" end
      if audio.volume() < 66 then return icon_path .. "volume_mid.svg" end
      return icon_path .. "volume_max.svg"
   end,
   max_value = 100,
}

audio.volume:subscribe(function(volume)
   audio_popup.value = volume
   audio_popup:show()
end)

audio.muted:subscribe(function()
   audio_popup:show()
end)
