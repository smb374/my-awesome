local awful = require("awful")

local helpers = {}

function helpers.tag_back_and_forth(tag_index)
  local s = awful.screen.focused({ mouse = true })
  local tag = s.tags[tag_index]
  if tag then
    if tag == s.selected_tag then
      awful.tag.history.restore()
    else
      tag:view_only()
    end
  end
end

return helpers
