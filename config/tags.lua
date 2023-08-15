local sharedtags = require "lib.sharedtags"
local awful = require "awful"

local l = awful.layout.suit

sharedtags {
      { name = "www", layout = l.tile },
      { name = "emacs", layout = l.max },
      { name = "term", layout = l.tile },
      { name = "misc", layout = l.tile },
      { name = "chat", layout = l.max },
      { name = "game", layout = l.tile },
      { name = "notes", layout = l.tile },
}
