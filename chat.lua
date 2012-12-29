---------------------------------------------------------------------------
-- @author Shi Yudi &lt;cedsyd@gmail.com&gt;
-- @copyright 2012 Shi Yudi
-- @release v0.1
---------------------------------------------------------------------------

-- Grab environment we need
local ipairs = ipairs
local math = math
local string = string
local print = print

--- Chat layouts module for awful
module(...)

local function chat(p, place)
   local wa = p.workarea
   local cls = p.clients

   if #cls > 0 then
      local cs = 0
      local bs = 0
      for k, c in ipairs(cls) do
         if (c.class == "AliWangWang"
             and not string.find(c.name, "^Form"))
         then
            if string.find(c.name, "^阿里旺旺")
            then
               bs = bs + 1
            else
               cs = cs + 1
            end
         end
      end

      local cell = 0
      local height = wa.height
      local width = wa.width * 3 / (4 * cs)
      for k, c in ipairs(cls) do
         local g = {}
         if (c.class == "AliWangWang"
             and not string.find(c.name, "^Form"))
         then
            if ( place == "left" )  then
               if string.find(c.name, "^阿里旺旺")
               then
                  g.x = wa.x
                  g.y = wa.y
                  g.width = wa.width / 4
                  g.height = wa.height
               else
                  g.x = wa.width / 4 + cell * width
                  g.y = wa.y
                  g.width = width
                  g.height = height
                  cell = cell + 1
               end
            end
            if ( place == "right" ) then
               if string.find(c.name, "^阿里旺旺") then
                  g.x = wa.width - wa.width / 4
                  g.y = wa.y
                  g.width = wa.width / 4
                  g.height = wa.height
               else
                  g.x = wa.x + cell * width
                  g.y = wa.y
                  g.width = width
                  g.height = height
                  cell = cell + 1
               end
            end
         end

         c:geometry(g)
      end
   end
end

--- Horizontal chat layout.
-- @param screen The screen to arrange.
left = {}
left.name = "chatleft"
function left.arrange(p)
   return chat(p, "left")
end

-- Vertical chat layout.
-- @param screen The screen to arrange.
right = {}
right.name = "chatright"
function right.arrange(p)
   return chat(p, "right")
end
