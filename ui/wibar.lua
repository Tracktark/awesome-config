local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local battery = require "system.battery"
local battery_widget = require "ui.widgets.battery"

local clock = wibox.widget.textclock()

local b = battery_widget.new()
local function update() b:update() end
battery.charging:subscribe(update)
battery.conservation:subscribe(update)
battery.level:subscribe(update)

local taglist_buttons = gears.table.join(
   awful.button({}, 1, function(t) t:view_only() end),
   awful.button({ "Mod4" }, 1, function(t)
      if client.focus then
         client.focus:move_to_tag(t)
      end
   end)
)

local tasklist_buttons = gears.table.join(
   awful.button({}, 1, function(c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal(
            "request::activate",
            "tasklist",
            { raise = true }
         )
      end
   end))

screen.connect_signal("request::desktop_decoration", function(s)
   s.wibar_taglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
   }

   s.wibar_tasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons
   }

   s.wibar = awful.wibar({ position = "top", screen = s, height = 25 })

   s.wibar:setup {
      layout = wibox.layout.align.horizontal,
      {   -- Left widgets
         s.wibar_taglist,
         layout = wibox.layout.fixed.horizontal,
      },
      s.wibar_tasklist,   -- Middle widget
      {                   -- Right widgets
         wibox.widget.systray(),
         clock,
         {
            widget = wibox.container.margin,
            buttons = awful.button({}, awful.button.names.LEFT, function() battery:toggle_conservation() end),
            margins = {
               left = 5,
               right = 5,
               top = 6,
               bottom = 6,
            },
            b,
         },
         layout = wibox.layout.fixed.horizontal,
      },
   }
end)
