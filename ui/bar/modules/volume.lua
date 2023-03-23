local awful = require("awful")
local ibar = require("ui.bar.modules.ibar")

local helpers = require("helpers")

local palette = G.palette
local signal_base = G.signal_base

local color = palette.teal
local inactive_color = palette.surface2

local icon = "󰕾"
local mute_icon = "󰖁"

local volume_ibar = ibar.ibar_simple(icon, color)

signal_base:connect_signal("signal::volume", function(_, volume)
  volume_ibar.get_bar().value = volume
end)

signal_base:connect_signal("signal::mute", function(_, muted)
  if muted then
    volume_ibar.get_bar().color = inactive_color
    volume_ibar.get_icon().markup = helpers.colorize_text(mute_icon, color)
  else
    volume_ibar.get_bar().color = color
    volume_ibar.get_icon().markup = helpers.colorize_text(icon, color)
  end
end)

volume_ibar.get_icon():connect_signal("button::press", function(_, _, _, button)
  if button == 4 then
    awful.spawn.easy_async([[wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+]], {})
  elseif button == 5 then
    awful.spawn.easy_async([[wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-]], {})
  elseif button == 1 then
    awful.spawn([[wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle]])
  end
end)

return volume_ibar
