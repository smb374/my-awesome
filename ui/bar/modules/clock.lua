local awful = require("awful")
local gears = require("gears")
local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local helpers = require("helpers")

local dpi = G.dpi
local palette = G.palette

local bar = wibox.widget({
  max_value = 59,
  value = 0,
  color = gears.color.change_opacity(palette.mauve, 0.6),
  background_color = palette.base,
  widget = widget.progressbar,
})

local function update_bar()
  awful.spawn.easy_async([[date +'%S']], function(stdout)
    local sec = stdout:match("(%d+)")
    bar.value = tonumber(sec) or 0
  end)
end

local clock = wibox.widget({
  {
    {
      bar,
      forced_height = dpi(55),
      forced_width = dpi(32),
      direction = "east",
      widget = container.rotate,
    },
    {
      {
        {
          {
            format = "<b>%H</b>",
            refresh = 60,
            widget = widget.textclock,
          },
          {
            format = "<b>%M</b>",
            refresh = 10,
            widget = widget.textclock,
          },
          spacing = dpi(1),
          layout = layout.fixed.vertical,
        },
        halign = "center",
        valign = "center",
        widget = container.place,
      },
      margins = {
        top = dpi(5),
        bottom = dpi(5),
      },
      widget = container.margin,
    },
    layout = layout.stack,
  },
  shape = helpers.rrect(5),
  bg = palette.base,
  widget = container.background,
})

gears.timer({
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function()
    update_bar()
  end,
})

return clock
