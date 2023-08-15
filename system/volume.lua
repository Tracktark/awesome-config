local awful = require "awful"
local gears = require "gears"
local event_process = require "lib.event_process"

local volume = {
   ---@type integer
   _volume = nil,
   ---@type boolean
   _muted = nil
}

function volume:get_volume()
   return self._volume
end
function volume:set_volume(value)
   awful.spawn("pamixer --set-volume " .. tostring(value))
end

function volume:get_muted()
   return self._muted
end
function volume:set_muted(value)
   local arg = value and "--mute" or "--unmute"
   awful.spawn("pamixer " .. arg)
end

local o = gears.object {
   class = volume,
   enable_properties = true,
   enable_auto_signals = true,
}

local debouncing = false
event_process {
   command = "pactl subscribe",
   stdout = function(line)
      if string.match(line, "Event 'change' on server ") or
         string.match(line, "Event 'change' on sink ") then
         if not debouncing then
            debouncing = true
            gears.timer.start_new(0.05, function()
               debouncing = false
               o:update()
            end)
         end
      end
   end,
}

function volume:update()
   local new_volume = io.popen("pamixer --get-volume"):read("n")
   local new_muted = io.popen("pamixer --get-mute"):read() == "true"
   local changed = false

   if self._volume ~= new_volume then
      changed = true
      self._volume = new_volume
      self:emit_signal("property::volume", new_volume)
   end

   if self._muted ~= new_muted then
      changed = true
      self._muted = new_muted
      self:emit_signal("property::muted", new_muted)
   end

   if changed then
      self:emit_signal "change"
   end
end
o:update()

function volume:toggle_mute()
   awful.spawn("pamixer --toggle-mute")
end

function volume:add(value)
   self.volume = self.volume + value
end

return o
