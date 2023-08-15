local awful = require "awful"
local gears = require "gears"
local event_process = require "lib.event_process"

local volume = {
   ---@type integer
   volume = nil,
   ---@type boolean
   muted = nil
}

local o = gears.object {
   class = volume,
   enable_properties = true,
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
   if volume.volume ~= new_volume or
      volume.muted ~= new_muted then

      print("Volume changed")
      print(volume.volume, volume.muted)
      volume.volume = new_volume
      volume.muted = new_muted
      print(volume.volume, volume.muted)

      self:emit_signal "change"
   end
end
o:update()

function volume:set(value)
   awful.spawn("pamixer --set-volume " .. tostring(value))
end

function volume:toggle_mute()
   awful.spawn("pamixer --toggle-mute")
end

function volume:add(value)
   if value < 0 then
      awful.spawn("pamixer --decrease " .. tostring(-value))
   else
      awful.spawn("pamixer --increase " .. tostring(value))
   end
end

return o
