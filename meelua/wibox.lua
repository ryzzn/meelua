--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 18:32:21 ryan>
-- Time-stamp: <2013-10-23 16:31:15 ryan>

local wibox = require("wibox")
local awful = require("awful")
-- Notification library
local naughty = require("naughty")
-- vicious
local vicious = require("vicious")
-- meelua
local theme = require("meelua.theme")
local o = require("meelua.conf")
local u = require("meelua.util")
local beautiful = require("beautiful")
local json = require("json")    -- not installed by default in lua 5.2
local lain = require("lain")

terminal = o.terminal

-- Colours
coldef  = "</span>"
colwhi  = "<span color='#b2b2b2'>"
colbwhi = "<span color='#ffffff'>"
blue = "<span color='#7493d2'>"
yellow = "<span color='#e0da37'>"
purple = "<span color='#e33a6e'>"
lightpurple = "<span color='#eca4c4'>"
azure = "<span color='#80d9d8'>"
green = "<span color='#87af5f'>"
lightgreen = "<span color='#62b786'>"
red = "<span color='#e54c62'>"
orange = "<span color='#ff7100'>"
brown = "<span color='#db842f'>"
fuchsia = "<span color='#800080'>"
gold = "<span color='#e7b400'>"

local scriptdir = o.mee_home .. "/scripts"

