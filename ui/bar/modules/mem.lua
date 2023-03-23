local ibar = require("ui.bar.modules.ibar")

local palette = G.palette
local signal_base = G.signal_base

local color = palette.blue

local icon = "󰘚"

local mem_ibar = ibar.ibar_simple(icon, color)

signal_base:connect_signal("signal::mem", function(_, mem)
  mem_ibar.get_bar().value = mem
end)

return mem_ibar
