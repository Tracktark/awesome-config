local awful = require "awful"

local button = awful.button.names
awful.mouse.append_client_mousebindings {
    awful.button({ }, button.LEFT, function (c)
        c:activate { context = "mouse_click", raise = true }
    end),
    awful.button({ "Mod4" }, button.LEFT, function (c)
        c:activate { context = "mouse_click", raise = true, action = "mouse_move" }
    end),
    awful.button({ "Mod4" }, button.RIGHT, function (c)
        c:activate { context = "mouse_click", raise = true, action = "mouse_resize" }
    end),
}
