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
      bg = beautiful.dashboard.background,
      visible = false,
      opacity = 0,
      ontop = true,
      shape = function(c, w, h) gears.shape.rounded_rect(c, w, h, 20) end,
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

function dashboard.add_widget_at(...)
   dashboard._widget:add_widget_at(...)
end

function dashboard.add_widget(widget)
   local row, col = dashboard._widget:get_next_empty()
   dashboard._widget:add_widget_at(widget, row, col)
end

function dashboard.add_button(args)
   local row, col = dashboard._widget:get_next_empty()
   dashboard._widget:add_widget_at(dashboard.widget.button(args), row, col)
end
function dashboard.add_slider(args)
   dashboard._widget:add_widget_at(dashboard.widget.slider(args), args.row, args.col or 1, 1, args.colspan or 4)
end

dashboard.widget = {
   button = require("lib.dashboard.widgets.button"),
   slider = require("lib.dashboard.widgets.slider"),
}

return setmetatable(dashboard, {__call = function(_, ...) return dashboard.new(...) end})
