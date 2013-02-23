--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 14:10:25 ryan>
-- Time-stamp: <2012-12-30 12:29:43 ryan>

local beautiful = require("beautiful")
local gears = require("gears")
local awesome = awesome
-- meelua
local o = require("meelua.conf")

mytheme = {
   theme = o.theme,
   wallpaper = o.wallpaper,
   font = "Terminus 8",
   border_width  = 2,
   border_normal = "#3F3F3F",
   border_focus  = "#6F6F6F",
   border_marked = "#CC9393",
   border_high_focus = "#D2691E",
}

-- Themes define colours, icons, and wallpapers
beautiful.init(mytheme.theme)
beautiful.get().font = mytheme.font
beautiful["layout_chatright"] = os.getenv("XDG_CONFIG_HOME") .. "/awesome/pic/chat.png"

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
