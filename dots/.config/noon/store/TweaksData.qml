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
                    "store": "state",
                    "comboBoxValues": IconThemesService.availableIconThemeIds
                },
                {
                    "icon": "arrow_selector_tool",
                    "name": "Cursor Theme",
                    "store": "hypr",
                    "key": "cursor_theme",
                    "type": "combobox",
                    "comboBoxValues": CursorsService.cursors
                }
            ]
        },
        {
            "section": "Fonts & Typography",
            "icon": "font_download",
            "shell": "Global",
            "items": [
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
                }
            ]
        },
        {
            "section": "Hyprland",
            "icon": "water_drop",
            "shell": "Global",
            "items": [
                {
                    "icon": "ads_click",
                    "name": "Cursor Size",
                    "store": "hypr",
                    "key": "cursor_size",
                    "type": "spin"
                },
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
                    "comboBoxValues": ["standard", "snappy", "cinematic"]
                },
                {
                    "icon": "monitor",
                    "name": "External Monitor Profile",
                    "type": "combobox",
                    "store": "hypr",
                    "key": "external_monitor_mode",
                    "comboBoxValues": Mem.options.desktop.hyprland.externalMonitorProfiles
                },
            ]
        },
        {
            "section": "OSDs",
            "icon": "notifications",
            "shell": "Main",
            "items": [
                {
                    "icon": "notifications",
                    "name": "OSD Mode",
                    "key": "desktop.osd.mode",
                    "type": "combobox",
                    "comboBoxValues": ["Pixel", "BottomPill", "Nobuntu", "CenterIsland", "SideBay"]
                }
            ]
        },
        {
            "section": "Clock Settings",
            "icon": "schedule",
            "shell": "Main",
            "items": [
                {
                    "icon": "timer",
                    "name": "Desktop Clock",
                    "key": "desktop.clock.enabled"
                },
                {
                    "icon": "brand_family",
                    "name": "Arabic Mode",
                    "key": "desktop.clock.arabicMode"
                },
                {
                    "icon": "timer",
                    "name": "Center Clock",
                    "store": "state",
                    "enableTooltip": false,
                    "key": "desktop.clock.center"
                },
                {
                    "icon": "schedule",
                    "name": "Layer Clock Font",
                    "key": "desktop.clock.font",
                    "type": "combobox",
                    "comboBoxValues": ["Badeen Display", "Ndot 55", "Six Caps", "Alfa Slab One", "Notable", "Monoton", "Titan One", "Bebas Neue", "Rubik", "UnifrakturCook"]
                },
                {
                    "store": "state",
                    "icon": "font_download",
                    "name": "Clock Weight",
                    "key": "fonts.variableAxes.display.wght",
                    "type": "slider",
                    "sliderMinValue": 100,
                    "sliderValue": 100,
                    "sliderMaxValue": 1000
                },
                {
                    "store": "state",
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
                    "store": "state",
                    "icon": "timer",
                    "name": "Clock Size",
                    "key": "desktop.clock.scale",
                    "type": "slider",
                    "sliderMinValue": 0.25,
                    "sliderValue": 0.25,
                    "sliderMaxValue": 4
                }
            ]
        },
        {
            "section": "Modules",
            "icon": "dashboard_customize",
            "shell": "Main",
            "items": [
                {
                    "icon": "menu",
                    "name": "Bar",
                    "key": "bar.enabled"
                },
                {
                    "icon": "dock",
                    "name": "Dock",
                    "key": "dock.enabled"
                },
                {
                    "icon": "notifications",
                    "name": "OSD",
                    "key": "osd.enabled"
                },
                {
                    "icon": "lock",
                    "name": "Lock Screen",
                    "key": "desktop.lock.enabled"
                }
            ]
        },
        {
            "section": "Bar",
            "icon": "toolbar",
            "shell": "Main",
            "items": [
                {
                    "icon": "palette",
                    "name": "Background",
                    "key": "bar.appearance.useBg"
                },
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
                    "name": "Bar Mode",
                    "key": "bar.appearance.mode",
                    "type": "spin"
                },
                {
                    "icon": "width_full",
                    "name": "Width",
                    "key": "bar.appearance.width",
                    "type": "spin"
                },
                {
                    "icon": "height",
                    "name": "Height",
                    "key": "bar.appearance.height",
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
                    "key": "bar.modules.visualizer",
                    "condition": "Mem.options.bar.currentLayout === 5"
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
                    "icon": "straighten",
                    "name": "Icon Size",
                    "key": "dock.appearance.iconSizeMultiplier",
                    "type": "slider",
                    "sliderMinValue": 0.4,
                    "sliderMaxValue": 1
                }
            ]
        },
        {
            "section": "Sidebar Launcher",
            "icon": "view_sidebar",
            "shell": "Main",
            "items": [
                {
                    "icon": "tune",
                    "name": "Mode",
                    "key": "sidebar.appearance.mode",
                    "type": "spin"
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
                }
            ]
        },
        {
            "section": "Sidebar Content",
            "icon": "dashboard",
            "shell": "Main",
            "items": [
                {
                    "icon": "api",
                    "name": "APIs",
                    "key": "sidebar.content.apis"
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
            "section": "Beam",
            "icon": "api",
            "shell": "Main",
            "items": [
                {
                    "icon": "animation",
                    "name": "Animation Style",
                    "type": "combobox",
                    "comboBoxValues": BeamData.availableAnimationStyles,
                    "key": "beam.appearance.animationStyle"
                },
                {
                    "icon": "masked_transitions",
                    "name": "Animation Scale",
                    "type": "text",
                    "key": "beam.appearance.animationScale"
                }
            ]
        },
        {
            "section": "Media Player",
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
                    "comboBoxValues": ["filled", "thickbars", "bars", "circular", "waveform", "particles", "gradient", "fluid", "neural", "ripple", "plasma", "crystal", "wave3d", "atom"],
                    "key": "mediaPlayer.visualizerMode"
                }
            ]
        },
        {
            "section": "Games Launcher",
            "icon": "stadia_controller",
            "shell": "Main",
            "items": [
                {
                    "icon": "palette",
                    "name": "Adaptive Theme",
                    "key": "services.games.adaptiveTheme"
                }
            ]
        },
        {
            "section": "Desktop & Wallpaper",
            "icon": "wallpaper",
            "shell": "Global",
            "items": [
                {
                    "icon": "extension",
                    "name": "Widgets",
                    "key": "desktop.widgets.enabled"
                },
                {
                    "icon": "palette",
                    "name": "Widgets Bg Mode",
                    "key": "desktop.widgets.mode",
                    "type": "combobox",
                    "comboBoxValues": ["col", "grad"]
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
            "section": "System & Behavior",
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
                    "icon": "mouse",
                    "name": "Mouse Oriented",
                    "key": "interactions.mouseOriented"
                },
                {
                    "icon": "dashboard",
                    "name": "Expose Mode",
                    "type": "combobox",
                    "comboBoxValues": ['smartgrid', 'justified', 'bands', 'masonry', 'hero', 'spiral', 'satellite', 'staggered', 'columnar'],
                    "key": "desktop.view.mode"
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
            "section": "Default Apps",
            "icon": "apps",
            "shell": "Global",
            "items": [
                {
                    "icon": "folder_open",
                    "name": "File Manager",
                    "key": "apps.fileManager",
                    "type": "text"
                },
                {
                    "icon": "language",
                    "name": "Browser",
                    "key": "apps.browser",
                    "type": "text"
                },
                {
                    "icon": "web",
                    "name": "Browser Alt",
                    "key": "apps.browserAlt",
                    "type": "text"
                },
                {
                    "icon": "terminal",
                    "name": "Terminal",
                    "key": "apps.terminal",
                    "type": "text"
                },
                {
                    "icon": "code",
                    "name": "Terminal Alt",
                    "key": "apps.terminalAlt",
                    "type": "text"
                },
                {
                    "icon": "edit_note",
                    "name": "Editor",
                    "key": "apps.editor",
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
