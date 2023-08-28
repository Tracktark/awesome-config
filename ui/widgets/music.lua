local wibox = require "wibox"
local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local spotify = require "system.spotify"

local ICON_SIZE = 30

local cover_image = wibox.widget {
   widget = wibox.widget.imagebox,
   image = spotify.image,
   forced_width = 80,
   forced_height = 80,
   clip_shape = function(c, w, h) gears.shape.rounded_rect(c, w, h, 10) end
}

local title = wibox.widget {
   widget = wibox.widget.textbox,
   font = "Roboto Bold 12",
}
local artist = wibox.widget {
   widget = wibox.widget.textbox,
   font = "Roboto 10",
}

local icon_path = gears.filesystem.get_configuration_dir() .. "assets/icons/"

local prev_button = wibox.widget {
   widget = wibox.widget.imagebox,
   image = gears.color.recolor_image(icon_path .. "play_prev.svg", beautiful.colors.text),
   forced_width = ICON_SIZE,
   forced_height = ICON_SIZE,
   buttons = {
      awful.button({}, awful.button.names.LEFT, spotify.previous)
   }
}

local play_image = gears.color.recolor_image(icon_path .. "play.svg", beautiful.colors.text)
local pause_image = gears.color.recolor_image(icon_path .. "pause.svg", beautiful.colors.text)

local play_pause_button = wibox.widget {
   widget = wibox.widget.imagebox,
   forced_width = ICON_SIZE,
   forced_height = ICON_SIZE,
   buttons = {
      awful.button({}, awful.button.names.LEFT, spotify.play_pause)
   }
}

local next_button = wibox.widget {
   widget = wibox.widget.imagebox,
   image = gears.color.recolor_image(icon_path .. "play_next.svg", beautiful.colors.text),
   forced_width = ICON_SIZE,
   forced_height = ICON_SIZE,
   buttons = {
      awful.button({}, awful.button.names.LEFT, spotify.next)
   }
}


local widget = wibox.widget {
   widget = wibox.container.background,
   bg = beautiful.colors.base,
   shape = function(c, w, h) gears.shape.rounded_rect(c, w, h, 10) end,
   {
      widget = wibox.container.margin,
      margins = 10,
      {
         layout = wibox.layout.fixed.vertical,
         {
            layout = wibox.layout.fixed.horizontal,
            spacing = 20,
            cover_image,
            {
               widget = wibox.container.place,
               halign = "left",
               {
                  layout = wibox.layout.fixed.vertical,
                  spacing = 2,
                  {
                     widget = wibox.container.scroll.horizontal,
                     step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                     max_size = 180,
                     speed = 80,
                     fps = 60,
                     title,
                  },
                  artist,
               }
            }
         },
         {
            widget = wibox.container.place,
            {
               widget = wibox.container.margin,
               top = 15,
               bottom = 5,
               {
                  layout = wibox.layout.fixed.horizontal,
                  spacing = 25,
                  prev_button,
                  play_pause_button,
                  next_button,
               }
            }
         }
      }
   }
}

local function update()
   print("updating widget")
   if not spotify.available then
      print("not available")
      widget.visible = false
      return
   end
   widget.visible = true
   cover_image:set_image(spotify.image)
   title:set_text(spotify.title)
   artist:set_text(spotify.artist)
   if spotify.playing() then
      play_pause_button:set_image(pause_image)
   else
      play_pause_button:set_image(play_image)
   end
end
update()

spotify.playing:subscribe(update)

return widget
