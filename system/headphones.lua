local reactive = require "lib.reactive"
local dbus_proxy = require "lib.dbus_proxy"

local proxy

local headphones = {
   connected = reactive {
      setter = function(_,value)
         if value then
            proxy:ConnectAsync()
         else
            proxy:DisconnectAsync()
         end
      end
   }
}

function headphones.update()
   headphones.connected:set_internal(proxy.is_connected and proxy.Connected)
end

local opts = {
   bus = dbus_proxy.Bus.SYSTEM,
   name = "org.bluez",
   interface = "org.bluez.Device1",
   path = "/org/bluez/hci0/dev_2C_BE_EB_02_A7_62"
}
proxy = dbus_proxy.monitored.new(opts, function(p, appeared)
   if appeared then
      p:on_properties_changed(headphones.update)
   end
   headphones.update()
end)

return headphones
