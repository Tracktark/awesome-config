local awful = require "awful"
local gears = require "gears"
local dashboard = require "lib.dashboard"
local battery = require "system.battery"

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

local conservation_button = dashboard.widget.button {
   image = icon_path .. "battery_conservation.svg",
   active = battery.conservation,
   callback = function()
      battery:toggle_conservation()
   end
}

battery:connect_signal("property::conservation", function()
   conservation_button.active = battery.conservation
end)

dashboard.add_widget_at(conservation_button, 1, 1)

local brightness_slider = dashboard.widget.slider {
   
}
dashboard.add_widget_at(brightness_slider, 2, 1, 1, 4)

awful.screen.connect_for_each_screen(function(s)
   s.dashboard = dashboard {
      screen = s
   }
end)
