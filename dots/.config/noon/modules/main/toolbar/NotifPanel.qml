import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets

Scope {
    id: root
    Variants {
        model: [MonitorsInfo.focused]
        StyledPanel {
            id: panel
            property var modelData
            name: "toolbar"
            shell: "noon"

            anchors.top: true
            implicitWidth: 999
            implicitHeight: 999

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

                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    margins: Padding.massive
                    topMargin: 0
                }
                color: Colors.colLayer0
                clip: true
                layer.enabled: false
                implicitWidth: collapsedSize.width
                implicitHeight: collapsedSize.height

                readonly property bool expanded: hoverArea.containsMouse
                readonly property size collapsedSize: Qt.size(500, 82)
                readonly property size expandedSize: Qt.size(800, 385)

                Content {
                    panel: root.panel
                    state: bg.state
                    visible: state !== "hidden"
                    anchors.fill: parent
                    anchors.margins: Padding.large
                }

                states: [
                    State {
                        name: "hidden"
                        when: false
                        PropertyChanges {
                            target: bg
                            implicitHeight: hoverArea.hoverZone
                            implicitWidth: 200 //collapsedSize.width
                            opacity: 1
                            bottomRadius: Rounding.tiny
                            color: Colors.colPrimary
                        }
                    },
                    State {
                        name: "collapsed"
                        when: !bg.expanded
                        PropertyChanges {
                            target: bg
                            implicitWidth: collapsedSize.width
                            implicitHeight: collapsedSize.height
                            opacity: 1
                            bottomRadius: Rounding.massive
                            color: Colors.colLayer0
                        }
                    },
                    State {
                        name: "expanded"
                        when: bg.expanded
                        PropertyChanges {
                            target: bg
                            implicitWidth: expandedSize.width
                            implicitHeight: expandedSize.height
                            opacity: 1
                            bottomRadius: Rounding.massive
                            color: Colors.colLayer0
                        }
                    }
                ]

                transitions: Transition {
                    Anim {
                        properties: "implicitHeight,implicitWidth,radius,bottomRadius"
                    }
                    // Anim {
                    //     property: "opacity"
                    //     duration: 100
                    // }
                }
            }
            RoundCorner {
                anchors {
                    top: bg.top
                    left: bg.right
                }
                color: bg.color
                corner: cornerEnum.topLeft
                size: bg.bottomRadius
                opacity: bg.opacity
            }
            RoundCorner {
                anchors {
                    top: bg.top
                    right: bg.left
                }
                color: bg.color
                corner: cornerEnum.topRight
                size: bg.bottomRadius
                opacity: bg.opacity
            }
            StyledRectangularShadow {
                z: -1
                target: bg
                opacity: bg.opacity
                intensity: 0.25
            }
        }
    }
}
