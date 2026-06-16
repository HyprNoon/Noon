import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

RippleButton {
    id: root

    property string displayText
    property string url
    property real faviconSize: 20

    implicitHeight: 30
    leftPadding: (implicitHeight - faviconSize) / 2
    rightPadding: 10
    buttonRadius: Rounding.full
    colBackground: Colors.colSurfaceContainerHighest
    colBackgroundHover: Colors.colSurfaceContainerHighestHover
    colRipple: Colors.colSurfaceContainerHighestActive
    onClicked: {
        if (url) {
            Qt.openUrlExternally(url);
            Globals.main.sidebar.expanded = false;
        }
    }

    PointingHandInteraction {}

    contentItem: Item {
        anchors.centerIn: parent
        implicitWidth: rowLayout.implicitWidth
        implicitHeight: rowLayout.implicitHeight

        RowLayout {
            id: rowLayout

            anchors.fill: parent
            spacing: 5

            Favicon {
                url: root.url
                size: root.faviconSize
                displayText: root.displayText
            }

            StyledText {
                id: text

                horizontalAlignment: Text.AlignHCenter
                text: displayText
                color: Colors.m3.m3onSurface
            }
        }
    }
}
