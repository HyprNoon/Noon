import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services
import "../common"

StyledPanel {
    id: root
    implicitWidth: 500
    name: "db"
    shell: "nobuntu"

    anchors {
        top: true
        right: true
        bottom: true
    }
    visible: GlobalStates.nobuntu.db.show
    mask: Region {
        item: bg
    }
    FocusHandler {
        windows: [root]
        active: root.visible
        onCleared: GlobalStates.nobuntu.db.show = false
    }

    StyledRect {
        id: bg
        color: Colors.colLayer2
        radius: 34
        implicitWidth: 435
        implicitHeight: content.implicitHeight + Padding.massive * 1.5
        enableBorders: true
        anchors {
            top: parent.top
            right: parent.right
            margins: Padding.normal
        }
        ColumnLayout {
            id: content
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: Padding.huge
            }

            GDBTopRow {}
            GBrightnessSlider {}
            GVolumeSlider {}
            GDBGrid {}
            // BottomRow {}
            Spacer {}
        }
    }
    StyledRectangularShadow {
        target: bg
    }
}
