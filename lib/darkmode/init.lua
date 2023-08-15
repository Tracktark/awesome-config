local lib_dir = (...):match("(.-)[^%.]+$").."darkmode."
local gears = require("gears")
local sunTime = require(lib_dir .. "suntime")

local darkmode = {
   active = false,
   override = nil,
   time = {
      dark  = {hour=19, min=0},
      light = {hour=6,  min=0}
   },
   location = nil,
   check_time = 60,
}

function darkmode:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   if o.location ~= nil then
      o.time.dark  = function() return sunTime("sunset",  o.location.lat, o.location.long) end
      o.time.light = function() return sunTime("sunrise", o.location.lat, o.location.long) end
   end

   o._signals = {}
   o._timer = gears.timer {
      timeout = o.check_time,
      callback = function()
         o:update()
         o._timer:again()
      end,
   }
   o.active = o:shouldBeActive()

   return o
end

function darkmode:update()
   local emittedActive = self:isActive()
   local oldActive = self.active
   self.active = self:shouldBeActive()
   if self.active ~= oldActive then
      self.override = nil
      if emittedActive ~= self.active then
         self:emit()
      end
   end
end

function darkmode:emit()
   for func in pairs(self._signals) do
      func(self:isActive(), self)
   end
end

function darkmode:shouldBeActive()
   local now = os.date("*t")
   now = now.hour * 60 + now.min

   local dark_start = self.time.dark
   if type(dark_start) == "function" then
      dark_start = dark_start()
   end
   dark_start = dark_start.hour * 60 + dark_start.min

   local dark_end = self.time.light
   if type(dark_end) == "function" then
      dark_end = dark_end()
   end
   dark_end = dark_end.hour * 60 + dark_end.min

   local range_start, range_end, range_active
   if dark_start < dark_end then
      range_start = dark_start
      range_end = dark_end
      range_active = true
   else
      range_start = dark_end
      range_end = dark_start
      range_active = false
   end

   if now >= range_start and now < range_end then
      return range_active
   else
      return not range_active
   end
end

function darkmode:isActive()
   if self.override ~= nil then
      return self.override
   end
   return self.active
end

function darkmode:set(active)
   local oldActive = self:isActive()
   self.override = active
   if oldActive ~= self:isActive() then
      self:emit()
   end
end

function darkmode:toggle()
   self:set(not self:isActive())
end

function darkmode:start()
   self._timer:start()
   self:emit()
end

function darkmode:stop()
   self._timer:stop()
   self:update()
end

function darkmode:connect_signal(fun)
   self._signals[fun] = true
end

function darkmode:disconnect_signal(fun)
   self._signals[fun] = nil
end

return setmetatable(darkmode, {__call = function(arg, ...) return darkmode:new(...) end })
