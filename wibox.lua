--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 18:32:21 ryan>
-- Time-stamp: <2013-05-15 22:45:26 ryan>

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
-- local weather = require("meelua.weather")
local blingbling = require("blingbling")
local equal = require("meelua.equal")
local o = require("meelua.conf")
local u = require("meelua.util")
local beautiful = require("beautiful")
local json = require("json")	-- not installed by default in lua 5.2

--{{---| MPD widget |-------------------------------------------------------------------------------
require("awesompd/awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
-- musicwidget.font = awesome.font
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

--{{---| WIFI widget |-------------------------------------------------------------------------------

local function wifi_format(wifi_w, args)
    format = ""
    if args["{ssid}"] == "N/A"
    then
      format = '<span font="Terminus 12" bgcolor="FloralWhite"> ☯ <span font="Terminus 9" color="red">N/A</span> </span>'
    else
       format = '<span font="Terminus 12" bgcolor="FloralWhite"> ☯ <span font="Terminus 9">${ssid} [${linp}%]</span> </span>'
    end
    for var, val in pairs(args) do
        format = format:gsub("$" .. (tonumber(var) and var or
            var:gsub("[-+?*]", function(i) return "%"..i end)),
        val)
    end

    return format
end

_wifi = wibox.widget.textbox()
vicious.register(_wifi, vicious.widgets.wifi,
                 wifi_format, 10, "wlan0")
mywifi = _wifi

--{{---| Weather widget |-------------------------------------------------------------------------------

local function read_json (path)
   if not awful.util.file_readable(path)
   then
      return nil
   end
   local file = io.open(path)
   local weather_info = file:read()
   local weather_o = json.decode(weather_info)
   -- return if file not match json form
   if weather_o == nil
      or weather_o.weatherinfo == nil
   then
      return nil
   end
   return weather_o
end

local function weather_format(w, args)
   obj = read_json("/home/ryan/data/weather.json")
   if nil == obj then return end
   weatherinfo = obj.weatherinfo

   local p_city = ' <span color="white">' .. weatherinfo.city .. '</span>'.. ' <span color="yellow">' .. weatherinfo.weather1 .. '</span>'
   local p_temp = ' ' .. weatherinfo.temp1 .. ' '

   return '<span font="Terminus 9" color="white" bgcolor="#A0CA99">' .. p_city .. p_temp .. '</span>'
end

myweather = wibox.widget.textbox()
vicious.register(myweather, vicious.widgets.wifi, weather_format, 10, "wlan0")

--{{---| Battery widget |-------------------------------------------------------------------------------

local _bat = wibox.widget.textbox()
local _bat_icon = wibox.widget.imagebox(beautiful.icon_battery)
local mybat = wibox.layout.fixed.horizontal()
mybat:add(_bat_icon)
mybat:add(_bat)
vicious.register(_bat, vicious.widgets.bat,
  '<span background="#92B0A0" font="Terminus 12"> <span font="Terminus 9" color="#FFFFFF" background="#92B0A0">$1$2% </span></span>', 1, "BAT0" )
-- mybat = wibox.layout.margin(_bat, 4, 4)

--{{---| Net widget |-------------------------------------------------------------------------------

local _net = wibox.widget.textbox()
local _net_icon = wibox.widget.imagebox(beautiful.icon_net)
local mynet = wibox.layout.fixed.horizontal()
local _net_dev = io.popen('ip route list match 0 | cut -d" " -f 5'):read()
local _net_ip = io.popen("ip route get 1.1.1.1 | head -n 1 | awk '{print $NF}'"):read()
mynet:add(_net_icon)
mynet:add(_net)
vicious.register(_net, vicious.widgets.net,
                 string.format(
                 '<span background="#C2C2A4" font="Terminus 12">'
                 .. ' <span font="Terminus 9" color="#FFFFFF">${%s down_kb}'
                 .. ' ↓↑ ${%s up_kb} [%s]</span> </span>',
                 _net_dev, _net_dev, _net_ip), 3)

--{{---| Volume widget |-------------------------------------------------------------------------------

local _volume = wibox.widget.textbox()
myvolume_v = vicious.register(_volume, vicious.widgets.volume,
      '<span bgcolor="Gainsboro"> <span font="monospace" font_weight="bold">♫ </span>$1 $2 </span>', 10, "Master")
-- _volume:set_font(theme.font)
local myvolume = _volume;

--{{---| Mail widget |-------------------------------------------------------------------------------

local _mdir_icon = wibox.widget.textbox()
local _mdir_tome = wibox.widget.textbox()
local _mdir_inbox = wibox.widget.textbox()
_mdir_icon:set_markup('<span bgcolor="Khaki" font="Terminus 12"> ✉ </span>')
vicious.register(_mdir_tome, vicious.widgets.mymdir,
                 '<span bgcolor="Khaki" font="Terminus 12"><span font="Terminus 9">ToMe: <span color="red">$1</span></span> </span>',
                 10, {"/home/ryan/Mail/Alipay/Tome"})
vicious.register(_mdir_inbox, vicious.widgets.mymdir,
                 '<span bgcolor="Khaki" font="Terminus 12"><span font="Terminus 9">Inbox: <span color="red">$2</span></span> </span>',
                 10, {"/home/ryan/Mail/Alipay/Inbox"})
local mymdir = wibox.layout.fixed.horizontal()
mymdir:add(_mdir_icon)
mymdir:add(_mdir_tome)
mymdir:add(_mdir_inbox)

--{{---| Time clock widget |-------------------------------------------------------------------------------
myclock = wibox.widget.textbox()
vicious.register(myclock, vicious.widgets.date,
 '<span font="Terminus 12" bgcolor="#BACCBA" fgcolor="#FFFFFF"> <span font="Terminus 9">%a %b %d, %H:%M</span> </span>', 60)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}

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
   -- mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons)
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s, opacity=0.8, height=16 })
   mywibox[s].visible = true

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   -- left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   -- left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(u.arrow(8, 16, beautiful.bg_normal, "#A0CA99"))
   right_layout:add(myweather)
   right_layout:add(u.arrow(8, 16, "#A0CA99", "#92B0A0"))
   right_layout:add(mybat)
   right_layout:add(u.arrow(8, 16, "#92B0A0", "#C2C2A4"))
   right_layout:add(mynet)
   right_layout:add(u.arrow(8, 16, "#C2C2A4", "#DCDCDC"))
   right_layout:add(myvolume)
   right_layout:add(u.arrow(8, 16, "#DCDCDC", "#F0E68C"))
   right_layout:add(mymdir)
   right_layout:add(u.arrow(8, 16, "#F0E68C", "#FFFAF0"))
   right_layout:add(mywifi)
   right_layout:add(u.arrow(8, 16, "#FFFAF0", "#2F4F4F"))
   right_layout:add(musicwidget.widget)
   right_layout:add(u.arrow(8, 16, "#2F4F4F", beautiful.bg_normal))
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   right_layout:add(u.arrow(8, 16, beautiful.bg_normal, "#BACCBA"))
   right_layout:add(myclock)
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local top_layout = wibox.layout.align.horizontal()
   top_layout:set_left(left_layout)
   top_layout:set_middle(mytasklist[s])
   top_layout:set_right(right_layout)

   local bottom_layout = wibox.layout.fixed.horizontal()
   bottom_layout:add(myweather)
   bottom_layout:add(mybat)
   bottom_layout:add(myvolume)
   bottom_layout:add(musicwidget.widget)
   bottom_layout:add(mywifi)

   local layout = equal.two()
   layout:set_first(top_layout)
   layout:set_second(bottom_layout)

   mywibox[s]:set_widget(top_layout)
end
-- }}}

