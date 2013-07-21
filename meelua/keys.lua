-- Author: Yudi Shi <a@sydi.org>
-- Create: <2012-12-02 14:10:25 ryan>
-- Time-stamp: <2013-07-21 22:51:17 ryan>

local o = require("meelua.conf")
local awful = require("awful")
local menubar = require("menubar")
local root = root

-- Default modkey.
modkey = "Mod4"

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = o.terminal
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   -- awesome quit & restart
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, ";",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right", awful.tag.viewnext        ),
   awful.key({ modkey,           }, "'", awful.tag.viewnext        ),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus
                then
                   client.focus:raise()
                end
             end),
   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus
                then
                   client.focus:raise()
                end
             end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus
                then
                   client.focus:raise()
                end
             end),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

   awful.key({ modkey,           }, "space", function () awful.layout.inc(o.layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(o.layouts, -1) end),

   awful.key({ modkey, "Shift" }, "n", awful.client.restore),


   -- start program
   awful.key({ modkey,           }, "Return", function () awful.util.spawn(o.terminal) end),

   -- Menubar
   awful.key({ modkey }, "p", function() menubar.show() end),

   -- toggle wibox
   awful.key({ modkey,           }, "b",
             function ()
                mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
             end),

   -- take screenshot
   awful.key({modkey, }, "s", false,
             function ()
                awful.util.spawn("scrot -e 'mv $f " .. o.screenshots_dir .. " 2>/dev/null'")
             end),
   awful.key({modkey, "Control"}, "s", false,
             function ()
                awful.util.spawn("scrot -s -e 'mv $f " .. o.screenshots_dir .. " 2>/dev/null'")
             end),

   awful.key({modkey, }, "a", function ()
                awful.util.spawn("sh -c 'cd ~ && ./a.out'")
             end),
   awful.key({modkey, "Control"}, "a", function ()
                awful.util.spawn("sh -c 'killall a.out'")
             end),
   -- screen saver
   awful.key({ modkey, }, "`", function () awful.util.spawn("xscreensaver-command -lock") end),

   -- audio sound control
   awful.key({}, "XF86AudioRaiseVolume", function () io.popen("amixer sset Master 5+"):close() myvolume_v.update() end),
   awful.key({}, "XF86AudioLowerVolume", function () io.popen("amixer sset Master 5-"):close() myvolume_v.update() end),
   awful.key({}, "XF86AudioMute", function () io.popen("amixer sset Master toggle"):close() myvolume_v.update() end),
   awful.key({modkey}, ",",
             function ()
                io.popen("amixer sset Master 5-"):close()
                myvolume_v.update()
             end),
   awful.key({modkey}, ".",
             function ()
                io.popen("amixer sset Master 5+"):close()
                myvolume_v.update()
             end),
   awful.key({modkey}, "/",
             function ()
                io.popen("amixer sset Master toggle"):close()
                myvolume_v.update()
             end),

   awful.key({modkey, "Control"}, "n",
             function ()
                io.popen("mpc next"):close()
             end),
   awful.key({modkey, "Control"}, "p",
             function ()
                io.popen("mpc toggle"):close()
             end),

   -- mpc client show.
   awful.key({ modkey, "Control"  }, "m",
             function ()
                -- raise mpc_client if it's ran.
                for k, c in pairs(client.get())
                do
                   if c.name == nil then goto continue end
                   local name = string.lower(c.name)
                   if string.match(name, o.mpc)
                   then
                      for i, v in ipairs(c:tags())
                      do
                         awful.tag.viewonly(v)
                         c:raise()
                         c.minimized = false
                         return
                      end
                   end
                   ::continue::
                end
                -- if there's no mpc_client running, just run it.
                awful.util.spawn(string.format("%s -e %s", terminal, o.mpc))
             end),

   awful.key({ modkey,  "Control" }, "u",
             function ()
                -- raise mail client if it's ran.
                for k, c in pairs(client.get())
                do
                   if c.name == nil then goto continue end
                   local name = string.lower(c.name)
                   if string.match(name, o.mail)
                   then
                      for i, v in ipairs(c:tags())
                      do
                         awful.tag.viewonly(v)
                         c:raise()
                         c.minimized = false
                         return
                      end
                   end
                   ::continue::
                end
                -- if there's no mail client running, just run it.
                awful.util.spawn(string.format("%s -e %s", terminal, o.mail))
             end),

   -- move mouse to another screen
   awful.key({ modkey,           }, "o",      function (c) awful.screen.focus_relative(1) end),

   -- lookup dict
   awful.key({ modkey,           }, "[",      function (c) awful.util.spawn("bash -c 'notify-send \"$(udict.pl $(xsel -po))\"'") end)
   )

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey, "Shift"   }, "o",      function (c)
                c.screen = awful.util.cycle(screen.count(), mouse.screen + 1)
                awful.screen.focus(c.screen)
                                              end),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
             function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
             end),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end),
    awful.key({ modkey, }, "c",
             function (c)
                 awful.placement.centered(c)
             end)
             )

local tags = require("meelua.tags")
local screen = screen

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count()
do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber
do
   globalkeys = awful.util.table.join(
      globalkeys,
      awful.key({ modkey }, "#" .. i + 9,
                function ()
                   local screen = mouse.screen
                   if tags[screen][i]
                   then
                      awful.tag.viewonly(tags[screen][i])
                   end
                end),
      awful.key({ modkey, "Control" }, "#" .. i + 9,
                function ()
                   local screen = mouse.screen
                   if tags[screen][i]
                   then
                      awful.tag.viewtoggle(tags[screen][i])
                   end
                end),
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                function ()
                   if client.focus and tags[client.focus.screen][i]
                   then
                      awful.client.movetotag(tags[client.focus.screen][i])
                   end
                end),
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                function ()
                   if client.focus and tags[client.focus.screen][i]
                   then
                      awful.client.toggletag(tags[client.focus.screen][i])
                   end
                end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

return globalkeys
