import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell
import qs.services
import qs.common
import qs.common.widgets
import "../../components"

StyledPanel {
    id: root

    readonly property int mode: Mem.options.bar.appearance.mode
    readonly property string pos: switch (Mem.options.bar.behavior.position) {
    case "left":
        "top";
    case "right":
        "bottom";
    case "top":
        "top";
    case "bottom":
        "bottom";
    default:
        "top";
    }

    readonly property int barHeight: Mem.options.bar.appearance.height
    name: "bar"

    implicitHeight: barHeight + (mode === 0 ? 2 * Sizes.barElevation : 0)
    exclusiveZone: barHeight

    anchors {
        left: true
        right: true
        top: pos === "top"
        bottom: pos === "bottom"
    }

    mask: Region {
        item: bg
    }

    StyledRectangularShadow {
        target: bg
    }

    StyledRect {
        id: bg

        color: BatteryService.isLow ? BatteryService.isCharging ? Colors.m3.m3successContainer : Colors.m3.m3errorContainer : Colors.colLayer0
        enableBorders: false
        implicitWidth: Screen.width
        radius: mode !== 0 ? 0 : Rounding.verylarge

        anchors {
            fill: parent
            topMargin: pos === "bottom" && mode === 2 ? Rounding.verylarge : (mode === 0 ? Sizes.barElevation : 0)
            bottomMargin: pos === "top" && mode === 2 ? Rounding.verylarge : (mode === 0 ? Sizes.barElevation : 0)
            leftMargin: mode === 0 ? Sizes.hyprland.gapsOut : 0
            rightMargin: mode === 0 ? Sizes.hyprland.gapsOut : 0
        }

        Behavior on color {
            CAnim {}
        }

        RoundCorner {
            id: corner1
            visible: mode === 2 && bg.height > 0
            size: Rounding.verylarge
            corner: pos === "bottom" ? cornerEnum.bottomLeft : cornerEnum.topLeft
            color: bg.color

            anchors {
                left: bg.left
                leftMargin: Sizes.frameThickness
                top: pos === "top" ? bg.bottom : undefined
                bottom: pos === "bottom" ? bg.top : undefined
            }
        }

        RoundCorner {
            id: corner2
            visible: mode === 2 && bg.height > 0
            size: Rounding.verylarge
            corner: pos === "bottom" ? cornerEnum.bottomRight : cornerEnum.topRight
            color: bg.color

            anchors {
                right: bg.right
                rightMargin: Sizes.frameThickness
                top: pos === "top" ? bg.bottom : undefined
                bottom: pos === "bottom" ? bg.top : undefined
            }
        }

        RowLayout {
            anchors {
                fill: parent
                rightMargin: Padding.massive
                leftMargin: Padding.massive
            }
            spacing: Padding.huge

            InlineWindowTitle {
                id: title
                font.family: Fonts.family.monospace
                bar: root
            }

            // Spacer {}

            SysTray {
                bar: root
            }

            Levels {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            VerticalSeparator {}

            NetworkInfo {}

            VerticalSeparator {}

            InlineResources {}

            VerticalSeparator {}

            Spacer {}

            VerticalSeparator {}

            SystemBattery {
                implicitHeight: 18
            }

            VerticalSeparator {}

            Logo {
                bordered: false
            }

            SilentHint {}
        }
    }

    component Word: StyledText {
        color: Colors.m3.m3onSurfaceVariant
        font.family: Fonts.family.monospace
    }

    component SilentHint: Revealer {
        reveal: Notifications.silent
        Symbol {
            color: Colors.colOnSecondaryContainer
            visible: Notifications.silent
            text: "notifications_off"
            fill: 1
        }
    }

    component Levels: RowLayout {
        spacing: 10
        property var focusedScreen: MonitorsInfo.focused
        property var brightnessMonitor: BrightnessService.getMonitorForScreen(focusedScreen)

        Resource {
            percentage: AudioService.sink?.audio.volume ?? 0
            iconName: AudioService.sink?.audio.muted ? "volume_off" : "volume_up"
        }

        Resource {
            percentage: brightnessMonitor?.brightness
            iconName: "light_mode"
        }
    }

    component NetworkInfo: MouseArea {
        id: root
        implicitHeight: parent.height
        implicitWidth: row.width
        hoverEnabled: true

        NetworkPopup {
            hoverTarget: root
        }

        RowLayout {
            id: row
            anchors.centerIn: parent

            Resource {
                iconName: NetworkService.materialSymbol
                percentage: NetworkService.networkStrength / 100
                spacing: 5
            }

            Word {
                text: "."
            }

            Word {
                text: `${NetworkService.networkName}`
            }
        }
    }

    component InlineResources: MouseArea {
        id: mouse
        readonly property var stats: ResourcesService.stats
        hoverEnabled: true
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            anchors.fill: parent
            Resource {
                iconName: "memory"
                percentage: (stats.mem_total - stats.mem_free) / stats.mem_total
            }

            Resource {
                iconName: "swap_horiz"
                percentage: (stats.swap_total - stats.swap_free) / stats.swap_total
            }

            Resource {
                iconName: "settings_slow_motion"
                percentage: stats.cpu_percent
            }

            Resource {
                iconName: "thermometer"
                percentageSymbol: false
                percentage: stats.cpu_temp
            }
        }

        ResourcesPopup {
            hoverTarget: mouse
        }
    }

    component Resource: RowLayout {
        id: root
        property string iconName
        property real percentage
        property bool percentageSymbol: true
        spacing: 5

        Symbol {
            text: root.iconName
            font.pixelSize: 17
            fill: 1
        }

        Word {
            text: Math.round(100 * root.percentage) + (percentageSymbol ? "%" : "")
        }
    }
}
