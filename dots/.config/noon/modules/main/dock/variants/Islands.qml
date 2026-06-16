import qs.services
import qs.common
import qs.common.widgets
import qs.modules.main.dock.components
import qs.modules.main.dock.components.osk
import qs.modules.main.dock
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
    id: root
    property bool pinned: Mem.states.dock.pinned ?? false
    property bool showOsk: Globals.main.oskOpen

    Variants {
        model: [Quickshell.screens[0]]

        StyledPanel {
            id: dockRoot
            screen: modelData
            name: "dock"
            anchors.bottom: true

            required property var modelData
            readonly property real rounding: 2 * Rounding.verylarge * Mem.options.dock.appearance.iconSizeMultiplier
            readonly property bool reveal: root.showOsk || root.pinned || mouseArea.containsMouse || (!ToplevelManager.activeToplevel?.activated && !Globals.main.sidebar.expanded)

            implicitWidth: content.implicitWidth + 10 * rounding
            implicitHeight: root.showOsk ? 340 : content.implicitHeight + Sizes.elevationMargin
            exclusiveZone: root.pinned ? content.implicitHeight + Sizes.elevationMargin : -1

            WlrLayershell.layer: WlrLayer.Top
            mask: Region {
                item: mouseArea
            }

            MouseArea {
                id: mouseArea
                z: 99
                hoverEnabled: true
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: {
                    if (dockRoot.reveal && !Globals.main.showBeam && !Globals.main.showOsdValues)
                        return 5;
                    else
                        dockRoot.implicitHeight - 5;
                }
                opacity: anchors.topMargin > dockRoot.implicitHeight - 6 ? 0 : 1

                Behavior on anchors.topMargin {
                    Anim {}
                }

                RowLayout {
                    id: content
                    spacing: Padding.small
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: Sizes.elevationMargin

                    DockPinButton {
                        radius: dockRoot.rounding
                        pinned: root.pinned
                    }
                    DockMedia {
                        radius: dockRoot.rounding
                    }
                    DockContent {
                        id: bg
                        radius: dockRoot.rounding
                    }
                    DockTimerIndicator {
                        borderColor: bg.border.color
                    }
                }
            }
        }
    }
}
