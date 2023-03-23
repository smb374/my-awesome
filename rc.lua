G = {}
pcall(jit.on)

require("awful.autofocus")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

require("def")
require("user")

beautiful.init("/home/poyehchen/.config/awesome/theme.lua")
naughty:connect_signal("request::display_error", function(msg, startup)
  naughty.notification({
    urgency = "crutial",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = msg,
  })
end)

require("bindings")

awful.layout.layouts = { awful.layout.suit.tile, awful.layout.suit.floating, awful.layout.suit.max }

local function set_wallpaper(_)
  local wallpaper = G.user.wallpaper
  if wallpaper then
    awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
  end
end

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
  local l = awful.layout.suit
  local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8" }
  awful.tag(tagnames, s, l.tile)
end)

screen.connect_signal("property::geometry", set_wallpaper)

client.connect_signal("mouse::enter", function(c)
  c:activate({ context = "mouse_enter", raise = false })
end)

require("rules")

require("ui.bar")

require("signals")
