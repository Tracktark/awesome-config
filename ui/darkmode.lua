local awful = require "awful"
local darkmode = require "lib.darkmode"
local titlebars = require "ui.titlebars"
local sunTime = require "lib.darkmode.suntime"
local beautiful = require "beautiful"

local location = {
   lat = 49.1521,
   long = 18.749,
}

local dm = darkmode {
   time = {
      dark = function()
         local time = sunTime("sunset", location.lat, location.long)
         time.hour = time.hour - 1
         return time
      end,
      light = function() return sunTime("sunrise", location.lat, location.long) end
   }
}

-- GTK
dm:connect_signal(function(dark)
      local theme = beautiful.gtktheme
      local scheme = dark and theme.dark or theme.light
      local cmd = [[sed -i 's/^Net\/ThemeName .*$/Net\/ThemeName "%s"/' ~/.config/xsettingsd/xsettingsd.conf && killall -HUP xsettingsd]]
      awful.spawn.with_shell(string.format(cmd, scheme))
end)

-- Emacs
dm:connect_signal(function(dark)
      local scheme = dark and "dark" or "light"
      awful.spawn({"emacsclient", "-e", "(elegance-set-theme '" .. scheme .. ")"})
end)

-- Titlebars
dm:connect_signal(function(active)
      titlebars.setDark(active)
end)

-- Alacritty
dm:connect_signal(function(dark)
      local scheme = dark and "dark" or "light"
      local cmd = [[rm ~/.config/alacritty/alacritty.toml && cp ~/.config/alacritty/alacritty_%s.toml ~/.config/alacritty/alacritty.toml]]
      awful.spawn.with_shell(string.format(cmd, scheme))
end)

-- Rofi
dm:connect_signal(function(dark)
      local theme = beautiful.rofi
      local scheme = dark and theme.dark or theme.light
      local cmd = [[sed -i 's/^@theme.*$/@theme "%s"/' ~/.config/rofi/config.rasi]]
      awful.spawn.with_shell(string.format(cmd, scheme))
end)

-- Cellwriter
dm:connect_signal(function()
   awful.spawn.easy_async("pkill cellwriter", function()
      awful.spawn("cellwriter --hide-window")
   end)
end)

-- gf2
dm:connect_signal(function(dark)
   local scheme = dark and "dark" or "light"
   local cmd = [[sed -i '/\[theme\]/d;/\[theme-%s\]/a[theme]' ~/.config/gf2_config.ini]]
   awful.spawn.with_shell(string.format(cmd, scheme))
end)

-- XSG Desktop Portal
dm:connect_signal(function(dark)
   local scheme = dark and "dark" or "light"
   local cmd = [[dconf write /org/gnome/desktop/interface/color-scheme \'prefer-%s\']]
   awful.spawn(string.format(cmd, scheme))
end)

return dm
