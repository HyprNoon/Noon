import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import Noon.Utils.Download

StyledRect {
    id: root

    height: expanded ? 320 : 72
    radius: Rounding.large
    color: Colors.colLayer2
    clip: true
    anchors.left: parent?.left
    anchors.right: parent?.right

    required property var modelData
    required property int index
    property int cppIndex: index

    property bool expanded: false
    property bool canceled: modelData.state === DownloadItem.State.Canceled
    property bool finished: modelData.state === DownloadItem.State.Finished

    function formatBytes(bytes) {
        if (bytes <= 0)
            return "—";
        if (bytes < 1024)
            return bytes + " B";
        if (bytes < 1048576)
            return (bytes / 1024).toFixed(1) + " KB";
        if (bytes < 1073741824)
            return (bytes / 1048576).toFixed(1) + " MB";
        return (bytes / 1073741824).toFixed(2) + " GB";
    }

    function formatEta(seconds) {
        if (seconds < 0)
            return "—";
        if (seconds < 60)
            return seconds + "s";
        if (seconds < 3600)
            return Math.floor(seconds / 60) + "m " + (seconds % 60) + "s";
        return Math.floor(seconds / 3600) + "h " + Math.floor((seconds % 3600) / 60) + "m";
    }

    function formatState(state) {
        switch (state) {
        case DownloadItem.State.Queued:
            return "Queued";
        case DownloadItem.State.Running:
            return "Running";
        case DownloadItem.State.Paused:
            return "Paused";
        case DownloadItem.State.Canceled:
            return "Canceled";
        case DownloadItem.State.Finished:
            return "Finished";
        default:
            return "Unknown";
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true
        onClicked: root.expanded = !root.expanded
    }
    Item {
        id: container
        anchors.fill: parent
        anchors.margins: Padding.large
        HeadSection {
            id: head
            anchors {
                topMargin: Padding.verysmall
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }
        StyledRect {
            visible: root.expanded
            anchors {
                topMargin: Padding.large
                top: head.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            color: Colors.colLayer1Hover
            radius: Rounding.normal

            InfoSection {
                anchors.fill: parent
                anchors.margins: Padding.large
                itemData: root.modelData
                itemIndex: root.cppIndex
            }
        }
    }

    component HeadSection: RLayout {
        Layout.fillWidth: true
        spacing: Padding.huge

        Item {
            implicitHeight: 38
            implicitWidth: 38

            ClippedFilledCircularProgress {
                anchors.centerIn: parent
                value: modelData.progress === 0 ? 1 : modelData.progress / 100
                implicitSize: 38
            }

            Symbol {
                z: 99
                anchors.centerIn: parent
                color: Colors.colOnPrimary
                font.pixelSize: 22
                fill: 1
                text: {
                    switch (root.modelData.state) {
                    case DownloadItem.State.Queued:
                        return "hourglass_empty";
                    case DownloadItem.State.Running:
                        return "download";
                    case DownloadItem.State.Paused:
                        return "pause";
                    case DownloadItem.State.Canceled:
                        return "close";
                    case DownloadItem.State.Finished:
                        return "check";
                    default:
                        return "";
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true

            StyledText {
                id: label
                text: root.modelData.label
                color: (root.canceled || root.finished) ? Colors.colSubtext : Colors.colOnLayer2
                truncate: true
                Layout.fillWidth: true
                font {
                    pixelSize: Fonts.sizes.normal
                    variableAxes: Fonts.variableAxes.title
                    strikeout: root.canceled || root.finished
                }
            }

            StyledText {
                id: ext
                text: FileUtils.getEscapedFileExtension(root.modelData.url)
                color: Colors.colSubtext
                truncate: true
                Layout.fillWidth: true
                font {
                    pixelSize: Fonts.sizes.verysmall
                    strikeout: root.canceled || root.finished
                }
            }
        }

        RippleButtonWithIcon {
            toggled: root.expanded
            materialIcon: toggled ? "collapse_content" : "expand_content"
            releaseAction: () => root.expanded = !root.expanded
        }
    }

    component InfoSection: ColumnLayout {

        required property var itemData
        required property int itemIndex
        spacing: Padding.normal

        Repeater {
            model: [
                {
                    label: "Downloaded",
                    value: root.formatBytes(itemData.receivedBytes)
                },
                {
                    label: "Total",
                    value: root.formatBytes(itemData.totalBytes)
                },
                {
                    label: "Remaining",
                    value: root.formatBytes(Math.max(0, itemData.totalBytes - itemData.receivedBytes))
                },
                {
                    label: "Speed",
                    value: root.formatBytes(itemData.speed) + "/s"
                },
                {
                    label: "ETA",
                    value: root.formatEta(itemData.eta)
                },
                {
                    label: "State",
                    value: root.formatState(itemData.state)
                }
            ]

            delegate: RLayout {
                Layout.fillWidth: true

                StyledText {
                    truncate: true
                    Layout.fillWidth: true
                    color: Colors.colSubtext
                    font.pixelSize: Fonts.sizes.verysmall
                    text: modelData.label
                }

                StyledText {
                    truncate: true
                    color: Colors.colSecondary
                    font.pixelSize: Fonts.sizes.verysmall
                    text: modelData.value
                }
            }
        }

        RLayout {
            Layout.fillWidth: true
            visible: !root.canceled && !root.finished
            spacing: 2 * Padding.massive

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: "Speed Limit"
                    color: Colors.colOnLayer2
                    font.weight: 600
                    font.pixelSize: Fonts.sizes.small - 1
                    Layout.alignment: Qt.AlignVCenter
                }
                StyledText {
                    text: {
                        const mb = itemData.itemMaxSpeed / (1024 * 1024);
                        return mb > 0 ? mb.toFixed(1) + " MB/s" : "Unlimited";
                    }
                    color: Colors.colSubtext
                    font.pixelSize: Fonts.sizes.verysmall
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            StyledSlider {
                Layout.minimumWidth: 80
                Layout.fillWidth: true
                from: 0
                to: 100
                stepSize: 0.5
                enableTooltip: false
                value: itemData.itemMaxSpeed / (1024 * 1024)
                onMoved: itemData.itemMaxSpeed = value * 1024 * 1024
            }
        }

        RLayout {
            Layout.fillWidth: true
            Layout.topMargin: Padding.small

            Item {
                Layout.fillWidth: true
            }
            Repeater {
                model: [
                    {
                        icon: "open_in_new",
                        visible: root.finished,
                        releaseAction: () => DownloadService.manager.open(itemIndex)
                    },
                    {
                        icon: "folder",
                        visible: root.finished,
                        releaseAction: () => DownloadService.manager.reveal(itemIndex)
                    },
                    {
                        icon: itemData.state === DownloadItem.State.Paused ? "play_arrow" : "pause",
                        visible: !root.canceled && !root.finished,
                        releaseAction: () => {
                            if (itemData.state === DownloadItem.State.Running)
                                DownloadService.manager.pause(itemIndex);
                            else if (itemData.state === DownloadItem.State.Paused)
                                DownloadService.manager.resume(itemIndex);
                        }
                    },
                    {
                        visible: !root.canceled && !root.finished,
                        icon: "close",
                        releaseAction: () => DownloadService.manager.cancel(itemIndex)
                    },
                    {
                        visible: root.canceled,
                        icon: "restart_alt",
                        releaseAction: () => DownloadService.manager.retry(itemIndex)
                    },
                    {
                        visible: root.finished || root.canceled,
                        icon: "link",
                        releaseAction: () => ClipboardService.manager.copy(itemData.url)
                    },
                    {
                        visible: root.finished || root.canceled,
                        icon: "close",
                        releaseAction: () => DownloadService.manager.dismiss(itemIndex)
                    }
                ]
                delegate: RippleButtonWithIcon {
                    visible: modelData.visible
                    materialIcon: modelData.icon
                    releaseAction: () => modelData.releaseAction()
                    colBackground: Colors.colLayer3
                    colBackgroundHover: Colors.colLayer2Hover
                }
            }
        }
    }
}
