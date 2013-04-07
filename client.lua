--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 18:54:43 ryan>
-- Time-stamp: <2013-04-08 00:16:19 ryan>

local awful = require("awful")
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
     properties = { border_width = theme.border_width,
        border_color = theme.border_normal,
        focus = awful.client.focus.filter,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false,
        skip_taskbar = false } },
   { rule = {class = "URxvt" },
     properties = { border_width = 10,
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
   { rule = { class = "Pidgin" },
     properties = { floating = false,
                    tag = tags[1][5],} },
   { rule = { class = "Openfetion" },
     properties = { floating = true,
                    tag = tags[1][4],} },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   { rule = { class = "Emacs" },
     properties = { tag = tags[1][2],
                    switchtotag = true}},
   { rule = { class = "Chromium" },
     properties = { tag = tags[1][3],
                    maximized_vertical = true,
                    maximized_horizontal = true}},
   { rule = { class = "AliWangWang" },
     properties = { tag = tags[1][4] }},
   { rule = { class = "AliWangWang",
              name = "ScreenCapturePainter" },
     properties = { floating = true,
                    ontop = true, } },
   { rule = { class = "AliWangWang",
              name = "系统通知" },
     properties = { floating = true,
                    ontop = true, } },
   { rule = { name = o.mpc_client },
     properties = { tag = tags[1][10] }},
   -- { rule = { name = "lyricshow" },
   --   properties = { opacity = 0 }},
   -- for chromium popups
   { rule = { instance = "exe" },
     properties = { floating = true } },
   -- { rule = { class = "Mail" },
   --   properties = { tag = tags[1][4],
   --                  maximazied_vertical = true,
   --      	    maximazied_horizontal = true}},
   -- { rule = { class = "Mail" },
   --   properties = { tag = tags[1][5],
   --                  floating = true}},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
                      function (c, startup)
                         -- Enable sloppy focus
                         -- c:connect_signal("mouse::enter",
                         --                  function(c)
                         --                     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         --                        and  awful.client.focus.filter(c)
                         --                     then
                         --                        client.focus = c
                         --                     end
                         --                  end)

                         if not startup
                         then
                            -- Set the windows at the slave,
                            -- i.e. put it at the end of others instead of setting it master.
                            -- awful.client.setslave(c)

                            -- Put windows in a smart way, only if they does not set an initial position.
                            if not c.size_hints.user_position
                               and not c.size_hints.program_position
                            then
                               awful.placement.no_overlap(c)
                               awful.placement.no_offscreen(c)
                            end
                         end
                      end)

client.connect_signal("focus",
                      function(c)
                         if c.class and string.match(c.class, "URxvt")
                         then
                            c.border_color = theme.border_high_focus
                         else
                            c.border_color = theme.border_focus
                         end
                         -- c.opacity = 0.7
                      end)
client.connect_signal("unfocus",
                      function(c)
                         c.border_color = theme.border_normal
                         -- c.opacity = 0.7
                      end)
-- }}}

