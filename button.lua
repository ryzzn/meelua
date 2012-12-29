--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 22:40:35 ryan>
-- Time-stamp: <2012-12-02 23:03:20 ryan>
local awful = require("awful")
local root = root

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                awful.button({ }, 3, function () awful.util.spawn(o.terminal) end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
                                  ))
-- }}}
