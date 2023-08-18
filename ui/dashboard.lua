local awful = require "awful"
local gears = require "gears"
local dashboard = require "lib.dashboard"
local audio = require "system.audio"
local airplane = require "system.airplane"
local dm = require "ui.darkmode"

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

dashboard.add_button {
   image_active = icon_path .. "wifi.svg",
   image_inactive = icon_path .. "wifi_off.svg",
   updater = {
      object = airplane,
      property = "wifi"
   }
}

dashboard.add_button {
   image_active = icon_path .. "bluetooth.svg",
   image_inactive = icon_path .. "bluetooth_off.svg",
   updater = {
      object = airplane,
      property = "bluetooth"
   }
}

dashboard.add_button {
   image_active = icon_path .. "battery_conservation.svg",
   image_inactive = icon_path .. "battery_conservation_off.svg",
   updater = {
      object = require "system.battery",
      property = "conservation"
   }
}

dashboard.add_button {
   image_active = icon_path .. "volume_mute.svg",
   image_inactive = icon_path .. "volume_mute_off.svg",
   property = audio.muted,
}

dashboard.add_button {
   image_active = icon_path .. "airplane.svg",
   image_inactive = icon_path .. "airplane_off.svg",
   updater = {
      object = airplane,
      property = "airplane",
   }
}

local darkmode_button = dashboard.widget.button {
   image_active = icon_path .. "darkmode.svg",
   image_inactive = icon_path .. "darkmode_off.svg",
   active = dm.active,
   callback = function()
      dm:toggle()
   end
}
dm:connect_signal(function(dark)
   darkmode_button.active = dark
end)
dashboard.add_widget(darkmode_button)

dashboard.add_button {
   image_active = icon_path .. "redshift.svg",
   image_inactive = icon_path .. "redshift_off.svg",
   updater = {
      object = require "system.redshift",
      property = "active",
   }
}

dashboard.add_slider {
   row = 3,
   image = icon_path .. "brightness.svg",
   updater = {
      object = screen.primary.backlight,
      property = "brightness"
   },
}

dashboard.add_slider {
   row = 4,
   image = icon_path .. "volume_max.svg",
   property = audio.volume,
}

awful.screen.connect_for_each_screen(function(s)
   s.dashboard = dashboard {
      screen = s
   }
end)
