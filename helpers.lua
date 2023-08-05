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

helpers.scratchpad = function(match, spawn_cmd, spawn_args)
  local cf = client.focus
  if cf and awful.rules.match(cf, match) then
    cf.minimized = true
  else
    helpers.run_or_raise(match, true, spawn_cmd, spawn_args)
  end
end

helpers.run_or_raise = function(match, move, spawn_cmd, spawn_args)
  local matcher = function(c)
    return awful.rules.match(c, match)
  end

  -- Find and raise
  local found = false
  for c in awful.client.iterate(matcher) do
    found = true
    c.minimized = false
    if move then
      c:move_to_tag(mouse.screen.selected_tag)
      client.focus = c
    else
      c:jump_to()
    end
    break
  end

  -- Spawn if not found
  if not found then
    awful.spawn(spawn_cmd, spawn_args)
  end
end

return helpers
