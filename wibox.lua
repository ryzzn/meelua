--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 18:32:21 ryan>
-- Time-stamp: <2012-12-29 13:00:44 ryan>

local wibox = require("wibox")
local awful = require("awful")
-- Notification library
local naughty = require("naughty")
local client = client
local print = print
-- vicious
local vicious = require("vicious")
-- meelua
local theme = require("meelua.theme")
local weather = require("meelua.weather")
local equal = require("meelua.equal")
local o = require("meelua.conf")

print(theme.font)

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
mytextclock:set_font(theme.font)
mystar = wibox.widget.imagebox()
-- mystar:set_image("/home/ryan/star.png")

require("awesompd/awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
musicwidget.font = "Liberation Mono" -- Set widget font
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 10 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/ryan/.config/awesome/awesompd/icons"
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks and local tracks will also contain
-- album cover image.
musicwidget.show_album_cover = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
musicwidget.album_cover_size = 50
-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
musicwidget.mpd_config = "/home/ryan/.mpdconf"
-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
musicwidget.browser = "chromium"
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = " "
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
   { server = "localhost",
     port = 6600 },
   { server = "192.168.0.72",
     port = 6600 } }
-- Set the buttons of the widget
musicwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, musicwidget:command_toggle() },
                               { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
                               { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
                               { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
                               { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
                               { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
                               { "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
                               { "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() },
                               { modkey, "Pause", musicwidget:command_playpause() } })
musicwidget:run() -- After all configuration is done, run the widget

-- Create mpd status widget
_mpd = wibox.widget.textbox()
_mpd:set_font(theme.font)
mympd = wibox.layout.margin(_mpd, 4, 4)
vicious.register(_mpd, vicious.widgets.mpd,
                 "<span color='coral'>${Artist}</span>" ..
                    " - <span color='yellowgreen'>${Title}</span>", 10)

-- Create wifi status widget
_wifi = wibox.widget.textbox()
_wifi:set_font(theme.font)
mywifi = wibox.layout.margin(_wifi, 4, 4)
vicious.register(_wifi, vicious.widgets.wifi,
                 "WIFI: ${ssid}{${linp}%}", 10, "wlan0")

-- Create battery status widget
_bat = wibox.widget.textbox()
_bat:set_font(theme.font)
mybat = wibox.layout.margin(_bat, 4, 4)
vicious.register(_bat, vicious.widgets.bat,
                 "<span color=\"lightblue\">Bat</span>:" ..
                    " {<span color=\"red\">$1</span> $2%" ..
                    " <span color=\"brown\">$3</span>}", 10, "BAT0")

-- Create volume status widget
_volume = wibox.widget.textbox()
_volume:set_font(theme.font)
myvolume = wibox.layout.margin(_volume, 4, 4)
myvolume_v = vicious.register(_volume,
                            vicious.widgets.volume, "$1 $2", 10, "Master")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
myweather = weather()
myweather:set_font(theme.font)

check_bat = timer({ timeout = 10 })
check_bat:connect_signal("timeout",
                         function ()
                            local now = vicious.widgets.bat("", "BAT0")
                            bat_per = tonumber(now[2])
                            bat_stat = now[1]
                            if bat_per < 10 and bat_stat ~= '+' then
                               naughty.notify({preset = naughty.config.presets.critical,
                                               title = "WARN",
                                               text = "battery is lower than 10%..."
                                              })
                            end
                         end)
check_bat:start()


mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1,
                function (c)
                   if c == client.focus
                   then
                      c.minimized = true
                   else
                      -- Without this, the following
                      -- :isvisible() makes no sense
                      c.minimized = false
                      if not c:isvisible()
                      then
                         awful.tag.viewonly(c:tags()[1])
                      end
                      -- This will also un-minimize
                      -- the client, if needed
                      client.focus = c
                      c:raise()
                   end
                end),
   awful.button({ }, 3,
                function ()
                   if instance
                   then
                      instance:hide()
                      instance = nil
                   else
                      instance = awful.menu.clients({ width=250 })
                   end
                end),
   awful.button({ }, 4,
                function ()
                   awful.client.focus.byidx(1)
                   if client.focus then client.focus:raise() end
                end),
   awful.button({ }, 5,
                function ()
                   awful.client.focus.byidx(-1)
                   if client.focus then client.focus:raise() end
                end))

screen_cnt = 1;              -- screen.count()
for s = 1, screen_cnt
do
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(o.layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(o.layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(o.layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(o.layouts, -1) end)))

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s, opacity=0.8, height=38 })
   mywibox[s].visible = true

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   -- left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   -- left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   right_layout:add(mytextclock)
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local top_layout = wibox.layout.align.horizontal()
   top_layout:set_left(left_layout)
   top_layout:set_middle(mytasklist[s])
   top_layout:set_right(right_layout)

   local bottom_layout = wibox.layout.fixed.horizontal()
   bottom_layout:add(mystar)
   bottom_layout:add(myweather)
   bottom_layout:add(mybat)
   bottom_layout:add(myvolume)
   bottom_layout:add(musicwidget.widget)
   bottom_layout:add(mywifi)

   local layout = equal.two()
   layout:set_first(top_layout)
   layout:set_second(bottom_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

