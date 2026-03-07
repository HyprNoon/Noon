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

    property int iconSize: Fonts.sizes.verylarge
    property bool verticalMode: false
    readonly property var content: [
        {
            icon: "radio_button_checked",
            visible: RecordingService.isRecording,
            dialog: "Record",
            hoverItem: recPopup
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
        }
    ]
    readonly property Component btPopup: BluetoothPopup {}
    readonly property Component networkPopup: NetworkPopup {}
    readonly property Component recPopup: StyledToolTip {
        property var hoverTarget
        extraVisibleCondition: hoverTarget.containsMouse
        content: "Recording " + RecordingService.getFormattedDuration()
    }

    Layout.fillHeight: !verticalMode
    Layout.fillWidth: verticalMode
    Layout.preferredWidth: !verticalMode ? grid.implicitWidth + Padding.huge : 0
    Layout.preferredHeight: verticalMode ? grid.implicitHeight + Padding.huge : 0
    Layout.margins: Padding.tiny

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
                font.pixelSize: root.iconSize
                fill: 0
                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        GlobalStates.main.dialogs.current = modelData.dialog;
                        NoonUtils.callIpc("sidebar reveal Notifs");
                    }
                    StyledLoader {
                        anchors.fill: parent
                        sourceComponent: modelData?.hoverItem ?? null
                        onLoaded: if (ready) {
                            if ("hoverTarget" in item)
                                item.hoverTarget = Qt.binding(() => hoverArea);
                        }
                    }
                }
            }
        }
    }
}
