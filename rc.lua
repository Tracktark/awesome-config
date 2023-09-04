pcall(require, "luarocks.loader")

local fennel = require("fennel").install()
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
fennel["macro-path"] = fennel["macro-path"] .. ";.config/awesome/?.fnl"

local naughty = require "naughty"
local beautiful = require "beautiful"
local gears = require "gears"

local in_error = false
awesome.connect_signal("debug::error", function(err)
   -- Make sure we don't go into an endless error loop
   if in_error then return end
   in_error = true

   naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
   })
   in_error = false
end)

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

require "awful.autofocus"
require "config"
require "system"
require "ui"
