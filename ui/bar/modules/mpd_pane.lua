local awful = require("awful")
local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local ibar = require("ui.bar.modules.ibar")
local helpers = require("helpers")

local dpi = G.dpi
local palette = G.palette
local signal_base = G.signal_base

local tooltip = awful.tooltip()

local album_cache = "Unknown"
local artist_cache = "Unknown"
local title_cache = "Unknown"

local play_icon = "󰐊"
local pause_icon = "󰏤"

local mpd_art = wibox.widget({
  image = "/home/poyehchen/placeholder.png",
  clip_shape = helpers.rrect(5),
  widget = widget.imagebox,
})

local play_butn = wibox.widget({
  markup = play_icon,
  font = "Symbols Nerd Font Mono 12",
  widget = widget.textbox,
})

local prev_butn = wibox.widget({
  markup = "󰅃",
  font = "Symbols Nerd Font Mono 12",
  widget = widget.textbox,
})

local next_butn = wibox.widget({
  markup = "󰅀",
  font = "Symbols Nerd Font Mono 12",
  widget = widget.textbox,
})

local pane = ibar.ibar_custom({
  prev_butn,
  play_butn,
  next_butn,
  layout = layout.fixed.vertical,
}, palette.sky)

local mpd = wibox.widget({
  {
    {

      {
        mpd_art,
        halign = "center",
        valign = "center",
        widget = container.place,
      },
      width = dpi(32),
      widget = container.constraint,
    },
    {
      pane,
      margins = {
        top = dpi(5),
        bottom = dpi(5),
      },
      widget = container.margin,
    },
    layout = layout.fixed.vertical,
  },
  shape = helpers.rrect(5),
  bg = palette.base,
  widget = container.background,
})

tooltip:add_to_object(mpd_art)

signal_base:connect_signal("signal::mpd::cover", function(_, cover)
  mpd_art:set_image(cover)
end)

signal_base:connect_signal("signal::mpd::meta", function(_, album, artist, title, is_playing)
  if album ~= album_cache then
    album_cache = album
  end
  if artist ~= artist_cache then
    artist_cache = artist
  end
  if title ~= title_cache then
    title_cache = title
  end
  if is_playing then
    play_butn.markup = helpers.colorize_text(pause_icon, palette.text)
  else
    play_butn.markup = helpers.colorize_text(play_icon, palette.text)
  end
end)

signal_base:connect_signal("signal::mpd::progress", function(_, progress)
  pane.get_bar().value = progress
end)

mpd_art:connect_signal("mouse::enter", function()
  tooltip.text = "Now Playing: " .. artist_cache .. " - " .. title_cache .. ", " .. album_cache
end)

play_butn:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn([[mpc toggle]])
  end
end)

prev_butn:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn([[mpc prev]])
  end
end)

next_butn:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn([[mpc next]])
  end
end)

return mpd
