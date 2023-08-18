local gears = require "gears"
local awful = require "awful"
local reactive = require "lib.reactive"

local battery = {
   conservation = reactive {
      setter = function(_, value)
         local arg = value and "1" or "0"
         awful.spawn("bcon " .. arg)
      end
   },

   level = reactive {
      setter = false
   },
   charging = reactive {
      setter = false
   },
}

function battery.update()
   local file = io.open("/sys/class/power_supply/BAT1/capacity")
   if file ~= nil then
      battery.level:set_internal(file:read("n"))
      file:close()
   end

   file = io.open("/sys/class/power_supply/ACAD/online")
   if file ~= nil then
      battery.charging:set_internal(file:read("n") == 1)
      file:close()
   end

   file = io.open("/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode")
   if file ~= nil then
      battery.conservation:set_internal(file:read("n") == 1)
      file:close()
   end
end

function battery.toggle_conservation()
   awful.spawn("bcon t")
end

gears.timer {
   timeout = 60,
   autostart = true,
   call_now = true,
   callback = battery.update,
}

return battery
