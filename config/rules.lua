local awful = require "awful"
local gears = require "gears"
local ruled = require "ruled"

ruled.client.append_rule {
   rule = {},
   properties = {
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
   }
}

ruled.client.append_rule {
   rule = {
      class = "Rofi"
   },
   properties = {
      floating = true,
      ontop = true,
   }
}

ruled.client.append_rule {
   rule_any = {
      type = { "normal", "dialog" }
   },
   properties = {
      titlebars_enabled = true
   }
}

ruled.client.append_rule {
   rule_any = { class = { "Cellwriter", "Onboard" } },
   properties = {
      focusable = false,
      dockable = true,
      screen = function() return screen.primary end,
      callback = function(c)
         c:connect_signal("property::height", function(_)
            local geo = c:geometry()
            local screen_geo = screen.primary.geometry
            c:geometry {
               x = screen_geo.x,
               y = screen_geo.y + screen_geo.height - geo.height,
               height = geo.height,
               width = geo.width,
            }
            c:struts {
               bottom = geo.height
            }
         end)
         c:emit_signal("property::height", c, c.height)
      end,
   }
}

ruled.client.append_rule {
   rule = { class = "thunderbird" },
   properties = {
      tag = "emacs",
      callback = function(c)
         c:connect_signal("property::minimized", function(_)
            if c.minimized then
               c.hidden = true
            end
         end)

         c:connect_signal("request::activate", function(_)
            c.hidden = false
         end)
      end
   }
}

ruled.client.append_rule {
   rule = {
      class = "sowon",
   },
   properties = {
      floating = true,
   }
}

ruled.client.append_rule {
   rule = {
      class = "Alacritty",
      name = "Calculator",
   },
   properties = {
      floating = true,
      placement = awful.placement.bottom_right,
   }
}

ruled.client.append_rule {
   rule = {
      class = "com.moonlight_stream.Moonlight",
   },
   properties = {
      fullscreen = true,
   }
}
