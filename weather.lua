#!/usr/bin/lua

-- Time-stamp: <2012-12-29 13:44:35 ryan>
-- It's simple but usefule weather widget under awesome wm.
-- Usage:
--     1. weather = require("weather")
--     2. weather_w = weather()
--     3. add weather_w to your wibox.
--
-- author:  施宇迪
-- contact: cedsyd@gmail.com

local cityid = 101210101        -- 杭州
-- http://www.weather.com.cn/data/sk/101210101.html 实况

local io = require("io")
local json = require("json")	-- not installed by default in lua 5.1
local awful = require("awful")
local timer = timer
local wibox = require("wibox")
local margin = require("wibox.layout.margin")
local textbox = require("wibox.widget.textbox")
local imagebox = require("wibox.widget.imagebox")
local setmetatable = setmetatable
local base = require("wibox.layout.base")
local string = string
local print = print
local naughty = require("naughty")

module(...)
local weather = {
   mt = {}
}


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

local function notify_weather ()
  obj = read_json("/home/ryan/.data/weather.json")
  if nil == obj then return end
  info = obj.weatherinfo

  naughty.notify({
    fg = '#ff00cc',
    title = string.format("%s [%s]", info.date_y, info.week),
    text = string.format("今天  %-16s <%s> %s\n", info.weather1, info.temp1, info.wind1)
             .. string.format("明天  %-16s <%s> %s\n", info.weather2, info.temp2, info.wind2)
             .. string.format("后天  %-16s <%s> %s", info.weather3, info.temp3, info.wind3)})
  end

local function update (w)
   obj = read_json("/home/ryan/.data/weather.json")
   if nil == obj then return end
   weatherinfo = obj.weatherinfo

   local p_city = '<span color="lightblue">' .. weatherinfo.city .. '</span> : <span color="yellow">' .. weatherinfo.weather1 .. '</span>'

   local p_temp = ' [<span color="orange">' .. weatherinfo.temp1 .. '</span>]'
   local index = weatherinfo.img_single
   if index == '99' then
      index = 0
   end
   local p_image = "/home/ryan/.data/weather.gif/c" .. index .. ".gif"

   w.city:set_markup(p_city)
   w.icon:set_image(p_image)
   w.temp:set_markup(p_temp)
end

local function new()
   local w = {
      icon = imagebox(),
      city = textbox(),
      temp = textbox()
   }

   layout = wibox.layout.fixed.horizontal()
   layout:add(w.city)
   layout:add(w.temp)
   layout:add(w.icon)

   layout:buttons(
      awful.util.table.join(
	 awful.button({ }, 1, notify_weather)))

   w.city:set_markup("ok")
   w.temp:set_markup("temp")
   w.icon:set_image("/home/ryan/.data/weather.gif/c1.gif")
   update(w)

   weather_timer = timer({ timeout = 10 })
   weather_timer:connect_signal("timeout", function () update(w) end)
   weather_timer:start()

   m = margin(layout, 4, 4)
   m.set_font = function (self, font)
      w.city:set_font(font)
      w.temp:set_font(font)
      end
   return m
end

function weather.mt:__call(...)
   return new(...)
end

return setmetatable(weather, weather.mt)
