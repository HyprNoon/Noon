import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Controls.Material
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
    readonly property string today: DateTimeService.request("D/M/yyyy")
    Component.onCompleted: CalendarService.pull()
    function formatTasks() {
        const data = TodoService?.list;
        return data.map(item => {
            return {
                content: item?.content ?? "",
                start: item?.due + '/' + DateTimeService.year ?? "",
                isTask: true
            };
        });
    }

    function getTasksOfDate(dateString) {
        const todayEvents = CalendarService.list.filter(e => e.start === dateString);
        const allTasks = formatTasks();
        const tasks = allTasks.filter(task => task.start === dateString);

        return [...todayEvents, ...tasks];
    }

    function isToday(date) {
        return isInDate(date, today);
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
                model: getTasksOfDate(DateTimeService.request("d/M/yyyy"))
                delegate: Item {
                    required property var modelData
                    anchors.right: parent?.right
                    anchors.left: parent?.left
                    height: 55
                    RLayout {
                        anchors.fill: parent

                        ColumnLayout {
                            Layout.fillWidth: true

                            StyledText {
                                text: modelData.content
                                color: Colors.colOnLayer0
                                font.pixelSize: Fonts.sizes.normal
                                font.family: Fonts.family.variable
                                font.variableAxes: Fonts.variableAxes.title
                                Layout.fillWidth: true
                                truncate: true
                                Layout.rightMargin: Padding.large
                            }
                            StyledText {
                                visible: text.length > 0
                                text: {
                                    if (modelData.isTask)
                                        return "";
                                    const parts = modelData.end.split('/');
                                    const prefix = "Ends at ";
                                    return prefix + parts[0] + '/' + parts[1];
                                }
                                color: Colors.colOnLayer0
                                font.pixelSize: Fonts.sizes.verysmall + 1
                                font.family: Fonts.family.variable
                                font.variableAxes: Fonts.variableAxes.main
                                Layout.fillWidth: true
                                truncate: true
                                Layout.maximumWidth: 100
                            }
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
                        id: dayButton
                        readonly property int row: Math.floor(index / 7)
                        readonly property int col: index % 7
                        window: root.window
                        day: calendarLayout[row][col].day
                        isToday: calendarLayout[row][col].today
                        getTasksOfDate: root.getTasksOfDate
                        releaseAction: () => CalendarService.pull()
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
