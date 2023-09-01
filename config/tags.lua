local sharedtags = require "lib.sharedtags"
local awful = require "awful"
local db = require "system.db"
local gears = require "gears"

db:exec [[
CREATE TABLE IF NOT EXISTS tags (name TEXT UNIQUE, screen_index INTEGER);
]]

local l = awful.layout.suit

local tags = sharedtags {
      { name = "www", layout = l.tile },
      { name = "emacs", layout = l.max },
      { name = "term", layout = l.tile },
      { name = "misc", layout = l.tile },
      { name = "chat", layout = l.max },
      { name = "game", layout = l.tile },
      { name = "notes", layout = l.tile },
}

for res in db:nrows("SELECT name, screen_index FROM tags;") do
   local tag = tags[res.name]

   if tag ~= nil and res.screen_index <= screen:count() then
      sharedtags.movetag(tag, screen[res.screen_index])
   end
end

local function view_tag(tag, screen)
   sharedtags.viewonly(tag, screen)
   local stmt = db:prepare [[
   INSERT INTO tags (name, screen_index) VALUES (:tag, :screen)
   ON CONFLICT(name) DO UPDATE SET screen_index=excluded.screen_index;
   ]]
   stmt:bind_names {
      tag = tag.name,
      screen = screen.index,
   }
   stmt:step()
   stmt:finalize()
end

return {
   view_tag = view_tag
}
