local awful = require("awful")
local wibox = require("wibox")
local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")

local helpers = require("helpers")

local dpi = G.dpi
local palette = G.palette

awful.screen.connect_for_each_screen(function(s)
  s.systray = widget.systray()
  s.traybox = wibox({
    screen = s,
    width = dpi(100),
    height = dpi(40),
    bg = "#00000000",
    visible = false,
    ontop = true,
  })

  s.traybox:setup({
    {
      {
        s.systray,
        layout = layout.fixed.horizontal,
      },
      margins = dpi(10),
      widget = container.margin,
    },
    bg = palette.base,
    border_width = dpi(2),
    border_color = palette.lavender,
    shape = helpers.rrect(5),
    widget = container.background,
  })
  awful.placement.bottom_right(s.traybox, { margins = dpi(15) })
end)
