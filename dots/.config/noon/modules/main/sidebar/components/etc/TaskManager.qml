import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

LayerRect {
    id: root
    color: "transparent"
    radius: Rounding.verylarge
    clip: true

    property bool expanded
    property string searchQuery: ""
    property bool detached
    signal dismiss
    signal searchFocusRequested
    signal contentFocusRequested
    readonly property var procs: TaskManagerService.manager.processes
    readonly property var res: ResourcesService.stats

    function formatBytes(bytes) {
        if (bytes < 1024)
            return bytes + " B";
        if (bytes < 1048576)
            return (bytes / 1024).toFixed(0) + " KB";
        if (bytes < 1073741824)
            return (bytes / 1048576).toFixed(0) + " MB";
        return (bytes / 1073741824).toFixed(1) + " GB";
    }

    function memPct(key) {
        var total = res ? res[key + "_total"] : 0;
        var avail = res ? res[key + "_available"] : 0;
        if (!total)
            return 0;
        return (total - avail) / total;
    }

    function stateColor(s) {
        if (s === "R")
            return Colors.colSuccess;
        if (s === "S" || s === "D")
            return Colors.colPrimary;
        if (s === "Z")
            return Colors.colError;
        if (s === "T")
            return Colors.colWarning;
        return Colors.colSubtext;
    }

    function stateIcon(s) {
        if (s === "R")
            return "play_circle";
        if (s === "S")
            return "pause_circle";
        if (s === "D")
            return "warning";
        if (s === "Z")
            return "dangerous";
        if (s === "T")
            return "stop_circle";
        return "circle";
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Padding.large

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Padding.large
            Layout.rightMargin: Padding.large
            spacing: Padding.small

            Repeater {
                id: cat
                model: [
                    {
                        icon: "memory",
                        label: "CPU",
                        pct: res ? (res.cpu_percent ?? 0) / 100 : 0,
                        text: res ? (res.cpu_percent ?? 0).toFixed(0) + "%" : "0%"
                    },
                    {
                        icon: "dataset",
                        label: "RAM",
                        pct: root.memPct("mem"),
                        text: res ? root.formatBytes((res.mem_total - res.mem_available)) : "0"
                    },
                    {
                        icon: "database",
                        label: "Swap",
                        pct: root.memPct("swap"),
                        text: res ? root.formatBytes(res.swap_total - res.swap_free) : "0"
                    },
                ]

                delegate: Item {
                    id: resItem
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    implicitHeight: 60

                    StyledRect {
                        anchors.fill: parent
                        color: Colors.colLayer2
                        rightRadius: index === cat.model.length ? Rounding.large : Rounding.tiny
                        leftRadius: index === 0 ? Rounding.large : Rounding.tiny

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Padding.normal
                            spacing: Padding.verysmall

                            RowLayout {
                                spacing: Padding.small
                                Layout.fillWidth: true

                                Symbol {
                                    iconSize: Fonts.sizes.normal
                                    text: modelData.icon
                                    fill: 1
                                    color: Colors.colPrimary
                                }

                                StyledText {
                                    text: modelData.label
                                    font.pixelSize: Fonts.sizes.small - 1
                                    font.weight: Font.Medium
                                    color: Colors.colSubtext
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                StyledText {
                                    text: modelData.text
                                    font.pixelSize: Fonts.sizes.verysmall
                                    font.weight: Font.DemiBold
                                    color: Colors.colOnLayer2
                                }
                            }

                            StyledProgressBar {
                                Layout.margins: Padding.verysmall
                                Layout.fillWidth: true
                                value: modelData.pct
                                sperm: true
                                valueBarGap: 4
                            }
                        }
                    }
                }
            }
        }

        StyledListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Padding.large
            Layout.rightMargin: Padding.large
            Layout.bottomMargin: Padding.normal
            spacing: Padding.verysmall
            clip: true
            hint: true

            model: {
                if (!root.procs)
                    return [];
                var q = root.searchQuery.trim().toLowerCase();
                var filtered = [];
                for (var i = 0; i < root.procs.length; i++) {
                    var p = root.procs[i];
                    if (q.length === 0 || p.name.toLowerCase().indexOf(q) >= 0 || String(p.pid).indexOf(q) >= 0 || p.user.toLowerCase().indexOf(q) >= 0) {
                        filtered.push(p);
                    }
                }
                filtered.sort(function (a, b) {
                    return b.cpuUsage - a.cpuUsage;
                });
                return filtered;
            }

            delegate: StyledRect {
                id: itemBg
                required property var modelData
                required property int index
                readonly property bool selected: listView.currentIndex === index
                anchors.left: parent?.left
                anchors.right: parent?.right
                implicitHeight: 65
                color: selected ? Colors.colLayer3 : Colors.colLayer2
                topRadius: (selected || index === 0) ? Rounding.verylarge : Rounding.tiny
                bottomRadius: (selected || index === listView.count - 1) ? Rounding.verylarge : Rounding.tiny

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Padding.huge
                    anchors.rightMargin: Padding.huge
                    spacing: Padding.huge

                    Symbol {
                        iconSize: 24
                        text: stateIcon(modelData.state)
                        fill: 1
                        color: stateColor(modelData.state)
                        Layout.alignment: Qt.AlignVCenter
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: Padding.verysmall

                        StyledText {
                            text: modelData.name
                            font.pixelSize: Fonts.sizes.normal
                            font.weight: Font.Medium
                            color: Colors.colOnLayer2
                            truncate: true
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            spacing: Padding.normal

                            StyledText {
                                Layout.fillWidth: true
                                text: "PID: " + modelData.pid
                                font.pixelSize: Fonts.sizes.small
                                color: Colors.colSubtext
                            }

                            // StyledText {
                            //     text: modelData.user
                            //     font.pixelSize: Fonts.sizes.small
                            //     color: Colors.colSubtext
                            // }

                            StyledText {
                                text: modelData.cpuUsage.toFixed(1) + "%"
                                font.pixelSize: Fonts.sizes.small
                                font.weight: Font.DemiBold
                                color: modelData.cpuUsage > 50 ? Colors.colError : Colors.colOnLayer2
                            }

                            StyledText {
                                text: formatBytes(modelData.memoryUsage)
                                font.pixelSize: Fonts.sizes.small
                                font.weight: Font.DemiBold
                                color: Colors.colOnLayer2
                            }
                        }
                    }

                    GroupButtonWithIcon {
                        materialIcon: modelData.cpuUsage > 0 ? "close" : "close"
                        implicitSize: 32
                        colBackground: Colors.colError
                        colSymbol: Colors.colOnError
                        colBackgroundHover: Colors.colErrorHover
                        releaseAction: () => TaskManagerService.manager.kill(modelData.pid)
                    }
                }
            }

            PagePlaceholder {
                anchors.centerIn: parent
                shown: listView.count === 0
                title: "No Processes"
                icon: "check_circle"
                iconSize: 96
                description: root.searchQuery.length > 0 ? "No processes match your search" : ""
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Up) {
                    if (currentIndex <= 0) {
                        currentIndex = -1;
                        root.searchFocusRequested();
                    } else {
                        currentIndex--;
                    }
                    event.accepted = true;
                } else if (event.key === Qt.Key_Down) {
                    if (currentIndex < count - 1) {
                        currentIndex++;
                    }
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Delete) {
                    if (currentIndex >= 0 && currentIndex < listView.count) {
                        TaskManagerService.manager.kill(listView.model[currentIndex].pid);
                    }
                    event.accepted = true;
                } else if (event.key === Qt.Key_Escape) {
                    root.dismiss();
                    event.accepted = true;
                }
            }
        }
    }

    onContentFocusRequested: {
        if (listView.count > 0) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    Component.onCompleted: TaskManagerService.manager.refresh()
}
