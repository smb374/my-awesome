local awful = require("awful")
local gears = require("gears")
local signal_base = G.signal_base

local get_mem = function()
  awful.spawn.easy_async_with_shell(
    [[free -m | sed -n '2p' | awk '{printf "scale=2; (%d / %d) * 100\n", $7, $2}' | bc -l]],
    function(line)
      local percentage = tonumber(line) or 0.0
      signal_base:emit_signal("signal::mem", percentage)
    end
  )
end

gears.timer({
  timeout = 0.75,
  call_now = true,
  autostart = true,
  callback = function()
    get_mem()
  end,
})
