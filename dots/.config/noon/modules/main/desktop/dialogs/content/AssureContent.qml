import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

Item {
    id: root
    anchors.fill: parent
    anchors.margins: Padding.massive
    signal dismiss
    clip: true
    property var content

    PageHeader {
        title: root.content.title
        subTitle: root.content.description

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: Padding.huge
        }
    }

    RowLayout {
        Layout.fillWidth: true
        height: cancelButton.implicitHeight

        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }

        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            id: cancelButton
            visible: root.content?.canCancel ?? true
            buttonText: "Cancel"
            toggled: false
            releaseAction: () => root.dismiss()
        }

        DialogButton {
            buttonText: root.content.acceptText
            toggled: true
            colText: Colors.colOnPrimary
            releaseAction: () => {
                Qt.callLater(() => root.dismiss());
                root.content.onAccepted();
            }
        }
    }
}
