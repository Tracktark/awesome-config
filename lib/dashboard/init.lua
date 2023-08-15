local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local rubato = require "lib.rubato"

local dashboard = {
   visible = false,
   spacing = 20,
}
dashboard.__index = dashboard
dashboard._widget = wibox.widget {
   layout = wibox.layout.grid,
   forced_num_cols = 4,
   forced_width = 20 * 3 + 60 * 4,
   spacing = dashboard.spacing,
}

function dashboard.new(o)
   local self = setmetatable(o, dashboard)

   self._popup = awful.popup {
      screen = self.screen,
      bg = beautiful.colors.base,
      visible = false,
      opacity = 0,
      ontop = true,
      shape = gears.shape.rounded_rect,
      widget = wibox.widget {
         widget = wibox.container.margin,
         margins = self.spacing,
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
   return self
end

function dashboard:show()
   self._rubato.target = 1
   self.visible = true
end

function dashboard:hide()
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

function dashboard.add_widget_at(...)
   dashboard._widget:add_widget_at(...)
end

dashboard.widget = {
   button = require("lib.dashboard.widgets.button"),
   slider = require("lib.dashboard.widgets.slider"),
}

return setmetatable(dashboard, {__call = function(_, ...) return dashboard.new(...) end})
