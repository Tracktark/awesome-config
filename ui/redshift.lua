local darkmode = require "lib.darkmode"
local redshift = require "system.redshift"

local rs = darkmode {
   location = {
      lat = 49.1521,
      long = 18.749,
   }
}

rs:connect_signal(function(active)
   redshift.active(active)
end)
