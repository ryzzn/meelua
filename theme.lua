--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 14:10:25 ryan>
-- Time-stamp: <2012-12-14 22:38:37 ryan>

local beautiful = require("beautiful")
local gears = require("gears")
local awesome = awesome
-- meelua
local o = require("meelua.conf")

mytheme = {
   font = "Terminus 8",
   border_width  = 2,
   border_normal = "#3F3F3F",
   border_focus  = "#6F6F6F",
   border_marked = "#CC9393",
   border_high_focus = "#D2691E",
}

wallpaper = "/home/ryan/personal/wallpapers/november-11-a_clearing_in_the_foggy_forest__5-nocal-1280x800_duclear.jpg"
theme = "/usr/share/awesome/themes/zenburn/theme.lua"

-- Themes define colours, icons, and wallpapers
beautiful.init(theme)
beautiful.get().font = mytheme.font
beautiful["layout_chatright"] = os.getenv("XDG_CONFIG_HOME") .. "/awesome/pic/chat.png"

-- {{{ Wallpaper
if wallpaper
then
   for s = 1, screen.count()
   do
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end
-- }}}

-- {{{ Variable definitions
awesome.font = mytheme.font
return mytheme
