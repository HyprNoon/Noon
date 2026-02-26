pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.services

Singleton {
    property QtObject hyprland
    property QtObject sidebar
    property QtObject osd
    property QtObject screenshot
    property QtObject editor
    property QtObject mediaPlayer

    readonly property real infinity: Number.POSITIVE_INFINITY
    readonly property real barElevation: hyprland.gapsOut / 2
    readonly property real osdWidth: 220
    readonly property real osdHeight: 45
    readonly property real notificationPopupWidth: 420
    readonly property real elevationValue: Padding.verylarge
    readonly property real frameThickness: Mem.options.desktop.bg.borderMultiplier * (hyprland.gapsOut - Padding.normal)
    readonly property real elevationMargin: frameThickness + elevationValue
    readonly property size beamSize: Qt.size(540, 65)
    readonly property size beamSizeExpanded: Qt.size(1000, 100)
    readonly property size gameLauncherItemSize: Qt.size(225, 360)

    editor: QtObject {
        property size statusIsland: Qt.size(120, 40)
    }
    mediaPlayer: QtObject {
        property real sidebarWidth: 300
        property real sidebarWidthCollapsed: 82
        property real overlaySize: 145
        property size controlsSize: Qt.size(600, 80)
    }
    screenshot: QtObject {
        property size size: Qt.size(400, 85)
    }
    osd: QtObject {
        readonly property size nobuntu: Qt.size(220, 64)
        readonly property size bottomPill: Qt.size(180, 42)
        readonly property size centerIsland: Qt.size(145, 145)
        readonly property size sideBay: Qt.size(48, 200)
        readonly property size windows_10: Qt.size(85, 240)
    }

    sidebar: QtObject {
        readonly property real bar: 65
        readonly property real contentQuarter: Math.round(Screen.width * 0.235) - bar
        readonly property real half: Math.round(Screen.width * 0.457)
        readonly property real quarter: Math.round(Screen.width * 0.246)
        readonly property real largerQuarter: Math.round(Screen.width * 0.28)
        readonly property real threeQuarter: Math.round(Screen.width * 0.85)

        readonly property real session: 280
        readonly property real overview: 1250
        readonly property real widgetSize: 172
        readonly property real widgetPillHeight: 72
        readonly property size shelfItemSize: Qt.size(115, 115)
        readonly property size shelfPopupSize: Qt.size(300, 200)

        property QtObject widgets: QtObject {
            readonly property real expandedWidth: 2 * Sizes.sidebar.widgetSize + Padding.verylarge
        }
    }

    hyprland: QtObject {
        property real borders: HyprlandParserService?.variables?.borders || 0
        property real gapsOut: HyprlandParserService?.variables?.gaps_out || 0
        property real gapsIn: HyprlandParserService?.variables?.gaps_in || 0
        property real blurSize: HyprlandParserService?.variables?.blur_size || 0
        property real blurPasses: HyprlandParserService?.variables?.blur_passes || 0
        property real shadowsRange: HyprlandParserService?.variables?.shadows_range || 0
    }
}
