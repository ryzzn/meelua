--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 22:42:45 ryan>
-- Time-stamp: <2012-12-02 23:06:13 ryan>
local awful = require("awful")

-- Redefined Menu keys binding.
awful.menu.menu_keys = { up = { "Up", "k"},
                         down = { "Down", "j"},
                         exec = { "Return", "Right", "l" },
                         back = { "Left", "h"},
                         enter = { "Return" },
                         close = { "Escape", "q" } }

-- -- Create a laucher widget and a main menu
-- myawesomemenu = {
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", awesome.quit }
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })
