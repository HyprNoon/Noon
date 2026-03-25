import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions
import qs.services

Item {
    id: root
    anchors.fill: parent
    property string url

    property var segmentedButtonsContent: ["Audio", "Video"]
    signal dismiss

    // Simplified quality options mapped to yt-dlp parameters
    readonly property var qualityOptions: ({
            "video": {
                options: ["1080p", "720p", "480p", "360p"],
                default: "720p",
                toParams: quality => {
                    let height = quality.replace("p", "");
                    // Format: "yt-dlp-format|post-processing-args"
                    return `bestvideo[height<=${height}]+bestaudio/best[height<=${height}]|`;
                }
            },
            "audio": {
                options: ["Best", "Medium", "Low"],
                default: "Best",
                toParams: quality => {
                    let qualityMap = {
                        "Best": "0",
                        "Medium": "5",
                        "Low": "9"
                    };
                    let q = qualityMap[quality];
                    // Passes the audio format and the conversion/metadata flags
                    return `bestaudio|--extract-audio --audio-format mp3 --audio-quality ${q} --embed-thumbnail --add-metadata`;
                }
            }
        })

    readonly property var avilableActions: [
        {
            text: "Download",
            action: () => {
                execute();
                Qt.callLater(() => root.dismiss());
            }
        },
        {
            text: "Cancel",
            action: () => {
                root.dismiss();
            }
        }
    ]
    function execute() {
        let url = root.url;
        if (!url)
            return;
        let mode = segmentedButtonsContent[segmentedButtons.selectedIndex].toLowerCase();
        let dir = mode === "audio" ? FileUtils.trimFileProtocol(Directories.standard.music) : FileUtils.trimFileProtocol(Directories.standard.videos);
        let config = qualityOptions[mode];
        let quality = qualityRow.model[qualityRow.currentIndex] || config.default;
        let params = config.toParams(quality);

        BeatsService.downloadWithDLP({
            parameters: params,
            url: root.url,
            destination: FileUtils.trimFileProtocol(Directories.standard.downloads)
        });
        root.dismiss();
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Padding.large

        Item {
            implicitHeight: placeholder.implicitHeight
            implicitWidth: placeholder.implicitWidth
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignHCenter
            PagePlaceholder {
                id: placeholder
                icon: "play_arrow"
                title: "You dropped a youtube link \nLets see what can we do"
                shape: MaterialShape.Shape.Bun
                implicitWidth: 180
                implicitHeight: 180
                shown: true
            }
        }

        SegmentedButtonGroup {
            id: segmentedButtons
            content: root.segmentedButtonsContent
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.preferredHeight: 20
        }

        OptionRow {
            id: qualityRow
            property string currentMode: segmentedButtonsContent[segmentedButtons.selectedIndex].toLowerCase()
            text: "Download Quality"
            model: currentMode === "video" ? qualityOptions.video.options : qualityOptions.audio.options
            Layout.maximumWidth: root.width * 0.7
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

    component OptionRow: RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        property alias text: title.text
        property alias model: combo.model
        property alias currentIndex: combo.currentIndex

        StyledText {
            id: title
            Layout.fillWidth: true
            truncate: true
            Layout.rightMargin: Padding.massive
            color: Colors.colOnLayer0
        }

        StyledComboBox {
            id: combo
        }
    }
}
