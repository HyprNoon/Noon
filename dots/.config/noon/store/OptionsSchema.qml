import qs.common
import qs.common.utils
import qs.services
import QtQuick
import Quickshell

JsonAdapter {
    property JsonObject applications: JsonObject {
        property JsonObject windowControls: JsonObject {
            property bool minimize: false
            property bool maximize: false
            property bool close: true
        }
    }
    property JsonObject appearance: JsonObject {
        property JsonObject animations
        property JsonObject colors
        property JsonObject transparency
        property JsonObject rounding
        property JsonObject padding
        property JsonObject icons
        property JsonObject fonts

        animations: JsonObject {
            property real scale: 1
        }

        colors: JsonObject {
            property string palattePath: "auto"
            property bool palatte: false
        }

        transparency: JsonObject {
            property bool blur: true
            property bool enabled: false
            property real scale: 0
        }

        rounding: JsonObject {
            property real scale: 1
            property real power: 2
        }

        padding: JsonObject {
            property real scale: 1
        }

        icons: JsonObject {
            property bool tint: true
        }

        fonts: JsonObject {
            property real scale: 1
            property string main: "Google Sans Flex"
            property bool syncFamily: false
        }
    }

    property JsonObject policies: JsonObject {
        property int ai: 1
        property int translator: 1
        property int todoist: 1
    }

    property JsonObject ai: JsonObject {

        property string beamScreenshotHintCommand: "Explain This Briefly and Simply"
        property string summaryPrompt: "Summarize the following text:"

        property string systemPrompt: "
        ## Style
        - You are '7ebesha - حبيشة' a funny and smart tiny assistant
        - Use Arabic - Egyptian Dilect
        - don't be formal!
        - Make sure you answer precisely without hallucination and prefer bullet points over walls of text.
        - Don't repeat the user's question

         ## Presentation
            - Use Markdown features in your response:
            - **Bold** text to **highlight keywords** in your response when needed
            - **Split long information into small sections** with h2 headers and a relevant emoji in the begining (for example `## 🐧 Linux`).
            - Bullet points are preferred over long paragraphs, unless you're offering writing support or instructed otherwise by the user.
            - Asked to compare different options? You should firstly use a table to compare the main aspects, then elaborate or include relevant comments from online forums *after* the table.
            - Make sure to provide a final recommendation for the user's use case!
            - Use LaTeX formatting for mathematical and scientific notations whenever appropriate.
            - Enclose all LaTeX '$$' delimiters. NEVER generate LaTeX code in a latex block unless the user explicitly asks for it.
            - DO NOT use LaTeX for regular documents (resumes, letters, essays, CVs, etc...).
            - Try to be very very cheap with tokens.
            - DO NOT yap alot just Concise & Precise.
        "
        property string tool: "functions"
        // property list<var> extraModels: []
        property string model: "gemini-3.1-flash-lite"
        property real temperature: 0.5
        property JsonObject context: JsonObject {
            property bool distro: false
            property bool datetime: false
            property bool windowclass: false
            property bool desktopEnvironment: false
            property bool tasks: false
            property bool alarms: false
            property bool timers: false
            property bool username: false
            property bool location: false
            property bool notes: false
            property bool currentMedia: false
            property bool weather: false
            property bool pdf: false
        }
    }

    property JsonObject audio: JsonObject {
        property JsonObject protection

        protection: JsonObject {
            property bool enable: false
            property real maxAllowedIncrease: 100
            property real maxAllowed: 200
        }
    }

    property JsonObject interactions: JsonObject {
        property JsonObject scrolling
        property bool mouseOriented: false
        scrolling: JsonObject {
            property bool fasterTouchpadScroll: true
            property int mouseScrollDeltaThreshold: 120
            property int mouseScrollFactor: 120
            property int touchpadScrollFactor: 600
        }
    }

    property JsonObject apps: JsonObject {
        property string bluetooth: "kcmshell6 kcm_bluetooth"
        property string network: "plasmawindowed org.kde.plasma.networkmanagement"
        property string networkEthernet: "kcmshell6 kcm_networkmanagement"
        property string settings: "systemsettings"
        property string terminal: "foot"
        property string terminalAlt: "kitty"
        property string browser: "zen-browser"
        property string browserAlt: "firefox"
        property string fileManager: "dolphin"
        property string editor: "codium"
    }

    property JsonObject services: JsonObject {
        property JsonObject idle
        property JsonObject todo
        property JsonObject time
        property JsonObject prayer
        property JsonObject weather
        property JsonObject recording
        property JsonObject notifications
        property JsonObject nightLight
        property JsonObject ambientSounds
        property JsonObject games
        property string backlightDevice: "dell::kbd_backlight"
        property bool easyEffects: false
        property string location: "Cairo"

        games: JsonObject {
            property bool adaptiveTheme: false
            property list<string> launchEnv: ["__NV_PRIME_RENDER_OFFLOAD=1", "__GLX_VENDOR_LIBRARY_NAME=nvidia"] // Nvidia Offloading
        }

        idle: JsonObject {
            property int timeOut: 10000
            property bool inhibit: false
        }

        nightLight: JsonObject {
            property bool autoNightLightCycle: false
        }
        time: JsonObject {
            property bool use12HourFormat: true
        }

        prayer: JsonObject {
            property string method: "Egyptian"
        }

        weather: JsonObject {
            property bool useFehrenheit: false
        }

        recording: JsonObject {
            property int recordingMode: 0
            property int audioMode: 1
            property int quality: 1
            property string customOutputPath: ""
            property bool showCursor: true
            property int customFramerate: 0
        }

        notifications: JsonObject {
            property bool silent: false
        }

        ambientSounds: JsonObject {}
    }

    property JsonObject battery: JsonObject {
        property bool automaticSuspend: true
        property int low: 20
        property int critical: 5
        property int suspend: 2
    }

    property JsonObject beam: JsonObject {
        property JsonObject behavior: JsonObject {
            property bool scrollToReveal: true
            property bool revealOnEmpty: false
            property bool topMode: false
            property bool clearAiChatBeforeSearch: false
            property bool revealLauncherOnAction: true
        }
    }

    property JsonObject sidebar: JsonObject {
        property JsonObject content
        property JsonObject behavior
        property JsonObject appearance
        property JsonObject shelf
        property bool pinned: false

        shelf: JsonObject {
            property int previewDelay: 250
        }

        content: JsonObject {
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

        behavior: JsonObject {
            property bool overlay: false
            property bool preExpand: false
            property bool aiTextFadeIn: false
            property bool superHeldReveal: false
        }

        appearance: JsonObject {
            property int mode: 2
            property real itemListScale: 1
            property bool showNavTitles: false
            property bool showSliders: true
            property bool showVolumeInputSlider: false
            property bool alternateListStripes: true
        }
    }

    property JsonObject osd: JsonObject {
        property int timeout: 3000
        property bool enabled: true
    }

    property JsonObject osk: JsonObject {
        property string layout: "qwerty_full"
    }

    property JsonObject search: JsonObject {
        property int nonAppResultDelay: 120
        property bool sloppy: false
    }

    property JsonObject language: JsonObject {
        property JsonObject translator

        translator: JsonObject {
            property int delay: 100
            property string engine: "auto"
            property string targetLanguage: "العربية"
            property string sourceLanguage: "auto"
        }
    }

    property JsonObject networking: JsonObject {
        property string userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
        property string sidebarAgent: "Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.86 Mobile Safari/537.36"
        property string searchPrefix: "https://duckduckgo.com/?q="
    }

    property JsonObject mediaPlayer: JsonObject {
        property bool useBlur: false
        property bool enableGrad: false
        property bool adaptiveTheme: false
        property string visualizerMode: ""
        property bool showVisualizer: false
        property bool lyrics: false
        property list<string> excludedPlayers: [".mpd", "playerctld", "firefox", "chromium", "kdeconnect"]
    }
    property JsonObject desktop: JsonObject {
        property JsonObject shell
        property JsonObject osd
        property JsonObject bg
        property JsonObject clock
        property JsonObject view
        property JsonObject lock
        property JsonObject icons
        property JsonObject hyprland
        property JsonObject behavior
        property JsonObject widgets

        property bool desktopClock: true
        property int screenCorners: 1
        property bool timerOverlayMode: true

        shell: JsonObject {
            property bool deloadOnFullscreen: true
            property string mode: ""
        }
        widgets: JsonObject {
            property bool enabled: true
            property string mode: "col"
        }
        osd: JsonObject {
            property string mode: "bottom_pill"
        }
        view: JsonObject {
            property string mode: "spiral"
        }
        bg: JsonObject {
            property JsonObject parallax

            property real borderMultiplier: 0.2
            property bool depthMode: true
            property bool useQs: true

            parallax: JsonObject {
                property bool enabled: false
                property bool widgetParallax: false
                property bool verticalParallax: false
                property real parallaxStrength: 0.0
            }
        }

        clock: JsonObject {
            property bool enabled: false
            property real scale: 1
            property real spacingMultiplier: 0.3
            property bool verticalMode: false
            property string font: "Badeen Display"
        }

        lock: JsonObject {
            property bool enabled: true
        }

        icons: JsonObject {}

        hyprland: JsonObject {
            property list<string> externalMonitorProfiles: ["1680x1050@68", "1920x1080@60", "1920x1080@72"]
            property string externalMonitorProfile: "1680x1050@68"
            property string tilingLayout: "dwindle"
            property int blurPasses: 1
            property bool shadows: true
            property int shadowsRange: 1
            property int shadowsPower: 1
            property int gapsOut: 1
            property int gapsIn: 1
            property int borders: 1
            property string cursorTheme: "Breeze"
        }

        behavior: JsonObject {
            property JsonObject sounds

            sounds: JsonObject {
                property bool enabled: true
                property real level: 0.75
            }
        }
    }

    property JsonObject bar: JsonObject {
        property JsonObject appearance
        property JsonObject behavior
        property JsonObject modules
        property JsonObject keyboard
        property JsonObject workspaces

        property bool enabled: true
        property int batteryLowThreshold: 20
        property string horizontalLayout: "Dynamic"
        property string verticalLayout: "VDynamic"
        property string currentLayout: "Dynamic"
        property list<var> hMapPresets: []
        property list<var> vMapPresets: []
        property JsonObject vMap: JsonObject {
            property int spacing: 6
            property list<string> topArea: ["materialStatusIcons", "battery", "weather", "tray"]
            property list<string> centerArea: []
            property list<string> bottomArea: ["media", "resources", "separator", "volume", "brightness", "separator", "progressWs", "separator", "clock", "separator", "keyboard", "separator", "power"]
        }
        property JsonObject hMap: JsonObject {
            property int spacing: 6
            property list<string> leftArea: ["power", "separator", "progressWs", "separator", "title"]
            property list<string> centerArea: ["media", "separator", "clock"]
            property list<string> rightArea: ["tray", "battery", "materialStatusIcons"]
        }
        property list<string> bars: ["Dynamic", "HyDe", "NovelKnocks", "Sleek", "VDynamic"]

        appearance: JsonObject {
            property int mode: 2
            property bool enableSeparators: true
            property bool useBg: true
            property bool barGroup: false
            property bool outline: true
            property int height: 45
            property int width: 50
        }

        behavior: JsonObject {
            property string position: "left"
            property bool autoHide: false
            property bool showOnAll: false
        }

        modules: JsonObject {
            property bool visualizer: false
        }

        keyboard: JsonObject {}

        workspaces: JsonObject {
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

    property JsonObject dock: JsonObject {
        property JsonObject appearance

        property bool enabled: false
        property bool hoverToReveal: true
        property int animationDuration: 200
        appearance: JsonObject {
            property real iconSize: 100 * iconSizeMultiplier
            property real iconSizeMultiplier: 0.5
        }
    }

    property JsonObject cheats: JsonObject {
        property string superKey: "󰌽"
        property bool useMacSymbol: true
        property bool splitButtons: true
        property bool useMouseSymbol: true
        property bool useFnSymbol: true
        property JsonObject fontSize: JsonObject {
            property int key: Fonts.sizes.large
            property int comment: Fonts.sizes.verylarge
        }
    }

    property JsonObject hacks: JsonObject {
        property int arbitraryRaceConditionDelay: 100
    }
}
