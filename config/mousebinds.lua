local awful = require "awful"

local button = awful.button.names
awful.mouse.append_client_mousebindings {
   awful.button({}, button.LEFT, function(c)
      c:activate { context = "mouse_click", raise = true }
   end),
   awful.button({ "Mod4" }, button.LEFT, function(c)
      c:activate { context = "mouse_click", raise = true, action = "mouse_move" }
   end),
   awful.button({ "Mod4" }, button.RIGHT, function(c)
      c:activate { context = "mouse_click", raise = true, action = "mouse_resize" }
   end),
   awful.button({}, 10, function()
         awful.screen.focused().dashboard:toggle()
   end)
}

awful.mouse.append_global_mousebindings {
   awful.button({}, 10, function()
         awful.screen.focused().dashboard:toggle()
   end)
}
