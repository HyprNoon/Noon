import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    bottomAreaReveal: true
    collapsedHeight: 360
    enableStagedReveal: false
    color: Colors.colLayer1
    bgAnchors {
        rightMargin: Padding.large
        leftMargin: Padding.large
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: 0

        BottomDialogHeader {
            title: qsTr("Download Settings")
            subTitle: qsTr("Speed & concurrency limits")
        }

        BottomDialogSeparator {}

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.verylarge
            spacing: Padding.huge

            RowLayout {
                Layout.fillWidth: true
                spacing: Padding.small

                Symbol {
                    text: "speed"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        text: qsTr("Speed Limit")
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: {
                            const mb = DownloadService.manager.maxSpeed / (1024 * 1024);
                            return mb > 0 ? mb.toFixed(1) + " MB/s" : qsTr("Unlimited");
                        }
                        font.pixelSize: Fonts.sizes.small
                        color: Colors.colOutline
                    }
                }

                StyledSlider {
                    id: speedSlider
                    Layout.minimumWidth: 120
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    stepSize: 0.5
                    value: DownloadService.manager.maxSpeed / (1024 * 1024)
                    onMoved: DownloadService.manager.maxSpeed = value * 1024 * 1024
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Padding.small

                Symbol {
                    text: "horizontal_split"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        text: qsTr("Max Parallel Downloads")
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: DownloadService.manager.maxParallel > 0 ? DownloadService.manager.maxParallel : qsTr("Unlimited")
                        font.pixelSize: Fonts.sizes.small
                        color: Colors.colOutline
                    }
                }

                StyledSpinBox {
                    id: parallelSpin
                    Layout.minimumWidth: 80
                    from: 0
                    to: 20
                    value: DownloadService.manager.maxParallel
                    onValueChanged: DownloadService.manager.maxParallel = value
                }
            }

            Spacer {}
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
