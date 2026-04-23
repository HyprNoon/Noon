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
    name: "notificationPopup"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0
    fill: true
    mask: Region {
        item: listview.contentItem
    }

    color: "transparent"
    implicitWidth: Sizes.notificationPopupWidth + 100

    NotificationListView {
        id: listview
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: Padding.massive
        }
        hint: false
        implicitWidth: Sizes.notificationPopupWidth - anchors.rightMargin * 2
        popup: true
        clip: false
        animateMovement: true
        animateAppearance: true
    }
}
