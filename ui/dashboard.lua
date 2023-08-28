local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local dashboard = require "lib.dashboard"
local audio = require "system.audio"
local airplane = require "system.airplane"
local dm = require "ui.darkmode"

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

local buttons = wibox.widget {
   widget = wibox.layout.grid,
   spacing = beautiful.dashboard.spacing,
   forced_num_cols = beautiful.dashboard.button.columns,
}
dashboard.add(buttons)

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "wifi.svg",
   image_inactive = icon_path .. "wifi_off.svg",
   property = airplane.wifi,
})

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "bluetooth.svg",
   image_inactive = icon_path .. "bluetooth_off.svg",
   property = airplane.bluetooth,
})

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "battery_conservation.svg",
   image_inactive = icon_path .. "battery_conservation_off.svg",
   property = require("system.battery").conservation,
})

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "volume_mute.svg",
   image_inactive = icon_path .. "volume_mute_off.svg",
   property = audio.muted,
})

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "airplane.svg",
   image_inactive = icon_path .. "airplane_off.svg",
   property = airplane.airplane,
})

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
buttons:add(darkmode_button)

buttons:add(dashboard.widget.button {
   image_active = icon_path .. "redshift.svg",
   image_inactive = icon_path .. "redshift_off.svg",
   property = require("system.redshift").active,
})


dashboard.add(dashboard.widget.slider {
   image = icon_path .. "brightness.svg",
   property = screen.primary.backlight.brightness,
})

dashboard.add(dashboard.widget.slider {
   image = icon_path .. "volume_max.svg",
   property = audio.volume,
})

dashboard.add(require("ui.widgets.music"))

awful.screen.connect_for_each_screen(function(s)
   s.dashboard = dashboard {
      screen = s
   }
end)
