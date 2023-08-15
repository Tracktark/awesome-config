local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

screen.connect_signal("request::wallpaper", function(s)
   local image_path = gears.filesystem.get_configuration_dir() .. "assets/wallpaper/"
   awful.wallpaper {
      screen = s,
      widget = {
         layout = wibox.layout.manual,
         {
            widget = wibox.widget.imagebox,
            upscale = true,
            downscale = true,
            image = image_path .. "bg.png",
         },
         {
            {
               widget = wibox.widget.textbox,
               format = "%H:%M",
               font = "Roboto Bold 130",
               halign = "center",
               text = os.date("%H:%M"),
            },
            fg = beautiful.colors.surface1,
            widget = wibox.container.background,
            point = function(geo, args)
               return {
                  x = (args.parent.width - geo.width) / 2,
                  y = 210,
               }
            end
         },
         {
            widget = wibox.widget.imagebox,
            upscale = true,
            downscale = true,
            image = image_path .. "bg2.png"
         }
      },
   }
end)

awesome.connect_signal("clock::change", function()
   for s in screen do
      s:emit_signal("request::wallpaper")
   end
end)
