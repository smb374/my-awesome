local awful = require("awful")
local gears = require("gears")
local signal_base = G.signal_base

local album_old = ""

local get_mpd_meta = function()
  awful.spawn.easy_async_with_shell(
    [[mpc -f '%album%;%artist%;%title%' | sed -n '1p' | tr -d '\n' | xargs -0 -I @@ mpc status '@@;%state%']],
    function(stdout)
      local is_playing = false
      local album, artist, title, is_playing_str = stdout:match("([%S ]*);([%S ]*);([%S ]*);(%S+)")
      if is_playing_str == "playing" then
        is_playing = true
      end
      if album ~= album_old then
        album_old = album
        signal_base:emit_signal("signal::mpd::get_cover")
      end
      signal_base:emit_signal("signal::mpd::meta", album, artist, title, is_playing)
    end
  )
end

local get_mpd_option = function()
  awful.spawn.easy_async([[mpc status '%repeat%;%single%']], function(stdout)
    local is_repeat = false
    local is_single = false
    local is_repeat_str, is_single_str = stdout:match("(%S+);(%S+)")
    if is_repeat_str == "on" then
      is_repeat = true
    end
    if is_single_str == "on" then
      is_single = true
    end
    signal_base:emit_signal("signal::mpd::option", is_repeat, is_single)
  end)
end

local get_cover = function()
  awful.spawn.easy_async([[mpd_cover_path]], function(stdout)
    local cover = stdout:match("([%S ]+)")
    signal_base:emit_signal("signal::mpd::cover", cover)
  end)
end

local get_progress = function()
  awful.spawn.easy_async([[mpc status '%percenttime%']], function(stdout)
    local prog_str = stdout:match(" (%S+)%%")
    local prog = tonumber(prog_str) or 0
    signal_base:emit_signal("signal::mpd::progress", prog)
  end)
end

signal_base:connect_signal("signal::mpd::get_cover", function(_)
  get_cover()
end)

get_mpd_meta()
get_mpd_option()

gears.timer({
  timeout = 1.0,
  call_now = true,
  autostart = true,
  callback = function()
    get_progress()
  end,
})

awful.spawn.easy_async_with_shell(
  [[ps x | grep "mpc idleloop" | grep -v grep | awk '{print $1}' | xargs kill]],
  function()
    awful.spawn.with_line_callback([[mpc idleloop]], {
      stdout = function(_)
        get_mpd_meta()
        get_progress()
        get_mpd_option()
      end,
    })
  end
)
