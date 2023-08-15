local beautiful = require "beautiful"
local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local rubato = require "lib.rubato"

local widget = {
  timer = nil,
  popup = nil,
  progressbar = nil,
  anim = nil,
  imagebox = nil,
}
widget.__index = widget

function widget.new(screen)
  local self = setmetatable({}, widget)

  self.progressbar = wibox.widget {
    widget = wibox.widget.progressbar,
    forced_height = 4,
    forced_width = 100,
    bar_shape = gears.shape.rounded_bar,
    background_color = beautiful.bg_focus,
    color = beautiful.fg_normal,
    shape = gears.shape.rounded_bar
  }

  self.imagebox = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
    forced_width = 100,
    forced_height = 100,
  }

  self.popup = awful.popup {
    bg = beautiful.bg_normal .. "7F",
    ontop = true,
    visible = false,
    type = "notification",
    widget = {
      {
        self.imagebox,
        self.progressbar,
        layout = wibox.layout.fixed.vertical,
        spacing = 30,
      },
      widget = wibox.container.margin,
      top = 30,
      bottom = 30,
      left = 50,
      right = 50,
    },
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 8) end,
    input_passthrough = true,
    placement = function (d) return awful.placement.centered(d, { offset = {y = 250} }) end,
    screen = screen,
  }

  self.timer = gears.timer {
    timeout = 1.5,
    single_shot = true,
    callback = function() self.popup.visible = false end,
  }

  self.anim = rubato.timed {
    duration = 0.2,
    rate = 30,
    subscribed = function(val) self.progressbar:set_value(val) end,
  }

  return self
end

function widget:set_from(popup)
  local image = popup.image
  if type(image) == "function" then image = image() end
  self.imagebox.image = gears.color.recolor_image(image, beautiful.fg_normal)

  self.progressbar.max_value = popup.max_value
  local value = popup.value
  if type(value) == "function" then value = value() end
  self.anim.target = value
end

function widget:show()
  self.timer:again()
  self.popup.visible = true
end

function widget:hide()
  self.timer:stop()
  self.popup.visible = false
end

local popup = {
  image = nil,
  screen = nil,
  value = nil,
  max_value = nil,
  curr_screen = nil,
}
popup.__index = popup

function popup.new(args)
  local self = setmetatable({}, popup)

  self.image = args.image
  self.screen = args.screen or awful.screen.focused
  self.value = args.value or 0.5
  self.max_value = args.max_value or 100

  return self
end

function popup:show()
  local screen = self.screen
  if type(screen) == 'function' then
    screen = screen()
  end
  local widget = screen.popup
  widget:set_from(self)
  widget:show()
end

awful.screen.connect_for_each_screen(function(s)
    s.popup = widget.new(s)
end)

return setmetatable(popup, {__call = function(f, ...) return popup.new(...) end})
