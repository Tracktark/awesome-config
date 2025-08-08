local awful = require "awful"

awful.screen.connect_for_each_screen(function (s)
   s:connect_signal("property::geometry", function()
      -- NOTE: Needed because when a secondary monitor is added it gets incorrectly set as the primary,
      -- which lasts until awesome is restarted
      awesome.restart()
   end)
end)
