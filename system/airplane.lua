local awful = require "awful"
local event_process = require "lib.event_process"
local reactive = require "lib.reactive"

local BLUETOOTH_IDS = {"3", "1"}
local WIFI_IDS = {"0", "2"}

local function set(ids, value)
   local verb = value and "unblock" or "block"
   awful.spawn("rfkill " .. verb .. " " .. table.concat(ids, " "))
end

local airplane = {
   bluetooth = reactive {
      value = false,
      setter = function(_, value)
         set(BLUETOOTH_IDS, value)
      end
   },
   wifi = reactive {
      value = false,
      setter = function(_, value)
         set(WIFI_IDS, value)
      end
   },
}

airplane.airplane = reactive.computed {
   dependencies = {airplane.wifi, airplane.bluetooth},
   value = function() return airplane.wifi() == false and airplane.bluetooth() == false end,
   setter = function(_, value)
      airplane.wifi( not value )
      airplane.bluetooth( not value )
   end,
}

event_process {
   command = "rfkill event",
   stdout = function(line)
      local id, value = string.match(line, "idx (%d+) type %d+ op %d+ soft (%d)")
      if id == nil then return end
      value = value == "0"
      if BLUETOOTH_IDS[1] == id then
         airplane.bluetooth:set_internal(value)
      end
      if WIFI_IDS[1] == id then
         airplane.wifi:set_internal(value)
      end
   end
}

return airplane
