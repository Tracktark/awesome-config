local gears = require "gears"

local timer = gears.timer {
   timeout = 60 - (os.time() % 60),
   single_shot = true,
   autostart = true,
}

timer:connect_signal("timeout", function()
   timer.timeout = 60 - (os.time() % 60)
   timer:again()
   awesome.emit_signal("clock::change")
end)
