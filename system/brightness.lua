local gears = require "gears"
local awful = require "awful"

local function map(value, in_min, in_max, out_min, out_max)
    local in_range = in_max - in_min
    local out_range = out_max - out_min
    local t = (value - in_min) / in_range
    return t * out_range + out_min
end
local function xb_to_aw(value, min) return map(value, min, 100, 0, 100) end
local function aw_to_xb(value, min) return map(value, 0, 100, min, 100) end

local backlight = {
   min = 0,
   name = nil,
   _brightness = 100,
}

function backlight:set_brightness(value)
   value = math.min(math.max(value, 0), 100)
   self._brightness = value
   awful.spawn("xbacklight -perceived -set " .. tostring(aw_to_xb(value, self.min)) .. " -ctrl " .. self.name)
   self:emit_signal("property::brightness", value)
end
function backlight:get_brightness()
   return self._brightness
end

awful.screen.connect_for_each_screen(function (s)
      s.backlight = gears.object {
         class = backlight,
         enable_properties = true,
      }

      if s == screen.primary then
         s.backlight.name = "intel_backlight"
         s.backlight.min = 40
      else
         s.backlight.name = "ddcci11"
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
            new_brightness = xb_to_aw(new_brightness, s.backlight.min)
            if new_brightness ~= s.backlight._brightness then
               s.backlight._brightness = new_brightness
               s:emit_signal("property::brightness", new_brightness)
            end
         end)
      end
   end
}

local function add(s, value)
   if s.backlight._brightness == nil then return end
   s.backlight.brightness = s.backlight.brightness + value
end

return { add = add }
