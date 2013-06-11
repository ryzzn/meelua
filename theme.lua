--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 14:10:25 ryan>
-- Time-stamp: <2013-06-11 23:53:37 ryan>

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local awesome = awesome
-- meelua
local o = require("meelua.conf")

mytheme = {
   theme = o.theme,
   wallpaper = o.wallpaper,
   font = o.font,
   border_width  = 0,
   border_normal = "#3F3F3F",
   border_focus  = "#6F6F6F",
   border_marked = "#CC9393",
   border_high_focus = "#D2691E",
}

-- Themes define colours, icons, and wallpapers
beautiful.init(mytheme.theme)
beautiful.get().font = mytheme.font
mytheme.confdir = beautiful.get().confdir
beautiful["layout_chatright"] = o.mee_home .. "/pic/wangwang.png"
beautiful["icon_battery"] = o.mee_home .. "/pic/icon_battery.png"
beautiful["icon_net"] = o.mee_home .. "/pic/icon_net.png"

-- {{{ Wallpaper
if mytheme.wallpaper
then
   for s = 1, screen.count()
   do
      gears.wallpaper.maximized(mytheme.wallpaper, s, true)
   end
end
-- }}}

-- {{{ Variable definitions
awesome.font = mytheme.font
return mytheme
