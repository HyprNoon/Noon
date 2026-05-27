import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    property var timer
    implicitHeight: 120
    anchors.right: parent?.right
    anchors.left: parent?.left
    color: Colors.colLayer2

    RowLayout {
        id: contentLayout
        anchors {
            fill: parent
            rightMargin: Padding.verylarge
            leftMargin: Padding.verylarge
        }
        spacing: Padding.normal
        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 10
            value: root.timer.remainingTime / root.timer.originalDuration
            size: 85
            secondaryColor: Colors.m3.m3secondaryContainer
            primaryColor: timer?.color || Colors.m3.m3primary
            Symbol {
                icon: timer?.icon ?? "timer"
                anchors.centerIn: parent
                font.pixelSize: 30
                fill: 1
                color: Colors.colOnLayer0
            }
        }
        ColumnLayout {
            id: info
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 40
            spacing: 0
            StyledText {
                id: duration
                font.variableAxes: Fonts.variableAxes.numbers
                text: TimerService.formatTime(timer.remainingTime)
                font.pixelSize: Fonts.sizes.huge
                color: Colors.colOnLayer1
            }
            StyledText {
                id: name
                truncate: true
                Layout.fillWidth: true
                text: timer.name
                font.pixelSize: Fonts.sizes.normal
                color: Colors.colOnLayer1
            }
            StyledText {
                id: wakeLabel
                visible: timer?.wakeTime
                text: timer?.wakeTime ? TimerService.formatWakeTime(timer.wakeTime) : ""
                font.pixelSize: Fonts.sizes.small
                color: Colors.colSubtext
                truncate: true
                Layout.fillWidth: true
            }
        }
        ButtonGroup {
            id: controls
            Repeater {
                model: [
                    {
                        materialIcon: timer?.isRunning ? "pause" : "play_arrow",
                        enabled: timer && timer.remainingTime > 0,
                        action: () => {
                            if (timer.isRunning) {
                                TimerService.pauseTimer(timer.id);
                            } else {
                                TimerService.startTimer(timer.id);
                            }
                        }
                    },
                    {
                        materialIcon: "restart_alt",
                        enabled: timer !== null,
                        action: () => TimerService.resetTimer(timer.id)
                    },
                    {
                        materialIcon: "delete",
                        enabled: timer !== null,
                        action: () => TimerService.removeTimer(timer.id)
                    }
                ]
                delegate: GroupButtonWithIcon {
                    required property var modelData
                    enabled: modelData.enabled ?? true
                    materialIcon: modelData.materialIcon ?? ""
                    releaseAction: () => modelData.action()
                    colBackground: Colors.colLayer3
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }
}
