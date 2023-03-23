local awful = require("awful")
local signal_base = G.signal_base

-- Subscribe to backlight changes
-- Requires inotify-tools
local brightness_subscribe_script = [[
   bash -c "
   while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done
"]]

local get_brightness = function()
  awful.spawn.easy_async([[light -G]], function(stdout)
    local percentage = math.floor(tonumber(stdout) or 0)
    signal_base:emit_signal("signal::brightness", percentage)
  end)
end

-- Run once to initialize widgets
get_brightness()

-- Kill old inotifywait process
awful.spawn.easy_async_with_shell(
  [[ps x | grep "inotifywait -e modify /sys/class/backlight" | grep -v grep | awk '{print $1}' | xargs kill]],
  function()
    -- Update brightness status with each line printed
    awful.spawn.with_line_callback(brightness_subscribe_script, {
      stdout = function(_)
        get_brightness()
      end,
    })
  end
)
