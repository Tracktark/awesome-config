local base = require "wibox.widget.base"
local gtable = require "gears.table"
local color = require "gears.color"

local empty = {}

function empty:fit(_, width, height)
   return width, height
end

function empty:draw(_, cr, _, _)
   if self._private.bg then
      cr:set_source(self._private.bg)
      cr:paint()
   end
end

function empty:set_bg(bg)
   if bg then
      self._private.bg = color(bg)
   else
      self._private.bg = nil
   end
   self:emit_signal "widget::redraw_needed"
end

function empty:get_bg()
   return self._private.bg
end

function empty.new(bg)
   local ret = base.make_widget(nil, nil, {
      enable_properties = true,
   })
   gtable.crush(ret, empty, true)

   ret:set_bg(bg)

   return ret
end

return setmetatable(empty, {__call = function(_, ...) return empty.new(...) end})
