import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.common
import qs.common.widgets
import qs.common.utils

Scope {
    id: root
    readonly property int margins: Sizes.hyprland.gapsOut
    readonly property bool bottom: false
    Variants {
        model: MonitorsInfo.all
        StyledPanel {
            id: panel
            // shell: "zen"
            name: "bar"
            required property var modelData
            screen: modelData
            fill: true
            anchors.top: !root.bottom
            anchors.bottom: root.bottom
            implicitHeight: bg.height + root.margins * 2
            exclusiveZone: bg.height + root.margins * 2

            Item {
                anchors.fill: parent
                anchors.margins: root.margins

                StyledRect {
                    id: bg
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: root.margins
                    anchors.verticalCenter: parent.verticalCenter
                    height: 40
                    color: Colors.m3.m3surfaceDim
                    RowLayout {
                        anchors.fill: parent
                        spacing: Padding.huge
                        ZWorkspacesIndicator {
                            bar: panel
                        }
                        ZTitle {
                            bar: panel
                        }
                        Spacer {}
                        ZStatusIcons {}
                    }
                }
            }
        }
    }
}
