local awful = require "awful"
local gdebug = require "gears.debug"
local global_tags = require "config.tags".tags

local module = {}

function module.drag_to_tag(c)
    if (not c) or (not c.valid) then return end

    local coords = mouse.coords()

    local dir = nil

    local wa = c.screen.workarea

    if coords.x >= wa.x + wa.width - 1 then
        dir = "right"
    elseif coords.x <= wa.x + 1 then
        dir = "left"
    end

    local tags = c.screen.tags
    local t = c.screen.selected_tag
    local idx = t.index

    if dir then
        if dir == "right" and idx + 1 <= #tags then
            local newtag = tags[idx + 1]
            c:move_to_tag(newtag)
            newtag:view_only()
            mouse.coords({ x = wa.x + 2 }, true)
        elseif dir == "left" and idx - 1 > 0 then
            local newtag = tags[idx - 1]
            c:move_to_tag(newtag)
            newtag:view_only()
            mouse.coords({ x = wa.x + wa.width - 2 }, true)
        end
    end
end

awful.mouse.resize.add_move_callback(function(c, _, _)
    module.drag_to_tag(c)
end, "mouse.move")


awful.mouse.resize.add_leave_callback(function(c, geo, args)
      local widgets = mouse.current_widgets
      if not widgets then return end
      if (not c) or (not c.valid) then return end
      local in_taglist = false
      for i, widget in ipairs(widgets) do
         if string.find(tostring(widget), "taglist") then
            in_taglist = true
            break
         end
      end
      if not in_taglist then return end
      local target_tag = widgets[#widgets].text
      if not target_tag then return end
      c:move_to_tag(global_tags[target_tag])
end, "mouse.move")
