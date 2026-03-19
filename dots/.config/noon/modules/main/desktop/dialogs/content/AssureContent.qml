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
    signal dismiss

    property var content
    // {
    //     title: "";
    //     description: "";
    //     onAccepted: () => {};
    //     acceptText: "Accept";
    // }

    CLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive * 1.5
        spacing: Padding.large

        BottomDialogHeader {
            title: root.content.title
            subTitle: root.content.description
            showCloseButton: false
        }

        Spacer {}

        WindowDialogButtonRow {
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: "Cancel"
                toggled: false
                releaseAction: () => {
                    root.dismiss();
                }
            }

            DialogButton {
                buttonText: root.content.acceptText
                toggled: true
                colText: Colors.colOnPrimary
                releaseAction: () => root.content.onAccepted()
            }
        }
    }
}
