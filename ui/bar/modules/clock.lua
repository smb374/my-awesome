local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local dpi = G.dpi

local clock = wibox.widget({
  {
    format = "<b>%H</b>",
    refresh = 60,
    align = "center",
    valign = "center",
    widget = widget.textclock,
  },
  {
    format = "<b>%M</b>",
    refresh = 10,
    align = "center",
    valign = "center",
    widget = widget.textclock,
  },
  spacing = dpi(1),
  layout = layout.fixed.vertical,
})

return clock
