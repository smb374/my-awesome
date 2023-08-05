G = {}
pcall(jit.on)

require("awful.autofocus")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

require("def")
require("user")

beautiful.init("/home/poyehchen/.config/awesome/theme.lua")

naughty.config.padding = G.dpi(10)
naughty.config.spacing = G.dpi(4)
naughty.config.icon_dirs = { "/usr/share/icons/Papirus/32x32" }
naughty.config.defaults.margin = G.dpi(10)
naughty:connect_signal("request::display_error", function(msg, startup)
  naughty.notification({
    urgency = "crutial",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = msg,
  })
end)

require("bindings")

awful.layout.layouts = { awful.layout.suit.tile, awful.layout.suit.floating, awful.layout.suit.max }
local current_wp = ""

awful.screen.connect_for_each_screen(function(s)
  local l = awful.layout.suit
  local wallpaper = G.user.wallpaper
  local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8" }
  awful.tag(tagnames, s, l.tile)
  if type(wallpaper) == "string" then
    awful.spawn.easy_async([[feh --bg-fill ]] .. wallpaper)
    current_wp = wallpaper
  elseif type(wallpaper) == "table" then
    awful.spawn.easy_async([[feh --bg-fill ]] .. wallpaper[1])
    current_wp = wallpaper[1]
  end
end)

client.connect_signal("mouse::enter", function(c)
  c:activate({ context = "mouse_enter", raise = false })
end)

client.connect_signal("manage", function(c)
  c.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 10)
  end
end)

screen.connect_signal("property::geometry", function(_)
  awful.spawn.easy_async([[feh --bg-fill ]] .. current_wp)
end)

tag.connect_signal("property::selected", function(t)
  local wallpaper = G.user.wallpaper
  if t.selected then
    if type(wallpaper) == "table" then
      local ws_len = gears.table.count_keys(G.user.wallpaper)
      if not t.ws_set then
        if t.index > ws_len then
          local idx = ((t.index - 1) % ws_len) + 1
          awful.spawn.easy_async([[feh --bg-fill ]] .. wallpaper[idx])
          current_wp = wallpaper[idx]
        else
          awful.spawn.easy_async([[feh --bg-fill ]] .. wallpaper[t.index])
          current_wp = wallpaper[t.index]
        end
      end
    end
  end
end)

require("rules")

require("ui.bar")
require("ui.titlebar.mpd")
require("ui.systray")

require("signals")
