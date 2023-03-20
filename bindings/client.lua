local awful = require("awful")
local bindings = {}

local supr = "Mod4"
local ctrl = "Control"
local shft = "Shift"

bindings.keys = {
  -- Set master
  awful.key({ supr, ctrl }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),

  -- Change client opacity
  awful.key({ ctrl, supr }, "o", function(c)
    c.opacity = c.opacity - 0.1
  end, { description = "decrease client opacity", group = "client" }),
  awful.key({ supr, shft }, "o", function(c)
    c.opacity = c.opacity + 0.1
  end, { description = "increase client opacity", group = "client" }),

  -- P for pin: keep on top OR sticky
  -- On top
  awful.key({ supr, shft }, "p", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),
  -- Sticky
  awful.key({ supr, ctrl }, "p", function(c)
    c.sticky = not c.sticky
  end, { description = "toggle sticky", group = "client" }),

  -- Minimize
  awful.key({ supr }, "n", function(c)
    c.minimized = true
  end, { description = "minimize", group = "client" }),

  -- Maximize
  awful.key({ supr }, "m", function(c)
    c.maximized = not c.maximized
  end, { description = "(un)maximize", group = "client" }),
  awful.key({ supr, ctrl }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { description = "(un)maximize vertically", group = "client" }),
  awful.key({ supr, shft }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, { description = "(un)maximize horizontally", group = "client" }),
  awful.key({ supr, shft }, "q", function(c)
    c:kill()
  end, { description = "kill focused client", group = "client" }),
  awful.key({ supr }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
}

bindings.buttons = {
  awful.button({}, 1, function(c)
    client.focus = c
  end),
  awful.button({ supr }, 1, awful.mouse.client.move),
  -- awful.button({ supr }, 2, function (c) c:kill() end),
  awful.button({ supr }, 3, function(c)
    client.focus = c
    awful.mouse.client.resize(c)
    -- awful.mouse.resize(c, nil, {jump_to_corner=true})
  end),

  -- Super + scroll = Change client opacity
  awful.button({ supr }, 4, function(c)
    c.opacity = c.opacity + 0.1
  end),
  awful.button({ supr }, 5, function(c)
    c.opacity = c.opacity - 0.1
  end),
}

return bindings
