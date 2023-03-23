local awful = require("awful")

local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local helpers = require("helpers")
local taglist = require("ui.bar.modules.tags")
local clock = require("ui.bar.modules.clock")
local volume = require("ui.bar.modules.volume")
local brightness = require("ui.bar.modules.brightness")
local cpu = require("ui.bar.modules.cpu")
local mem = require("ui.bar.modules.mem")
local battery = require("ui.bar.modules.battery")
local mpd_pane = require("ui.bar.modules.mpd_pane")

local dpi = G.dpi
local palette = G.palette

local function section(child)
  return wibox.widget({
    {
      child,
      margins = {
        top = dpi(10),
        bottom = dpi(10),
      },
      widget = container.margin,
    },
    shape = helpers.rrect(5),
    bg = palette.base,
    widget = container.background,
  })
end

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({
    screen = s,
    position = "left",
    width = dpi(32),
    height = dpi(s.geometry.height) - dpi(20),
    bg = "#00000000",
    fg = palette.text,
    margins = {
      left = dpi(5),
    },
    widget = {
      section({
        taglist(s),
        margins = {
          top = dpi(1),
          bottom = dpi(1),
          left = dpi(11),
          right = dpi(11),
        },
        widget = container.margin,
      }),
      mpd_pane,
      {
        section({
          brightness,
          volume,
          spacing = dpi(5),
          layout = layout.fixed.vertical,
        }),
        section({
          battery,
          mem,
          cpu,
          spacing = dpi(5),
          layout = layout.fixed.vertical,
        }),
        section(clock),
        spacing = dpi(5),
        layout = layout.fixed.vertical,
      },
      expand = "none",
      layout = layout.align.vertical,
    },
  })
end)
