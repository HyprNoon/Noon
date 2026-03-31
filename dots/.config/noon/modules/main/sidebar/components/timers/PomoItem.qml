import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

RippleButton {
    id: root
    property var timer
    implicitHeight: 120
    colBackground: Colors.colLayer1
    buttonRadius: Rounding.normal
    releaseAction: () => {
        if (timer.isRunning) {
            TimerService.pauseTimer(timer.id);
        } else {
            TimerService.startTimer(timer.id);
        }
    }
    RowLayout {
        id: contentLayout
        anchors {
            fill: parent
            rightMargin: Padding.massive
            leftMargin: Padding.verylarge
        }
        spacing: Padding.large
        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 12
            // fill: false
            value: Math.min(1, (timer.originalDuration - timer.remainingTime) / timer.originalDuration)
            size: parent.height * 0.8
            secondaryColor: Colors.m3.m3secondaryContainer
            primaryColor: timer?.color || Colors.m3.m3primary
            Symbol {
                text: timer?.icon ?? "timer"
                anchors.centerIn: parent
                font.pixelSize: Fonts.sizes.title
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
                text: timer.name
                font.pixelSize: Fonts.sizes.normal
                color: Colors.colOnLayer1
            }
        }
        Spacer {}
        RowLayout {
            id: controls
            RippleButtonWithIcon {
                materialIcon: timer?.isRunning ? "pause" : "play_arrow"
                enabled: timer && timer.remainingTime > 0
                onClicked: {
                    if (timer.isRunning) {
                        TimerService.pauseTimer(timer.id);
                    } else {
                        TimerService.startTimer(timer.id);
                    }
                }
            }

            RippleButtonWithIcon {
                materialIcon: "restart_alt"
                enabled: timer !== null
                onClicked: TimerService.resetTimer(timer.id)
            }

            RippleButtonWithIcon {
                materialIcon: "delete"
                enabled: timer !== null
                onClicked: TimerService.removeTimer(timer.id)
            }
        }
    }
}
