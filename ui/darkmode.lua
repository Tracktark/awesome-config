local awful = require "awful"
local darkmode = require "lib.darkmode"
local titlebars = require "ui.titlebars"

local dm = darkmode {
   location = {
      lat = 49.1521,
      long = 18.749,
   }
}

-- GTK
dm:connect_signal(function(dark)
      local theme = dark and "Catppuccin-Macchiato-Standard-Teal-dark" or "Catppuccin-Latte-Standard-Teal-light"
      awful.spawn.with_shell("sed -i 's/^Net\\/ThemeName .*$/Net\\/ThemeName \"" .. theme .. "\"/' /home/moss/.config/xsettingsd/xsettingsd.conf && killall -HUP xsettingsd")
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
      local scheme = dark and "macchiato" or "latte"
      awful.spawn({"sed", "-i",
                   "s/^colors:.*$/colors: *" .. scheme .. "/",
                   "/home/moss/.config/alacritty/alacritty.yml"})
end)

-- Rofi
dm:connect_signal(function(dark)
      local theme = dark and "catppuccin-macchiato" or "catppuccin-latte"
      awful.spawn({"sed", "-i",
                   "s/^@theme.*$/@theme \"" .. theme .. "\"/",
                   "/home/moss/.config/rofi/config.rasi"})
end)

dm:start()

return dm
