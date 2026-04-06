import qs.common.utils

JsonAdapter {
    property JsonObject applications: JsonObject {
        property JsonObject settings: JsonObject {
            property string cat: ""
            property bool sidebar_expanded: false
            property bool sidebar_pinned: true
            property int appearance_mode: 2
        }
        property JsonObject reader: JsonObject {
            property string currentFile: ""
            property bool sidebar_expanded: false
            property bool sidebar_pinned: true
            property int appearance_mode: 2
        }
    }
    property JsonObject desktop: JsonObject {
        property JsonObject icons
        property JsonObject bg
        property JsonObject appearance
        property JsonObject clock
        property JsonObject shell

        shell: JsonObject {
            property bool deload: false
        }
        icons: JsonObject {
            property string currentIconTheme: ""
        }
        bg: JsonObject {
            property bool isBright: false
            property bool isLive: false
            property string currentVideo: ""
            property string currentBg: ""
            property string currentFolder: "~/Pictures/Wallpapers"
        }
        appearance: JsonObject {
            property JsonObject colors

            property bool autoSchemeSelection: false
            property bool autoShellMode: false
            property string mode: "dark"
            property string scheme: ""

            colors: JsonObject {
                property real chroma: 1
                property real tone: 1
            }
        }
        clock: JsonObject {
            property real x: 0
            property real y: 0
            property bool arabicMode: false
            property bool editMode: false
            property bool center: false
            property real scale: 1
        }
    }

    property JsonObject services: JsonObject {
        property JsonObject kdeconnect
        property JsonObject islam
        property JsonObject bookmarks
        property JsonObject ai
        property JsonObject radio
        property JsonObject emojis
        property JsonObject nightLight
        property JsonObject ambientSounds
        property JsonObject mediaPlayer
        property JsonObject power
        property JsonObject games
        property JsonObject todo
        property JsonObject timers

        timers: JsonObject {
            property list<var> alarms: []
            property int nextAlarmId: 1
            property list<var> timers: []
            property int nextTimerId: 1
        }

        todo: JsonObject {
            property list<var> tasks: []
        }
        games: JsonObject {
            property list<var> list: []
            property string gameModeCommand
        }
        islam: JsonObject {
            property list<var> donePrayers: []
            property string currentSurah: ""
        }

        ai: JsonObject {
            property JsonObject tokenCount: JsonObject {
                property int input
                property int output
                property int total
            }
        }
        radio: JsonObject {
            property string url: ""
        }
        power: JsonObject {
            property string controller: ""
            property string mode: ""
            property list<var> modes
        }
        kdeconnect: JsonObject {
            property string selectedDeviceId: ""
        }
        nightLight: JsonObject {
            property bool enabled: false
            property int temperature: 3600
        }
        bookmarks: JsonObject {
            property list<var> firefoxBookmarks
        }

        emojis: JsonObject {
            property list<var> frequentEmojies: []
        }
        ambientSounds: JsonObject {
            property real masterVolume: 1
            property bool masterPaused: false
            property bool muted: false
            property list<var> activeSounds: []
        }
        mediaPlayer: JsonObject {}
    }

    property JsonObject fonts: JsonObject {
        property JsonObject variableAxes

        variableAxes: JsonObject {
            property JsonObject display

            display: JsonObject {
                property int wght: 100
                property int wdth: 100
                property int ital: 100
                property int slnt: 100
                property int opsz: 100
            }
        }
    }

    property JsonObject dock: JsonObject {
        property bool pinned: false
    }
    property JsonObject sidebar: JsonObject {
        property JsonObject apis
        property JsonObject web
        property JsonObject widgets
        property JsonObject shelf
        web: JsonObject {
            property string currentUrl: ""
        }
        shelf: JsonObject {
            property list<string> filePaths: []
        }
        widgets: JsonObject {
            property list<string> enabled: []
            property list<string> desktop: []
            property list<string> pilled: []
            property list<string> pinned: []
            property list<string> expanded: []
        }
        apis: JsonObject {
            property int selectedTab: 0
            property real fontScale: 1
        }
    }
    property JsonObject favorites: JsonObject {
        property list<string> apps: ["firefox", "dolphin"]
        property list<string> recentApps: ["vesktop", "kitty", "spotify", "heroic", "foot", "firefox"]
        property list<string> fastLaunchApps: ["heroic", "codium", "steam"]
        property list<string> desktopApps: ["org.kde.dolphin", "foot"]
    }
    property JsonObject mediaPlayer: JsonObject {
        property string currentTrackPath: ""
        property list<string> folders: []
    }
}
