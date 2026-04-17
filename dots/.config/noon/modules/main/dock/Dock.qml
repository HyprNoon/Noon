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
            name: "slide_layer"
            shell: "noon"
            screen: modelData
            _layer: "Top"
            required property var modelData
            readonly property bool reveal: root.pinned || mouseArea.containsMouse || (!GlobalStates.topLevel?.activated && !GlobalStates.main.sidebar.expanded)

            implicitWidth: Screen.width
            implicitHeight: bg?.height + Sizes.elevationMargin * 2
            exclusiveZone: root.pinned ? bg?.height + Sizes.elevationMargin : -1
            fill: true
            anchors.top: false
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
                        when: dockRoot.reveal && !GlobalStates.main.showBeam && !GlobalStates.main.showOsdValues
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
                StyledRect {
                    id: bg
                    width: content.implicitWidth
                    height: content.implicitHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: Sizes.elevationMargin
                    anchors.bottom: parent.bottom
                    color: Colors.colLayer0
                    radius: Rounding.verylarge

                    RowLayout {
                        id: content
                        anchors.centerIn: parent
                        spacing: 0
                        DockPinButton {}
                        DockPluginsFactory {
                            leftMode: true
                        }
                        DockApps {}
                        DockPluginsFactory {}
                    }
                }
            }
        }
    }
}
