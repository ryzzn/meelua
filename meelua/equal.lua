-- equal.lua ---
--
-- Filename: equal.lua
-- Description: It's a layout of wibox of awesome window manager that
--              divide wibox into some pieces equally. Inspired by
--              align layout design.

-- Author: Yudi Shi <a@sydi.org>
-- Created: 2012-12-1 12:03:01 (+0800)
-- Version: 0.1
-- Last-Updated: 2012-12-01 12:20:57 (+0800)
--           By: Yudi Shi <a@sydi.org>
--     Update #: 5
--

-- Change Log:
--
--
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 3, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; see the file COPYING.  If not, write to
-- the Free Software Foundation, Inc., 51 Franklin Street, Fifth
-- Floor, Boston, MA 02110-1301, USA.
--
--

-- Code:

local setmetatable = setmetatable
local table = table
local pairs = pairs
local type = type
local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")

-- meelua.equal
local equal = {}

-- Draw the given equal layout. num describes the number diveded into
-- of the layout.
local function draw(num, layout, wibox, cr, width, height)
   local h = height / num
    local size_first = 0
    local size_third = 0
    local size_limit = dir == "y" and height or width

    if layout.first then
       base.draw_widget(wibox, cr, layout.first, 0, 0, width, h)
    end

    if layout.second then
       base.draw_widget(wibox, cr, layout.second, 0, h, width, h)
    end

    if layout.third then
       base.draw_widget(wibox, cr, layout.third, 0, 2 * h, width, h)
    end
end

local function widget_changed(layout, old_w, new_w)
    if old_w then
        old_w:disconnect_signal("widget::updated", layout._emit_updated)
    end
    if new_w then
        widget_base.check_widget(new_w)
        new_w:connect_signal("widget::updated", layout._emit_updated)
    end
    layout._emit_updated()
end

--- Set the layout's first widget. This is the widget that is at the top
function equal:set_first(widget)
    widget_changed(self, self.first, widget)
    self.first = widget
end

--- Set the layout's second widget. This is the centered one.
function equal:set_second(widget)
    widget_changed(self, self.second, widget)
    self.second = widget
end

--- Set the layout's third widget. This is the widget that is at the bottom
function equal:set_third(widget)
    widget_changed(self, self.third, widget)
    self.third = widget
end

function equal:reset()
    for k, v in pairs({ "first", "second", "third" }) do
        self[v] = nil
    end
    self:emit_signal("widget::updated")
end

local function get_layout(num)
    local function draw_num(layout, wibox, cr, width, height)
       draw(num, layout, wibox, cr, width, height)
    end

    local ret = widget_base.make_widget()
    ret.draw = draw_num
    ret.fit = function(box, ...) return ... end
    -- ret.get_dir = function () return dir end
    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    for k, v in pairs(equal) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    return ret
end

-- Return a vertical layout divide wibox into *two* pieces equally.
function equal.two()
    local ret = get_layout(2)
    return ret
end

-- Return a vertical layout divied wibox into *three&* pieces equally.
function equal.three()
    local ret = get_layout(3)
    return ret
end

return equal

--
-- equal.lua ends here
