import QtQuick

QtObject {
    id: root

    property QtObject desktop: QtObject {
        property QtObject shell: QtObject {
            property bool deloadOnFullscreen: true
            property string mode: ""
        }

        property QtObject osd: QtObject {
            property string mode: "bottom_pill"
        }

        property QtObject bg: QtObject {
            property real borderMultiplier: 0.2
            property bool depthMode: true
            property bool useQs: true

            property QtObject parallax: QtObject {
                property bool enabled: false
                property bool widgetParallax: false
                property bool verticalParallax: false
                property real parallaxStrength: 0.0
            }
        }

        property QtObject clock: QtObject {
            property bool enabled: false
            property real scale: 1
            property real spacingMultiplier: 0.3
            property bool verticalMode: false
            property string font: "Badeen Display"
        }

        property QtObject view: QtObject {
            property string mode: "spiral"
        }

        property QtObject widgets: QtObject {
            property bool enabled: true
            property string mode: "col"
        }

        property bool desktopClock: true
        property int screenCorners: 1
        property bool timerOverlayMode: true
    }

    property QtObject sidebar: QtObject {
        property QtObject appearance: QtObject {
            property int mode: 2
            property bool showNavTitles: false
            property bool showSliders: true
            property bool showVolumeInputSlider: false
            property bool alternateListStripes: true
        }
    }

    property QtObject dock: QtObject {
        property bool enabled: false
        property QtObject appearance: QtObject {
            property real iconSize: 100 * iconSizeMultiplier
            property real iconSizeMultiplier: 0.5
        }
    }

    property QtObject bar: QtObject {
        property bool enabled: true
        property string horizontalLayout: "Dynamic"
        property string verticalLayout: "VDynamic"
        property string currentLayout: "VDynamic"

        property QtObject appearance: QtObject {
            property int mode: 2
            property string separatorsMode: "dot"
            property bool enableSeparators: true
            property bool useBg: true
            property bool barGroup: false
            property bool outline: true
            property int height: 45
            property int width: 50
        }

        property QtObject behavior: QtObject {
            property string position: "left"
            property bool autoHide: false
            property bool showOnAll: false
        }

        property QtObject workspaces: QtObject {
            property int shownWs: 4
            property bool showAppIcons: true
            property string displayMode: "normal"
            property string customFallback: "●"
            property list<string> avilableModes: ["normal", "japanese", "roman", "custom"]
            property list<string> customMapping: []
            property string unicodeChar: "♡"
            property string unicodeMode: "unicode"
        }

        property QtObject vMap: QtObject {
            property int spacing: 6
            property list<string> topArea: ["materialStatusIcons", "battery", "weather", "tray"]
            property list<string> centerArea: []
            property list<string> bottomArea: ["media", "resources", "separator", "volume", "brightness", "separator", "progressWs", "separator", "clock", "separator", "keyboard", "separator", "power"]
        }

        property QtObject hMap: QtObject {
            property int spacing: 6
            property list<string> leftArea: ["power", "separator", "progressWs", "separator", "title"]
            property list<string> centerArea: ["media", "separator", "clock"]
            property list<string> rightArea: ["tray", "battery", "materialStatusIcons"]
        }
    }
}
