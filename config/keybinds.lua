local awful = require "awful"
local mouse = require "mouse"
local brightness = require "system.brightness"
local audio = require "system.audio"
local darkmode = require "ui.darkmode"
local tags = require "config.tags"
local gears = require "gears"

local key = awful.key
local modkey = "Mod4"

awful.keyboard.append_global_keybindings { group = "tag",
   key({ modkey }, "Tab", awful.tag.history.restore, { description = "Go to last tag" }),
   key({ modkey }, "c", function()
      if screen:count() < 2 then return end
      local last_tag = screen[1].selected_tag
      for i = 2, screen:count() do
         local curr_tag = screen[i].selected_tag
         if last_tag then
            tags.view_tag(last_tag, screen[i])
         end
         last_tag = curr_tag
      end
      if last_tag then
         tags.view_tag(last_tag, screen[1])
      end

      gears.timer.start_new(0.01, function() awful.screen.focus(mouse.screen) end)
   end, { description = "Rotate tags on screens" }),
   key({ modkey, "Shift" }, "c", function()
      local screen_count = screen.count()
      if screen_count < 2 then return end
      local focused = awful.screen.focused()
      local new_screen_index = (focused.index % screen_count) + 1
      tags.view_tag(focused.selected_tag, screen[new_screen_index])
   end, { descripiton = "Move tag to another screen" }),
   key({ modkey }, "s", function() awful.screen.focus_relative(1) end,
      { description = "Move focus to next screen" }),
   key({ modkey }, "Right", function() awful.tag.viewnext() end,
      { description = "Focus next tag" }),
   key({ modkey }, "Left", function() awful.tag.viewprev() end,
      { description = "Focus previous tag" }),
}

for i = 1, 9 do
   awful.keyboard.append_global_keybindings { group = "tag",
      key({ modkey }, "#" .. i + 9, function()
         local tag = root.tags()[i]
         if tag then
            tag:view_only()
            awful.screen.focus(tag.screen)
         end
      end, { description = "Go to tag #" .. i }),
      key({ modkey, "Shift" }, "#" .. i + 9, function()
         if client.focus then
            local tag = root.tags()[i]
            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end, { description = "Move focused client to tag #" .. i }),
   }
end

awful.keyboard.append_global_keybindings { group = "launcher",
   key({ modkey }, "Return", function() awful.spawn("alacritty") end, { description = "Open a terminal" }),
   key({ modkey }, ";", function() awful.spawn("emacsclient -nc") end, { description = "Open emacsclient" }),
   key({ modkey }, "e", function() awful.spawn("thunar") end, { description = "Open file browser" }),
   key({ modkey }, "d", function() awful.spawn("rofi -show combi -normal-window") end, { description = "Open Rofi" }),
   key({ modkey }, "z", function() awful.spawn("boomer") end, { description = "Zoom in" }),
}

awful.keyboard.append_global_keybindings { group = "awesome",
   key({ modkey, "Ctrl" }, "r", awesome.restart, { description = "Reload awesome" }),
   key({ modkey, "Ctrl" }, "x", awesome.quit, { description = "Close awesome" }),

   key({ modkey }, "t", function()
      darkmode:toggle()
   end, { description = "Toggle color scheme" }),
}

awful.keyboard.append_global_keybindings { group = "layout",
   key({ modkey }, "Up", function() awful.layout.inc(1) end,
      { description = "Use next layout style" }),
   key({ modkey }, "Down", function() awful.layout.inc(-1) end,
      { description = "Use previous layout style" }),
}

awful.keyboard.append_client_keybindings { group = "client",
   key({ modkey }, "w", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end, { description = "Toggle fullscreen" }),
   key({ modkey, "Shift" }, "q", function(c) c:kill() end,
      { description = "Close" }),
   key({ modkey, "Ctrl" }, "w", function(c) c.floating = not c.floating end,
      { description = "Close" }),
   key({ modkey, "Shift" }, "w", function(c) c.ontop = not c.ontop end,
      { description = "Ontop" }),
}
-- Brightness
awful.keyboard.append_global_keybindings { group = "system",
   awful.key({}, "XF86MonBrightnessDown", function() brightness.add(awful.screen.focused(), -5) end),
   awful.key({}, "XF86MonBrightnessUp", function() brightness.add(awful.screen.focused(), 5) end),
}

-- Volume
awful.keyboard.append_global_keybindings { group = "system",
   awful.key({}, "XF86AudioLowerVolume", function() audio.add(-5) end),
   awful.key({}, "XF86AudioRaiseVolume", function() audio.add(5) end),
   awful.key({}, "XF86AudioMute", function() audio.toggle_mute() end),
}

-- Dashboard
awful.keyboard.append_global_keybindings { group = "awesome",
   awful.key({ modkey }, "o", function() awful.screen.focused().dashboard:toggle() end)
}

-- PrintScreen
awful.keyboard.append_global_keybindings { group = "print_screen",
   awful.key({ "Shift" }, "Print", function() awful.spawn.with_shell("maim -slDu -c 0,0,0,0.4 ~/Screenshots/(date +%s).png") end),
   awful.key({ }, "Print", function() awful.spawn.with_shell("maim -slDu -c 0,0,0,0.4 | xclip -selection clipboard -t image/png") end),
}

-- Macro
awful.keyboard.append_global_keybindings { group = "macro",
   awful.key({ }, "F9", nil, function() awful.spawn.with_shell("xdotool ~/.macro") end)
}
