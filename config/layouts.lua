local awful = require "awful"

local l = awful.layout.suit

awful.layout.append_default_layouts {
    l.tile,
    l.tile.top,
    l.max,
}
