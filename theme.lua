local palette = G.palette
local dpi = G.dpi

local theme = {}

theme.font = "Fantasque Sans Mono 10"
theme.bg_dark = palette.base
theme.bg_normal = palette.overlay0
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

theme.titlebars_enabled = false

return theme
