local awful = require("awful")
local gears = require("gears")
local signal_base = G.signal_base

local get_battery = function()
  awful.spawn.with_line_callback([[cat /sys/class/power_supply/BAT0/capacity]], {
    stdout = function(line)
      local percentage = tonumber(line) or 0.0
      signal_base:emit_signal("signal::battery", percentage)
    end,
  })
end

local plug_subscribe_script = [[bash -c "while (inotifywait -e modify /tmp/acs -qq) do echo; done"]]

local get_plugged = function()
  awful.spawn.with_line_callback([[cat /sys/class/power_supply/AC/online]], {
    stdout = function(line)
      signal_base:emit_signal("signal::plug", tonumber(line) or 0)
    end,
  })
end

gears.timer({
  timeout = 0.75,
  call_now = true,
  autostart = true,
  callback = function()
    get_battery()
  end,
})

get_plugged()

awful.spawn.easy_async_with_shell(
  [[ps x | grep "inotifywait -e modify /tmp/acs" | grep -v grep | awk '{print $1}' | xargs kill]],
  function()
    -- Update brightness status with each line printed
    awful.spawn.with_line_callback(plug_subscribe_script, {
      stdout = function(_)
        get_plugged()
      end,
    })
  end
)
