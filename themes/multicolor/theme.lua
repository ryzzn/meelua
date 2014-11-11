--[[

     Multicolor Awesome WM config 2.0
     github.com/copycat-killer

--]]


theme                               = {}

theme.confdir                       = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"
theme.wallpaper                     = theme.confdir .. "/wall.png"
theme.icon_dir                      = theme.confdir .. "/icons"
theme.layout_dir                    = theme.confdir .. "/layouts"
theme.tag_dir                       = theme.confdir .. "/taglist"

theme.font                          = "Terminus 10"

theme.menu_bg_normal                = "#000000"
theme.menu_bg_focus                 = "#000000"
theme.bg_normal                     = "#000000"
theme.bg_focus                      = "#000000"
theme.bg_urgent                     = "#000000"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ff8c00"
theme.fg_urgent                     = "#af1d18"
theme.fg_minimize                   = "#ffffff"
theme.fg_black                      = "#424242"
theme.fg_red                        = "#ce5666"
theme.fg_green                      = "#80a673"
theme.fg_yellow                     = "#ffaf5f"
theme.fg_blue                       = "#7788af"
theme.fg_magenta                    = "#94738c"
theme.fg_cyan                       = "#778baf"
theme.fg_white                      = "#aaaaaa"
theme.fg_blu                        = "#8ebdde"
theme.border_width                  = "1"
theme.border_normal                 = "#1c2022"
theme.border_focus                  = "#606060"
theme.border_marked                 = "#3ca4d8"
theme.menu_width                    = "110"
theme.menu_border_width             = "0"
theme.menu_fg_normal                = "#aaaaaa"
theme.menu_fg_focus                 = "#ff8c00"
theme.menu_bg_normal                = "#050505dd"
theme.menu_bg_focus                 = "#050505dd"

theme.submenu_icon                  = theme.icon_dir .. "/submenu.png"
theme.widget_temp                   = theme.icon_dir .. "/temp.png"
theme.widget_uptime                 = theme.icon_dir .. "/ac.png"
theme.widget_cpu                    = theme.icon_dir .. "/cpu.png"
theme.widget_weather                = theme.icon_dir .. "/dish.png"
theme.widget_fs                     = theme.icon_dir .. "/fs.png"
theme.widget_mem                    = theme.icon_dir .. "/mem.png"
theme.widget_fs                     = theme.icon_dir .. "/fs.png"
theme.widget_note                   = theme.icon_dir .. "/note.png"
theme.widget_note_on                = theme.icon_dir .. "/note_on.png"
theme.widget_netdown                = theme.icon_dir .. "/net_down.png"
theme.widget_netup                  = theme.icon_dir .. "/net_up.png"
theme.widget_mail                   = theme.icon_dir .. "/mail.png"
theme.widget_batt                   = theme.icon_dir .. "/bat.png"
theme.widget_clock                  = theme.icon_dir .. "/clock.png"
theme.widget_vol                    = theme.icon_dir .. "/spkr.png"

theme.taglist_font                  = theme.font
theme.taglist_squares_sel           = theme.tag_dir .. "/square_a.png"
theme.taglist_squares_unsel         = theme.tag_dir .. "/square_b.png"

theme.tasklist_font                 = theme.font
theme.tasklist_disable_icon         = true
-- theme.tasklist_floating             = ""
-- theme.tasklist_maximized_horizontal = ""
-- theme.tasklist_maximized_vertical   = ""

theme.layout_tile                   = theme.layout_dir .. "/tile.png"
theme.layout_tilegaps               = theme.layout_dir .. "/tilegaps.png"
theme.layout_tileleft               = theme.layout_dir .. "/tileleft.png"
theme.layout_tilebottom             = theme.layout_dir .. "/tilebottom.png"
theme.layout_tiletop                = theme.layout_dir .. "/tiletop.png"
theme.layout_fairv                  = theme.layout_dir .. "/fairv.png"
theme.layout_fairh                  = theme.layout_dir .. "/fairh.png"
theme.layout_spiral                 = theme.layout_dir .. "/spiral.png"
theme.layout_dwindle                = theme.layout_dir .. "/dwindle.png"
theme.layout_max                    = theme.layout_dir .. "/max.png"
theme.layout_fullscreen             = theme.layout_dir .. "/fullscreen.png"
theme.layout_magnifier              = theme.layout_dir .. "/magnifier.png"
theme.layout_floating               = theme.layout_dir .. "/floating.png"


return theme
