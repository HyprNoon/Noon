import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import Noon.Utils

LayerRect {
    id: root
    color: "transparent"
    radius: Rounding.verylarge
    clip: true

    property bool expanded
    property string searchQuery: ""
    property bool detached
    property bool showStats: false

    signal dismiss
    signal searchFocusRequested
    signal contentFocusRequested
    readonly property TaskManager manager: TaskManager {}
    readonly property ResourcesWatcher watcher: ResourcesService.watcher

    readonly property var procs: manager.processes
    readonly property var res: watcher.stats

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

        PageHeader {
            title: root.showStats ? "Resources" : "Task Manager"
            subTitle: root.showStats ? "System Resources" : root.procs.length + " Running Processes"
            sideButton {
                visible: true
                materialIcon: root.showStats ? "auto_awesome_motion" : "leaderboard"
                releaseAction: () => root.showStats = !root.showStats
            }
        }
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
                        rightRadius: index === cat.model.length - 1 ? Rounding.large : Rounding.tiny
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
        StackLayout {
            id: pages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.showStats ? 1 : 0

            ColumnLayout {
                id: processesPage
                spacing: Padding.large

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
                                text: root.stateIcon(modelData.state)
                                fill: 1
                                color: root.stateColor(modelData.state)
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

                                    StyledText {
                                        text: modelData.cpuUsage.toFixed(1) + "%"
                                        font.pixelSize: Fonts.sizes.small
                                        font.weight: Font.DemiBold
                                        color: modelData.cpuUsage > 50 ? Colors.colError : Colors.colOnLayer2
                                    }

                                    StyledText {
                                        text: root.formatBytes(modelData.memoryUsage)
                                        font.pixelSize: Fonts.sizes.small
                                        font.weight: Font.DemiBold
                                        color: Colors.colOnLayer2
                                    }
                                }
                            }

                            GroupButtonWithIcon {
                                materialIcon: "close"
                                implicitSize: 32
                                colBackground: Colors.colError
                                colSymbol: Colors.colOnError
                                colBackgroundHover: Colors.colErrorHover
                                releaseAction: () => root.manager.kill(modelData.pid)
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
                                root.manager.kill(listView.model[currentIndex].pid);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            root.dismiss();
                            event.accepted = true;
                        }
                    }
                }
            }

            ColumnLayout {
                id: statsPage
                spacing: Padding.verylarge

                StyledListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: Padding.large
                    Layout.rightMargin: Padding.large
                    Layout.bottomMargin: Padding.normal
                    spacing: Padding.large
                    clip: true
                    hint: true

                    model: {
                        var secs = [];
                        var r = root.res;

                        if (r) {
                            var cpuItems = [];
                            cpuItems.push({
                                label: "Usage",
                                value: r.cpu_percent / 100,
                                text: r.cpu_percent.toFixed(1) + "%"
                            });
                            if (r.cpu_temp > 0)
                                cpuItems.push({
                                    label: "Temperature",
                                    value: Math.min(r.cpu_temp / 100, 1.0),
                                    text: r.cpu_temp.toFixed(1) + " °C"
                                });
                            if (r.cpu_total_freq_ghz > 0)
                                cpuItems.push({
                                    label: "Clock",
                                    value: Math.min(r.cpu_freq_ghz / r.cpu_total_freq_ghz, 1.0),
                                    text: r.cpu_freq_ghz.toFixed(2) + " / " + r.cpu_total_freq_ghz.toFixed(2) + " GHz"
                                });
                            secs.push({
                                title: "CPU",
                                items: cpuItems
                            });

                            var memItems = [];
                            var used = r.mem_total - r.mem_available;
                            memItems.push({
                                label: "RAM",
                                value: r.mem_total > 0 ? used / r.mem_total : 0,
                                text: (used / 1073741824).toFixed(1) + " / " + (r.mem_total / 1073741824).toFixed(1) + " GB"
                            });
                            if (r.swap_total > 0) {
                                var swapUsed = r.swap_total - r.swap_free;
                                memItems.push({
                                    label: "Swap",
                                    value: swapUsed / r.swap_total,
                                    text: (swapUsed / 1073741824).toFixed(1) + " / " + (r.swap_total / 1073741824).toFixed(1) + " GB"
                                });
                            }
                            secs.push({
                                title: "Memory",
                                items: memItems
                            });

                            if (r.disks && r.disks.length > 0) {
                                var diskItems = [];
                                for (var d = 0; d < r.disks.length; d++) {
                                    var disk = r.disks[d];
                                    diskItems.push({
                                        subtitle: disk.type.toUpperCase(),
                                        label: disk.mount,
                                        value: disk.total > 0 ? disk.used / disk.total : 0,
                                        text: (disk.used / 1073741824).toFixed(1) + " / " + (disk.total / 1073741824).toFixed(1) + " GB"
                                    });
                                }
                                secs.push({
                                    title: "Storage",
                                    items: diskItems
                                });
                            }

                            if (r.gpus) {
                                for (var i = 0; i < r.gpus.length; i++) {
                                    var gpu = r.gpus[i];
                                    var gpuItems = [];
                                    gpuItems.push({
                                        label: "Utilization",
                                        value: gpu.utilization / 100,
                                        text: gpu.utilization.toFixed(1) + "%"
                                    });
                                    if (gpu.temperature > 0)
                                        gpuItems.push({
                                            label: "Temperature",
                                            value: Math.min(gpu.temperature / 100, 1.0),
                                            text: gpu.temperature.toFixed(1) + " °C"
                                        });
                                    if (gpu.memory_total > 0)
                                        gpuItems.push({
                                            label: "VRAM",
                                            value: gpu.memory_used / gpu.memory_total,
                                            text: gpu.memory_used.toFixed(0) + " / " + gpu.memory_total.toFixed(0) + " MB"
                                        });
                                    if (gpu.power_draw > 0)
                                        gpuItems.push({
                                            label: "Power",
                                            value: gpu.power_limit > 0 ? Math.min(gpu.power_draw / gpu.power_limit, 1.0) : 0,
                                            text: gpu.power_limit > 0 ? gpu.power_draw.toFixed(1) + " / " + gpu.power_limit.toFixed(1) + " W" : gpu.power_draw.toFixed(1) + " W"
                                        });
                                    secs.push({
                                        title: gpu.name,
                                        items: gpuItems
                                    });
                                }
                            }
                        }

                        return secs;
                    }

                    delegate: ResourceCard {
                        required property var modelData
                        title: modelData.title
                        anchors.right: parent?.right
                        anchors.left: parent?.left

                        Repeater {
                            model: modelData.items
                            delegate: ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                StyledText {
                                    text: modelData?.subtitle ?? ""
                                    visible: modelData.subtitle !== undefined
                                    color: Colors.m3.m3onSurfaceVariant
                                    font.pixelSize: Fonts.sizes.verysmall
                                    font.weight: Font.Medium
                                    elide: Text.ElideMiddle
                                    opacity: 0.7
                                }

                                ResourceBar {
                                    title: modelData.label
                                    value: modelData.value
                                    valueText: modelData.text
                                }

                                Item {
                                    Layout.preferredHeight: modelData.subtitle !== undefined ? 4 : 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onContentFocusRequested: {
        if (pages.currentIndex === 0 && listView.count > 0) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    Component.onCompleted: manager.refresh()

    component ResourceCard: StyledRect {
        id: cardRoot
        default property alias content: cardLayout.data
        property string title: ""
        radius: Rounding.large
        color: Colors.colLayer2
        Layout.fillWidth: true
        implicitHeight: cardLayout.implicitHeight + Padding.verylarge * 2

        ColumnLayout {
            id: cardLayout
            anchors.fill: parent
            anchors.margins: Padding.verylarge
            spacing: Padding.small

            StyledText {
                text: cardRoot.title
                font.pixelSize: Fonts.sizes.small
                font.weight: Font.Black
                color: Colors.m3.m3onSurfaceVariant
                font.letterSpacing: 1.1
                opacity: 0.8
                visible: cardRoot.title.length > 0
            }

            Item {
                Layout.preferredHeight: cardRoot.title.length > 0 ? Padding.verysmall : 0
            }
        }
    }

    component ResourceBar: RLayout {
        id: barRoot
        property alias title: label.text
        property real value: 0
        property string valueText: ""
        Layout.fillWidth: true
        Layout.preferredHeight: 36
        spacing: Padding.huge

        StyledText {
            id: label
            Layout.preferredWidth: 80
            font.pixelSize: Fonts.sizes.normal
            color: Colors.colOnLayer2
        }

        StyledText {
            text: barRoot.valueText
            color: Colors.m3.m3onSurfaceVariant
            font.pixelSize: Fonts.sizes.small
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: 110
        }

        StyledRect {
            Layout.preferredWidth: 80
            Layout.fillWidth: true
            radius: Rounding.full
            clip: true
            height: 6
            color: Colors.colLayer3

            StyledRect {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.max(0, Math.min(barRoot.value, 1.0)) * parent.width
                color: {
                    var v = barRoot.value;
                    if (v > 0.8)
                        return Colors.colError;
                    if (v > 0.5)
                        return Colors.colTertiary;
                    return Colors.colPrimary;
                }

                Behavior on width {
                    SmoothedAnimation {
                        velocity: 60
                    }
                }
            }
        }
    }
}
