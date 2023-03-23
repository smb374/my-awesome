local ibar = require("ui.bar.modules.ibar")

local helpers = require("helpers")

local palette = G.palette
local signal_base = G.signal_base

local color = palette.peach

local icon = "󰁿"
local plug_icon = "󰂄"

local battery_ibar = ibar.ibar_simple(icon, color)

signal_base:connect_signal("signal::battery", function(_, battery)
  battery_ibar.get_bar().value = battery
end)

signal_base:connect_signal("signal::plug", function(_, plug)
  if plug == 1 then
    battery_ibar.get_icon().markup = helpers.colorize_text(plug_icon, color)
  else
    battery_ibar.get_icon().markup = helpers.colorize_text(icon, color)
  end
end)

return battery_ibar
