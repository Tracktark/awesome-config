local awful = require "awful"
local brightness = require "system.brightness"
local volume = require "system.volume"
local sharedtags = require "lib.sharedtags"
local darkmode = require "ui.darkmode"

local key = awful.key
local modkey = "Mod4"

awful.keyboard.append_global_keybindings { group = "tag",
  key({modkey}, "Tab", awful.tag.history.restore, {description = "Go to last tag"}),
  key({modkey}, "c", function()
      if screen:count() < 2 then return end
      local last_tag = screen[1].selected_tag
      for i = 2, screen:count() do
        local curr_tag = screen[i].selected_tag
        if last_tag then
          sharedtags.viewonly(last_tag, screen[i])
        end
        last_tag = curr_tag
      end
      if last_tag then
        sharedtags.viewonly(last_tag, screen[1])
      end
    end, {description = "Rotate tags on screens"}),
key({modkey, "Shift"}, "c", function()
      local screen_count = screen.count()
      if screen_count < 2 then return end
      local focused = awful.screen.focused()
      local new_screen_index = (focused.index % screen_count) + 1
      sharedtags.viewonly(focused.selected_tag, screen[new_screen_index])
end, {descripiton = "Move tag to another screen"}),
key({modkey}, "s", function() awful.screen.focus_relative(1) end,
    {description = "Move focus to next screen"}),
}

for i = 1, 9 do
   awful.keyboard.append_global_keybindings { group = "tag",
      key({ modkey }, "#" .. i + 9, function()
         local screen = awful.screen.focused()
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
  key({modkey}, "Return", function() awful.spawn("alacritty") end,                       {description = "Open a terminal"}),
  key({modkey}, ";",      function() awful.spawn("emacsclient -nc") end,                 {description = "Open emacsclient"}),
  key({modkey}, "e",      function() awful.spawn("thunar") end,                          {description = "Open file browser"}),
  key({modkey}, "d",      function() awful.spawn("rofi -show combi -normal-window") end, {description = "Open Rofi"}),
  key({modkey}, "z",      function() awful.spawn("boomer") end,                          {description = "Zoom in"}),
}

awful.keyboard.append_global_keybindings { group = "awesome",
  key({modkey, "Ctrl"}, "r", awesome.restart, {description = "Reload awesome"}),
  key({modkey, "Ctrl"}, "x", awesome.quit, {description = "Close awesome"}),

  key({modkey}, "t", function()
        darkmode:toggle()
  end, {description = "Toggle color scheme"}),
}

awful.keyboard.append_global_keybindings { group = "layout",
  key({modkey}, "Up", function() awful.layout.inc(1) end,
    {description = "Use next layout style"}),
  key({modkey}, "Down", function() awful.layout.inc(-1) end,
    {description = "Use previous layout style"}),
}

awful.keyboard.append_client_keybindings { group = "client",
   key({ modkey }, "w", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end, { description = "Toggle fullscreen" }),
   key({ modkey, "Shift" }, "q", function(c) c:kill() end,
      { description = "Close" }),
}
-- Brightness
awful.keyboard.append_global_keybindings { group = "system",
   awful.key({}, "XF86MonBrightnessDown", function() brightness.add(awful.screen.focused(), -5, "keybind") end),
   awful.key({}, "XF86MonBrightnessUp",   function() brightness.add(awful.screen.focused(),  5, "keybind") end),
}

-- Volume
awful.keyboard.append_global_keybindings { group = "system",
   awful.key({}, "XF86AudioLowerVolume", function() volume:add(-5) end),
   awful.key({}, "XF86AudioRaiseVolume", function() volume:add( 5) end),
   awful.key({}, "XF86AudioMute", function() volume.muted = not volume.muted end),
}

-- Dashboard
awful.keyboard.append_global_keybindings { group = "awesome",
   awful.key({ "Mod4" }, "o", function() awful.screen.focused().dashboard:toggle() end)
}
