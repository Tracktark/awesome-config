local xresources = require("beautiful.xresources")
local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local dpi = xresources.apply_dpi

function darken_color(color, factor)
   factor = factor or 0.9
   local red, green, blue = gears.color.parse_color(color)
   local red = red * 255 * factor
   local green = green * 255 * factor
   local blue = blue * 255 * factor
   return string.format("#%x%x%x", math.floor(red), math.floor(green), math.floor(blue))
end

local theme = {}

local catppuccin = {
    latte = {
        rosewater = "#dc8a78",
        flamingo = "#dd7878",
        pink = "#ea76cb",
        mauve = "#8839ef",
        red = "#d20f39",
        maroon = "#e64553",
        peach = "#fe640b",
        yellow = "#df8e1d",
        green = "#40a02b",
        teal = "#179299",
        sky = "#04a5e5",
        sapphire = "#209fb5",
        blue = "#1e66f5",
        lavender = "#7287fd",
        text = "#4c4f69",
        subtext1 = "#5c5f77",
        subtext0 = "#6c6f85",
        overlay2 = "#7c7f93",
        overlay1 = "#8c8fa1",
        overlay0 = "#9ca0b0",
        surface2 = "#acb0be",
        surface1 = "#bcc0cc",
        surface0 = "#ccd0da",
        crust = "#dce0e8",
        mantle = "#e6e9ef",
        base = "#eff1f5",
    },
    macchiato = {
        rosewater = "#f4dbd6",
        flamingo = "#f0c6c6",
        pink = "#f5bde6",
        mauve = "#c6a0f6",
        red = "#ed8796",
        maroon = "#ee99a0",
        peach = "#f5a97f",
        yellow = "#eed49f",
        green = "#a6da95",
        teal = "#8bd5ca",
        sky = "#91d7e3",
        sapphire = "#7dc4e4",
        blue = "#8aadf4",
        lavender = "#b7bdf8",
        text = "#cad3f5",
        subtext1 = "#b8c0e0",
        subtext0 = "#a5adcb",
        overlay2 = "#939ab7",
        overlay1 = "#8087a2",
        overlay0 = "#6e738d",
        surface2 = "#5b6078",
        surface1 = "#494d64",
        surface0 = "#363a4f",
        base = "#24273a",
        mantle = "#1e2030",
        crust = "#181926",
    },
}

local colors = catppuccin.macchiato
theme.colors = colors

theme.font = "Roboto 10"

theme.bg_normal    = colors.crust
theme.bg_focus     = colors.base
theme.bg_urgent    = colors.crust
theme.bg_minimize  = colors.crust
theme.bg_systray   = theme.bg_normal

theme.fg_normal    = colors.text
theme.fg_focus     = colors.text
theme.fg_urgent    = colors.yellow
theme.fg_minimize  = colors.overlay1

theme.useless_gap   = dpi(3)
theme.border_width  = 0
theme.border_normal = colors.overlay0
theme.border_focus  = colors.lavender
theme.border_marked = theme.yellow

theme.battery_discharging  = colors.text
theme.battery_critical     = colors.red
theme.battery_charging     = colors.green
theme.battery_outline      = theme.battery_discharging
theme.battery_conservation = colors.flamingo

function define_titlebar_button(name, color, stateful)
   if stateful then
      theme["titlebar_" .. name .. "_button_focus_active"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, color)
      theme["titlebar_" .. name .. "_button_focus_active_hover"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.8))
      theme["titlebar_" .. name .. "_button_focus_active_press"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.6))
      theme["titlebar_" .. name .. "_button_focus_inactive"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, color)
      theme["titlebar_" .. name .. "_button_focus_inactive_hover"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.8))
      theme["titlebar_" .. name .. "_button_focus_inactive_press"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.6))
   else
      theme["titlebar_" .. name .. "_button_focus"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, color)
      theme["titlebar_" .. name .. "_button_focus_hover"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.8))
      theme["titlebar_" .. name .. "_button_focus_press"] = gears.surface.load_from_shape(dpi(30), dpi(30), gears.shape.circle, darken_color(color, 0.6))
   end
end
define_titlebar_button("close", colors.red)
define_titlebar_button("maximized", colors.green, true)
define_titlebar_button("floating", colors.blue, true)


theme.titlebars = {
   button_margins = 7,
   dark = {
      bg = catppuccin.macchiato.crust,
      fg = catppuccin.macchiato.text
   },
   light = {
      bg = catppuccin.latte.crust,
      fg = catppuccin.latte.text
   }
}

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.notification_icon_size = 100

return theme
