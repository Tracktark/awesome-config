-- local lgi = require "lgi"
-- local Gio = lgi.Gio
-- local GLib = lgi.GLib
local gears = require "gears"

awesome.emit_signal "clock::change"
gears.timer.start_new(60 - (os.time() % 60), function()
   gears.timer {
      timeout = 60,
      autostart = true,
      call_now = true,
      callback = function() awesome.emit_signal "clock::change" end
   }
   return false
end)

-- Run signal on resume from suspend
local function onLoginManagerSignal(_, arg)
   if arg == false then -- Arg is false after resume
      awesome.restart()
   end
end

-- NOTE: AwesomeWM's dbus module is deprecated,
-- but listening to signals on the system bus through GDBus doesn't work for some reason.
-- This commented code works fine in a standalone lua file, but doesn't in AwesomeWM. 100% AwesomeWM bug, not mine.

-- local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)
-- bus:signal_subscribe("org.freedesktop.login1",
--    "org.freedesktop.login1.Manager",
--    "PrepareForSleep",
--    "/org/freedesktop/login1",
--    nil,
--    Gio.DBusSignalFlags.NONE,
--    onLoginManagerSignal)

dbus.add_match("system", "type='signal',sender='org.freedesktop.login1',interface='org.freedesktop.login1.Manager',member='PrepareForSleep',path='/org/freedesktop/login1'")
dbus.connect_signal("org.freedesktop.login1.Manager", onLoginManagerSignal)
