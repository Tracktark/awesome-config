local awful = require "awful"
local gears = require "gears"

local redshift = {
   _active = false,
   _temp = 4500,
}

function redshift:update()
   local cmd = "redshift -x"
   if self._active then
      cmd = cmd .. " && redshift -O " .. tostring(self._temp)
   end
   awful.spawn.with_shell(cmd)
end

function redshift:set_active(active)
   self._active = active
   self:update()
   self:emit_signal("property::active", active)
end
function redshift:get_active()
   return self._active
end

function redshift:set_temp(temp)
   self._temp = temp
   self:update()
   self:emit_signal("property::temp", temp)
end
function redshift:get_temp()
   return self._temp
end

return gears.object {
   class = redshift,
   enable_properties = true,
}
