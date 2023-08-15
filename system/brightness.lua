local gears = require "gears"
local awful = require "awful"

local function map(value, in_min, in_max, out_min, out_max)
    local in_range = in_max - in_min
    local out_range = out_max - out_min
    local t = (value - in_min) / in_range
    return t * out_range + out_min
end
local function xb_to_aw(value) return map(value, 35, 100, 0, 100) end
local function aw_to_xb(value) return map(value, 0, 100, 35, 100) end

awful.screen.connect_for_each_screen(function (s)
      if s == screen.primary then
         s.backlight = "intel_backlight"
      else
         s.backlight = "ddcci11"
      end
end)

gears.timer {
   timeout = 60 * 5,
   call_now = true,
   autostart = true,
   callback = function()
      for s in screen do
         awful.spawn.easy_async("xbacklight -get -perceived -ctrl " .. s.backlight, function(out)
            local new_brightness = tonumber(out)
            if new_brightness == nil then return end
            new_brightness = xb_to_aw(new_brightness)
            if new_brightness ~= s.brightness then
               s:emit_signal("brightness::change", new_brightness, "timer")
               s.brightness = new_brightness
            end
         end)
      end
   end
}

local function set(s, value, reason)
   value = math.min(math.max(value, 0), 100)
   s.brightness = value
   awful.spawn("xbacklight -perceived -set " .. tostring(aw_to_xb(s.brightness)) .. " -ctrl " .. s.backlight)
   s:emit_signal("brightness::change", s.brightness, reason)
end

local function add(s, value, reason)
   s.brightness = math.min(math.max(s.brightness + value, 0), 100)
   awful.spawn("xbacklight -perceived -set " .. tostring(aw_to_xb(s.brightness)) .. " -ctrl " .. s.backlight)
   s:emit_signal("brightness::change", s.brightness, reason)
end

return { set = set, add = add }
