import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    readonly property bool isRecording: RecordingService.isRecording
    collapsedHeight: isRecording ? 150 : 450
    color: Colors.colLayer1

    contentItem: CLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive

        BottomDialogHeader {
            title: root.isRecording ? "Recording Now" : "Screen Recording"
            subTitle: root.isRecording ? RecordingService.getFormattedDuration() : "Configure and Record"
            target: root
        }

        BottomDialogSeparator {
            visible: !root.isRecording
        }

        StyledIndeterminateProgressBar {
            visible: root.isRecording
            Layout.fillWidth: true
            Layout.topMargin: -8
            Layout.bottomMargin: -8
            Layout.leftMargin: -Rounding.large
            Layout.rightMargin: -Rounding.large
        }
        CLayout {
            visible: !root.isRecording
            Layout.fillWidth: true
            Layout.fillHeight: true
            OptionsSection {
                title: "Region"
                content: ["Screen", "Region", "Window"]
                action: i => RecordingService.setRecordingMode(i)
            }

            OptionsSection {
                title: "Audio"
                content: ["Muted", "System Audio", "Mic"]
                action: i => RecordingService.setAudioMode(i)
            }

            OptionsSection {
                title: "Quality"
                content: ["720@30", "1080@30", "1080@60"]
                action: i => RecordingService.setQuality(i)
            }

            RLayout {
                Layout.fillWidth: true
                spacing: 10

                Symbol {
                    text: "mouse"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: "Show Cursor"
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: RecordingService.showCursor
                    onToggled: RecordingService.showCursor = checked
                }
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
                        RecordingService.toggleRecording();
                        if (!root.isRecording)
                            root.show = false;
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
