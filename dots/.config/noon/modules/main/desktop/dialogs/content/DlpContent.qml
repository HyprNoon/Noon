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

    readonly property var qualityOptions: ({
            "audio": ["Best", "Standard", "Low"],
            "video": ["Best", "Standard", "Low"]
        })

    readonly property var qualityMap: ({
            "Best": "best",
            "Standard": "standard",
            "Low": "low"
        })

    readonly property var availableActions: [
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
        if (!root.url)
            return;

        const mode = segmentedButtonsContent[segmentedButtons.selectedIndex].toLowerCase();
        const isAudio = mode === "audio";
        const dir = isAudio ? FileUtils.trimFileProtocol(Directories.standard.music) : FileUtils.trimFileProtocol(Directories.standard.videos);
        const label = qualityRow.model[qualityRow.currentIndex] ?? "Best";

        DlpService.request({
            url: root.url,
            audio: isAudio,
            video: !isAudio,
            quality: root.qualityMap[label],
            directory: dir
        });
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
            readonly property string currentMode: segmentedButtonsContent[segmentedButtons.selectedIndex].toLowerCase()
            text: "Download Quality"
            model: root.qualityOptions[currentMode]
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
            model: root.availableActions
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
