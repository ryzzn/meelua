-----------------------------------
-- @author Ryan Shi
-- @date Fri Jul 27 21:28:35 2012
-- @version 0.1
----------------------------------

-- varibles
local ipairs = ipairs
local table = table
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

