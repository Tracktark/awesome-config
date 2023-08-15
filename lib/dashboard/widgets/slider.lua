local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

local slider = {
   _value = 0
}

function slider:set_value(value)
   rawset(self, "_value", value)
   self.base.value = value
end

function slider:get_value()
   return self._value
end

function slider.new(args)
   args = args or {}
   local base = wibox.widget {
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

   local ret = wibox.widget.base.make_widget(base, nil, {
      class = slider,
      enable_properties = true,
   })
   ret.base = base
   gears.table.crush(ret, args)
   return ret
end

return setmetatable(slider, {__call=function(_, ...) return slider.new(...) end})
