local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local theme = beautiful.dashboard.slider

local slider = {
   _callback = nil,
}

function slider:set_value(value)
   self.slider.value = value
end

function slider:get_value()
   return self.slider.value
end

function slider:set_image(img)
   self.image_widget:set_image(gears.color.recolor_image(img, theme.icon_color))
end

function slider:set_callback(callback)
   self._callback = callback
   self.slider:weak_connect_signal("property::value", callback)
end

function slider:set_from_updater(value)
   self.value = value
end

function slider:get_for_updater()
   return self.value
end

function slider.new(args)
   args = args or {}

   local slider_widget = wibox.widget {
      widget = wibox.widget.slider,
      max_value = 1,
      forced_height = theme.height,
      forced_width = 1,
      bar_shape = gears.shape.rounded_bar,
      bar_active_color = theme.foreground,
      bar_color = theme.background,
      handle_shape = gears.shape.circle,
      handle_width = theme.height,
      handle_color = theme.foreground,
   }

   local image_widget = wibox.widget {
      widget = wibox.widget.imagebox,
      resize = true,
      forced_width = theme.icon_size,
      forced_height = theme.icon_size,
   }

   local base = wibox.widget {
      layout = wibox.layout.stack,
      slider_widget,
      {
         widget = wibox.container.place,
         halign = "left",
         {
            widget = wibox.container.margin,
            left = (theme.height - theme.icon_size) / 2,
            image_widget,
         }
      }
   }

   local ret = wibox.widget.base.make_widget(base, nil, {
      class = slider,
      enable_properties = true,
   })
   ret.slider = slider_widget
   ret.image_widget = image_widget
   gears.table.crush(ret, args)
   return ret
end

return setmetatable(slider, {__call=function(_, ...) return slider.new(...) end, __index = require "lib.dashboard.widgets.base"})
