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
mpc = "ncmpcpp"

terminal = "urxvt +sb -is -bc -ic +tr -sh 80"
editor = os.getenv("EDITOR") or "vim"

mpc_client = "ncmpcpp"
font = "Terminus 9"

screenshots_dir = "~/personal/screenshots/"
-- wallpaper = "/home/ryan/personal/wallpapers/november-11-a_clearing_in_the_foggy_forest__5-nocal-1280x800_duclear.jpg"
wallpaper = awful.util.getdir("config") .. "/wallpaper"
-- theme = awful.util.getdir("config") .. "/themes/cool-blue/theme.lua"
theme = awful.util.getdir("config") .. "/themes/multicolor/theme.lua"
-- theme = "/usr/share/awesome/themes/zenburn/theme.lua"

layouts = {
   -- suit.floating,
   suit.tile.bottom,
   suit.tile.right,
   suit.max,
   -- suit.magnifier,
}
