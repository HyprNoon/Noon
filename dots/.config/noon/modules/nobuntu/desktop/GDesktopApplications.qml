import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import qs.store

Item {
    id: root
    z: 99999
    anchors {
        fill: parent
        topMargin: Padding.massive * 2.5
        leftMargin: Padding.massive * 2
    }

    readonly property list<string> apps: Mem.states.favorites.desktopApps
    readonly property size appSize: Qt.size(100, 100)

    GridLayout {
        anchors {
            top: parent.top
            left: parent.left
        }
        columns: 1
        Repeater {
            model: apps
            delegate: StyledRect {
                required property var modelData
                required property int index
                property var app: DesktopEntries.heuristicLookup(modelData)
                implicitWidth: appSize.width
                implicitHeight: appSize.height
                enableBorders: _event.pressed
                radius: Rounding.massive
                color: _event.pressed ? Colors.colSecondaryContainerHover : "transparent"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Padding.normal
                    StyledIconImage {
                        _source: app.icon
                        implicitSize: 53
                    }
                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        truncate: true
                        // wrapMode: Text.NoWrap
                        // Layout.preferredWidth: parent.width / 2
                        Layout.maximumWidth: 50
                        // Layout.fillWidth: true
                        // maximumLineCount: 2
                        text: app.name
                        color: Colors.colOnBackground
                        font.pixelSize: Fonts.sizes.small
                    }
                }
                MouseArea {
                    id: _event
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onDoubleClicked: {
                        app.execute();
                    }
                }
            }
        }
    }
}
