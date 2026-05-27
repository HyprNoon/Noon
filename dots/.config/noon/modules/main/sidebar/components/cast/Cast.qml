import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
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
    signal searchFocusRequested
    signal contentFocusRequested

    readonly property string resultPath: "/var/tmp/cast-picker-result"
    readonly property string windowDataPath: "/var/tmp/cast-window-data"
    readonly property var allScreens: Quickshell.screens
    readonly property var allWindows: ToplevelManager?.toplevels?.values ?? []
    property var portalWindows: []  // [{handle, class, title}] from XDPH_WINDOW_SHARING_LIST

    Process {
        id: writer
        running: false
    }

    Process {
        id: reader
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.parseWindowData(text.trim());
            }
        }
    }

    function loadWindowData() {
        reader.running = false;
        reader.command = ["cat", root.windowDataPath];
        reader.running = true;
    }

    function parseWindowData(raw) {
        if (!raw)
            return;
        var entries = [];
        var parts = raw.split("[HA>]");
        for (var i = 0; i < parts.length - 1; i++) {
            var p = parts[i];
            var hEnd = p.indexOf("[HC>]");
            if (hEnd < 0)
                continue;
            var handle = p.substring(0, hEnd);
            var rest = p.substring(hEnd + 5);
            var cEnd = rest.indexOf("[HT>]");
            var cls = cEnd >= 0 ? rest.substring(0, cEnd) : "";
            rest = cEnd >= 0 ? rest.substring(cEnd + 5) : rest;
            var tEnd = rest.indexOf("[HE>]");
            var title = tEnd >= 0 ? rest.substring(0, tEnd) : rest;
            entries.push({
                handle: handle,
                class: cls,
                title: title
            });
        }
        portalWindows = entries;
    }

    function writeResult(text) {
        if (!text)
            return;
        writer.running = false;
        writer.command = ["sh", "-c", "printf '%s' '" + text.replace(/'/g, "'\\''") + "' > " + root.resultPath];
        writer.running = true;
    }

    function selectScreen(screenName) {
        writeResult("[SELECTION]/screen:" + screenName);
    }

    function selectWindowByIndex(index) {
        var entry = portalWindows[index];
        if (entry && entry.handle)
            writeResult("[SELECTION]/window:" + entry.handle);
    }

    function cancel() {
        writeResult("__cancel__");
        root.dismiss();
    }

    Component.onCompleted: loadWindowData()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.large

        PageHeader {
            title: "Share Screen"
            subTitle: "Select a screen or window to share"
            showCloseButton: false
        }

        StyledText {
            Layout.topMargin: Padding.large
            Layout.leftMargin: Padding.large
            text: "Screens"
            font.pixelSize: Fonts.sizes.small
            font.variableAxes: Fonts.variableAxes.title
            color: Colors.colSubtext
        }

        StyledListView {
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight + Padding.massive
            hint: false
            clip: true

            model: root.allScreens
            delegate: ScreenItem {
                required property var modelData
                anchors.left: parent?.left
                anchors.right: parent?.right
                height: 212
                screenName: modelData.name
                screenRes: modelData.width + "x" + modelData.height
                captureSource: modelData
                onClicked: root.selectScreen(modelData.name)
            }
        }

        StyledText {
            Layout.topMargin: Padding.large
            Layout.leftMargin: Padding.large
            text: "Windows"
            font.pixelSize: Fonts.sizes.small
            font.variableAxes: Fonts.variableAxes.title
            color: Colors.colSubtext
        }

        StyledListView {
            id: windowList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.allWindows
            hint: false
            clip: true

            delegate: WindowItem {
                required property var modelData
                required property int index
                anchors.left: parent?.left
                anchors.right: parent?.right
                topRadius: index === 0 ? Rounding.large : Rounding.tiny
                bottomRadius: index === windowList.count - 1 ? Rounding.large : Rounding.tiny

                readonly property var pw: root.portalWindows[index] ?? null
                readonly property var winInfo: HyprlandService.windowByAddress["0x" + (modelData?.HyprlandToplevel?.address ?? "")] ?? null

                windowTitle: pw?.title ?? winInfo?.title ?? modelData?.title ?? "Unknown"
                windowClass: pw?.class ?? winInfo?.class ?? ""
                captureSource: modelData

                onClicked: root.selectWindowByIndex(index)
            }
        }

        ButtonGroup {
            Layout.topMargin: Padding.large
            Layout.fillWidth: true
            Layout.maximumHeight: 50

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: "Cancel"
                onClicked: root.cancel()
            }
        }
    }
}
