local sqlite = require "lsqlite3"
local fs = require("gears").filesystem

local db = sqlite.open(fs.get_xdg_data_home() .. "awesome/awesome.db")

return db
