local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

local user = G.user

local supr = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shft = "Shift"

local client_keys = gears.table.join(
  -- Focus client by direction
  awful.key({ supr }, "j", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus down", group = "client" }),
  awful.key({ supr }, "k", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus up", group = "client" }),
  awful.key({ supr }, "h", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus left", group = "client" }),
  awful.key({ supr }, "l", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus right", group = "client" }),
  awful.key({ supr }, "Down", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus down", group = "client" }),
  awful.key({ supr }, "Up", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus up", group = "client" }),
  awful.key({ supr }, "Left", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus left", group = "client" }),
  awful.key({ supr }, "Right", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus right", group = "client" }),

  awful.key({ supr }, "z", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ supr, shft }, "z", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus next by index", group = "client" }),

  awful.key({ supr, alt }, "q", function()
    local clients = awful.screen.focused().clients
    for _, c in pairs(clients) do
      c:kill()
    end
  end, { description = "kill all visible clients for the current tag", group = "client" }),

  awful.key({ supr }, "u", function()
    local uc = awful.client.urgent.get()
    -- If there is no urgent client, go back to last tag
    if uc == nil then
      awful.tag.history.restore()
    else
      awful.client.urgent.jumpto()
    end
  end, { description = "jump to urgent client", group = "client" }),

  awful.key({ supr, ctrl }, "space", function()
    local layout_is_floating = (awful.layout.get(mouse.screen) == awful.layout.suit.floating)
    if not layout_is_floating then
      awful.client.floating.toggle()
    end
  end, { description = "toggle floating", group = "client" })
)

local layout_keys = gears.table.join(
  awful.key({ supr, alt }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ supr, alt }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ supr, alt }, "Left", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ supr, alt }, "Right", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),

  -- Number of columns
  awful.key({ supr, alt }, "k", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ supr, alt }, "j", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ supr, alt }, "Up", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ supr, alt }, "Down", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" })
)

local tag_keys = gears.table.join(
  awful.key({ supr }, "x", function()
    awful.tag.history.restore()
  end, { description = "go back", group = "tag" }),
  -- Max layout
  -- Single tap: Set max layout
  -- Double tap: Also disable floating for ALL visible clients in the tag
  awful.key({ supr }, "w", function()
    awful.layout.set(awful.layout.suit.max)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, { description = "set max layout", group = "tag" }),
  -- Tiling
  -- Single tap: Set tiled layout
  -- Double tap: Also disable floating for ALL visible clients in the tag
  awful.key({ supr }, "s", function()
    awful.layout.set(awful.layout.suit.tile)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, { description = "set tiled layout", group = "tag" }),
  -- Set floating layout
  awful.key({ supr, shft }, "s", function()
    awful.layout.set(awful.layout.suit.floating)
  end, { description = "set floating layout", group = "tag" })
)

local ntags = 8
for i = 1, ntags do
  tag_keys = gears.table.join(
    tag_keys,
    awful.key({ supr }, "#" .. i + 9, function()
      helpers.tag_back_and_forth(i)
    end, { description = "view tag #" .. i, group = "tag" }),
    awful.key({ supr, shft }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, { description = "move focused client to tag #" .. i, group = "tag" }),
    awful.key({ supr, alt }, "#" .. i + 9, function()
      local tag = client.focus.screen.tags[i]
      local clients = awful.screen.focused().clients
      if tag then
        for _, c in pairs(clients) do
          c:move_to_tag(tag)
        end
        tag:view_only()
      end
    end, { description = "move all visible clients to tag #" .. i, group = "tag" })
  )
end

local launcher_keys = gears.table.join(
  awful.key({ supr }, "Return", function()
    awful.spawn(user.terminal)
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ supr, shft }, "Return", function()
    awful.spawn(user.floating_terminal, { floating = true })
  end, { description = "spawn floating terminal", group = "launcher" }),
  awful.key({ supr }, "d", function()
    awful.spawn.with_shell("rofi -matching fuzzy -show combi")
  end, { description = "rofi launcher", group = "launcher" })
)

local wm_keys = gears.table.join(
  awful.key({ supr, shft }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ supr, shft }, "x", awesome.quit, { description = "quit awesome", group = "awesome" })
)

local keys = gears.table.join(client_keys, layout_keys, tag_keys, launcher_keys, wm_keys)

root.keys(keys)
