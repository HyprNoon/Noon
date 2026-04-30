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
            property bool close: true
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

        animations: JO {
            property real scale: 1
        }

        colors: JO {
            property string palattePath: "auto"
            property bool palatte: false
        }

        transparency: JO {
            property bool blur: true
            property bool enabled: false
            property real scale: 0
        }

        rounding: JO {
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
        property JO protection

        protection: JO {
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
        property string settings: "systemsettings"
        property string terminal: "foot"
        property string terminalAlt: "kitty"
        property string browser: "zen-browser"
        property string browserAlt: "firefox"
        property string fileManager: "dolphin"
        property string editor: "zeditor"
    }

    property JO services: JO {
        property JO idle
        property JO todo
        property JO time
        property JO prayer
        property JO weather
        property JO notifications
        property JO nightLight
        property JO ambientSounds
        property JO games
        property string backlightDevice: "dell::kbd_backlight"
        property bool easyEffects: false
        property string location: "Cairo"

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

        prayer: JO {
            property string method: "Egyptian"
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
        property JO behavior: JO {
            property bool scrollToReveal: true
            property bool revealOnEmpty: false
            property bool topMode: false
            property bool clearAiChatBeforeSearch: false
            property bool revealLauncherOnAction: true
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
            property bool apis: true
            property bool shelf: true
            property bool tasks: true
            property bool history: true
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
            property int mode: 2
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
        property string searchPrefix: "https://duckduckgo.com/?q="
    }

    property JO mediaPlayer: JO {
        property int fetchLimit: 24
        property bool useBlur: false
        property bool enableGrad: false
        property bool adaptiveTheme: false
        property string visualizerMode: ""
        property bool showVisualizer: false
        property bool lyrics: false
        property list<string> excludedPlayers: [".mpd", "playerctld", "mpv", "firefox", "chromium", "kdeconnect"]
    }
    property JO desktop: JO {
        property JO shell
        property JO osd
        property JO bg
        property JO clock
        property JO view
        property JO lock
        property JO icons
        property JO hyprland
        property JO behavior
        property JO widgets

        property bool desktopClock: true
        property int screenCorners: 1
        property bool timerOverlayMode: true

        shell: JO {
            property bool deloadOnFullscreen: true
            property string mode: ""
        }
        widgets: JO {
            property bool enabled: true
            property string mode: "col"
        }
        osd: JO {
            property string mode: "bottom_pill"
        }
        view: JO {
            property string mode: "spiral"
        }
        bg: JO {
            property JO parallax

            property real borderMultiplier: 0.2
            property bool depthMode: true
            property bool useQs: true

            parallax: JO {
                property bool enabled: false
                property bool widgetParallax: false
                property bool verticalParallax: false
                property real parallaxStrength: 0.0
            }
        }

        clock: JO {
            property bool enabled: false
            property real scale: 1
            property real spacingMultiplier: 0.3
            property bool verticalMode: false
            property string font: "Badeen Display"
        }

        lock: JO {
            property bool enabled: true
            property bool showAzkar: true
        }

        icons: JO {}

        hyprland: JO {
            property list<string> externalMonitorProfiles: ["1680x1050@68", "1920x1080@60", "1920x1080@72"]
            property string externalMonitorProfile: "1680x1050@68"
            property string tilingLayout: "dwindle"
            property int blurPasses: 1
            property bool unBlurApps: false
            property bool shadows: true
            property int shadowsRange: 1
            property int shadowsPower: 1
            property int gapsOut: 1
            property int gapsIn: 1
            property int borders: 1
            property real applicationsOpacity: 0.6
            property real layerAlpha: 0.6
            property string cursorTheme: "Breeze"
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

        property bool enabled: true
        property int batteryLowThreshold: 20
        property string horizontalLayout: "Dynamic"
        property string verticalLayout: "VDynamic"
        property string currentLayout: "Dynamic"
        property list<var> hMapPresets: []
        property list<var> vMapPresets: []
        property JO vMap: JO {
            property int spacing: 6
            property list<string> topArea: ["materialStatusIcons", "battery", "weather", "tray"]
            property list<string> centerArea: []
            property list<string> bottomArea: ["media", "resources", "separator", "volume", "brightness", "separator", "progressWs", "separator", "clock", "separator", "keyboard", "separator", "power"]
        }
        property JO hMap: JO {
            property int spacing: 6
            property list<string> leftArea: ["power", "separator", "progressWs", "separator", "title"]
            property list<string> centerArea: ["media", "separator", "clock"]
            property list<string> rightArea: ["tray", "battery", "materialStatusIcons"]
        }
        property list<string> bars: ["Dynamic", "HyDe", "NovelKnocks", "Sleek", "VDynamic"]

        appearance: JO {
            property int mode: 2
            property bool enableSeparators: true
            property bool useBg: true
            property bool barGroup: false
            property bool outline: true
            property int height: 45
            property int width: 50
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
        property JO appearance

        property bool enabled: false
        property bool hoverToReveal: true
        property int animationDuration: 200
        appearance: JO {
            property real iconSize: 100 * iconSizeMultiplier
            property real iconSizeMultiplier: 0.5
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
