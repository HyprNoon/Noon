pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    readonly property var tweaks: [
        {
            "section": "Noon",
            "icon": "palette",
            "shell": "Global",
            "subsections": [
                {
                    "name": "Shell Appearance",
                    "items": [
                        {
                            "icon": "palette",
                            "name": "Shell Mode",
                            "type": "combobox",
                            "comboBoxValues": ["main", "xp", "nobuntu"],
                            "key": "desktop.shell.mode"
                        },
                        {
                            "icon": "rounded_corner",
                            "name": "Rounding Level",
                            "key": "appearance.rounding.scale",
                            "type": "slider",
                            "sliderMinValue": 0,
                            "sliderMaxValue": 3
                        },
                        {
                            "icon": "shutter_speed",
                            "name": "Rounding Power",
                            "key": "appearance.rounding.power",
                            "type": "slider",
                            "sliderMinValue": 1,
                            "sliderMaxValue": 4
                        },
                        {
                            "icon": "border_all",
                            "name": "Border Multiplier",
                            "key": "desktop.bg.borderMultiplier",
                            "type": "slider",
                            "sliderMinValue": 0,
                            "sliderMaxValue": 1
                        },
                        {
                            "icon": "crop_free",
                            "name": "Screen Corners",
                            "key": "desktop.screenCorners",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Transparency & Blur",
                    "items": [
                        {
                            "icon": "opacity",
                            "name": "Enable Transparency",
                            "key": "appearance.transparency.enabled"
                        },
                        {
                            "icon": "blur_on",
                            "name": "Shell Blur",
                            "key": "appearance.transparency.blur"
                        },
                        {
                            "icon": "layers",
                            "name": "Transparency Level",
                            "key": "appearance.transparency.scale",
                            "type": "slider",
                            "sliderMinValue": 0.1,
                            "sliderMaxValue": 1.0
                        }
                    ]
                },
                {
                    "name": "Typography & Icons",
                    "items": [
                        {
                            "icon": "font_download",
                            "name": "Main Font",
                            "key": "appearance.fonts.main",
                            "type": "text"
                        },
                        {
                            "icon": "font_download",
                            "name": "Main Font",
                            "key": "appearance.fonts.scale",
                            "type": "text"
                        },
                        {
                            "icon": "sync",
                            "name": "Sync Family",
                            "key": "appearance.fonts.syncFamily"
                        },
                        {
                            "icon": "format_paint",
                            "name": "Tint Icons",
                            "key": "appearance.icons.tint"
                        }
                    ]
                },
                {
                    "name": "Scaling",
                    "items": [
                        {
                            "icon": "format_size",
                            "name": "Font Scale",
                            "key": "appearance.fonts.scale",
                            "type": "spin"
                        },
                        {
                            "icon": "motion_photos_on",
                            "name": "Animations Scale",
                            "key": "appearance.animations.scale",
                            "type": "spin"
                        },
                        {
                            "icon": "motion_photos_on",
                            "name": "Padding Scale",
                            "key": "appearance.padding.scale",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Noon Apps",
                    "items": [
                        {
                            "icon": "close",
                            "name": "Close Button",
                            "key": "applications.windowControls.close"
                        },
                        {
                            "icon": "expand_content",
                            "name": "Maximize Button",
                            "key": "applications.windowControls.maximize"
                        },
                        {
                            "icon": "collapse_content",
                            "name": "Minimize Button",
                            "key": "applications.windowControls.minimize"
                        }
                    ]
                }
            ]
        },
        {
            "section": "Hyprland",
            "icon": "water_drop",
            "shell": "Global",
            "subsections": [
                {
                    "name": "Decorations",
                    "items": [
                        {
                            "icon": "border_all",
                            "name": "Gaps In",
                            "key": "desktop.hyprland.gapsIn",
                            "type": "spin"
                        },
                        {
                            "icon": "border_outer",
                            "name": "Gaps Out",
                            "key": "desktop.hyprland.gapsOut",
                            "type": "spin"
                        },
                        {
                            "icon": "line_weight",
                            "name": "Border Width",
                            "key": "desktop.hyprland.borders",
                            "type": "spin"
                        },
                        {
                            "icon": "blur_on",
                            "name": "Blur Passes",
                            "key": "desktop.hyprland.blurPasses",
                            "type": "spin"
                        },
                        {
                            "icon": "dark_mode",
                            "name": "Shadows",
                            "key": "desktop.hyprland.shadows"
                        },
                        {
                            "icon": "star",
                            "name": "Shadow Power",
                            "key": "desktop.hyprland.shadowsPower",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Default Apps",
                    "items": [
                        {
                            "icon": "terminal",
                            "name": "Terminal",
                            "key": "apps.terminal",
                            "type": "text"
                        },
                        {
                            "icon": "web",
                            "name": "Browser",
                            "key": "apps.browser",
                            "type": "text"
                        },
                        {
                            "icon": "folder",
                            "name": "File Manager",
                            "key": "apps.fileManager",
                            "type": "text"
                        },
                        {
                            "icon": "code",
                            "name": "Editor",
                            "key": "apps.editor",
                            "type": "text"
                        }
                    ]
                },
                {
                    "name": "Tiling & Layout",
                    "items": [
                        {
                            "icon": "dashboard",
                            "name": "Tiling Layout",
                            "key": "desktop.hyprland.tilingLayout",
                            "type": "combobox",
                            "comboBoxValues": ["dwindle", "scrolling", "master"]
                        },
                    ]
                },
            ]
        },
        {
            "section": "Modules",
            "icon": "grid_view",
            "shell": "Global",
            "subsections": [
                {
                    "name": "Wallpaper",
                    "items": [
                        {
                            "icon": "dashboard",
                            "name": "Widgets",
                            "key": "desktop.widgets.enabled"
                        },
                        {
                            "icon": "palette",
                            "name": "Widgets Mode",
                            "key": "desktop.widgets.mode",
                            "type": "combobox",
                            "comboBoxValues": ["col", "grad"]
                        },
                        {
                            "icon": "3d_rotation",
                            "name": "Parallax Enabled",
                            "key": "desktop.bg.parallax.enabled"
                        },
                        {
                            "icon": "vibration",
                            "name": "Motion Strength",
                            "key": "desktop.bg.parallax.parallaxStrength",
                            "type": "slider",
                            "sliderMinValue": 0,
                            "sliderMaxValue": 0.1
                        },
                        {
                            "icon": "height",
                            "name": "Vertical Parallax",
                            "key": "desktop.bg.parallax.verticalParallax"
                        },
                        {
                            "icon": "widgets",
                            "name": "Widget Parallax",
                            "key": "desktop.bg.parallax.widgetParallax"
                        },
                        {
                            "icon": "layers_clear",
                            "name": "Deload On Fullscreen",
                            "key": "desktop.shell.deloadOnFullscreen"
                        },
                        {
                            "icon": "image",
                            "name": "Depth Mode",
                            "key": "desktop.bg.depthMode"
                        }
                    ]
                },
                {
                    "name": "Desktop Clock",
                    "items": [
                        {
                            "icon": "timer",
                            "name": "Enable Clock",
                            "key": "desktop.clock.enabled"
                        },
                        {
                            "icon": "font_download",
                            "name": "Clock Font",
                            "key": "desktop.clock.font",
                            "type": "text"
                        },
                        {
                            "icon": "reorder",
                            "name": "Vertical Mode",
                            "key": "desktop.clock.verticalMode"
                        },
                        {
                            "icon": "zoom_in",
                            "name": "Clock Scale",
                            "key": "desktop.clock.scale",
                            "type": "slider",
                            "sliderMinValue": 0.5,
                            "sliderMaxValue": 3
                        }
                    ]
                },
                {
                    "name": "OSD Settings",
                    "items": [
                        {
                            "icon": "notification_important",
                            "name": "Enable OSD",
                            "key": "osd.enabled"
                        },
                        {
                            "icon": "timer",
                            "name": "OSD Timeout",
                            "key": "osd.timeout",
                            "type": "spin"
                        },
                        {
                            "icon": "palette",
                            "name": "OSD Mode",
                            "key": "desktop.osd.mode",
                            "type": "combobox",
                            "comboBoxValues": ["Pixel", "BottomPill", "Nobuntu", "CenterIsland", "SideBay"]
                        }
                    ]
                },
                {
                    "name": "Expose",
                    "items": [
                        {
                            "icon": "dashboard",
                            "name": "Expose Mode",
                            "type": "combobox",
                            "comboBoxValues": ['smartgrid', 'justified', 'bands', 'masonry', 'hero', 'spiral', 'satellite', 'staggered', 'columnar'],
                            "key": "desktop.view.mode"
                        }
                    ]
                },
                {
                    "name": "Dock",
                    "items": [
                        {
                            "icon": "dock",
                            "name": "Enable Dock",
                            "key": "dock.enabled"
                        },
                        {
                            "icon": "pan_tool_alt",
                            "name": "Hover Reveal",
                            "key": "dock.hoverToReveal"
                        },
                        {
                            "icon": "photo_size_select_large",
                            "name": "Size Scale",
                            "key": "dock.appearance.iconSizeMultiplier",
                            "type": "slider",
                            "sliderMinValue": 0.3,
                            "sliderMaxValue": 1.2
                        }
                    ]
                },
                {
                    "name": "Beam Search",
                    "items": [
                        {
                            "icon": "keyboard_double_arrow_down",
                            "name": "Scroll Reveal",
                            "key": "beam.behavior.scrollToReveal"
                        },
                        {
                            "icon": "cleaning_services",
                            "name": "Auto-Clear Chat",
                            "key": "beam.behavior.clearAiChatBeforeSearch"
                        },
                        {
                            "icon": "unfold_more",
                            "name": "Reveal Empty",
                            "key": "beam.behavior.revealOnEmpty"
                        }
                    ]
                }
            ]
        },
        {
            "section": "Bar",
            "icon": "toolbar",
            "shell": "Main",
            "subsections": [
                {
                    "name": "Bar Appearance",
                    "items": [
                        {
                            "icon": "visibility",
                            "name": "Enable Bar",
                            "key": "bar.enabled"
                        },
                        {
                            "icon": "palette",
                            "name": "Mode",
                            "key": "bar.appearance.mode",
                            "type": "spin"
                        },
                        {
                            "icon": "palette",
                            "name": "Use Background",
                            "key": "bar.appearance.useBg"
                        },
                        {
                            "icon": "border_all",
                            "name": "Group Modules",
                            "key": "bar.appearance.barGroup"
                        },
                        {
                            "icon": "border_outer",
                            "name": "Outline",
                            "key": "bar.appearance.outline"
                        },
                        {
                            "icon": "width",
                            "name": "Spacing",
                            "key": "bar.spacing",
                            "type": "spin"
                        },
                        {
                            "icon": "reorder",
                            "name": "Separators",
                            "key": "bar.appearance.enableSeparators"
                        },
                        {
                            "icon": "width_full",
                            "name": "Bar Width",
                            "key": "bar.appearance.width",
                            "type": "spin"
                        },
                        {
                            "icon": "height",
                            "name": "Bar Height",
                            "key": "bar.appearance.height",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Workspaces",
                    "items": [
                        {
                            "icon": "visibility",
                            "name": "Show Icons",
                            "key": "bar.workspaces.showAppIcons"
                        },
                        {
                            "icon": "format_list_numbered",
                            "name": "Visible Count",
                            "key": "bar.workspaces.shownWs",
                            "type": "spin"
                        },
                        {
                            "icon": "style",
                            "name": "Display Mode",
                            "key": "bar.workspaces.displayMode",
                            "type": "combobox",
                            "comboBoxValues": ["normal", "japanese", "roman", "custom"]
                        },
                        {
                            "icon": "edit",
                            "name": "Custom Symbol",
                            "key": "bar.workspaces.customFallback",
                            "type": "text"
                        }
                    ]
                }
            ]
        },
        {
            "section": "Sidebar",
            "icon": "side_navigation",
            "shell": "Main",
            "subsections": [
                {
                    "name": "Launcher Behavior",
                    "items": [
                        {
                            "icon": "palette",
                            "name": "Appearance Mode",
                            "key": "sidebar.appearance.mode",
                            "type": "spin"
                        },
                        {
                            "icon": "layers",
                            "name": "Overlay Mode",
                            "key": "sidebar.behavior.overlay"
                        },
                        {
                            "icon": "expand",
                            "name": "Pre-Expand",
                            "key": "sidebar.behavior.preExpand"
                        },
                        {
                            "icon": "text_fields",
                            "name": "Nav Titles",
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
                    "name": "Content Visibility",
                    "items": [
                        {
                            "icon": "apps",
                            "name": "Apps",
                            "key": "sidebar.content.apps"
                        },
                        {
                            "icon": "api",
                            "name": "APIs",
                            "key": "sidebar.content.apis"
                        },
                        {
                            "icon": "share",
                            "name": "QuickShare",
                            "key": "sidebar.content.share"
                        },
                        {
                            "icon": "public",
                            "name": "Web",
                            "key": "sidebar.content.web"
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
                            "icon": "notifications",
                            "name": "Notifications",
                            "key": "sidebar.content.notifs"
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
                            "icon": "account_circle",
                            "name": "Session",
                            "key": "sidebar.content.session"
                        },
                        {
                            "icon": "sports_esports",
                            "name": "Games",
                            "key": "sidebar.content.games"
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
                        },
                        {
                            "icon": "more_horiz",
                            "name": "Misc",
                            "key": "sidebar.content.misc"
                        }
                    ]
                },
                {
                    "name": "Beats Appearance",
                    "items": [
                        {
                            "icon": "equalizer",
                            "name": "Show Visualizer",
                            "key": "mediaPlayer.showVisualizer"
                        },
                        {
                            "icon": "view_quilt",
                            "name": "Visualizer Mode",
                            "key": "mediaPlayer.visualizerMode",
                            "type": "combobox",
                            "comboBoxValues": ["filled", "bars", "waveform", "circular", "particles"]
                        },
                        {
                            "icon": "palette",
                            "name": "Adaptive Theme",
                            "key": "mediaPlayer.adaptiveTheme"
                        },
                        {
                            "icon": "blur_on",
                            "name": "Blur Player",
                            "key": "mediaPlayer.useBlur"
                        },
                    ]
                },
            ]
        },
        {
            "section": "Services",
            "icon": "settings_input_component",
            "shell": "Global",
            "subsections": [
                {
                    "name": "AI",
                    "items": [
                        {
                            "icon": "model_training",
                            "name": "Model",
                            "key": "ai.model",
                            "type": "text"
                        },
                        {
                            "icon": "thermostat",
                            "name": "Temperature",
                            "key": "ai.temperature",
                            "type": "slider",
                            "sliderMinValue": 0,
                            "sliderMaxValue": 1
                        },
                        {
                            "icon": "bolt",
                            "name": "Function Mode",
                            "key": "ai.tool",
                            "type": "combobox",
                            "comboBoxValues": ["functions", "search", "none"]
                        },
                        {
                            "icon": "summarize",
                            "name": "Summary Prompt",
                            "key": "ai.summaryPrompt",
                            "type": "text"
                        },
                        {
                            "icon": "screenshot",
                            "name": "Vision Hint",
                            "key": "ai.beamScreenshotHintCommand",
                            "type": "text"
                        }
                    ]
                },
                {
                    "name": "AI Instructions",
                    "items": [
                        {
                            "icon": "description",
                            "name": "System Prompt",
                            "key": "ai.systemPrompt",
                            "type": "field",
                            "fillHeight": true
                        }
                    ]
                },
                {
                    "name": "AI Awareness",
                    "items": [
                        {
                            "icon": "badge",
                            "name": "Username",
                            "key": "ai.context.username"
                        },
                        {
                            "icon": "laptop_chromebook",
                            "name": "Distro Info",
                            "key": "ai.context.distro"
                        },
                        {
                            "icon": "desktop_windows",
                            "name": "DE Context",
                            "key": "ai.context.desktopEnvironment"
                        },
                        {
                            "icon": "schedule",
                            "name": "DateTime",
                            "key": "ai.context.datetime"
                        },
                        {
                            "icon": "location_on",
                            "name": "Location",
                            "key": "ai.context.location"
                        },
                        {
                            "icon": "cloud",
                            "name": "Weather",
                            "key": "ai.context.weather"
                        },
                        {
                            "icon": "description",
                            "name": "PDF Content",
                            "key": "ai.context.pdf"
                        },
                        {
                            "icon": "notes",
                            "name": "Notes Access",
                            "key": "ai.context.notes"
                        },
                        {
                            "icon": "alarm",
                            "name": "Alarms & Timers",
                            "key": "ai.context.alarms"
                        },
                        {
                            "icon": "event_note",
                            "name": "Task List",
                            "key": "ai.context.tasks"
                        },
                        {
                            "icon": "window",
                            "name": "Active Window",
                            "key": "ai.context.windowclass"
                        },
                        {
                            "icon": "play_circle",
                            "name": "Now Playing",
                            "key": "ai.context.currentMedia"
                        }
                    ]
                },
                {
                    "name": "Language & Translation",
                    "items": [
                        {
                            "icon": "translate",
                            "name": "Target Lang",
                            "key": "language.translator.targetLanguage",
                            "type": "text"
                        },
                        {
                            "icon": "smart_toy",
                            "name": "Engine",
                            "key": "language.translator.engine",
                            "type": "combobox",
                            "comboBoxValues": ["auto", "google", "bing", "deepl"]
                        },
                        {
                            "icon": "timer",
                            "name": "Process Delay",
                            "key": "language.translator.delay",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Region & Prayer",
                    "items": [
                        {
                            "icon": "location_city",
                            "name": "City",
                            "key": "services.location",
                            "type": "text"
                        },
                        {
                            "icon": "mosque",
                            "name": "Prayer Method",
                            "key": "services.prayer.method",
                            "type": "text"
                        },
                        {
                            "icon": "schedule",
                            "name": "12-Hour Format",
                            "key": "services.time.use12HourFormat"
                        }
                    ]
                }
            ]
        },
        {
            "section": "System Control",
            "icon": "settings",
            "shell": "Global",
            "subsections": [
                {
                    "name": "Policies",
                    "items": [
                        {
                            "icon": "security",
                            "name": "AI Policy",
                            "key": "policies.ai",
                            "type": "spin"
                        },
                        {
                            "icon": "translate",
                            "name": "Translator Policy",
                            "key": "policies.translator",
                            "type": "spin"
                        },
                        {
                            "icon": "medical_services",
                            "name": "Medical Terminology Policy",
                            "key": "policies.medicalDictionary",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Power & Battery",
                    "items": [
                        {
                            "icon": "power_settings_new",
                            "name": "Auto Suspend",
                            "key": "battery.automaticSuspend"
                        },
                        {
                            "icon": "battery_alert",
                            "name": "Low Level",
                            "key": "battery.low",
                            "type": "spin"
                        },
                        {
                            "icon": "battery_charging_full",
                            "name": "Suspend Level",
                            "key": "battery.suspend",
                            "type": "spin"
                        }
                    ]
                },
                {
                    "name": "Audio",
                    "items": [
                        {
                            "icon": "security",
                            "name": "Safety Limiter",
                            "key": "audio.protection.enable"
                        },
                        {
                            "icon": "volume_up",
                            "name": "Max Allowed Vol",
                            "key": "audio.protection.maxAllowed",
                            "type": "spin"
                        },
                        {
                            "icon": "music_note",
                            "name": "System Sounds",
                            "key": "desktop.behavior.sounds.enabled"
                        },
                        {
                            "icon": "volume_down",
                            "name": "Sound Level",
                            "key": "desktop.behavior.sounds.level",
                            "type": "slider",
                            "sliderMinValue": 0,
                            "sliderMaxValue": 1
                        }
                    ]
                },
                {
                    "name": "Idle",
                    "items": [
                        {
                            "icon": "shutter_speed",
                            "name": "Inhibit Idle",
                            "key": "services.idle.inhibit"
                        },
                        {
                            "icon": "timer",
                            "name": "Idle Timeout",
                            "key": "services.idle.timeOut",
                            "type": "text"
                        },
                        {
                            "icon": "lock",
                            "name": "Lockscreen",
                            "key": "desktop.lock.enabled"
                        }
                    ]
                },
                {
                    "name": "Scrolling",
                    "items": [
                        {
                            "icon": "mouse",
                            "name": "Fast Touchpad",
                            "key": "interactions.scrolling.fasterTouchpadScroll"
                        },
                        {
                            "icon": "mouse",
                            "name": "Mouse Oriented",
                            "key": "interactions.mouseOriented"
                        },
                        {
                            "icon": "swap_calls",
                            "name": "Scroll Threshold",
                            "key": "interactions.scrolling.mouseScrollDeltaThreshold",
                            "type": "spin"
                        },
                        {
                            "icon": "speed",
                            "name": "Scroll Speed",
                            "key": "interactions.scrolling.touchpadScrollFactor",
                            "type": "spin"
                        }
                    ]
                }
            ]
        },
        {
            "section": "Advanced",
            "icon": "terminal",
            "shell": "Global",
            "subsections": [
                {
                    "name": "Optimization & Hacks",
                    "items": [
                        {
                            "icon": "memory",
                            "name": "Race Delay",
                            "key": "hacks.arbitraryRaceConditionDelay",
                            "type": "spin"
                        }
                    ]
                }
            ]
        },
    ]
}
