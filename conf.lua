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
local os=os
-- local widget = require("widget")

module(...)

globalkeys = {}
mpc = "ncmpcpp"

terminal = "urxvt +sb -is -bc -ic +tr -sh 80"
editor = os.getenv("EDITOR") or "vim"

mpc_client = "ncmpcpp"

screenshots_dir = "~/personal/screenshots/"

layouts = {
   -- suit.floating,
   suit.tile.bottom,
   suit.tile.right,
   suit.max,
   -- suit.magnifier,
}
