local gears = require "gears"
local awful = require "awful"
local reactive = require "lib.reactive"

local backlight_names = {
   ["eDP-1"] = "intel_backlight",
   ["HDMI-1"] = "ddcci1",
   ["DP-2"] = "ddcci11"
}

local function map(value, in_min, in_max, out_min, out_max)
    local in_range = in_max - in_min
    local out_range = out_max - out_min
    local t = (value - in_min) / in_range
    return t * out_range + out_min
end
local function xb_to_aw(value, min) return map(value, min, 100, 0, 100) end
local function aw_to_xb(value, min) return map(value, 0, 100, min, 100) end

awful.screen.connect_for_each_screen(function(s)
   s.backlight = {}
   s.backlight.brightness = reactive {
      value = 100,
      setter = function(self, value)
         value = math.min(math.max(value, 0), 100)
         awful.spawn("xbacklight -perceived -set " ..
                     tostring(aw_to_xb(value, s.backlight.min)) ..
                     " -ctrl " .. s.backlight.name)
         self:set_internal(value)
      end
   }

   for name, v in pairs(s.outputs) do
      s.backlight.screen_name = name
      break
   end

   if s == screen.primary then
      s.backlight.name = "intel_backlight"
      s.backlight.min = 40
   else
      s.backlight.name = backlight_names[s.backlight.screen_name]
      s.backlight.min = 0
   end
end)

gears.timer {
   timeout = 60 * 5,
   call_now = true,
   autostart = true,
   callback = function()
      for s in screen do
         awful.spawn.easy_async("xbacklight -get -perceived -ctrl " .. s.backlight.name, function(out)
            local new_brightness = tonumber(out)
            if new_brightness == nil then return end
            s.backlight.brightness:set_internal(xb_to_aw(new_brightness, s.backlight.min))
         end)
      end
   end
}

local function add(s, value)
   if s.backlight.brightness() == nil then return end
   s.backlight.brightness( s.backlight.brightness() + value )
   s.backlight.brightness:emit(s.backlight.brightness())
end

return { add = add }
