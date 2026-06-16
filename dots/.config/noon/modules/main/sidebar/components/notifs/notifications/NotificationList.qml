import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

LayerRect {
    id: root

    radius: Rounding.veryhuge
    clip: false

    // Scrollable window
    NotificationListView {
        id: listview
        hint: true
        anchors.fill: parent
        anchors.margins: Padding.large
        popup: false

        PagePlaceholder {
            shown: Notifications.list.length === 0
            anchors.centerIn: parent
            icon: Notifications.silent ? "notifications_off" : "notifications_active"
            shape: MaterialShape.Ghostish
        }
    }

    Item {
        id: statusRow

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Padding.small
        Layout.fillWidth: true
        implicitHeight: 50

        StyledText {
            id: statusText
            anchors.left: parent.left
            anchors.leftMargin: Padding.huge
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            text: `${Notifications.list.length} notifications`
            opacity: Notifications.list.length > 0 ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                Anim {}
            }
        }

        ButtonGroup {
            id: controls

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: Padding.large

            NotificationStatusButton {
                buttonIcon: "notifications_paused"
                buttonText: qsTr("Silent")
                toggled: Notifications.silent
                onClicked: () => Mem.options.services.notifications.silent = !Notifications.silent
            }

            NotificationStatusButton {
                buttonIcon: "clear_all"
                buttonText: qsTr("Clear")
                onClicked: () => Notifications.discardAllNotifications()
            }
        }
    }
}
