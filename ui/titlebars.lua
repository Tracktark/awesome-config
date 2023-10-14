local wibox = require "wibox"
local awful = require "awful"
local beautiful = require "beautiful"

local titlebars = {
   dark = false
}

function titlebars.setDark(active)
   titlebars.dark = active
   for i, c in ipairs(client.get()) do
      c:emit_signal("request::titlebars")
   end
end

client.connect_signal("request::titlebars", function(c)
   if c.requests_no_titlebar then return end

   local color
   if titlebars.dark then
      color = beautiful.titlebars.dark
   else
      color = beautiful.titlebars.light
   end

   local buttons = {
      awful.button({}, awful.button.names.LEFT, function()
            c:activate { context = "titlebar", action = "mouse_move" }
      end),
      awful.button({}, awful.button.names.RIGHT, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
      end),
   }

   awful.titlebar(c, { bg = color.bg, fg = color.fg }):setup {
      layout = wibox.layout.align.horizontal,
      {
         widget = wibox.container.constraint,
         width = 50,
         {
            widget = require("ui.widgets.empty"),
            buttons = {
               awful.button({}, awful.button.names.LEFT, function()
                  c:activate { context = "titlebar", action = "mouse_resize" }
               end)
            },
         }
      },
      {
         widget = awful.titlebar.widget.titlewidget(c),
         align = "center",
         buttons = buttons,
      },
      {
         {
            awful.titlebar.widget.floatingbutton(c),
            margins = beautiful.titlebars.button_margins,
            widget = wibox.container.margin,
         },
         {
            awful.titlebar.widget.maximizedbutton(c),
            margins = beautiful.titlebars.button_margins,
            widget = wibox.container.margin,
         },
         {
            awful.titlebar.widget.closebutton(c),
            margins = beautiful.titlebars.button_margins,
            widget = wibox.container.margin,
         },
         layout = wibox.layout.fixed.horizontal,
      }
   }
end)

return titlebars
