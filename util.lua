-----------------------------------
-- @author Ryan Shi
-- @date Fri Jul 27 21:28:35 2012
-- @version 0.1
----------------------------------

-- varibles
local ipairs = ipairs
local table = table
local lgi = require 'lgi'
local cairo = lgi.cairo
local color = require("gears.color")
local wibox = require("wibox")
module(...)

function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

function mapn(func, ...)
  local new_array = {}
  local i=1
  local arg_length = table.getn(arg)
  while true do
    local arg_list = map(function(arr) return arr[i] end, arg)
    if table.getn(arg_list) < arg_length then return new_array end
    new_array[i] = func(unpack(arg_list))
    i = i+1
  end
end

function lua_remove_if(func, arr)
  local new_array = {}
  for _,v in arr do
    if not func(v) then table.insert(new_array, v) end
  end
  return new_array
end

function arrow(width, height, left_color, right_color)
  local surface = cairo.ImageSurface.create('ARGB32', width, height)
  local cr = cairo.Context.create(surface)

  cr:set_line_width(0.1)
  local r,g,b,a = color.parse_color(left_color)
  cr:set_source_rgb(r,g,b,a)
  cr:rectangle(0, 0, width, height)
  cr:fill()

  cr:move_to(width, 0)
  cr:line_to(0, height / 2)
  cr:line_to(width, height)
  cr:close_path()
  local r,g,b,a = color.parse_color(right_color)
  cr:set_source_rgb(r,g,b,a)
  cr:fill()
  cr:stroke()

  return wibox.widget.imagebox(surface)
end
