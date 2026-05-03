import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

DockButton {
    id: root

    colBackground: ColorUtils.transparentize(Colors.colLayer2, 0.3)

    StyledToolTip {
        bg.enableBorders: true
        bg.color: Colors.colLayer1
        bg.anchors.bottomMargin: root.iconSize / 10
        content: appToplevel.appId
    }

    releaseAction: () => {
        if (dragHandlerActive)
            return;
        groupPopup.shown = !groupPopup.shown;
    }

    contentItem: Item {
        anchors.fill: parent

        Grid {
            id: iconGrid
            columns: 2
            spacing: 2
            anchors.centerIn: parent
            width: root.iconSize - Padding.normal
            height: root.iconSize - Padding.normal

            Repeater {
                model: Math.min(appToplevel.entries.length, 4)
                delegate: StyledIconImage {
                    required property int index
                    property var entry: appToplevel.entries[index]
                    property var de: DesktopEntries.byId(entry.appId)
                    implicitSize: (root.iconSize - Padding.normal) / 2 - 1
                    source: NoonUtils.iconPath(de ? (de.icon || de.genericIcon || "applications-system") : entry.appId)
                }
            }
        }

        RowLayout {
            spacing: 2
            height: countDotHeight
            anchors {
                top: iconGrid.bottom
                topMargin: countDotHeight
                horizontalCenter: parent.horizontalCenter
            }
            Repeater {
                model: Math.min(appToplevel.toplevels.length, 3)
                delegate: StyledRect {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    required property int index
                    radius: Rounding.full
                    implicitHeight: root.countDotHeight
                    implicitWidth: root.countDotHeight
                    color: appIsActive ? Colors.colPrimary : ColorUtils.transparentize(Colors.colOnLayer0, 0.4)
                }
            }
        }
    }

    DockGroupPopup {
        id: groupPopup
        groupData: appToplevel
        parentButton: root
    }
}
