import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

Item {
    id: root
    anchors.fill: parent

    signal dismiss

    property string url

    function accept() {
        ThawbService.install(root.url);
        Qt.callLater(() => root.dismiss());
    }

    CLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive * 1.5
        spacing: Padding.large

        BottomDialogHeader {
            title: "Thawb  -  ثوب"
            subTitle: "Get New Thawb"
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
                buttonText: "Install"
                toggled: true
                colText: Colors.colOnPrimary
                releaseAction: () => {
                    root.accept();
                }
            }
        }
    }
}
