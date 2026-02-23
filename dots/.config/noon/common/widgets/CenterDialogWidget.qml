import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.functions
import qs.services

AppWindow {
    id: root
    visible: true
    maximumSize: Qt.size(640, 480)
    minimumSize: Qt.size(800, 600)
    color: "transparent"
    property string dropUrl
    property alias icon: placeholder.icon
    property alias title: placeholder.title
    property alias description: placeholder.description
    property alias shape: placeholder.shape
    property alias shapePadding: placeholder.shapePadding
    property string currentAction
    property var segmentedButtonsContent
    property var avilableActions: [
        {
            text: "Download",
            action: () => {
                execute();
                console.log("download");
                root.visible = true;
            }
        },
        {
            text: "Cancel",
            action: () => {
                root.visible = false;
            }
        }
    ]
    function execute() {
        let url = root.dropUrl;
        if (!url)
            return;
        let guide = segmentedButtonsContent[segmentedButtons.selectedIndex];
        let dir = FileUtils.trimFileProtocol(Directories.standard.downloads);
        let params;

        switch (guide.toLowerCase()) {
        case "video":
            params = "bestvideo[height<=720]+bestaudio/best[height<=720] --no-playlist";
            break;
        case "audio":
            params = "bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --no-playlist";
            break;
        }

        let cmd = `yt-dlp -f ${params} -P "${dir}" --no-playlist "${url}"`;
        BeatsService.downloadByCommand(cmd);
    }

    StyledRect {
        color: Colors.colLayer0
        anchors.fill: parent

        CLayout {
            anchors.centerIn: parent
            spacing: 120
            Item {
                Layout.alignment: Qt.AlignCenter
                implicitWidth: placeholder.implicitWidth
                implicitHeight: placeholder.implicitHeight
                PagePlaceholder {
                    id: placeholder

                    implicitWidth: 120
                    implicitHeight: 120
                    anchors.centerIn: parent
                    shown: true
                }
            }
            ColumnLayout {
                spacing: 5
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                implicitWidth: 70
                StyledText {
                    Layout.leftMargin: Padding.large
                    text: "Download Type"
                    color: Colors.colPrimary
                    font.weight: Font.DemiBold
                    font.pixelSize: Fonts.sizes.normal
                }
                SegmentedButtonGroup {
                    id: segmentedButtons
                    content: root.segmentedButtonsContent
                }
            }
        }

        RLayout {
            implicitHeight: 40
            implicitWidth: 200
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: Padding.massive
            }
            Repeater {
                model: root.avilableActions
                delegate: DialogButton {
                    required property var modelData
                    buttonText: modelData.text
                    onClicked: () => modelData.action()
                }
            }
        }
    }
}
