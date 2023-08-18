local awful = require "awful"
local reactive = require "lib.reactive"

local redshift = {
   active = reactive(false),
   temp = reactive(4500),
}

function redshift.update()
   local cmd = "redshift -x"
   if redshift.active() then
      cmd = cmd .. " && redshift -O " .. tostring(redshift.temp())
   end
   awful.spawn.with_shell(cmd)
end

redshift.active:subscribe(redshift.update)
redshift.temp:subscribe(redshift.update)

return redshift
