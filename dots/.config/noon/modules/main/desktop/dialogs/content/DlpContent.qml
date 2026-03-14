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
    property string url

    property var segmentedButtonsContent: ["Audio", "Video", "Command"]
    signal dismiss

    // Simplified quality options mapped to yt-dlp parameters
    readonly property var qualityOptions: ({
            "video": {
                options: ["1080p", "720p", "480p", "360p"],
                default: "720p",
                toParams: quality => {
                    let height = quality.replace("p", "");
                    return `bestvideo[height<=${height}]+bestaudio/best[height<=${height}] --no-playlist`;
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
                    return `bestaudio --extract-audio --audio-format mp3 --audio-quality ${q} --embed-thumbnail --add-metadata --no-playlist`;
                }
            }
        })

    readonly property var avilableActions: [
        {
            text: "Download",
            action: () => {
                execute();
                root.dismiss();
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
        let dir = FileUtils.trimFileProtocol(Directories.standard.downloads);
        let params = "";

        if (mode === "command") {
            params = textArea.text.trim();
        } else {
            let config = qualityOptions[mode];
            let quality = qualityRow.model[qualityRow.currentIndex] || config.default;
            params = config.toParams(quality);
        }

        let cmd = `yt-dlp -f ${params} -P "${dir}" "${url}"`;
        BeatsService.downloadByCommand(cmd);
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
            visible: currentMode !== "command"
            text: "Download Quality"
            model: currentMode === "video" ? qualityOptions.video.options : qualityOptions.audio.options
        }

        MaterialTextArea {
            id: textArea
            visible: segmentedButtonsContent[segmentedButtons.selectedIndex].toLowerCase() === "command"
            placeholderText: "Enter Your Custom Parameters after yt-dlp -f ..."
            Layout.preferredHeight: 60
            Layout.preferredWidth: 250
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
