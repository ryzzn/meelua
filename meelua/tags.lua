--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 14:10:25 ryan>
-- Time-stamp: <2013-10-16 18:30:03 ryan>
-- About tags and layout configurations.

local awful = require("awful")
local chat = require("meelua.chat")
local tag = require("awful.tag")
local suit = awful.layout.suit
local screen = screen;
local naughty = require("naughty")

local mytags = {
   { name = "Term", layout = suit.tile.bottom },
   { name = "Emacs", layout = suit.max },
   { name = "Web", layout = suit.max },
   { name = "WW", layout = chat.right },
   { name = "IM", layout = suit.floating },
   { name = "6", layout = suit.floating },
   { name = "7", layout = suit.floating },
   { name = "8", layout = suit.floating },
   { name = "9", layout = suit.floating },
   { name = "mpc", layout = suit.max },
   { name = "mail", layout = suit.max },
}

--- Create a set of tags and attach it to a screen.
-- @param screen The tag screen, or 1 if not set.
-- @param mytags The name and layout table
-- @return A table with all created tags.
local function create_tags(screen, mytags)
   local screen = screen or 1
   local tags = {}
   for id, prop in ipairs(mytags) do
      table.insert(tags,
                   id,
                   tag.add(prop.name,
                           {screen = screen,
                            layout = prop.layout}))
      -- Select the first tag.
      if id == 1 then
         tags[id].selected = true
      end
   end

   return tags
end

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count()
do
   -- Each screen has its own tag table.
   tags[s] = create_tags(s, mytags)
end
-- }}}

screen[1]:connect_signal("tag::history::update",
                         function ()
                           local sel = tag.selected(1)
                           local name = sel.name
                           if not mywibox[mouse.screen].visible then
                             awful.util.spawn_with_shell('twmnc -t TAG -c "<' .. name .. '>" -s 30 --id 1543 -d 1000')
                           end
                         end)

return tags