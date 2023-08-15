local awful = require "awful"
local gears = require "gears"
local event_process = require "lib.event_process"

local BLUETOOTH_IDS = {"3", "1"}
local WIFI_IDS = {"0", "2"}

local function set(ids, value)
   local verb = value and "unblock" or "block"
   awful.spawn("rfkill " .. verb .. " " .. table.concat(ids, " "))
end

local airplane = {
   _bluetooth = false,
   _wifi = false,
   _last_airplane = nil,
}

function airplane:get_bluetooth()
   return self._bluetooth
end

function airplane:set_bluetooth(value)
   set(BLUETOOTH_IDS, value)
end

function airplane:set_wifi(value)
   set(WIFI_IDS, value)
end

function airplane:get_wifi()
   return self._wifi
end

function airplane:set_airplane(value)
   self.wifi = not value
   self.bluetooth = not value
end

function airplane:get_airplane()
   return self._wifi == false and self._bluetooth == false
end

local o = gears.object {
   class = airplane,
   enable_properties = true,
}

local function update_airplane()
   local new = o.airplane
   if new ~= o._last_airplane then
      o._last_airplane = new
      o:emit_signal("property::airplane", new)
   end
end
o:connect_signal("property::bluetooth", update_airplane)
o:connect_signal("property::wifi", update_airplane)

event_process {
   command = "rfkill event",
   stdout = function(line)
      local id, value = string.match(line, "idx (%d+) type %d+ op %d+ soft (%d)")
      if id == nil then return end
      value = value == "0"
      if BLUETOOTH_IDS[1] == id then
         o._bluetooth = value
         o:emit_signal("property::bluetooth", value)
      end
      if WIFI_IDS[1] == id then
         o._wifi = value
         o:emit_signal("property::wifi", value)
      end
   end
}

return o
