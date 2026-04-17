import Noon.Services
import Qt5Compat.GraphicalEffects
import QtNetwork
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import qs.common
import qs.common.widgets
import qs.services

BarGroup {
    id: root

    readonly property var content: [
        {
            icon: "radio_button_checked",
            visible: RecordingService.isRecording,
            dialog: "Record",
            tooltip: "Recording " + RecordingService.getFormattedDuration()
        },
        {
            icon: "volume_off",
            visible: AudioService.sink?.audio.muted
        },
        {
            icon: NetworkService.materialSymbol,
            dialog: "Wifi",
            hoverItem: networkPopup
        },
        {
            icon: BluetoothService.currentDeviceIcon,
            dialog: "Bluetooth",
            hoverItem: btPopup
        },
        {
            icon: "notifications_off",
            visible: Notifications.silent
        },
        {
            icon: "shield",
            visible: PolkitService.interactionAvailable,
            action: () => NoonUtils.callIpc("sidebar reveal Auth"),
            tooltip: PolkitService?.flow?.message
        },
        {
            icon: "mode_heat",
            visible: ResourcesService.stats.cpu_temp > 85,
            tooltip: "CPU Temp: " + ResourcesService.stats.cpu_temp
        }
    ]
    readonly property Component btPopup: BluetoothPopup {}
    readonly property Component networkPopup: NetworkPopup {}
    readonly property Component tooltipComp: StyledToolTip {
        property var hoverTarget
        extraVisibleCondition: hoverTarget.containsMouse
    }

    implicitWidth: grid.implicitWidth + Padding.huge
    implicitHeight: grid.implicitHeight + Padding.huge

    GridLayout {
        id: grid

        anchors.centerIn: parent
        rows: verticalMode ? 4 : 1
        columns: verticalMode ? 1 : 4
        rowSpacing: verticalMode ? Padding.normal : 0
        columnSpacing: verticalMode ? 0 : Padding.normal
        Repeater {
            model: root.content.filter(item => item.visible ?? true)

            delegate: Symbol {
                text: modelData.icon || ""
                color: Colors.colSecondary
                font.pixelSize: Fonts.sizes.verylarge
                fill: 1
                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.dialog) {
                            GlobalStates.main.dialogs.current = modelData.dialog;
                            NoonUtils.callIpc("sidebar reveal Notifs");
                        } else
                            modelData?.action() ?? null;
                    }
                    StyledLoader {
                        shown: modelData.hoverItem !== null
                        anchors.fill: parent
                        sourceComponent: modelData.tooltip ? tooltipComp : modelData?.hoverItem ?? null
                        onLoaded: {
                            if ("hoverTarget" in _item) {
                                _item.hoverTarget = Qt.binding(() => hoverArea);
                            }
                            if (("content" in _item) && modelData.tooltip) {
                                _item.content = Qt.binding(() => modelData.tooltip);
                            }
                        }
                    }
                }
            }
        }
    }
}
