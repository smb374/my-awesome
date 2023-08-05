local awful = require("awful")
local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")
local wibox = require("wibox")

local helpers = require("helpers")

local dpi = G.dpi
local palette = G.palette
local signal_base = G.signal_base

local function text_button(icon, size, color)
  return wibox.widget({
    markup = helpers.colorize_text(icon, color),
    font = "Symbols Nerd Font " .. size,
    widget = widget.textbox,
  })
end

local album_cache = "Unknown"
local artist_cache = "Unknown"
local title_cache = "Unknown"
local play_icon = "󰐊"
local pause_icon = "󰏤"
local repeat_icon = "󰑖"
local single_icon = "󰎤"
local cover_path = ""

local mpd_art = wibox.widget({
  image = "/home/poyehchen/placeholder.png",
  clip_shape = helpers.prrect(dpi(5), false, false, false, true),
  widget = widget.imagebox,
})

local play_butn = text_button(play_icon, 18, palette.text)
local prev_butn = text_button("󰒮", 18, palette.text)
local next_butn = text_button("󰒭", 18, palette.text)
local repeat_butn = text_button(repeat_icon, 18, palette.text)
local single_butn = text_button(single_icon, 18, palette.text)

local control_pane = wibox.widget({
  repeat_butn,
  prev_butn,
  play_butn,
  next_butn,
  single_butn,
  spacing = dpi(8),
  layout = layout.fixed.horizontal,
})

local album_text = wibox.widget({
  markup = helpers.colorize_text("Unknown", palette.text),
  font = "Noto Sans CJK JP Bold 10",
  valign = "center",
  widget = widget.textbox,
})

local artist_text = wibox.widget({
  markup = helpers.colorize_text("Unknown", palette.text),
  font = "Noto Sans CJK JP Regular 9",
  valign = "center",
  widget = widget.textbox,
})

local title_text = wibox.widget({
  markup = helpers.colorize_text("Unknown", palette.text),
  font = "Noto Sans CJK JP Regular 9",
  valign = "center",
  widget = widget.textbox,
})

local rolling = wibox.widget({
  title_text,
  step_function = container.scroll.step_functions.linear_increase,
  speed = 30,
  fps = 60,
  layout = container.scroll.horizontal,
})

rolling:set_extra_space(20)

local mpd_title = wibox.widget({
  halign = "left",
  valign = "center",
  forced_width = dpi(300),
  fill_horizontal = true,
  layout = wibox.container.place,
})

local info_text = wibox.widget({
  album_text,
  mpd_title,
  artist_text,
  spacing = dpi(0),
  layout = layout.fixed.vertical,
})

local list_text = wibox.widget({
  markup = helpers.colorize_text("#--/--", palette.text),
  font = "Fantasque Sans Mono Regular 12",
  halign = "center",
  valign = "center",
  widget = widget.textbox,
})

local tot_time = ""
local cur_time = ""
local time_text = wibox.widget({
  markup = helpers.colorize_text("--:--/--:--", palette.text),
  font = "Fantasque Sans Mono Regular 12",
  halign = "center",
  valign = "center",
  widget = widget.textbox,
})

local set_click_cb = function(w, cb)
  w:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      cb()
    end
  end)
end

local mpd_decorate = function(c)
  local btbar = awful.titlebar(c, { position = "bottom", size = dpi(60), bg = palette.mantle })
  btbar:setup({
    {
      {
        {
          {
            mpd_art,
            halign = "center",
            valign = "center",
            widget = container.place,
          },
          width = dpi(60),
          widget = container.constraint,
        },
        info_text,
        spacing = dpi(10),
        layout = layout.fixed.horizontal,
      },
      control_pane,
      {
        time_text,
        margins = dpi(10),
        widget = container.margin,
      },
      expand = "none",
      layout = layout.align.horizontal,
    },
    halign = "center",
    valign = "center",
    content_fill_horizontal = true,
    widget = container.place,
  })
  c.custom_decoration = { bottom = true, left = true }
end

-- Signals...
signal_base:connect_signal("signal::mpd::cover", function(_, cover)
  cover_path = cover
  mpd_art:set_image(cover)
end)

signal_base:connect_signal("signal::mpd::meta", function(_, album, artist, title, is_playing)
  title = string.gsub(title or "Unknown", "&", "&amp;")
  artist = string.gsub(artist or "Unknown", "&", "&amp;")
  album = string.gsub(album or "Unknown", "&", "&amp;")

  if album ~= album_cache then
    album_cache = album
    album_text.markup = helpers.colorize_text(album, palette.text)
  end
  if artist ~= artist_cache then
    artist_cache = artist
    artist_text.markup = helpers.colorize_text(artist, palette.text)
  end
  if title ~= title_cache then
    title_cache = title
    title_text.markup = helpers.colorize_text(title, palette.text)
  end
  if is_playing then
    play_butn.markup = helpers.colorize_text(pause_icon, palette.text)
  else
    play_butn.markup = helpers.colorize_text(play_icon, palette.text)
  end
  local title_size = title_text:get_preferred_size(1)
  if title_size <= dpi(300) then
    mpd_title:set_widget(title_text)
  else
    mpd_title:set_widget(rolling)
  end
end)

signal_base:connect_signal("signal::mpd::option", function(_, is_repeat, is_single)
  if is_repeat then
    repeat_butn.markup = helpers.colorize_text(repeat_icon, palette.text)
  else
    repeat_butn.markup = helpers.colorize_text(repeat_icon, palette.surface2)
  end
  if is_single then
    single_butn.markup = helpers.colorize_text(single_icon, palette.text)
  else
    single_butn.markup = helpers.colorize_text(single_icon, palette.surface2)
  end
end)

signal_base:connect_signal("signal::mpd::list", function(_, list)
  list_text.markup = helpers.colorize_text(list, palette.text)
end)

signal_base:connect_signal("signal::mpd::time", function(_, ctime)
  cur_time = ctime
  time_text.markup = helpers.colorize_text(cur_time .. "/" .. tot_time, palette.text)
end)

signal_base:connect_signal("signal::mpd::length", function(_, song_length)
  if song_length ~= tot_time then
    tot_time = song_length
    time_text.markup = helpers.colorize_text(cur_time .. "/" .. tot_time, palette.text)
  end
end)

set_click_cb(play_butn, function()
  awful.spawn.easy_async([[mpc toggle]], function(_) end)
end)

set_click_cb(prev_butn, function()
  awful.spawn.easy_async([[mpc prev]], function(_) end)
end)

set_click_cb(next_butn, function()
  awful.spawn.easy_async([[mpc next]], function(_) end)
end)

set_click_cb(repeat_butn, function()
  awful.spawn.easy_async([[mpc repeat]], function(_) end)
end)

set_click_cb(single_butn, function()
  awful.spawn.easy_async([[mpc single]], function(_) end)
end)

set_click_cb(mpd_art, function()
  awful.spawn.easy_async("imv '" .. cover_path .. "'", function(_) end)
end)

table.insert(awful.rules.rules, {
  rule_any = {
    class = {
      "music",
    },
    instance = {
      "music",
    },
  },
  properties = {},
  callback = mpd_decorate,
})
