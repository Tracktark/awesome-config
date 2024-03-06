local awful = require "awful"
local gears = require "gears"
local event_process = require "lib.event_process"
local reactive = require "lib.reactive"

local multiplier = 1

local audio = {
   boost = reactive(false),
   volume = reactive {
      value = 0,
      setter = function(_, val)
         awful.spawn("pamixer --allow-boost --set-volume " .. tostring(math.floor(val * multiplier)))
      end
   },

   muted = reactive {
      value = false,
      setter = function(_, val)
         local arg = val and "--mute" or "--unmute"
         awful.spawn("pamixer " .. arg)
      end
   }
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
               audio.update()
            end)
         end
      end
   end,
}

function audio.update()
   awful.spawn.easy_async("pamixer --get-volume", function(out)
      local vol = tonumber(out) / multiplier
      if vol > 100 then
         audio.volume(100)
      else
         audio.volume:set_internal(vol)
      end
   end)

   awful.spawn.easy_async("pamixer --get-mute", function(out)
      audio.muted:set_internal(string.match(out, "true") and true or false)
   end)
end
audio.update()

function audio.toggle_mute()
   awful.spawn("pamixer --toggle-mute")
end

function audio.add(value)
   audio.volume( audio.volume() + value )
end

audio.boost:subscribe(function(boost)
      multiplier = boost and 1.5 or 1
      audio.update()
end)

return audio
