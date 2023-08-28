local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local awful = require "awful"
local battery = require "system.battery"

local battery_widget = {}
battery_widget.__index = battery_widget

function battery_widget:fit(_, _, height)
   return height * 2, height
end

function battery_widget:draw(_, cr, width, height)
   local line_width = 1.5
   local radius = 4
   local fill_offset = line_width * 1.5
   local knob_height = 0.4 * height
   local knob_width = knob_height / 2
   local critical_battery_level = 10
   local inner_width = width - knob_width - 2 * fill_offset

   -- Draw outside
   gears.shape.rounded_rect(cr, width - knob_width, height, radius)
   if battery.conservation() then
      cr:set_source(gears.color(beautiful.battery_conservation))
   else
      cr:set_source(gears.color(beautiful.battery_outline))
   end
   cr:set_line_width(1.5)
   cr:stroke()

   gears.shape.transform(gears.shape.rounded_rect) : translate(width - knob_width, (height - knob_height) / 2) (cr, knob_width, knob_height, 3)
   cr:fill()

   -- Set color
   if battery.charging() then
      cr:set_source(gears.color(beautiful.battery_charging))
   else
      if battery.level() < critical_battery_level then
         cr:set_source(gears.color(beautiful.battery_critical))
      else
         cr:set_source(gears.color(beautiful.battery_discharging))
      end
   end
   -- Draw inside
   gears.shape.transform(gears.shape.rounded_rect):translate(fill_offset, fill_offset)(
      cr,
      inner_width * battery.level() / 100,
      height - 2 * fill_offset,
      radius - line_width
   )

   cr:fill()
end


function battery_widget.new()
   local base = wibox.widget.base.make_widget()
   local self = setmetatable(base, battery_widget)

   self._tooltip = awful.tooltip { objects = {self}, delay_show = 1, text = tostring(battery.level()) .. "%" }
   return self
end

function battery_widget:update()
   self:emit_signal("widget::redraw_needed")
   self._tooltip:set_text(tostring(battery.level()) .. "%")
end

return battery_widget
