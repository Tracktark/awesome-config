local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local rubato = require "lib.rubato"

local dashboard = {
   visible = false,
}
dashboard.__index = dashboard

dashboard._widget = wibox.widget {
   layout = wibox.layout.fixed.vertical,
   spacing = beautiful.dashboard.spacing,
}

function dashboard.new(o)
   local self = setmetatable(o, dashboard)

   self._popup = awful.popup {
      screen = self.screen,
      bg = beautiful.dashboard.background,
      visible = false,
      opacity = 0,
      ontop = true,
      shape = function(c, w, h) gears.shape.rounded_rect(c, w, h, 20) end,
      widget = wibox.widget {
         widget = wibox.container.margin,
         margins = beautiful.dashboard.spacing,
         self._widget,
      }
   }

   self._rubato = rubato.timed {
      duration = 0.25,
      rate = 60,
      subscribed = function(val)
         local s = self.screen.geometry
         local p = self._popup
         p.y = s.y + self.screen.wibar.height + beautiful.useless_gap * 2
         p.x = s.x + s.width - (self._popup.width + beautiful.useless_gap * 2) * val
         p.visible = val > 0.1
         p.opacity = val
      end,
   }

   self._outside_click_callback = function()
      self:hide()
   end
   self._outside_click_button = awful.button({}, 1, self._outside_click_callback)
   return self
end

function dashboard:show()
   client.connect_signal("button::press", self._outside_click_callback)
   awful.mouse.append_global_mousebinding(self._outside_click_button)

   self._rubato.target = 1
   self.visible = true
end

function dashboard:hide()
   awful.mouse.remove_global_mousebinding(self._outside_click_button)
   client.disconnect_signal("button::press", self._outside_click_callback)

   self._rubato.target = 0
   self.visible = false
end

function dashboard:toggle()
   if self.visible then
      self:hide()
   else
      self:show()
   end
end

function dashboard.add(widget)
   dashboard._widget:add(widget)
end

dashboard.widget = {
   button = require("lib.dashboard.widgets.button"),
   slider = require("lib.dashboard.widgets.slider"),
}

return setmetatable(dashboard, {__call = function(_, ...) return dashboard.new(...) end})
