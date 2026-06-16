import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    clip: true
    color: "transparent"
    radius: Rounding.small

    property string searchQuery: ""
    property bool expanded
    property bool detached
    signal dismiss
    signal searchFocusRequested
    signal contentFocusRequested

    property string currentDay: todayStr()
    property var dayData: []
    property int timeFrom: 0
    property int timeTo: 86400

    property var timeRanges: [
        {
            label: "All Day",
            from: 0,
            to: 86400
        },
        {
            label: "Morning",
            from: 21600,
            to: 43200
        },
        {
            label: "Afternoon",
            from: 43200,
            to: 64800
        },
        {
            label: "Evening",
            from: 64800,
            to: 86400
        },
    ]
    property int activeRange: 0

    function todayStr() {
        var d = new Date();
        return d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0");
    }

    function formatTime(secs) {
        if (secs < 60)
            return secs + "s";
        if (secs < 3600)
            return Math.floor(secs / 60) + "m " + (secs % 60) + "s";
        var h = Math.floor(secs / 3600);
        var m = Math.floor((secs % 3600) / 60);
        return h + "h " + m + "m";
    }

    function loadDay(date) {
        currentDay = date;
        refreshData();
    }

    function refreshData() {
        var range = timeRanges[activeRange];
        timeFrom = range.from;
        timeTo = range.to;
        var raw = timeFrom === 0 && timeTo === 86400 ? ScreenTimeService.tracker.getDayTotals(currentDay) : ScreenTimeService.tracker.getDayTimeline(currentDay, timeFrom, timeTo);
        raw.sort(function (a, b) {
            return b.timeSeconds - a.timeSeconds;
        });
        dayData = raw;
    }

    function prevDay() {
        var d = new Date(currentDay);
        d.setDate(d.getDate() - 1);
        var y = d.getFullYear();
        var m = String(d.getMonth() + 1).padStart(2, "0");
        var day = String(d.getDate()).padStart(2, "0");
        loadDay(y + "-" + m + "-" + day);
    }

    function nextDay() {
        var today = todayStr();
        if (currentDay === today)
            return;
        var d = new Date(currentDay);
        d.setDate(d.getDate() + 1);
        var y = d.getFullYear();
        var m = String(d.getMonth() + 1).padStart(2, "0");
        var day = String(d.getDate()).padStart(2, "0");
        var next = y + "-" + m + "-" + day;
        loadDay(next > today ? today : next);
    }

    Component.onCompleted: loadDay(todayStr())

    Connections {
        target: ScreenTimeService
        function onAppTimesChanged() {
            if (currentDay === todayStr())
                refreshData();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: Padding.huge
        anchors.rightMargin: Padding.huge
        anchors.topMargin: Padding.normal
        anchors.bottomMargin: Padding.normal
        spacing: Padding.huge

        PageHeader {
            title: {
                var total = 0;
                for (var i = 0; i < dayData.length; i++)
                    total += dayData[i].timeSeconds;
                return root.formatTime(total);
            }
            subTitle: currentDay === todayStr() ? "Today" : currentDay

            ButtonGroup {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                GroupButtonWithIcon {
                    materialIcon: "chevron_left"
                    onClicked: root.prevDay()
                }
                GroupButtonWithIcon {
                    materialIcon: "chevron_right"
                    onClicked: root.nextDay()
                }
            }
        }

        ButtonGroup {
            Layout.fillWidth: true
            spacing: Padding.tiny

            Repeater {
                model: timeRanges

                delegate: GroupButton {
                    required property var modelData
                    required property int index
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    radius: Rounding.normal
                    toggled: index === activeRange
                    StyledText {
                        anchors.centerIn: parent
                        text: modelData.label
                        font.pixelSize: Fonts.sizes.verysmall
                        color: index === activeRange ? Colors.colOnPrimary : Colors.colOnSurfaceVariant
                    }
                    onClicked: {
                        activeRange = index;
                        refreshData();
                    }
                }
            }
        }

        StyledListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Rounding.large
            _model: dayData
            clip: true
            delegate: StyledRect {
                required property var modelData
                required property int index

                readonly property var appInfo: DesktopEntries.byId(modelData.class)
                readonly property real maxTime: {
                    var t = 0;
                    for (var i = 0; i < dayData.length; i++)
                        if (dayData[i].timeSeconds > t)
                            t = dayData[i].timeSeconds;
                    return t;
                }

                topRadius: index === 0 ? Rounding.verylarge : Rounding.tiny
                bottomRadius: index === listView.count - 1 ? Rounding.verylarge : Rounding.tiny

                anchors.right: parent.right
                anchors.left: parent.left
                height: 80
                color: Colors.colLayer2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Padding.veryhuge
                    anchors.rightMargin: Padding.veryhuge
                    anchors.topMargin: Padding.normal
                    anchors.bottomMargin: Padding.normal
                    spacing: Padding.tiny

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Padding.large

                        StyledIconImage {
                            _source: appInfo.icon
                            implicitSize: 32
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            StyledText {
                                text: appInfo.name ?? modelData?.class ?? "Unknown"
                                font.pixelSize: Fonts.sizes.normal
                                color: Colors.colOnSurface
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            StyledText {
                                text: root.formatTime(modelData.timeSeconds) ?? "-"
                                font.pixelSize: Fonts.sizes.small
                                font.family: Fonts.family.monospace
                                color: Colors.colOnSurfaceVariant
                            }
                        }
                    }

                    StyledProgressBar {
                        Layout.fillWidth: true
                        valueBarHeight: 8
                        valueBarGap: 6
                        value: maxTime > 0 ? modelData.timeSeconds / maxTime : 0
                        highlightColor: Colors.colPrimary
                        trackColor: Colors.colSurfaceVariant
                        showProgressIndicator: false
                        sperm: true
                    }
                }
            }

            StyledText {
                anchors.centerIn: parent
                visible: listView.count === 0
                text: "No activity this day"
                font.pixelSize: Fonts.sizes.normal
                color: Colors.colOnSurfaceVariant
            }
        }
    }
}
