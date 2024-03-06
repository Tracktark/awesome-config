local darkmode = require "lib.darkmode"
local redshift = require "system.redshift"

local rs = darkmode {
   time = {
      dark = {hour = 20, min=0},
      light = {hour = 5, min=0},
   }
}

rs:connect_signal(function(active)
   redshift.active(active)
end)
