local function dayOfYear(date)
   date = date or os.time()
   local year = os.date("*t", date).year
   local yearBeginning = os.time {year=year, month=1, day=1, hour=0, min=0, sec=0}
   local seconds = os.difftime(date, yearBeginning)
   local days = math.ceil(seconds / 60 / 60 / 24)
   return days
end

local function cos(deg)
   return math.cos(math.rad(deg))
end
local function acos(val)
   return math.deg(math.acos(val))
end
local function sin(deg)
   return math.sin(math.rad(deg))
end
local function asin(val)
   return math.deg(math.asin(val))
end
local function tan(deg)
   return math.tan(math.rad(deg))
end
local function atan(val)
   return math.deg(math.atan(val))
end

local function timezoneOffset()
   local utc_date = os.date("!*t")
   local local_date = os.date("*t")
   local_date.isdst = false
   return os.difftime(os.time(local_date), os.time(utc_date)) / 3600
end

return function(type, latitude, longitude, date)
   local sunrise
   if type == "sunrise" then
      sunrise = true
   elseif type == "sunset" then
      sunrise = false
   else
      error("Invalid type argument, should be 'sunrise' or 'sunset'")
   end

   local n = dayOfYear(date)

   local lambda = longitude / 15

   local t = n + ((sunrise and 6 or 18) - lambda) / 24

   local M = 0.9856*t - 3.289

   local L = M + 1.916*sin(M) + 0.02*sin(2*M) + 282.634
   L = L % 360

   local RA = atan(0.91764*tan(L)) % 360
   local Lquadrant  = math.floor(L  / 90) * 90
   local RAquadrant = math.floor(RA / 90) * 90
   RA = RA + (Lquadrant - RAquadrant)
   RA = RA / 15

   local sinDec = 0.39782 * sin(L)
   local cosDec = cos(asin(sinDec))

   local H = acos((cos(90.83) - sinDec*sin(latitude))
                        / (cosDec * cos(latitude)))
   if sunrise then
      H = 360 - H
   end
   H = H / 15

   local T = H + RA - (0.06571*t) - 6.622
   local UT = T - lambda
   UT = UT % 24

   local Tlocal = UT + timezoneOffset()
   local hour = math.floor(Tlocal)
   local minute = math.floor((Tlocal - hour) * 60)

   return {hour=hour, min=minute}
end
