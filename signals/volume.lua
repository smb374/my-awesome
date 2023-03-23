local awful = require("awful")
local script_root = G.script_root
local signal_base = G.signal_base

local volume_old = -1
local muted_old = false
local function get_volume()
  awful.spawn.easy_async_with_shell(script_root .. "volume -v", function(stdout)
    local volume = stdout:match("(%S+)")
    local volume_int = tonumber(volume) or 0
    if volume_int ~= volume_old then
      signal_base:emit_signal("signal::volume", volume_int)
      volume_old = volume_int
    end
  end)
end

local function get_mute()
  awful.spawn.easy_async_with_shell(script_root .. "volume -m", function(stdout)
    local muted_str = stdout:match("(%S+)")
    local muted = muted_str == "true"
    if muted ~= muted_old then
      signal_base:emit_signal("signal::mute", muted)
      muted_old = muted
    end
  end)
end

get_volume()
get_mute()

local volume_script = [[
    bash -c "
    pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

awful.spawn.easy_async_with_shell(
  [[ps x | grep "pactl subscribe" | grep -v grep | awk '{print $1}' | xargs kill]],
  function()
    -- Run emit_volume_info() with each line printed
    awful.spawn.with_line_callback(volume_script, {
      stdout = function(_)
        get_volume()
        get_mute()
      end,
    })
  end
)
