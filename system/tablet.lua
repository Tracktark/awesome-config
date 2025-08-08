local reactive = require "lib.reactive"

local tablet = {
   tablet = reactive {
      value = false, -- TODO: Probably change this
      setter = false,
   }
}

awesome.connect_signal("script::tablet_mode", function(mode)
   tablet.tablet:set_internal(mode == "tablet")
end)

return tablet
