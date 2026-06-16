import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.store
import qs.common
import qs.common.widgets
import "components"

Scope {
    id: root
    readonly property bool pinned: Mem.states.dock.pinned ?? false

    Variants {
        model: MonitorsInfo.main

        StyledPanel {
            id: dockRoot
            name: "blurred_layer"
            shell: "noon"
            screen: modelData
            _layer: "Top"
            required property var modelData
            readonly property bool reveal: root.pinned || mouseArea.containsMouse || (!Globals.topLevel?.activated && !Globals.main.sidebar.expanded)

            implicitWidth: Screen.width
            implicitHeight: bg?.height + Sizes.elevationMargin * 3
            exclusiveZone: root.pinned ? bg?.height + Sizes.elevationMargin : -1
            fill: true
            anchors.top: false
            Binding {
                target: Globals.main
                property: "dock"
                value: dockRoot
            }
            mask: Region {
                item: mouseArea
            }

            MouseArea {
                id: mouseArea
                z: 99
                hoverEnabled: true
                height: parent.height
                propagateComposedEvents: true
                acceptedButtons: Qt.NoButton
                anchors.horizontalCenter: parent.horizontalCenter
                width: bg?.width
                anchors.top: parent.top
                anchors.topMargin: dockRoot.implicitHeight - 5
                opacity: anchors.topMargin > dockRoot.implicitHeight - 6 ? 0 : 1
                states: [
                    State {
                        name: "revealed"
                        when: dockRoot.reveal && !Globals.main.showBeam && !Globals.main.showOsdValues
                        PropertyChanges {
                            target: mouseArea
                            anchors.topMargin: 5
                        }
                    }
                ]
                transitions: Transition {
                    Anim {
                        properties: "anchors.topMargin,opacity,width,height"
                        duration: Mem.options.dock.animationDuration
                    }
                }
                StyledRectangularShadow {
                    target: bg
                }
                ShaderRect {
                    id: bg
                    width: content.implicitWidth
                    height: content.implicitHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    state: Mem.options.dock.appearance?.style ?? "float"
                    states: [
                        State {
                            name: "float"
                            PropertyChanges {
                                target: bg
                                anchors.bottomMargin: Sizes.elevationMargin
                                radius: Rounding.verylarge
                            }
                        },
                        State {
                            name: "convex"
                            PropertyChanges {
                                target: bg
                                topRadius: Rounding.verylarge
                            }
                        },
                        State {
                            name: "sharp"
                            PropertyChanges {
                                target: bg
                            }
                        }
                    ]
                    RowLayout {
                        id: content
                        anchors.centerIn: parent
                        spacing: 0
                        DockPinButton {}
                        DockPluginsFactory {
                            leftMode: true
                        }
                        DockApps {
                            Layout.maximumWidth: dockRoot.implicitWidth * 0.75
                        }
                        DockPluginsFactory {}
                    }
                }
            }
        }
    }
}
