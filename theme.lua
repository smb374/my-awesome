local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local palette = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

local theme = {}

theme.font = "JetBrains Mono 10"
theme.bg_dark = palette.base
theme.bg_normal = palette.base
theme.bg_focus = palette.lavender
theme.bg_urgent = palette.red
theme.bg_minimize = palette.base
theme.bg_systray = palette.base

theme.fg_normal = palette.text
theme.fg_focus = palette.overlay0
theme.fg_urgent = palette.overlay0
theme.fg_minimize = palette.text

theme.useless_gap = dpi(5)
theme.screen_margin = dpi(5)
theme.border_width = dpi(2)
theme.border_color_normal = palette.overlay0
theme.border_color_active = palette.lavender
theme.border_radius = dpi(5)

-- taglist
theme.taglist_bg_empty = palette.surface0
theme.taglist_bg_occupied = palette.overlay0
theme.taglist_bg_focus = palette.lavender
theme.taglist_bg_urgent = palette.red
theme.taglist_disable_icon = true

theme.titlebars_enabled = false

theme.icon_theme = "/usr/share/icons/Papirus-Dark"

return theme