--{{---| MPD widget |-------------------------------------------------------------------------------
local awesompd = require("awesompd.awesompd")
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
-- font
musicwidget.font = theme.font
-- font color
musicwidget.font_color = '#800080'
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

--{{---| Time clock widget |-------------------------------------------------------------------------------
char_width = nil
text_color = theme.fg_normal or "#FFFFFF"
today_color = theme.fg_focus or "#00FF00"
calendar_width = 21

local calendar = nil
local offset = 0

local data = nil

local function pop_spaces(s1, s2, maxsize)
   local sps = ""
   for i = 1, maxsize - string.len(s1) - string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

local function create_calendar()
   offset = offset or 0

   local now = os.date("*t")
   local cal_month = now.month + offset
   local cal_year = now.year
   if cal_month > 12 then
      cal_month = (cal_month % 12)
      cal_year = cal_year + 1
   elseif cal_month < 1 then
      cal_month = (cal_month + 12)
      cal_year = cal_year - 1
   end

   local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
                                            month = cal_month + 1}) - 86400)
   local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
   local first_day_in_week =
      os.date("%w", first_day)
   local result = "Sun Mon Tue Wes Thu Fri Sat\n"
   for i = 1, first_day_in_week do
      result = result .. "    "
   end

   local this_month = false
   for day = 1, last_day do
      local last_in_week = (day + first_day_in_week) % 7 == 0
      local day_str = pop_spaces("", day, 3) .. (last_in_week and "" or " ")
      if cal_month == now.month and cal_year == now.year and day == now.day then
         this_month = true
         result = result ..
            string.format('<span weight="bold" foreground = "%s">%s</span>',
                          today_color, day_str)
      else
         result = result .. day_str
      end
      if last_in_week and day ~= last_day then
         result = result .. "\n"
      end
   end

   local header
   if this_month then
      header = os.date("%a, %d %b %Y")
   else
      header = os.date("%B %Y", first_day)
   end
   return header, string.format('<span font="%s" foreground="%s">%s</span>',
                                theme.font, text_color, result)
end

local function calculate_char_width()
   return beautiful.get_font_height(theme.font) * 0.555
end

local function hide()
   if calendar ~= nil then
      naughty.destroy(calendar)
      calendar = nil
      offset = 0
   end
end

local function show(inc_offset)
   inc_offset = inc_offset or 0

   local save_offset = offset
   hide()
   offset = save_offset + inc_offset

   local char_width = char_width or calculate_char_width()
   local header, cal_text = create_calendar()
   calendar = naughty.notify({ title = header,
                               text = cal_text,
                               timeout = 0, hover_timeout = 0.5,
                            })
end

myclock = wibox.widget.textbox()
vicious.register(myclock, vicious.widgets.date,
 "<span color='#7788af'> %A %d %B</span> " .. blue .. "</span><span color=\"#343639\">></span> <span color='#de5e1e'>%H:%M</span> ", 60)

myclock:connect_signal("mouse::enter", function() show(0) end)
myclock:connect_signal("mouse::leave", hide)
myclock:buttons(awful.util.table.join(awful.button({ }, 1, function() show(-1) end),
                                      awful.button({ }, 3, function() show(1) end)))

--{{---| WIFI widget |-------------------------------------------------------------------------------
local function wifi_format(wifi_w, args)
    format = ""
    if args["{ssid}"] == "N/A"
    then
      format = azure .. '☯ N/A' .. coldef
    else
       format = azure .. '☯ ${ssid} [${linp}%]' .. coldef
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
mywifi = wibox.layout.margin(_wifi, 4)

--{{---| Weather widget |-------------------------------------------------------------------------------

local function read_json(path)
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

   return '<span font="Terminus 9" color="white">' .. p_city .. p_temp .. '</span>'
end

myweather = wibox.widget.textbox()
-- vicious.register(myweather, vicious.widgets.wifi, weather_format, 10, "wlan0")


--{{---| Battery widget |-------------------------------------------------------------------------------

local _bat = wibox.widget.textbox()
local _bat_icon = wibox.widget.imagebox(beautiful.widget_batt)
local mybat = wibox.layout.fixed.horizontal()
mybat:add(_bat_icon)
mybat:add(_bat)

function batstate()
     local file = io.open("/sys/class/power_supply/BAT0/status", "r")

     if (file == nil) then
          return "Cable plugged"
     end

     local batstate = file:read("*line")
     file:close()

     if (batstate == 'Discharging' or batstate == 'Charging') then
          return batstate
     else
          return "Fully charged"
     end
end

vicious.register(_bat, vicious.widgets.bat,
     function (widget, args)
          -- plugged
          if (batstate() == 'Cable plugged') then return "AC "
          -- critical
          elseif (args[2] <= 5 and batstate() == 'Discharging') then
               naughty.notify({
                    text = "Plz save file and halt your computer!",
                    title = "Battery is eat up!",
                    position = "top_right",
                    timeout = 1,
                    fg="#FFFFFF",
                    bg="#A40004",
                    screen = 1,
                    ontop = true,
               })
          -- low
          elseif (args[2] <= 10 and batstate() == 'Discharging') then
               naughty.notify({
                    text = "Battery is too low [" .. args[2] .. "%]",
                    title = "Battery Warning",
                    position = "top_right",
                    timeout = 1,
                    fg="#FFFFFF",
                    bg="#E73A95",
                    screen = 1,
                    ontop = true,
               })
          end
          return " " .. args[2] .. "%"
     end, 1, 'BAT0')
local mybat = wibox.layout.margin(mybat, 0, 0)

-- CPU widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, purple .. "$1%" .. coldef, 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))
local mycpu = wibox.layout.fixed.horizontal()
mycpu:add(cpuicon)
mycpu:add(cpuwidget)

-- Memory widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, yellow .. "$2M" .. coldef, 1)
local mymem = wibox.layout.fixed.horizontal()
mymem:add(memicon)
mymem:add(memwidget)

-- Temp widget
tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo powertop ", false) end)
    ))
   tempwidget = wibox.widget.textbox()
   vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#f1af5f\">$1°C</span>", 9, {"coretemp.0", "core"} )
local mytemp = wibox.layout.fixed.horizontal()
mytemp:add(tempicon)
mytemp:add(tempwidget)

-- /home fs widget
fshicon = wibox.widget.imagebox()
fshicon:set_image(theme.confdir .. "/widgets/fs.png")
fshwidget = wibox.widget.textbox()
    vicious.register(fshwidget, vicious.widgets.fs,
    function (widget, args)
        if args["{/home used_p}"] >= 95 and args["{/home used_p}"] < 99 then
            return colwhi .. args["{/home used_p}"] .. "%" .. coldef
        elseif args["{/home used_p}"] >= 99 and args["{/home used_p}"] <= 100 then
            naughty.notify({ title = "Attenzione", text = "Partizione /home esaurita!\nFa' un po' di spazio.",
                             timeout = 10,
                             position = "top_right",
                             fg = beautiful.fg_urgent,
                             bg = beautiful.bg_urgent })
            return colwhi .. args["{/home used_p}"] .. "%" .. coldef
        else
            return azure .. args["{/home used_p}"] .. "%" .. coldef
        end
    end, 620)

local infos = nil

function remove_info()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

function add_info()
    remove_info()
    local capi = {
                mouse = mouse,
                screen = screen
          }
    local cal = awful.util.pread(scriptdir .. "/dfs")
    cal = string.gsub(cal, "          ^%s*(.-)%s*$", "%1")
    infos = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "Terminus", cal),
        timeout = 0,
        position = "top_right",
        margin = 10,
        height = 170,
        width = 585,
        screen  = capi.mouse.screen
    })
