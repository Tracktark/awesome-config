local lib_dir = (...):match("(.-)[^%.]+$").."dbus_proxy."

local Bus = require(lib_dir .. "_bus")
local Proxy = require(lib_dir .. "_proxy")
local variant = require(lib_dir .. "_variant")
local monitored = require(lib_dir .. "_monitored")

return {
  Proxy = Proxy,
  Bus = Bus,
  variant = variant,
  monitored = monitored,
}
