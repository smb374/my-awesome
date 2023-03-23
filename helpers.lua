local awful = require("awful")
local gears = require("gears")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.prrect = function(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

helpers.squircle = function(rate, delta)
  return function(cr, width, height)
    gears.shape.squircle(cr, width, height, rate, delta)
  end
end
helpers.psquircle = function(rate, delta, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partial_squircle(cr, width, height, tl, tr, br, bl, rate, delta)
  end
end

helpers.colorize_text = function(text, color)
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

helpers.tag_back_and_forth = function(tag_index)
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
