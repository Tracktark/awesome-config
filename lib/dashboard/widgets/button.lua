local wibox = require "wibox"
local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"

local button = {
   _active = false,
   _image_active = nil,
   _image_inactive = nil
}
button.__index = button

function button:set_image(img)
   rawset(self, "_image_active", gears.color.recolor_image(img, beautiful.colors.surface0))
   rawset(self, "_image_inactive", gears.color.recolor_image(img, beautiful.colors.text))

   if self._active then
      self.imagebox:set_image(self._image_active)
   else
      self.imagebox:set_image(self._image_inactive)
   end
end

function button:set_callback(callback)
   self:buttons {
      awful.button({}, awful.button.names.LEFT, callback)
   }
end

function button:set_active(active)
   rawset(self, "_active", active)
   if active then
      self.imagebox:set_image(self._image_active)
      self.base.bg = beautiful.colors.text
   else
      self.imagebox:set_image(self._image_inactive)
      self.base.bg = beautiful.colors.surface0
   end
end

function button:get_active()
   return self._active
end

function button.new(args)
   args = args or {}

   local imagebox = wibox.widget {
      widget = wibox.widget.imagebox,
      forced_height = 40,
      forced_width = 40,
   }

   local base = wibox.widget {
      widget = wibox.container.background,
      shape = gears.shape.circle,
      bg = beautiful.colors.surface0,
      {
         widget = wibox.container.margin,
         margins = 10,
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

return setmetatable(button, {__call = function(_, ...) return button.new(...) end})
