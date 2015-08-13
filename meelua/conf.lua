-----------------------------------
-- @author Yudi Shi <a@sydi.org>
-- @date Fri Jul 27 21:28:35 2012
-- @version 0.2
-----------------------------------

-- varible
-- Theme handling library
local beautiful = require("beautiful")
local suit = require("awful.layout.suit")
local awful = require("awful")
local chat = require("meelua.chat")
local os = os
local string = string
local debug = debug

module(...)

local _,_,dirname=string.find(debug.getinfo(1, "S").source, [[^@(.*)/([^/]-)$]])

mee_home = awful.util.getdir("config")

globalkeys = {}
terminal = "urxvtc +sb -bc -ic +tr -sh 80"
mpc = "ncmpcpp"
mail = "mutt"
netdev = "wlan0"

editor = os.getenv("EDITOR") or "vim"

font = "Terminus 9"

screenshots_dir = "~/personal/screenshots/"
wallpaper = awful.util.getdir("config") .. "/wallpaper.png"
theme = awful.util.getdir("config") .. "/themes/multicolor/theme.lua"
layouts = {
   -- suit.floating,
   suit.tile.bottom,
   suit.tile.top,
   suit.tile.right,
   suit.tile.left,
   suit.max,
   -- suit.magnifier,
}

awful.layout.layouts = layouts
