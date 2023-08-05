local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local helpers = require("helpers")

local palette = G.palette
local dpi = G.dpi

local _M = {}

function _M.ibar_custom(children, color)
  local ibar = wibox.widget({
    {
      {
        children,
        {
          {
            max_value = 100.0,
            value = 0.0,
            color = color,
            background_color = palette.surface0,
            shape = helpers.rrect(dpi(5)),
            widget = widget.progressbar,
            id = "bar_role",
          },
          forced_height = dpi(12),
          forced_width = dpi(3),
          direction = "east",
          widget = container.rotate,
        },
        spacing = dpi(2),
        layout = layout.fixed.horizontal,
      },
      halign = "center",
      valign = "center",
      widget = container.place,
    },
    margins = {
      left = dpi(5),
      right = dpi(5),
    },
    widget = container.margin,
  })
  ibar.get_bar = function()
    return ibar:get_children_by_id("bar_role")[1]
  end
  return ibar
end

function _M.ibar_simple(icon, color)
  local ibar = _M.ibar_custom({
    markup = helpers.colorize_text(icon, color),
    fg = color,
    font = "Symbols Nerd Font Mono 10",
    widget = widget.textbox,
    id = "icon_role",
  }, color)
  ibar.get_icon = function()
    return ibar:get_children_by_id("icon_role")[1]
  end
  return ibar
end

return _M
