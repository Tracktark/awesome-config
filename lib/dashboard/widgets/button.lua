local wibox = require "wibox"
local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"
local theme = beautiful.dashboard.button

local button = {
   _active = false,
   _image_active = nil,
   _image_inactive = nil,
}
button.__index = button

function button:_reset_image()
   if self._active then
      self.imagebox:set_image(self._image_active)
   else
      self.imagebox:set_image(self._image_inactive)
   end
end

function button:set_image_active(img)
   self._image_active = gears.color.recolor_image(img, theme.active.foreground)
   self:_reset_image()
end

function button:set_image_inactive(img)
   self._image_inactive = gears.color.recolor_image(img, theme.inactive.foreground)
   self:_reset_image()
end

function button:set_callback(callback)
   self:buttons {
      awful.button({}, awful.button.names.LEFT, callback)
   }
end

function button:set_from_updater(value)
   self.active = value
end

function button:get_for_updater()
   return not self.active
end

function button:set_active(active)
   self._active = active
   self:_reset_image()
   self.base.bg = theme[active and "active" or "inactive"].background
end

function button:get_active()
   return self._active
end

function button.new(args)
   args = args or {}

   local imagebox = wibox.widget {
      widget = wibox.widget.imagebox,
      forced_height = theme.icon_size,
      forced_width = theme.icon_size,
   }

   local base = wibox.widget {
      widget = wibox.container.background,
      shape = gears.shape.circle,
      forced_height = theme.size,
      forced_width = theme.size,
      {
         widget = wibox.container.place,
         imagebox
      }
   }

   local ret = wibox.widget.base.make_widget(base, nil, {
      class = button,
      enable_properties = true,
   })
   ret.imagebox = imagebox
   ret.base = base
   gears.table.crush(ret, args)
   return ret
end

return setmetatable(button, {__call = function(_, ...) return button.new(...) end, __index = require "lib.dashboard.widgets.base"})
