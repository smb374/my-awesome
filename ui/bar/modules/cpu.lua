local ibar = require("ui.bar.modules.ibar")

local palette = G.palette
local signal_base = G.signal_base

local color = palette.red

local icon = "󰍛"

local cpu_ibar = ibar.ibar_simple(icon, color)

signal_base:connect_signal("signal::cpu", function(_, cpu)
  cpu_ibar.get_bar().value = 100.0 - cpu
end)

return cpu_ibar
