pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

Singleton {
    readonly property var tweaks: [
        {
            "section": "Appearance",
            "icon": "palette",
            "shell": "Global",
            "items": [
                {
                    "icon": "blur_on",
                    "name": "Use Shaders",
                    "key": "appearance.effects.shaders"
                },
                {
                    "icon": "blur_on",
                    "name": "Shader Type",
                    "key": "appearance.effects.currentShader",
                    "type": "combobox",
                    "comboBoxValues": Shaders.available
                },
                {
                    "icon": "rounded_corner",
                    "name": "Radius",
                    "key": "appearance.rounding.scale",
                    "type": "slider",
                    "sliderMinValue": 0,
                    "sliderMaxValue": 2.45
                },
                {
                    "icon": "tune",
                    "name": "Border",
                    "key": "desktop.bg.borderMultiplier",
                    "type": "slider",
                    "sliderMinValue": 0,
                    "sliderMaxValue": 1
                },
                {
                    "icon": "rounded_corner",
                    "name": "Screen Corners",
                    "key": "desktop.screenCorners",
                    "type": "spin"
                },
                {
                    "icon": "stars_2",
                    "name": "Icon Theme",
                    "key": "desktop.icons.currentIconTheme",
                    "type": "combobox",
                    "reloadOnChange": true,
                    "canRefresh": true,
                    "refreshAction": () => IconThemesService.reload(),
                    "comboBoxValues": IconThemesService.availableIconThemeIds
                },
                {
                    "icon": "arrow_selector_tool",
                    "name": "Cursor Theme",
                    "store": "hypr",
                    "key": "cursor_theme",
                    "type": "combobox",
                    "canRefresh": true,
                    "refreshAction": () => CursorsService.reload(),
                    "comboBoxValues": CursorsService.cursors
                },
                {
                    "icon": "ads_click",
                    "name": "Cursor Size",
                    "store": "hypr",
                    "key": "cursor_size",
                    "type": "spin"
                },
                {
                    "icon": "font_download",
                    "name": "UI Font",
                    "key": "appearance.fonts.main",
                    "type": "font"
                },
                {
                    "icon": "font_download",
                    "name": "Sync Family",
                    "key": "appearance.fonts.syncFamily"
                },
                {
                    "icon": "palette",
                    "name": "Shell Mode",
                    "type": "combobox",
                    "comboBoxValues": ["main", "zen", "xp", "nobuntu"],
                    "key": "desktop.shell.mode"
                },
                {
                    "icon": "crop",
                    "name": "Depth Wallpaper",
                    "enableTooltip": false,
                    "key": "desktop.bg.depthMode"
                },
                {
                    "icon": "palette",
                    "name": "Widgets Bg Mode",
                    "key": "desktop.widgets.mode",
                    "type": "combobox",
                    "comboBoxValues": ["col", "grad"]
                }
            ]
        },
        {
            "section": "Desktop",
            "icon": "wallpaper",
            "shell": "Global",
            "items": [
                {
                    "icon": "notifications",
                    "name": "Toasts",
                    "key": "desktop.toasts.enabled"
                },
                {
                    "icon": "timer",
                    "name": "Desktop Clock",
                    "key": "desktop.clock.enabled"
                },
                {
                    "icon": "brand_family",
                    "name": "Arabic Mode",
                    "store": "states",
                    "key": "desktop.clock.arabicMode"
                },
                {
                    "icon": "timer",
                    "name": "Center Clock",
                    "store": "states",
                    "enableTooltip": false,
                    "key": "desktop.clock.center"
                },
                {
                    "icon": "schedule",
                    "name": "Layer Clock Font",
                    "key": "desktop.clock.font",
                    "type": "combobox",
                    "comboBoxValues": Fonts.family.preferredLayerClockFonts
                },
                {
                    "icon": "notifications_active",
                    "name": "Notifications Position",
                    "key": "desktop.popups.notifications",
                    "type": "combobox",
                    "comboBoxValues": ["TopCenter", "TopRight", "TopLeft", "BottomCenter", "BottomRight", "bottomLeft"]
                },
                {
                    "store": "states",
                    "icon": "font_download",
                    "name": "Clock Weight",
                    "key": "fonts.variableAxes.display.wght",
                    "type": "slider",
                    "sliderMinValue": 100,
                    "sliderValue": 100,
                    "sliderMaxValue": 1000
                },
                {
                    "store": "states",
                    "icon": "font_download",
                    "name": "Clock Width",
                    "key": "fonts.variableAxes.display.wdth",
                    "type": "slider",
                    "sliderMinValue": 0,
                    "sliderValue": 10,
                    "sliderMaxValue": 800
                },
                {
                    "icon": "height",
                    "name": "Vertical Mode",
                    "key": "desktop.clock.verticalMode"
                },
                {
                    "store": "states",
                    "icon": "timer",
                    "name": "Clock Size",
                    "key": "desktop.clock.scale",
                    "type": "slider",
                    "sliderMinValue": 0.25,
                    "sliderValue": 0.25,
                    "sliderMaxValue": 4
                },
                {
                    "icon": "extension",
                    "name": "Widgets",
                    "key": "desktop.widgets.enabled"
                },
                {
                    "icon": "apps",
                    "name": "Desktop Icons",
                    "key": "desktop.icons.enabled"
                },
                {
                    "icon": "keyboard_command_key",
                    "name": "Super Key",
                    "type": "combobox",
                    "comboBoxValues": Mem.store.services.cheats.superKeys,
                    "key": "cheats.superKey"
                },
                {
                    "icon": "width",
                    "name": "Parallax Effect",
                    "key": "desktop.bg.parallax.enabled"
                },
                {
                    "icon": "height",
                    "name": "Vertical Parallax",
                    "key": "desktop.bg.parallax.verticalParallax"
                },
                {
                    "icon": "image",
                    "name": "Deload On Fullscreen",
                    "key": "desktop.shell.deloadOnFullscreen"
                },
                {
                    "icon": "width",
                    "name": "Sidebar Parallax",
                    "key": "desktop.bg.parallax.widgetParallax"
                },
                {
                    "icon": "zoom_in_map",
                    "name": "Parallax Strength",
                    "type": "slider",
                    "sliderMaxValue": 1,
                    "key": "desktop.bg.parallax.parallaxStrength"
                }
            ]
        },
        {
            "section": "Window Management",
            "icon": "dashboard",
            "shell": "Global",
            "items": [
                {
                    "icon": "rounded_corner",
                    "name": "Window Rounding",
                    "store": "hypr",
                    "key": "rounding",
                    "type": "spin"
                },
                {
                    "icon": "rounded_corner",
                    "name": "Sync Rounding",
                    "key": "appearance.rounding.syncCompositor"
                },
                {
                    "icon": "blur_on",
                    "name": "Blur Passes",
                    "store": "hypr",
                    "key": "blur_passes",
                    "type": "spin"
                },
                {
                    "icon": "blur_on",
                    "name": "Blur Size",
                    "store": "hypr",
                    "key": "blur_size",
                    "type": "spin"
                },
                {
                    "icon": "blur_on",
                    "name": "X Ray",
                    "store": "hypr",
                    "key": "xray"
                },
                {
                    "icon": "dark_mode",
                    "name": "Shadows",
                    "store": "hypr",
                    "key": "shadows"
                },
                {
                    "icon": "collapse_content",
                    "name": "Shadows Range",
                    "store": "hypr",
                    "key": "shadows_range",
                    "type": "spin"
                },
                {
                    "icon": "collapse_content",
                    "name": "Shadows Power",
                    "store": "hypr",
                    "key": "shadows_power",
                    "type": "spin"
                },
                {
                    "icon": "expand_content",
                    "name": "Gaps Out",
                    "store": "hypr",
                    "key": "gaps_out",
                    "type": "spin"
                },
                {
                    "icon": "collapse_content",
                    "name": "Gaps In",
                    "store": "hypr",
                    "key": "gaps_in",
                    "type": "spin"
                },
                {
                    "icon": "border_all",
                    "name": "Border Width",
                    "store": "hypr",
                    "key": "borders",
                    "type": "spin"
                },
                {
                    "icon": "dashboard",
                    "name": "Tiling Layout",
                    "type": "combobox",
                    "store": "hypr",
                    "comboBoxValues": ["master", "dwindle", "scrolling", "monocle"],
                    "key": "layout"
                },
                {
                    "icon": "blur_on",
                    "name": "Animation Style",
                    "type": "combobox",
                    "store": "hypr",
                    "key": "animation_style",
                    "comboBoxValues": HyprlandService?.availableAnimations ?? []
                },
                {
                    "icon": "blur_on",
                    "name": "Animation Scale",
                    "type": "text",
                    "store": "hypr",
                    "key": "animation_scale"
                },
                {
                    "icon": "monitor",
                    "name": "External Monitor Profile",
                    "type": "combobox",
                    "store": "hypr",
                    "key": "external_monitor_mode",
                    "comboBoxValues": MonitorsInfo?.availableResolutions ?? []
                },
                {
                    "icon": "animation",
                    "name": "Beam Animation Style",
                    "type": "combobox",
                    "comboBoxValues": BeamData.availableAnimationStyles,
                    "key": "beam.appearance.animationStyle"
                },
                {
                    "icon": "masked_transitions",
                    "name": "Beam Animation Scale",
                    "type": "text",
                    "key": "beam.appearance.animationScale"
                }
            ]
        },
        {
            "section": "Bar",
            "icon": "toolbar",
            "shell": "Main",
            "items": [
                {
                    "icon": "border_all",
                    "name": "BarGroup",
                    "key": "bar.appearance.barGroup"
                },
                {
                    "icon": "border_horizontal",
                    "name": "Separators",
                    "key": "bar.appearance.enableSeparators"
                },
                {
                    "icon": "border_all",
                    "name": "Outline",
                    "key": "bar.appearance.outline"
                },
                {
                    "icon": "tune",
                    "name": "Style",
                    "key": "bar.appearance.style",
                    "type": "combobox",
                    "comboBoxValues": BarData.appearanceModes
                },
                {
                    "icon": "width_full",
                    "name": "Size",
                    "key": "bar.appearance.size",
                    "type": "spin"
                },
                {
                    "icon": "visibility_off",
                    "name": "Auto Hide",
                    "key": "bar.behavior.autoHide"
                },
                {
                    "icon": "tv",
                    "name": "Show On All Monitors",
                    "key": "bar.behavior.showOnAll"
                },
                {
                    "icon": "graphic_eq",
                    "name": "Visualizer",
                    "key": "bar.modules.visualizer"
                },
                {
                    "icon": "graphic_eq",
                    "name": "Ws Mode",
                    "type": "combobox",
                    "comboBoxValues": Mem.options.bar.workspaces.avilableModes,
                    "key": "bar.workspaces.displayMode"
                }
            ]
        },
        {
            "section": "Dock",
            "icon": "dock",
            "shell": "Main",
            "items": [
                {
                    "icon": "dock",
                    "name": "Dock",
                    "key": "dock.enabled"
                },
                {
                    "icon": "straighten",
                    "name": "Icon Size",
                    "key": "dock.appearance.iconSizeMultiplier",
                    "type": "slider",
                    "sliderMinValue": 0.4,
                    "sliderMaxValue": 1
                },
                {
                    "icon": "tune",
                    "name": "Style",
                    "key": "dock.appearance.style",
                    "type": "combobox",
                    "comboBoxValues": ["float", "convex", "sharp"]
                }
            ]
        },
        {
            "section": "Notifications",
            "icon": "notifications",
            "shell": "Main",
            "items": [
                {
                    "icon": "notifications",
                    "name": "OSD",
                    "key": "osd.enabled"
                },
                {
                    "icon": "notifications",
                    "name": "OSD Mode",
                    "key": "desktop.osd.mode",
                    "type": "combobox",
                    "comboBoxValues": ["Pixel", "BottomPill", "CenterIsland", "SideBay"]
                }
            ]
        },
        {
            "section": "Sidebar",
            "icon": "view_sidebar",
            "shell": "Main",
            "items": [
                {
                    "icon": "tune",
                    "name": "Style",
                    "key": "sidebar.appearance.style",
                    "comboBoxValues": SidebarData.appearanceModes,
                    "type": "combobox"
                },
                {
                    "icon": "width",
                    "name": "Overlay",
                    "key": "sidebar.behavior.overlay"
                },
                {
                    "icon": "width",
                    "name": "Pre-Expand",
                    "key": "sidebar.behavior.preExpand"
                },
                {
                    "icon": "text_fields",
                    "name": "Show Nav Titles",
                    "key": "sidebar.appearance.showNavTitles"
                },
                {
                    "icon": "linear_scale",
                    "name": "Show Sliders",
                    "key": "sidebar.appearance.showSliders"
                },
                {
                    "icon": "api",
                    "name": "APIs",
                    "key": "sidebar.content.apis"
                },
                {
                    "icon": "supervisor_account",
                    "name": "Screen Time",
                    "key": "sidebar.content.screenTime"
                },
                {
                    "icon": "view_agenda",
                    "name": "Shelf",
                    "key": "sidebar.content.shelf"
                },
                {
                    "icon": "check_box",
                    "name": "Tasks",
                    "key": "sidebar.content.tasks"
                },
                {
                    "icon": "history",
                    "name": "History",
                    "key": "sidebar.content.history"
                },
                {
                    "icon": "bookmark",
                    "name": "Bookmarks",
                    "key": "sidebar.content.bookmarks"
                },
                {
                    "icon": "emoji_emotions",
                    "name": "Emojis",
                    "key": "sidebar.content.emojies"
                },
                {
                    "icon": "music_note",
                    "name": "Beats",
                    "key": "sidebar.content.beats"
                },
                {
                    "icon": "tune",
                    "name": "Tweaks",
                    "key": "sidebar.content.tweaks"
                },
                {
                    "icon": "image",
                    "name": "Wallpapers",
                    "key": "sidebar.content.wallpapers"
                },
                {
                    "icon": "dashboard_2",
                    "name": "Overview",
                    "key": "sidebar.content.overview"
                },
                {
                    "icon": "stylus",
                    "name": "Notes",
                    "key": "sidebar.content.notes"
                },
                {
                    "icon": "extension",
                    "name": "Widgets",
                    "key": "sidebar.content.widgets"
                }
            ]
        },
        {
            "section": "Media & Gaming",
            "icon": "music_note",
            "shell": "Main",
            "items": [
                {
                    "icon": "palette",
                    "name": "Adaptive Theme",
                    "key": "mediaPlayer.adaptiveTheme"
                },
                {
                    "icon": "blur_off",
                    "name": "Blur Effect",
                    "key": "mediaPlayer.useBlur"
                },
                {
                    "icon": "palette",
                    "name": "Gradient Footer",
                    "key": "mediaPlayer.enableGrad"
                },
                {
                    "icon": "graphic_eq",
                    "name": "Show Visualizer",
                    "key": "mediaPlayer.showVisualizer"
                },
                {
                    "icon": "graphic_eq",
                    "name": "Visualizer Mode",
                    "type": "combobox",
                    "comboBoxValues": ["Filled", "Bars", "Waveform", "CapsuleWaves", "LineGlow"],
                    "key": "mediaPlayer.visualizerMode"
                },
                {
                    "icon": "palette",
                    "name": "Games Adaptive Theme",
                    "key": "services.games.adaptiveTheme"
                }
            ]
        },
        {
            "section": "System",
            "icon": "settings",
            "shell": "Global",
            "items": [
                {
                    "icon": "hearing",
                    "name": "System Sounds",
                    "key": "desktop.behavior.sounds.enabled"
                },
                {
                    "icon": "mouse",
                    "name": "Faster Scrolling",
                    "key": "interactions.scrolling.fasterTouchpadScroll"
                },
                {
                    "icon": "pets",
                    "name": "Pokemon in terminal",
                    "store": "env",
                    "key": "USE_POKEMON"
                },
                {
                    "icon": "mouse",
                    "name": "Mouse Oriented",
                    "key": "interactions.mouseOriented"
                },
                {
                    "icon": "globe",
                    "name": "Search Engine",
                    "type": "combobox",
                    "comboBoxValues": ["google", "duckduckgo", "yandex", "brave", "startpage"],
                    "key": "networking.searchEngine"
                },
                {
                    "icon": "location_on",
                    "name": "Location",
                    "key": "services.location",
                    "type": "text"
                }
            ]
        },
        {
            "section": "Default Applications",
            "icon": "apps",
            "shell": "Global",
            "items": [
                {
                    "icon": "folder_open",
                    "store": "hypr",
                    "name": "File Manager",
                    "key": "file_manager",
                    "type": "text"
                },
                {
                    "icon": "language",
                    "store": "hypr",
                    "name": "Browser",
                    "key": "browser",
                    "type": "text"
                },
                {
                    "icon": "web",
                    "store": "hypr",
                    "name": "Browser Alt",
                    "key": "browser_alt",
                    "type": "text"
                },
                {
                    "icon": "terminal",
                    "store": "hypr",
                    "name": "Terminal",
                    "key": "terminal",
                    "type": "text"
                },
                {
                    "icon": "code",
                    "store": "hypr",
                    "name": "Terminal Alt",
                    "key": "terminal_alt",
                    "type": "text"
                },
                {
                    "icon": "edit_note",
                    "store": "hypr",
                    "name": "Editor",
                    "key": "editor",
                    "type": "text"
                }
            ]
        },
        {
            "section": "User Profile",
            "icon": "account_circle",
            "shell": "Global",
            "items": [
                {
                    "icon": "folder",
                    "name": "Change Profile Picture",
                    "type": "action",
                    "actionName": "set_face.sh"
                }
            ]
        }
    ]
}
