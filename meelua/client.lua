--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 18:54:43 ryan>
-- Time-stamp: <2015-01-27 00:50:46 ryan>

local awful = require("awful")
local wibox = require("wibox")
local rules = require("awful.rules")
-- meelua
local theme = require("meelua.theme")
local o = require("meelua.conf")
local client = client
-- auto focus
require("awful.autofocus")

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- {{{ Rules
rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = {
        border_width = theme.border_width,
        border_color = theme.border_normal,
        focus = awful.client.focus.filter,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false,
        skip_taskbar = false } },
   { rule = {class = "URxvt" },
     properties = { border_width = 1,
                    opacity = 1 } },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   { rule_any = { class = {"feh", "Display"},
                  name = {"feh", "display"} },
     properties = { floating = true,
                    callback = function (c) awful.placement.centered(c) end } },
   { rule = { class = "Conky" },
     properties = { floating = true,
                    size_hits_honor = false,
                    border_width = 0,
                    keys = nil,
                    buttons = nil} },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   { rule = { class = "Emacs" },
     properties = { tag = tags.emacs,
                    switchtotag = true}},
   { rule = { class = "chromium",
              type = "dialog" },
     properties = { tag = tags.web,
                    floating = true,
                    callback = function (c) awful.placement.centered(c) end } },
   { rule = { class = "chromium",
              type = "normal",
              role = "browser" },
     properties = { tag = tags.web,
                    maximized_vertical = true,
                    maximized_horizontal = true}},
   { rule = { class = "chromium",
              role = "app" },
     properties = { floating = true,
                    ontop = true,
                    tag = tags.web }},
   { rule = { class = "AliWangWang" },
     properties = { tag = tags.wangwang,
                    opacity = 0.95 }},
   { rule = { class = "AliWangWang",
              name = "^阿里旺旺$"    },
     properties = { tag = tags.wangwang,
                    opacity = 0.95,
                    floating = true,
                    height = 600,
                    width = 300,
                    callback = function (c) awful.placement.centered(c) end
                    }},
   { rule = { class = "AliWangWang",
              name = "ScreenCapturePainter" },
     properties = { floating = true,
                    ontop = true, } },
   { rule = { class = "AliWangWang",
              name = "系统通知" },
     properties = { floating = true,
                    ontop = true, } },
   { rule = { class= "Docky",
              name = "Docky"},
     properties = { ontop = true } },
   { rule = { name = o.mpc },
     properties = { tag = tags.mpc,
                    switchtotag = true}},
   { rule = { name = "^" .. o.mail .. "$"},
     properties = { tag = tags.mail,
                    switchtotag = true}},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = (c.class == "AliWangWang")
    if titlebars_enabled then c.border_width = 2 end
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end

    if c.name == o.mpc or c.name == o.mail
    then
      c:connect_signal("unmanage",
      function(c)
          if mouse.screen == c.screen then
              awful.tag.history.restore()
          else
              old_screen = mouse.screen
              mouse.screen = c.screen
              awful.tag.history.restore()
              mouse.screen = old_screen
          end
      end)
    end
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",
                      function(c)
                         if c.class and (string.match(c.class, "URxvt") or c.class == "AliWangWang")
                         then
                            c.border_color = theme.border_high_focus
                         else
                            c.border_color = theme.border_focus
                         end
                         myline[c.screen]:focus()
                         awful.screen.focus(c.screen)
                         -- c.opacity = 0.7
                      end)

client.connect_signal("unfocus",
                      function(c)
                         c.border_color = theme.border_normal
                         myline[c.screen]:unfocus()
                         -- c.opacity = 0.7
                      end)
-- }}}
