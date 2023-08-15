local gears = require "gears"
local awful = require "awful"

local battery = {
   ---@type boolean
   conservation = nil,
   ---@type integer
   level = nil,
   ---@type boolean
   charging = nil,
}

function battery:update()
   local new_level, new_charging, new_conservation

   local file = io.open("/sys/class/power_supply/BAT1/capacity")
   if file ~= nil then
      new_level = file:read("n")
      file:close()
   end

   file = io.open("/sys/class/power_supply/ACAD/online")
   if file ~= nil then
      new_charging = file:read("n") == 1
      file:close()
   end

   file = io.open("/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode")
   if file ~= nil then
      new_conservation = file:read("n") == 1
      file:close()
   end

   if self.charging ~= new_charging or
      self.level ~= new_level or
      self.conservation ~= new_conservation then

      self.charging = new_charging
      self.level = new_level
      self.conservation = new_conservation

      self:emit_signal "change"
   end
end

function battery:toggle_conservation()
   awful.spawn("bcon t")
end

local o = gears.object {
   class = battery,
   enable_properties = true,
   enable_auto_signals = true,
}

gears.timer {
   timeout = 60,
   autostart = true,
   call_now = true,
   callback = function() o:update() end,
}

return o
