import qs.common.utils

JsonAdapter {
    property JO applications: JO {
        property JO settings: JO {
            property string cat: ""
            property bool sidebar_expanded: true
            property bool sidebar_pinned: true
            property int appearance_mode: 1
        }
        property JO reader: JO {
            property string currentFile: ""
            property bool sidebar_expanded: true
            property bool sidebar_pinned: true
            property int appearance_mode: 1
        }
    }
    property JO desktop: JO {
        property JO icons
        property JO clock
        property JO shell
        property JO dialogs
        property bool firstRun: true

        dialogs: JO {
            property string lastIncubatedCategory
        }
        shell: JO {
            property bool deload: false
        }
        icons: JO {
            property int iconSize: 48
            property int sortMode: 1
            property bool snapToGrid: true
            property var positions: []
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
        property JO bookmarks
        property JO notes
        property JO record
        property JO emojis
        property JO nightLight
        property JO power
        property JO games
        property JO timers
        property JO beats

        beats: JO {
            property int pageIndex: 0
            property var previewData: ({})
            property bool discoverMode: false
            property bool shuffleTracks: false
            property bool shuffleHits: false
            property int searchLimit: 128
            property list<var> hits: []
        }
        timers: JO {
            property list<var> timers: []
            property int nextTimerId: 1
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
        notes: JO {
            property string currentFile: "noon_notes.md"
        }
        power: JO {
            property string controller: ""
            property string mode: ""
            property list<var> modes
        }

        kdeconnect: JO {
            property int selectedDeviceIndex: 0
            property var connectedDevices: []
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
        property JO widgets
        property JO shelf

        shelf: JO {
            property list<string> filePaths: []
        }

        widgets: JO {
            property list<string> order: []
            property list<string> enabled: []
            property list<string> desktop: ["cal", "resources", "dino"]
            property list<string> pilled: ["dino"]
            property list<string> pinned: []
            property list<string> expanded: []
        }

        apis: JO {
            property int selectedTab: 0
            property real fontScale: 1
        }
    }

    property JO favorites: JO {
        property var apps: [
            {
                "appId": "firefox",
                "gid": null
            },
            {
                "appId": "kitty",
                "gid": null
            },
            {
                "appId": "obsidian",
                "gid": null
            },
            {
                "appId": "zen",
                "gid": null
            },
            {
                "appId": "org.kde.dolphin",
                "gid": "files"
            },
            {
                "appId": "io.github.Qalculate.qalculate-qt",
                "gid": "utilities"
            },
            {
                "appId": "systemsettings",
                "gid": "utilities"
            },
            {
                "appId": "pavucontrol-qt",
                "gid": "utilities"
            },
        ]
        property list<string> recentApps: ["vesktop", "kitty", "spotify", "heroic", "foot", "firefox"]
        property list<string> fastLaunchApps: ["heroic", "codium", "steam"]
        property list<string> desktopApps: ["org.kde.dolphin", "foot"]
    }
}
