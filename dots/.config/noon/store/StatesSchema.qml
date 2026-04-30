import qs.common.utils

JsonAdapter {
    property JO applications: JO {
        property JO settings: JO {
            property string cat: ""
            property bool sidebar_expanded: false
            property bool sidebar_pinned: true
            property int appearance_mode: 2
        }
        property JO reader: JO {
            property string currentFile: ""
            property bool sidebar_expanded: false
            property bool sidebar_pinned: true
            property int appearance_mode: 2
        }
    }
    property JO desktop: JO {
        property JO icons
        property JO bg
        property JO appearance
        property JO clock
        property JO shell
        property JO dialogs

        dialogs: JO {
            property string lastIncubatedCategory
        }
        shell: JO {
            property bool deload: false
        }
        icons: JO {
            property string currentIconTheme: ""
        }
        bg: JO {
            property bool isBright: false
            property bool isLive: false
            property string currentVideo: ""
            property string currentBg: ""
            property string currentFolder: "~/Pictures/Wallpapers"
        }
        appearance: JO {
            property JO colors

            property bool autoSchemeSelection: false
            property bool autoShellMode: false
            property string mode: "dark"
            property string scheme: ""

            colors: JO {
                property real chroma: 1
                property real tone: 1
            }
        }
        clock: JO {
            property real x: 0
            property real y: 0
            property bool arabicMode: false
            property bool editMode: false
            property bool center: false
            property real scale: 1
        }
    }

    property JO services: JO {
        property JO kdeconnect
        property JO islam
        property JO bookmarks
        property JO ai
        property JO radio
        property JO record
        property JO emojis
        property JO nightLight
        property JO mediaPlayer
        property JO power
        property JO games
        property JO todo
        property JO timers
        property JO beats
        property JO calendar

        beats: JO {
            property var previewData: ({})
            property bool discoverMode: false
            property bool shuffleHits: false
            property int searchLimit: 128
            property list<var> hits: []
        }
        timers: JO {
            property list<var> alarms: []
            property int nextAlarmId: 1
            property list<var> timers: []
            property int nextTimerId: 1
        }
        calendar: JO {
            property list<var> events: []
        }
        todo: JO {
            property list<var> tasks: []
        }
        record: JO {
            property bool fullscreen: true
            property bool audio: true
            property int duration: 200
        }
        games: JO {
            property list<var> list: []
            property string gameModeCommand
        }
        islam: JO {
            property list<var> donePrayers: []
            property string currentSurah: ""
        }

        ai: JO {
            property list<var> models: []
            property string model: ""
            property string currentSessionId: ""
            property list<var> sessions: []
            property JO tokenCount: JO {
                property int input
                property int output
                property int total
            }
        }
        radio: JO {
            property string url: ""
        }
        power: JO {
            property string controller: ""
            property string mode: ""
            property list<var> modes
        }
        kdeconnect: JO {
            property string selectedDeviceId: ""
        }
        nightLight: JO {
            property bool enabled: false
            property int temperature: 3600
        }
        bookmarks: JO {
            property list<var> firefoxBookmarks
        }

        emojis: JO {
            property list<var> frequentEmojies: []
        }
        mediaPlayer: JO {}
    }

    property JO fonts: JO {
        property JO variableAxes

        variableAxes: JO {
            property JO display

            display: JO {
                property int wght: 100
                property int wdth: 100
                property int ital: 100
                property int slnt: 100
                property int opsz: 100
            }
        }
    }

    property JO dock: JO {
        property bool pinned: false
    }
    property JO sidebar: JO {
        property JO apis
        property JO web
        property JO widgets
        property JO shelf
        web: JO {
            property string currentUrl: ""
        }
        shelf: JO {
            property list<string> filePaths: []
        }
        widgets: JO {
            property list<string> order: []
            property list<string> enabled: []
            property list<string> desktop: []
            property list<string> pilled: []
            property list<string> pinned: []
            property list<string> expanded: []
        }
        apis: JO {
            property int selectedTab: 0
            property real fontScale: 1
        }
    }
    property JO favorites: JO {
        property list<string> apps: ["firefox", "dolphin"]
        property list<string> recentApps: ["vesktop", "kitty", "spotify", "heroic", "foot", "firefox"]
        property list<string> fastLaunchApps: ["heroic", "codium", "steam"]
        property list<string> desktopApps: ["org.kde.dolphin", "foot"]
    }
    property JO mediaPlayer: JO {
        property string currentTrackPath: ""
        property list<string> folders: []
    }
}