end

fshwidget:connect_signal('mouse::enter', function () add_info() end)
fshwidget:connect_signal('mouse::leave', function () remove_info() end)

local myfsh = wibox.layout.fixed.horizontal()
myfsh:add(fshicon)
myfsh:add(fshwidget)

--{{---| Net widget |-------------------------------------------------------------------------------

local mynet = wibox.layout.fixed.horizontal()
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
vicious.register(netdowninfo, vicious.widgets.net, green .. "${wlan0 down_kb}" .. coldef, 1)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupicon.align = "middle"
netupinfo = wibox.widget.textbox()
vicious.register(netupinfo, vicious.widgets.net, red .. "${wlan0 up_kb}" .. coldef, 1)
mynet:add(netdownicon)
mynet:add(netdowninfo)
mynet:add(netupicon)
mynet:add(netupinfo)

--{{---| Volume widget |-------------------------------------------------------------------------------

-- ALSA volume bar
local _volumebar = lain.widgets.alsabar({
    ticks  = true,
    width  = 80,
    height = 10,
    channel = "Master",
    colors = {
        background = "#383838",
        unmute     = "#80CCE6",
        mute       = "#FF9F9F"
    },
    notifications = {
        font      = "Tamsyn",
        font_size = "12",
        bar_size  = 32
    }
})
local myvolume = wibox.layout.margin(_volumebar.bar, 5, 8)
wibox.layout.margin.set_top(myvolume, 4)
wibox.layout.margin.set_bottom(myvolume, 4)

--{{---| Mail widget |-------------------------------------------------------------------------------

local _mdir_icon = wibox.widget.textbox()
local _mdir_tome = wibox.widget.textbox()
local _mdir_inbox = wibox.widget.textbox()
_mdir_icon:set_markup(purple .. '✉ ' .. coldef)
vicious.register(_mdir_tome, vicious.widgets.mdir,
                 purple .. 'Mail: $1' .. coldef,
                 10, {"/home/ryan/Mail/Alipay/Tome"})
local mymdir = wibox.layout.fixed.horizontal()
mymdir:add(_mdir_icon)
mymdir:add(_mdir_tome)
mymdir = wibox.layout.margin(mymdir, 4)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}

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
                    if instance then
                        instance:hide()
                        instance = nil
                    else
                        instance = awful.menu.clients(
                            {theme = { width =250 }
                        })
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

for s = 1, screen.count()
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
   mywibox[s] = awful.wibox({ position = "top", screen = s, opacity=1, height=20, border_width = 0 })
   mywibox[s].visible = true

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   -- left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   if s == 1 then left_layout:add(musicwidget.widget) end
   -- left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(u.left_arrow(8, 16, beautiful.bg_normal, "#A0CA99"))
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   right_layout:add(u.right_arrow(8, 16, beautiful.bg_normal, "#A0CA99"))
   right_layout:add(myweather)
   right_layout:add(mycpu)
   right_layout:add(mymem)
   right_layout:add(mytemp)
   right_layout:add(mybat)
   right_layout:add(mynet)
   right_layout:add(myvolume)
   right_layout:add(myfsh)
   right_layout:add(mymdir)
   right_layout:add(mywifi)
   right_layout:add(myclock)
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local top_layout = wibox.layout.align.horizontal()
   top_layout:set_left(left_layout)
   top_layout:set_middle(mytasklist[s])
   if s == 1 then
     top_layout:set_right(right_layout)
   end

   mywibox[s]:set_widget(top_layout)
end
-- }}}
