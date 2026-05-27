import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

LayerRect {
    id: root
    radius: Rounding.large
    property bool revealAddDialog: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.large
        spacing: Padding.gigantic

        PageHeader {
            title: "Timers"
            subTitle: "Add/Remove Your Timers"
        }

        StyledListView {
            id: listView
            hint: false
            Layout.margins: Padding.small
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Padding.verysmall
            model: TimerService.timers
            delegate: TimerItem {
                timer: modelData
                topRadius: index === 0 ? Rounding.huge : Rounding.tiny
                bottomRadius: index === (listView.count - 1) ? Rounding.huge : Rounding.tiny
            }

            PagePlaceholder {
                shown: TimerService.timers.length === 0
                icon: "hourglass"
                title: "No active timers"
                description: "Swipe Below to add new timer"
            }
        }
    }

    BottomDialog {
        id: addDialog
        expandedHeight: 640
        collapsedHeight: 360
        enableStagedReveal: !addDialog.alarmMode
        bottomAreaReveal: true
        hoverHeight: 200
        bgAnchors {
            leftMargin: Padding.small
            rightMargin: Padding.small
        }
        color: Colors.colLayer2
        show: root.revealAddDialog
        expand: false
        property bool alarmMode: false
        function addEntry() {
            if (addDialog.alarmMode) {
                const timeStr = `${timePicker.hour}:${String(timePicker.minute).padStart(2, '0')}`;
                TimerService.wake(timeStr, nameField.text || "Wake Alarm");
            } else {
                const duration = TimerService.parseTimeString(`${timePicker.hour}h  ${timePicker.minute}m`);
                TimerService.addTimer(nameField.text, duration);
            }
            nameField.text = "";
            addDialog.show = false;
        }
        contentItem: Item {
            anchors.fill: parent
            ColumnLayout {
                spacing: Padding.large

                anchors {
                    fill: parent
                    margins: Padding.massive
                }

                RowLayout {
                    id: header
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.preferredHeight: 50
                    Layout.bottomMargin: 0
                    Layout.margins: Padding.normal
                    StyledText {
                        text: addDialog.alarmMode ? "Add Alarm" : "Add Timer"
                        font.pixelSize: Fonts.sizes.subTitle
                        color: Colors.colOnLayer2
                        verticalAlignment: Text.AlignVCenter
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    }
                    Spacer {}
                    RippleButtonWithIcon {
                        materialIcon: addDialog.alarmMode ? "timer" : "alarm"
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        onClicked: addDialog.alarmMode = !addDialog.alarmMode
                    }
                    RippleButtonWithIcon {
                        materialIcon: "close"
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        releaseAction: () => addDialog.show = false
                    }
                }
                Separator {}
                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    Layout.leftMargin: Padding.normal
                    font.pixelSize: Fonts.sizes.normal
                    placeholderText: addDialog.alarmMode ? "Alarm Name" : "Timer Name"
                    background: null
                    selectionColor: Colors.colPrimaryContainer
                    selectedTextColor: Colors.m3.m3onPrimaryContainer
                    color: Colors.colOnLayer0
                    placeholderTextColor: Colors.colSubtext
                    selectByMouse: true
                    onAccepted: addDialog.addEntry()
                }
                TimePicker {
                    id: timePicker
                    clockPicker: addDialog.alarmMode
                }
                StyledListView {
                    id: presets
                    visible: addDialog.expand && !addDialog.alarmMode
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: addDialog.alarmMode ? [] : TimerService.presets
                    delegate: StyledDelegateItem {
                        property var preset: modelData
                        title: preset.name
                        materialIcon: preset.icon
                        subtext: TimerService.formatTime(preset.duration)
                        releaseAction: () => TimerService.addTimer(preset.name, preset.duration, true)
                    }
                }
                Spacer {
                    visible: !presets.visible
                }
            }
            RippleButton {
                id: saveButton
                visible: addDialog.height > 300
                buttonRadius: Rounding.verylarge
                colBackground: Colors.colPrimaryContainer
                implicitWidth: 100
                implicitHeight: 50
                releaseAction: () => addDialog.addEntry()
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    margins: 20
                }
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Padding.normal
                    Symbol {
                        text: addDialog.alarmMode ? "alarm" : "edit"
                        fill: 1
                        font.pixelSize: Fonts.sizes.large
                        color: Colors.colOnPrimaryContainer
                    }
                    StyledText {
                        color: Colors.colOnPrimaryContainer
                        font.pixelSize: Fonts.sizes.normal
                        text: addDialog.alarmMode ? "Wake" : "Save"
                    }
                }
            }
        }
    }
}
