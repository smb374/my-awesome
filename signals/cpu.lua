local awful = require("awful")
local gears = require("gears")
local signal_base = G.signal_base

local get_cpu = function()
  awful.spawn.with_line_callback([[sh -c "top -bn1 | awk '/Cpu/ { print $2 }'"]], {
    stdout = function(line)
      local percentage = tonumber(line) or 0.0
      signal_base:emit_signal("signal::cpu", percentage)
    end,
  })
end

gears.timer({
  timeout = 0.5,
  call_now = true,
  autostart = true,
  callback = function()
    get_cpu()
  end,
})
