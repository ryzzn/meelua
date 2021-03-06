-- from sunjack, awesome3 theme, by Ryanz

--{{{ Main
awful = require("awful")

theme = {}

local _,_,dirname=string.find(debug.getinfo(1, "S").source, [[^@(.*)/([^/]-)$]])
theme.confdir = dirname
themedir = dirname
--}}}

--/// Styles

theme.font      = "Terminus 10"

--// Colors
theme.fg_normal = "#808080"
theme.fg_focus  = "#286f8a"
theme.fg_urgent = "#000000"
theme.bg_normal = "#202020"
theme.bg_focus  = "#0f0f0f"
theme.bg_urgent = "#ffc0c0"
--//

--// Borders
theme.border_width  = "0"
theme.border_normal = "#121212"
theme.border_focus  = theme.fg_focus
theme.border_marked = "#000000"
--//

--// Titlebars
theme.titlebar_fg_normal = "#808080"
theme.titlebar_fg_focus	 = "#ffffff"
theme.titlebar_bg_normal = "#363636ff"
theme.titlebar_bg_focus	 = "#000000ff"
theme.titlebar_font	 = theme.font or "cure 8"
--//

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
theme.taglist_bg_focus = theme.fg_focus
theme.taglist_fg_focus = theme.bg_normal
--theme.tasklist_bg_focus = theme.bg_normal

--////

--// Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal    = "#101010ff"
theme.menu_bg_focus     = "#000000ff"
theme.menu_fg_normal    = theme.fg_normal
theme.menu_fg_focus     = theme.fg_focus
theme.menu_border_width = "0"
theme.menu_height       = "18"
theme.menu_width        = "150"
--//

--//// Icons

--// Taglist
theme.taglist_squares_sel   = themedir .. "/taglist/squarefza.png"
theme.taglist_squares_unsel = themedir .. "/taglist/squareza.png"
theme.taglist_squares_resize = "false"
--//

--// Misc
--theme.awesome_icon           = themedir .. "/awesome-icon.png"
--theme.menu_submenu_icon      = sharedthemes .. "/default/submenu.png"
--theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"
--//

--// Layout
theme.layout_tile       = themedir .. "/layouts/tile.png"
theme.layout_tileleft   = themedir .. "/layouts/tileleft.png"
theme.layout_tilebottom = themedir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = themedir .. "/layouts/tiletop.png"
theme.layout_fairv      = themedir .. "/layouts/fairv.png"
theme.layout_fairh      = themedir .. "/layouts/fairh.png"
theme.layout_spiral     = themedir .. "/layouts/spiral.png"
theme.layout_dwindle    = themedir .. "/layouts/dwindle.png"
theme.layout_max        = themedir .. "/layouts/max.png"
theme.layout_fullscreen = themedir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = themedir .. "/layouts/magnifier.png"
theme.layout_floating   = themedir .. "/layouts/floating.png"
--//

--// Titlebar
--[[theme.titlebar_close_button_focus  = themedir .. "/close-focused.png"
theme.titlebar_close_button_normal = themedir .. "/close-unfocused.png"
theme.titlebar_maximized_button_focus_active  = themedir .. "/maximize-focused.png"
theme.titlebar_maximized_button_normal_active = themedir .. "/maximize-unfocused.png"
theme.titlebar_maximized_button_focus_inactive  = themedir .. "/maximize-focused.png"
theme.titlebar_maximized_button_normal_inactive = themedir .. "/maximize-unfocused.png"]]
--//

--////

return theme
