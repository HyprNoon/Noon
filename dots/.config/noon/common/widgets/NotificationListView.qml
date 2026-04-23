import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

StyledListView {
    id: root
    property bool popup: false
    spacing: Padding.small
    clip: true
    radius: Rounding.huge

    model: ScriptModel {
        values: root.popup ? Notifications.popupAppNameList : Notifications.appNameList
    }
    delegate: NotificationGroup {
        required property int index
        required property var modelData
        anchors.left: parent?.left
        anchors.right: parent?.right
        notificationGroup: popup ? Notifications.popupGroupsByAppName[modelData] : Notifications.groupsByAppName[modelData]
        dismissOvershoot: popup ? Screen?.width / 2 : 200
        dragConfirmThreshold: popup ? 40 : 20
        popup: root.popup
    }
}
