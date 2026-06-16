import qs.common
import qs.common.utils
import qs.services
import QtQuick
import Quickshell

JsonAdapter {
    property JO applications: JO {
        property JO windowControls: JO {
            property bool minimize: false
            property bool maximize: false
            property bool close: false
        }
    }
    property JO appearance: JO {
        property JO animations
        property JO colors
        property JO transparency
        property JO rounding
        property JO padding
        property JO icons
        property JO fonts
        property JO effects

        effects: JO {
            property bool shaders: false
            property string currentShader: "aero"
            property var availableShaders: []
            property bool showCirclesOnPanel: true
            property int circleCount: 3
        }

        animations: JO {
            property real scale: 1
        }

        colors: JO {
            property string palattePath: "auto"
        }

        transparency: JO {
            property bool blur: true
            property bool enabled: false
            property real scale: 0
        }

        rounding: JO {
            property bool syncCompositor: false
            property real scale: 1.5
            property real power: 2
        }

        padding: JO {
            property real scale: 1
        }

        icons: JO {
            property bool tint: true
        }

        fonts: JO {
            property real scale: 1
            property string main: "Google Sans Flex"
            property bool syncFamily: false
        }
    }

    property JO policies: JO {
        property int ai: 1
        property int translator: 1
        property int todoist: 1
    }

    property JO audio: JO {
        property JO protection: JO {
            property bool enable: false
            property real maxAllowedIncrease: 100
            property real maxAllowed: 200
        }
    }

    property JO interactions: JO {
        property JO scrolling
        property bool mouseOriented: false
        scrolling: JO {
            property bool fasterTouchpadScroll: true
            property int mouseScrollDeltaThreshold: 120
            property int mouseScrollFactor: 120
            property int touchpadScrollFactor: 600
        }
    }

    property JO apps: JO {
        property string bluetooth: "kcmshell6 kcm_bluetooth"
        property string network: "plasmawindowed org.kde.plasma.networkmanagement"
        property string networkEthernet: "kcmshell6 kcm_networkmanagement"
    }

    property JO keys: JO {
        property JO wallpapers: JO {
            property string wallhaven: ""
            property string unsplash: ""
        }
    }

    property JO services: JO {
        property JO idle
        property JO todo
        property JO time
        property JO timers
        property JO weather
        property JO notifications
        property JO nightLight
        property JO ambientSounds
        property JO games
        property JO wallpapers

        property string backlightDevice: "dell::kbd_backlight"
        property bool easyEffects: false
        property string location: "Cairo"
        property list<string> autoExecAppsList: ["vesktop", "kitty"]

        games: JO {
            property bool adaptiveTheme: false
            property list<string> launchEnv: ["__NV_PRIME_RENDER_OFFLOAD=1", "__GLX_VENDOR_LIBRARY_NAME=nvidia"] // Nvidia Offloading
        }

        idle: JO {
            property int timeOut: 10000
            property bool inhibit: false
        }

        nightLight: JO {
            property bool autoNightLightCycle: false
        }

        time: JO {
            property bool use12HourFormat: true
        }

        wallpapers: JO {
            property string method: "wallhaven"
        }

        timers: JO {
            property list<var> customPresets: [
                {
                    "duration": 1500,
                    "icon": "timer",
                    "name": "Example Timer"
                },
            ]
        }
        weather: JO {
            property bool useFehrenheit: false
        }

        notifications: JO {
            property bool silent: false
        }

        ambientSounds: JO {}
    }

    property JO battery: JO {
        property bool automaticSuspend: true
        property int low: 20
        property int critical: 5
        property int suspend: 2
    }

    property JO beam: JO {
        property JO appearance: JO {
            property real animationScale: 1.0
            property string animationStyle: "expo"
        }
        property JO behavior: JO {
            property bool scrollToReveal: true
        }
    }

    property JO sidebar: JO {
        property JO content
        property JO behavior
        property JO appearance
        property JO shelf
        property bool pinned: false

        shelf: JO {
            property int previewDelay: 250
        }

        content: JO {
            property bool apps: true
            property bool screenTime: true
            property bool apis: true
            property bool shelf: true
            property bool tasks: true
            property bool history: true
            property bool bookmarks: true
            property bool emojies: true
            property bool notifs: true
            property bool notes: true
            property bool beats: true
            property bool tweaks: true
            property bool wallpapers: true
            property bool session: true
            property bool widgets: true
            property bool overview: false
            property bool sounds: true
            property bool timers: true
        }

        behavior: JO {
            property bool overlay: false
            property bool preExpand: false
            property bool aiTextFadeIn: false
            property bool superHeldReveal: false
        }

        appearance: JO {
            property string style: "float"
            property real itemListScale: 1
            property bool showNavTitles: false
            property bool showSliders: true
            property bool showVolumeInputSlider: false
            property bool alternateListStripes: true
        }
    }

    property JO osd: JO {
        property int timeout: 3000
        property bool enabled: true
    }

    property JO osk: JO {
        property string layout: "qwerty_full"
    }

    property JO search: JO {
        property int nonAppResultDelay: 120
        property bool sloppy: false
    }

    property JO language: JO {
        property JO translator

        translator: JO {
            property int delay: 100
            property string engine: "auto"
            property string targetLanguage: "العربية"
            property string sourceLanguage: "auto"
        }
    }

    property JO networking: JO {
        property string userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
        property string sidebarAgent: "Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.86 Mobile Safari/537.36"
        property string searchEngine: "google"
    }

    property JO mediaPlayer: JO {
        property int fetchLimit: 24
        property bool useBlur: false
        property bool enableGrad: false
        property bool adaptiveTheme: false
        property string visualizerMode: ""
        property bool showVisualizer: false
        property bool lyrics: false
        property list<string> excludedPlayers: ["playerctld", "mpv", "firefox", "chromium", "kdeconnect"]
    }
    property JO desktop: JO {
        property JO shell
        property JO osd
        property JO bg
        property JO popups
        property JO clock
        property JO icons
        property JO behavior
        property JO widgets
        property JO toasts

        property int screenCorners: 1
        property bool timerOverlayMode: true
        property list<string> customResolutions: []

        toasts: JO {
            property bool enabled: true
        }
        shell: JO {
            property bool deloadOnFullscreen: true
            property string mode: ""
        }
        widgets: JO {
            property bool enabled: false
            property string mode: "col"
        }
        osd: JO {
            property string mode: "bottom_pill"
        }
        popups: JO {
            property string notifications: "TopCenter"
        }
        bg: JO {
            property JO parallax
            property JO live

            property real borderMultiplier: 0.2
            property bool depthMode: true

            parallax: JO {
                property bool enabled: false
                property bool widgetParallax: false
                property bool verticalParallax: false
                property real parallaxStrength: 0.0
            }

            live: JO {
                property int framerate: 24
            }
        }

        clock: JO {
            property bool enabled: false
            property real scale: 1
            property real spacingMultiplier: 0.3
            property bool verticalMode: false
            property string font: "Badeen Display"
        }

        icons: JO {
            property bool enabled: true
            property string currentIconTheme: "Breeze"
        }

        behavior: JO {
            property JO sounds

            sounds: JO {
                property bool enabled: true
                property real level: 0.75
            }
        }
    }

    property JO bar: JO {
        property JO appearance
        property JO behavior
        property JO modules
        property JO keyboard
        property JO workspaces

        property int batteryLowThreshold: 20
        property string horizontalLayout: "Dynamic"
        property string verticalLayout: "VDynamic"

        property JO vMap: JO {
            property int spacing: 5
            property list<string> topArea: ["materialStatusIcons", "battery", "weather", "tray"]
            property list<string> centerArea: []
            property list<string> bottomArea: ["media", "resources", "separator", "volume", "brightness", "separator", "progressWs", "separator", "clock", "separator", "keyboard", "separator", "power"]
        }
        property JO hMap: JO {
            property int spacing: 5
            property list<string> leftArea: ["power", "separator", "progressWs", "separator", "title"]
            property list<string> centerArea: ["media", "separator", "clock"]
            property list<string> rightArea: ["tray", "battery", "materialStatusIcons"]
        }
        property list<string> bars: ["Dynamic", "HyDe", "NovelKnocks", "Sleek", "VDynamic"]

        appearance: JO {
            property string style: "concave"
            property string separatorsMode: "dot"
            property bool enableSeparators: true
            property bool useBg: true
            property bool barGroup: false
            property bool outline: true
            property int size: 50
        }

        behavior: JO {
            property string position: "left"
            property bool autoHide: false
            property bool showOnAll: false
        }

        modules: JO {
            property bool visualizer: false
        }

        keyboard: JO {}

        workspaces: JO {
            property int shownWs: 4
            property bool showAppIcons: true
            property string displayMode: "normal"
            property string customFallback: "●"
            property list<string> avilableModes: ["normal", "japanese", "roman", "custom"]
            property list<string> customMapping: [] // ex: 1: "●"
            property string unicodeChar: "♡"
            property string unicodeMode: "unicode" // "unicode" , "rect"
        }
    }

    property JO dock: JO {

        property bool enabled: false
        property bool hoverToReveal: true
        property int animationDuration: 200

        property JO appearance: JO {
            property real iconSize: 100 * iconSizeMultiplier
            property real iconSizeMultiplier: 0.5
            property string style: "float"
        }
    }

    property JO cheats: JO {
        property string superKey: "󰌽"
        property bool useMacSymbol: true
        property bool splitButtons: true
        property bool useMouseSymbol: true
        property bool useFnSymbol: true
        property JO fontSize: JO {
            property int key: Fonts.sizes.large
            property int comment: Fonts.sizes.verylarge
        }
    }

    property JO hacks: JO {
        property int arbitraryRaceConditionDelay: 100
    }
}
