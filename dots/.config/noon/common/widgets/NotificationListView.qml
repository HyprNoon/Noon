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
    property var popupProps: ({
            overshoot: 200,
            threshold: 20
        })
    spacing: Padding.small
    clip: true
    radius: Rounding.huge
    _model: root.popup ? Notifications.popupAppNameList : Notifications.appNameList
    reuseItems: false
    delegate: NotificationGroup {
        required property int index
        required property var modelData
        anchors.left: parent?.left
        anchors.right: parent?.right
        notificationGroup: popup ? Notifications.popupGroupsByAppName[modelData] : Notifications.groupsByAppName[modelData]
        dismissOvershoot: root.popupProps?.overshoot  //?? 200
        dragConfirmThreshold: root.popupProps.threshold //?? 20
        popup: root.popup
    }
}
