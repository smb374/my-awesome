local awful = require("awful")
local beautiful = require("beautiful")

-- Determines how floating clients should be placed
local floating_client_placement = function(c)
  -- If the layout is floating or there are no other visible
  -- clients, center client
  if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
    return awful.placement.centered(c, {
      honor_padding = true,
      honor_workarea = true,
    })
  end

  -- Else use this placement
  local p = awful.placement.no_overlap + awful.placement.no_offscreen
  return p(c, {
    honor_padding = true,
    honor_workarea = true,
    margins = beautiful.useless_gap * 2,
  })
end

local universal_rules = {
  rule = {},
  properties = {
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = G.client_bindings.keys,
    buttons = G.client_bindings.buttons,
    -- screen = awful.screen.preferred,
    screen = awful.screen.focused,
    size_hints_honor = false,
    honor_workarea = true,
    honor_padding = true,
    maximized = false,
    titlebars_enabled = beautiful.titlebars_enabled,
    maximized_horizontal = false,
    maximized_vertical = false,
    placement = floating_client_placement,
  },
}

awful.rules.rules = {
  universal_rules,
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "floating_terminal",
        "riotclientux.exe",
        "leagueclientux.exe",
        "Devtools", -- Firefox devtools
        "float_term",
      },
      class = {
        "Gpick",
        "Lxappearance",
        "Nm-connection-editor",
        "File-roller",
        "fst",
        "Nvidia-settings",
        "alacritty_float",
      },
      name = {
        "Event Tester", -- xev
        "MetaMask Notification",
        "PyLNP",
      },
      role = { "AlarmWindow", "pop-up", "GtkFileChooserDialog", "conversation" },
      type = { "dialog" },
    },
    properties = {
      floating = true,
    },
  },
}
