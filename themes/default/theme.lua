---------------------------
-- Default awesome theme --
---------------------------
-- stylua: ignore start


local theme_assets                              = require("beautiful.theme_assets")
local xresources                                = require("beautiful.xresources")
local rnotification                             = require("ruled.notification")
local dpi                                       = xresources.apply_dpi

local gfs                                       = require("gears.filesystem")
local themes_path                               = gfs.get_configuration_dir() .. "themes/"

local theme                                     = {}

theme.font                                      = "Comic Shanns"

theme.user_icon                                 = os.getenv("HOME") .. "/.user_icon"


theme.bg_normal                                 = "#0F111A"
theme.bg_focus                                  = "#717CB4"
theme.bg_urgent                                 = "##f07178"
theme.bg_minimize                               = "#181A1F"
theme.bg_systray                                = theme.bg_normal

theme.fg_normal                                 = "#aaaaaa"
theme.fg_focus                                  = "#ffffff"
theme.fg_urgent                                 = "#ffffff"
theme.fg_minimize                               = "#ffffff"

theme.green                                     = "#00ff00"
theme.yellow                                    = "#ffff00"
theme.red                                       = "#ff0000"

theme.okay_color                                = theme.green
theme.warning_color                             = theme.yellow
theme.error_color                               = theme.red

theme.useless_gap                               = dpi(0)
theme.border_width                              = dpi(1)
theme.border_radius                             = 10
theme.border_color_normal                       = "#000000"
theme.border_color_active                       = "#535d6c"
theme.border_color_marked                       = "#91231c"

theme.alternate_color = "#00ADB5"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.taglist_bg_focus                          = "#ff0000"

-- Generate taglist squares:
local taglist_square_size                       = dpi(4)
theme.taglist_squares_sel                       = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel                     = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon                         = themes_path.."default/submenu.png"
theme.menu_height                               = dpi(15)
theme.menu_width                                = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path.."default/titlebar/maximized_focus_active.png"

-- theme.wallpaper = themes_path.."default/background.png"
theme.wallpaper_dir                             = os.getenv("HOME") .. "/Pictures/Wallpapers/"
theme.wallpaper                                 = theme.wallpaper_dir .. gfs.get_random_file_from_dir(theme.wallpaper_dir)

-- You can use your own layout icons like this:
theme.layout_fairh                              = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv                              = themes_path.."default/layouts/fairvw.png"
theme.layout_floating                           = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier                          = themes_path.."default/layouts/magnifierw.png"
theme.layout_max                                = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen                         = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom                         = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft                           = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile                               = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop                            = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral                             = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle                            = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw                           = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne                           = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw                           = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse                           = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                                = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule                                    = { urgency = 'critical' },
        properties                              = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

theme.taglist_widget_template_margins_right     = 1
theme.taglist_widget_template_margins_left      = 1
theme.taglist_icon_role_margins                 = 1
theme.taglist_index_role_margins                = 1
theme.taglist_spacing                           = 1

theme.flash_focus_start_opacity                 = 0.6 -- the starting opacity
theme.flash_focus_step                          = 0.01         -- the step of animation

-- For tabbed only
theme.tabbed_spawn_in_tab                       = false  -- whether a new client should spawn into the focused tabbing container

-- For tabbar in general
theme.tabbar_ontop                              = false
theme.tabbar_radius                             = 0                -- border radius of the tabbar
theme.tabbar_style                              = "default"         -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font                               = theme.font         -- font of the tabbar
theme.tabbar_size                               = 40                 -- size of the tabbar
theme.tabbar_position                           = "top"          -- position of the tabbar
theme.tabbar_bg_normal                          = "#000000"     -- background color of the focused client on the tabbar
theme.tabbar_fg_normal                          = "#ffffff"     -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus                           = "#1A2026"     -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus                           = "#ff0000"     -- foreground color of unfocused clients on the tabbar
theme.tabbar_bg_focus_inactive                  = nil   -- background color of the focused client on the tabbar when inactive
theme.tabbar_fg_focus_inactive                  = nil   -- foreground color of the focused client on the tabbar when inactive
theme.tabbar_bg_normal_inactive                 = nil  -- background color of unfocused clients on the tabbar when inactive
theme.tabbar_fg_normal_inactive                 = nil  -- foreground color of unfocused clients on the tabbar when inactive
theme.tabbar_disable                            = false           -- disable the tab bar entirely

-- the following variables are currently only for the "modern" tabbar style
theme.tabbar_color_close                        = "#f9929b" -- chnges the color of the close button
theme.tabbar_color_min                          = "#fbdf90" -- chnges the color of the minimize button
theme.tabbar_color_float                        = "#ccaced" -- chnges the color of the float button

theme.parent_filter_list                        = {"firefox", "Gimp"} -- class names list of parents that should not be swallowed
theme.child_filter_list                         = { "Dragon" }        -- class names list that should not swallow their parents
theme.swallowing_filter                         = true                   -- whether the filters above should be active

theme.modalbind_show_default_options            = true
theme.modalbind_show_options                    = true
theme.modalbind_location                        = "top_right"
theme.modalbind_opacity                         = 0.7
theme.modalbind_x_offset                        = -10
theme.modalbind_y_offset                        = 10

theme.modalbind_font                            = theme.font
theme.modalbind_fg                              = theme.fg_normal
theme.modalbind_bg                              = theme.bg_normal
theme.modalbind_border                          = theme.border_color_normal
theme.modalbind_border_width                    = 1
theme.modalbind_border_radius                   = 10

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
