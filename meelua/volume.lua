#!/usr/bin/lua

-- Time-stamp: <2012-12-01 23:47:11 ryan>
-- It's simple but usefule volume widget under awesome wm.
-- Usage:
--     1. volume = require(volume)
--     2. volume_w = volume()
--     3. add volume_w to your wibox.
--
-- author:  Shi Yudi
-- contact: cedsyd@gmail.com

local setmetatable = setmetatable
local timer = timer
local textbox = require("wibox.widget.textbox")
local margin = require("wibox.layout.margin")
local awful = require("awful")
local io = io
local string = string

module(...)
local volume = {
   mt = {}
}

local volume_cardid  = 0
local volume_channel = "Master"

-- redraw volume widget according current system volume.
local function update (w)
   local fd = io.popen("amixer -c " .. volume_cardid .. " -- sget " .. volume_channel)
   local status = fd:read("*all")
   fd:close()

   local volume_cur = string.match(status, "(%d?%d?%d)%%")
   volume_cur = string.format("% 3d", volume_cur)

   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
      volume_cur = '<span color=\"lightblue\">Vol: </span><span color="yellow">♬</span>' .. volume_cur .. "%"
   else
      volume_cur = '<span color=\"lightblue\">Vol: </span><span color="red">♬</span>' .. volume_cur .. '%'
   end
   w:set_markup(volume_cur)
end

-- raise volume
local function raise (layout)
   io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%+"):read("*all")
   update(layout.widget)
end

-- lower volume
local function lower (layout)
   io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%-"):read("*all")
   update(layout.widget)
end

-- toggle volume mute status
local function toggle_mute (layout)
   io.popen("amixer -c " .. volume_cardid .. " sset " .. volume_channel .. " toggle"):read("*all")
   update(layout.widget)
end

-- init a volume widget
local function new ()
   w = textbox()
   ret = margin(w, 5, 5)
   ret.raise = raise
   ret.lower = lower
   ret.toggle_mute = toggle_mute

   w:buttons(
      awful.util.table.join(
	 awful.button({ }, 4, function () raise(ret) end),
	 awful.button({ }, 5, function () lower(ret) end),
	 awful.button({ }, 1, function () toggle_mute(ret) end)))

   volume_clock = timer({ timeout = 10 })
   volume_clock:connect_signal("timeout", function () update(w) end)
   volume_clock:start()

   update(w)
   return ret
end

function volume.mt:__call(...)
   return new(...)
end

return setmetatable(volume, volume.mt)
