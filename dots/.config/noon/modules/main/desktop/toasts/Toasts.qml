import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

StyledPanel {
    id: root
    visible: true
    name: "toasts"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0
    aboveWindows: true
    color: "transparent"
    implicitWidth: Sizes.toastWidth + (Sizes.elevationMargin * 2)

    anchors {
        top: true
        bottom: true
        right: GlobalStates.main.sidebar.rightMode
        left: !GlobalStates.main.sidebar.rightMode
    }

    mask: Region {
        item: Rectangle {
            color: "transparent"
            x: listview.x
            y: listview.y + listview.height - listview.contentHeight
            width: listview.width
            height: listview.contentHeight
        }
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: listview.visible = true
    }

    StyledListView {
        id: listview
        anchors.fill: parent
        anchors.margins: Sizes.elevationMargin
        hint: false
        popin: true
        visible: false
        animateMovement: true
        reverseRemoveDirection: root.anchors.left
        animateAppearance: true
        verticalLayoutDirection: ListView.BottomToTop
        model: GlobalStates.toasts.data
        spacing: Padding.normal
        delegate: Toast {
            anchors.horizontalCenter: listview?.horizontalCenter
            width: Sizes.toastWidth
        }
    }
}
