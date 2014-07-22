--[[                                     ]]--
--                                         -
--   Multicolor Awesome WM 3.5.+ config    --
--       github.com/copycat-killer         --
--                                         -
--[[                                     ]]--


theme = {}

local _,_,dirname=string.find(debug.getinfo(1, "S").source, [[^@(.*)/([^/]-)$]])
theme.confdir = dirname

theme.font = "Terminus 8"
--theme.taglist_font =

theme.menu_bg_normal = "#000000"
theme.menu_bg_focus = "#000000"

theme.bg_normal = "#000000"
theme.bg_focus  = "#000000"
theme.bg_urgent = "#000000"

theme.fg_normal = "#aaaaaa"
theme.fg_focus  = "#ff8c00"
theme.fg_urgent = "#af1d18"
theme.fg_minimize   = "#ffffff"

theme.mouse_finder_color = "#afa72e"

theme.fg_black      = "#424242"
theme.fg_red        = "#ce5666"
theme.fg_green      = "#80a673"
theme.fg_yellow     = "#ffaf5f"
theme.fg_blue       = "#7788af"
theme.fg_magenta    = "#94738c"
theme.fg_cyan       = "#778baf"
theme.fg_white      = "#aaaaaa"
theme.fg_blu        = "#8ebdde"

theme.border_width  = 1
theme.border_normal = "#1c2022"
theme.border_focus  = "#606060"
theme.border_marked = "#3ca4d8"

theme.menu_width = 350
theme.menu_border_width  = 0
theme.menu_fg_normal = "#aaaaaa"
theme.menu_fg_focus =  "#ff8c00"
theme.menu_bg_normal = "#050505dd"
theme.menu_bg_focus  = "#050505dd"
theme.menu_submenu_icon  = theme.confdir .. "/submenu.png"

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#2F4F4F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.confdir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.confdir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/titlebar/maximized_normal_inactive.png"
-- }}}

theme.widget_temp       = theme.confdir .. "/widgets/temp.png"
theme.widget_uptime      = theme.confdir .. "/widgets/ac.png"
theme.widget_cpu        = theme.confdir .. "/widgets/cpu.png"
theme.widget_mem        = theme.confdir .. "/widgets/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/fs.png"
theme.widget_netdown    = theme.confdir .. "/widgets/net_down.png"
theme.widget_netup      = theme.confdir .. "/widgets/net_up.png"
theme.widget_gmail      = theme.confdir .. "/widgets/mail.png"
theme.widget_batt       = theme.confdir .. "/widgets/bat.png"
theme.widget_clock      = theme.confdir .. "/widgets/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/spkr.png"

theme.taglist_squares_sel   = theme.confdir .. "/taglist/square_a.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"

--theme.awesome_icon =
theme.wallpaper = theme.confdir .. "/wall.png"

return theme
