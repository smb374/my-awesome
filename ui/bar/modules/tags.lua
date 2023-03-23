local awful = require("awful")
local helpers = require("helpers")

local container = require("wibox.container")
local layout = require("wibox.layout")
local widget = require("wibox.widget")

local animation = require("modules.animation")
local dpi = G.dpi

return function(s)
  local taglist = awful.widget.taglist({
    layout = {
      spacing = dpi(8),
      layout = layout.fixed.vertical,
    },
    style = {
      shape = helpers.rrect(50),
    },
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({}, 1, function(t)
        t:view_only()
      end),
      awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
      end),
      awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
      end),
    },
    widget_template = {
      {
        widget = widget.textbox,
        markup = "",
        shape = helpers.rrect(20),
      },
      id = "background_role",
      widget = container.background,
      forced_width = dpi(10),
      forced_height = dpi(10),
      create_callback = function(self, tag)
        self.taganim = animation:new({
          duration = 0.12,
          easing = animation.easing.linear,
          update = function(_, pos)
            self:get_children_by_id("background_role")[1].forced_height = pos
          end,
        })
        self.update = function()
          if tag.selected then
            self.taganim:set(30)
          elseif #tag:clients() > 0 then
            self.taganim:set(10)
          else
            self.taganim:set(10)
          end
        end

        self.update()
      end,
      update_callback = function(self)
        self.update()
      end,
    },
  })
  return taglist
end
