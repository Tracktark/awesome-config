local awful = require "awful"
local reactive = require "lib.reactive"

local redshift = {
   active = reactive(false),
   temp = reactive(4500),
}

function redshift.update()
   local cmd
   if redshift.active() then
      cmd = "redshift -P -O " .. tostring(redshift.temp())
   else
      cmd = "redshift -x"
   end
   awful.spawn.with_shell(cmd)
end

redshift.active:subscribe(redshift.update)
redshift.temp:subscribe(redshift.update)

return redshift
