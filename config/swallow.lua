local awful = require("awful")

client.connect_signal("request::manage", function(client)
   local last = awful.client.focus.history.get(client.screen, 1)

   if last == nil then return end
   if last.class ~= "Alacritty" then return end
   if last.pid == nil or client.pid == nil then return end

   local is_child = os.execute("pstree -p "
      .. tostring(last.pid)
      .. " | grep "
      .. tostring(client.pid)
      .. " >/dev/null 2>&1")
   if not is_child then return end

   last.minimized = true
   client:connect_signal("request::unmanage", function()
      last.minimized = false
   end)
end)
