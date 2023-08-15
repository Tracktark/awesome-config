local gears = require "gears"

local function rounded_corners(c)
   if c.fullscreen or c.maximized then
      c.shape = gears.shape.rectangle
   else
      c.shape = function (cr,w,h) return gears.shape.rounded_rect(cr,w,h,10) end
   end
end

client.connect_signal("property::fullscreen", rounded_corners)
client.connect_signal("property::maximized", rounded_corners)
client.connect_signal("manage", rounded_corners)
