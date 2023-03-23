local awful = require("awful")
local ibar = require("ui.bar.modules.ibar")

local palette = G.palette
local signal_base = G.signal_base

local color = palette.yellow

local icon = "󰃠"

local brightness_ibar = ibar.ibar_simple(icon, color)

signal_base:connect_signal("signal::brightness", function(_, bright)
  brightness_ibar.get_bar().value = bright
end)

brightness_ibar.get_icon():connect_signal("button::press", function(_, _, _, button)
  if button == 4 then
    awful.spawn.easy_async([[light -A 10]], {})
  elseif button == 5 then
    awful.spawn.easy_async([[light -U 10]], {})
  end
end)

return brightness_ibar
