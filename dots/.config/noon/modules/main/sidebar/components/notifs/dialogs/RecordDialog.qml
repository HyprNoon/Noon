import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    readonly property bool isRecording: RecordingService.isRecording
    collapsedHeight: isRecording ? 150 : 300
    color: Colors.colLayer3
    clip: true

    bgAnchors {
        rightMargin: Padding.large
        leftMargin: Padding.large
    }

    contentItem: CLayout {
        anchors.fill: parent
        anchors.margins: Padding.large

        PageHeader {
            title: root.isRecording ? "Recording Now" : "Screen Recording"
            subTitle: root.isRecording ? RecordingService.getFormattedDuration() : "Configure and Record"
            target: root
        }
        Item {
            Layout.preferredHeight: 35
            Layout.fillWidth: true
            PageSeparator {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                visible: !root.isRecording
            }
            StyledIndeterminateProgressBar {
                visible: root.isRecording
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        CLayout {
            visible: !root.isRecording
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.huge

            OptionsSection {
                title: "Region"
                content: ["Screen", "Region"]
                action: i => Mem.states.services.record.fullscreen === (content[i] === "Screen")
            }

            OptionsSection {
                title: "Audio"
                content: ["Sound", "Muted"]
                action: i => Mem.states.services.record.sound === (content[i] === "Sound")
            }

            Spacer {}

            RLayout {
                Layout.preferredHeight: 50
                Layout.fillWidth: true

                Item {
                    Layout.fillWidth: true
                }

                DialogButton {
                    colText: Colors.colOnPrimary
                    buttonText: root.isRecording ? qsTr("Stop") : qsTr("Record")
                    colBackground: root.isRecording ? Colors.colError : Colors.colPrimary
                    colBackgroundHover: root.isRecording ? Colors.colErrorHover : Colors.colPrimaryHover
                    onClicked: {
                        if (root.isRecording)
                            RecordingService.stop();
                        else
                            RecordingService.record();
                    }
                }

                DialogButton {
                    buttonText: "Done"
                    enabled: true
                    onClicked: root.show = false
                }
            }
        }
    }
    component OptionsSection: RLayout {
        property alias title: title.text
        property alias content: bgroup.model
        property var action
        Layout.fillWidth: true
        Layout.preferredHeight: 55
        StyledText {
            id: title
            color: Colors.colSubtext
            font.variableAxes: Fonts.variableAxes.title
            font.pixelSize: Fonts.sizes.small
            Layout.fillWidth: true
        }

        StyledComboBox {
            id: bgroup
            Layout.alignment: Qt.AlignHCenter
            implicitHeight: 40
            onCurrentIndexChanged: action(currentIndex)
        }
    }
}
