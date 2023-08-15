local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

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
   self.image_widget:set_image(gears.color.recolor_image(img, beautiful.dashboard.slider.icon))
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
      value = 0.5,
      forced_height = 1,
      forced_width = 1,
      bar_shape = gears.shape.rounded_bar,
      bar_active_color = beautiful.dashboard.slider.foreground,
      bar_color = beautiful.dashboard.slider.background,
      handle_shape = gears.shape.circle,
      handle_width = 46,
      handle_color = beautiful.dashboard.slider.foreground,
   }

   local image_widget = wibox.widget.imagebox()

   local base = wibox.widget {
      widget = wibox.container.margin,
      top = 7,
      bottom = 7,
      {
         layout = wibox.layout.stack,
         slider_widget,
         {
            widget = wibox.container.constraint,
            height = 1,
            {
               widget = wibox.container.margin,
               margins = 10,
               image_widget,
            }
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
