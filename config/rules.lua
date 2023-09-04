local awful = require "awful"
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
   rule = { class = "Emacs" },
   properties = {
      size_hints_honor = false,
   }
}
