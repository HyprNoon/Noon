import qs.services
import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: button

    property string day
    property int isToday
    property bool bold
    property var releaseAction
    property var window
    property var getTasksOfDate

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitSize: 24
    color: (isToday === 1) ? Colors.colPrimary : "transparent"
    radius: Rounding.normal

    MouseArea {
        id: eventArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.releaseAction()
    }

    StyledText {
        anchors.centerIn: parent
        text: button.day
        horizontalAlignment: Text.AlignHCenter
        color: (isToday === 1) ? Colors.m3.m3onPrimary : (isToday === 0) ? Colors.colOnLayer1 : Colors.colOutlineVariant
        font.pixelSize: Fonts.sizes.verysmall
        font.weight: 800
        font.variableAxes: Fonts.variableAxes.title
        Behavior on color {
            CAnim {}
        }
    }

    StyledPopupPanel {
        hoverTarget: eventArea
        window: button.window
        // extraVisibilityCondition: tasksRepeater.count > 0

        ColumnLayout {
            spacing: Padding.large

            StyledText {
                Layout.preferredHeight: 45
                leftPadding: Padding.huge
                text: button.day + " Events."
                color: Colors.colOnLayer0
                font.pixelSize: Fonts.sizes.huge
            }

            ItemSeparator {}

            ColumnLayout {
                spacing: Padding.tiny
                Repeater {
                    id: tasksRepeater
                    model: ScriptModel {
                        values: root.getTasksOfDate(DateTimeService.request(`${button.day}/M/yyyy`))
                    }
                    delegate: ColumnLayout {
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        RowLayout {
                            Layout.fillWidth: true
                            StyledRadioButton {}
                            StyledText {
                                text: modelData.content
                                Layout.fillWidth: true
                                truncate: true
                            }
                        }
                        ItemSeparator {}
                    }
                }
            }
        }
    }

    component ItemSeparator: Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.leftMargin: Padding.massive
        Layout.rightMargin: Padding.massive
        visible: index !== tasksRepeater.count - 1
        color: Colors.colLayer3
        radius: 6
        height: 1
    }
}
