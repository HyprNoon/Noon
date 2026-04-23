import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets
import "calendar_layout.js" as CalendarLayout

SquareComponent {
    id: root
    property var calendarLayout: CalendarLayout.getCalendarLayout(viewingDate, monthShift === 0)
    property int monthShift: 0
    property var viewingDate: CalendarLayout.getDateInXMonthsTime(monthShift)

    function isToday(date) {
        if (!date)
            return false;
        if (date === -1)
            return true;
        const parts = date.split('/');
        const day = parseInt(parts[0]);
        const month = parseInt(parts[1]);
        const year = parseInt(parts[2]);
        const now = new Date();
        return day === now.getDate() && month === (now.getMonth() + 1) && year === now.getFullYear();
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive
        spacing: anchors.margins
        ColumnLayout {
            visible: root.expanded
            Layout.leftMargin: Padding.small
            Layout.maximumWidth: 165
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: -Padding.verysmall
            StyledText {
                text: DateTimeService.request("dddd")
                color: Colors.colPrimary
                font.variableAxes: Fonts.variableAxes.title
                font.pixelSize: Fonts.sizes.small
            }
            StyledText {
                text: DateTimeService.request("d")
                color: Colors.colOnLayer0
                font.family: Fonts.family.variable
                font.variableAxes: Fonts.variableAxes.numbers
                font.pixelSize: 40
            }
            StyledListView {
                radius: 0
                clip: true
                hint: false
                Layout.topMargin: Padding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ScriptModel {
                    values: TodoService.list.filter(task => isToday(task?.due))
                }
                delegate: Item {
                    required property var modelData
                    anchors.right: parent?.right
                    anchors.left: parent?.left
                    height: 55
                    RLayout {
                        anchors.fill: parent
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.margins: Padding.verysmall
                            width: 6
                            radius: 4
                            color: {
                                switch (modelData.status) {
                                case TodoService.status_todo:
                                    return Colors.colPrimaryContainer;
                                case TodoService.status_in_progress:
                                    return Colors.colPrimaryContainer;
                                case TodoService.status_final_touches:
                                    return Colors.colPrimary;
                                case TodoService.status_done:
                                    return Colors.colSuccess;
                                default:
                                    return Colors.colPrimaryContainer;
                                }
                            }
                        }
                        StyledText {
                            text: modelData?.content
                            font.strikeout: modelData.status === TodoService.status_done
                            color: modelData.status === TodoService.status_done ? Colors.colSubtext : Colors.colOnLayer0
                            font.pixelSize: Fonts.sizes.small
                            font.family: Fonts.family.variable
                            font.variableAxes: Fonts.variableAxes.title
                            Layout.fillWidth: true
                            truncate: true
                            Layout.maximumWidth: 100
                        }
                    }
                }
                StyledText {
                    visible: parent.count === 0
                    text: "No Events Today"
                    anchors.centerIn: parent
                    font.pixelSize: Fonts.sizes.small
                    color: Colors.colSubtext
                }
            }
        }
        VerticalSeparator {
            visible: root.expanded
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillHeight: true

            StyledText {
                text: DateTimeService.request("MMMM")
                color: Colors.colPrimary
                font.variableAxes: Fonts.variableAxes.title
                font.pixelSize: Fonts.sizes.small
                Layout.leftMargin: Padding.verysmall
            }

            GridLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                columns: 7
                rowSpacing: 0
                columnSpacing: 0

                Repeater {
                    model: CalendarLayout.weekDays
                    delegate: CalendarDayButton {
                        day: qsTr(modelData.day)
                        isToday: modelData.today
                        bold: true
                        enabled: false
                    }
                }

                Repeater {
                    model: 35
                    delegate: CalendarDayButton {
                        readonly property int row: Math.floor(index / 7)
                        readonly property int col: index % 7
                        day: calendarLayout[row][col].day
                        isToday: calendarLayout[row][col].today
                    }
                }
            }
        }
    }
}
