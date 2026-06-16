import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets

Scope {
    id: root
    property string selectedCategory: ""
    readonly property var contentMap: [
        {
            name: "Dash",
            icon: "dashboard"
        },
        {
            name: "Wallpapers",
            icon: "image"
        },
        {
            name: "Workspaces",
            icon: "workspaces"
        },
        {
            name: "Beats",
            icon: "music_note"
        }
    ]
    Variants {
        model: MonitorsInfo.main
        StyledPanel {
            id: panel
            property var modelData
            name: "noanim_blurred_layer"
            shell: "noon"
            fill: true
            _layer: "Overlay"
            mask: Region {
                item: bg
            }

            MouseArea {
                id: hoverArea

                readonly property int hoverZone: 12

                z: 999
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                acceptedButtons: Qt.NoButton
            }

            Timer {
                id: hideTimeout
                interval: 1000
                running: bg.state === "collapsed"
                onTriggered: bg.state = "hidden"
            }

            StyledRect {
                id: bg
                z: 0
                readonly property bool expanded: hoverArea.containsMouse
                readonly property size collapsedSize: Qt.size(300, 50)
                readonly property size expandedSize: Qt.size(1100, 420)

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colors.colLayer0
                clip: true
                width: expanded ? expandedSize.width : collapsedSize.width
                height: expanded ? expandedSize.height : collapsedSize.height
                bottomRadius: Rounding.silly

                Item {
                    anchors.fill: parent
                    anchors.margins: Padding.large

                    ColumnLayout {
                        anchors.fill: parent
                        RowLayout {
                            NavRail {
                                model: root.contentMap
                                selectedCategory: root.selectedCategory
                                bg {
                                    radius: Rounding.large
                                }
                            }
                            Spacer {}
                        }
                    }
                }
            }

            RoundCorner {
                anchors {
                    top: bg.top
                    left: bg.right
                }
                color: bg.color
                corner: RoundCorner.TopLeft
                size: Rounding.veryhuge
                opacity: bg.opacity
            }
            RoundCorner {
                anchors {
                    top: bg.top
                    right: bg.left
                }
                color: bg.color
                corner: RoundCorner.TopRight
                size: Rounding.veryhuge
                opacity: bg.opacity
            }
            StyledRectangularShadow {
                z: -1
                target: bg
                opacity: bg.opacity
            }
        }
    }
}
