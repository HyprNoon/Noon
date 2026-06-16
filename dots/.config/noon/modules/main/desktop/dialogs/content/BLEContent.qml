import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets

Item {
    id: root
    anchors.fill: parent
    anchors.margins: Padding.massive
    signal dismiss
    clip: true
    property var content

    readonly property var device: content?.device ?? null

    readonly property string deviceName: {
        if (!device)
            return "Unknown Device";
        return device.friendlyName || device.remoteName || device.name || device.address || "Unknown Device";
    }

    readonly property var deviceInfo: {
        if (!device)
            return null;

        const table = [
            {
                name: "Headphone",
                candidates: ["headphone", "airpod", "bud", "ear"],
                icon: "earbuds_2"
            },
            {
                name: "Headset",
                candidates: ["headset", "mic"],
                icon: "headset"
            },
            {
                name: "Speaker",
                candidates: ["speaker"],
                icon: "speaker"
            }
        ];

        const str = ((device.name || device.remoteName || "") + " " + (device.icon || "")).toLowerCase();
        return table.find(cat => cat.candidates.some(i => str.includes(i))) ?? null;
    }

    readonly property string badgeName: {
        if (!device || !badgesList.results)
            return "";

        const availableBadges = badgesList.results;
        const lowerDeviceName = root.deviceName.toLowerCase();

        const name = availableBadges.find(i => {
            return lowerDeviceName.includes(i.toLowerCase().split('.')[0]);
        });

        return name ?? "";
    }

    function getBadgePath() {
        return root.badgeName ? (badgesList.folder + "/" + root.badgeName) : "";
    }

    FolderListModel {
        id: badgesList
        readonly property var results: getArray("fileName")
        folder: "file://" + Directories.assets + "/devices"
        showDirs: false
        showFiles: true
        nameFilters: NameFilters.picture
    }

    RowLayout {
        anchors.fill: parent
        spacing: Padding.massive

        StyledIconImage {
            visible: root.badgeName !== ""
            implicitSize: 180
            source: root.getBadgePath()
        }

        ColumnLayout {
            spacing: Padding.large
            Layout.fillHeight: true
            Layout.fillWidth: true

            PageHeader {
                title: root.deviceName
                subTitle: root.content?.auth === "confirm"
                    ? "PIN: " + (root.content?.passkey ?? "")
                    : root.deviceInfo?.name ?? ""
            }

            Spacer {}

            RowLayout {
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                spacing: Padding.normal
                Layout.topMargin: Padding.normal

                DialogButton {
                    buttonText: "Cancel"
                    toggled: false
                    releaseAction: () => root.dismiss()
                }

                DialogButton {
                    buttonText: root.content?.acceptText ?? "Connect"
                    toggled: true
                    colText: Colors.colOnPrimary
                    releaseAction: () => {
                        Qt.callLater(() => root.dismiss());
                        if (root.content?.onAccepted) {
                            root.content.onAccepted();
                        }
                    }
                }
            }
        }
    }
}
