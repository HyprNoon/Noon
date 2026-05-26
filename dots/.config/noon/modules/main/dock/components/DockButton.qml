import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

GroupButton {
    id: root

    property var appToplevel
    property var appListRoot
    property real iconSize: Mem.options.dock.appearance.iconSize
    property real countDotHeight: 3
    property bool appIsActive: appToplevel.toplevels.find(t => t.activated === true) !== undefined

    property bool isPinned: appToplevel.pinned === true
    property bool isGroup: appToplevel.isGroup === true

    readonly property bool dragHandlerActive: dragHandler.active

    property bool dropIsCenter: false

    baseSize: iconSize
    Layout.fillHeight: true
    buttonRadius: Rounding.normal

    opacity: appListRoot.draggingAppId === appToplevel.appId ? 0.3 : 1.0
    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }
    }

    Drag.active: dragHandler.active && isPinned
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.mimeData: ({
            "text/plain": appToplevel.appId
        })
    Drag.dragType: Drag.Automatic
    Drag.onDragStarted: {
        appListRoot.draggingAppId = appToplevel.appId;
        appListRoot.draggingIsGroup = root.isGroup;
    }
    Drag.onDragFinished: {
        appListRoot.draggingAppId = "";
        appListRoot.draggingIsGroup = false;
    }

    DragHandler {
        id: dragHandler
        enabled: root.isPinned
        xAxis.enabled: true
        yAxis.enabled: false
        dragThreshold: 8
        onActiveChanged: {
            if (active) {
                root.grabToImage(function (result) {
                    root.Drag.imageSource = result.url;
                    root.Drag.active = true;
                });
            }
        }
    }

    TapHandler {
        acceptedButtons: Qt.MiddleButton
        enabled: root.isPinned
        onTapped: {
            const anchorId = root.isGroup ? appToplevel.gid : appToplevel.appId;
            appListRoot.insertSeparator(anchorId);
        }
    }

    DropArea {
        anchors.fill: parent
        enabled: {
            if (appListRoot.draggingAppId === "")
                return false;
            if (appToplevel.appId === appListRoot.draggingAppId)
                return false;
            if (!root.isPinned)
                return false;
            if (appListRoot.draggingIsGroup && !root.isGroup)
                return false;
            return true;
        }
        keys: ["text/plain"]
        onPositionChanged: drag => {
            if (root.isGroup && appListRoot.draggingIsGroup) {
                const centerStart = root.width * 0.25;
                const centerEnd = root.width * 0.75;
                dropIsCenter = drag.x >= centerStart && drag.x <= centerEnd;
            } else {
                dropIsCenter = false;
            }
            appListRoot.dropTargetAppId = appToplevel.appId;
        }
        onEntered: appListRoot.dropTargetAppId = appToplevel.appId
        onExited: {
            if (appListRoot.dropTargetAppId === appToplevel.appId) {
                appListRoot.dropTargetAppId = "";
                dropIsCenter = false;
            }
        }
        onDropped: {
            const wasCenterDrop = dropIsCenter;
            appListRoot.dropTargetAppId = "";
            dropIsCenter = false;

            const dragId = appListRoot.draggingAppId;
            const targetId = appToplevel.appId;
            if (!dragId || dragId === targetId)
                return;

            var apps = appListRoot.pinnedApps.slice();
            const fromGroup = appListRoot.draggingFromGroup || "";
            const dragIsGroup = appListRoot.draggingIsGroup;
            var movedItems = [];

            if (fromGroup !== "") {
                const idx = apps.findIndex(a => a.appId.toLowerCase() === dragId.toLowerCase() && a.gid && a.gid.toLowerCase() === fromGroup.toLowerCase());
                if (idx !== -1) {
                    movedItems.push(apps[idx]);
                    apps.splice(idx, 1);
                }
            } else if (dragIsGroup) {
                const remaining = [];
                for (var i = 0; i < apps.length; i++) {
                    if (apps[i].gid && apps[i].gid.toLowerCase() === dragId.toLowerCase())
                        movedItems.push(apps[i]);
                    else
                        remaining.push(apps[i]);
                }
                apps = remaining;
            } else {
                const idx = apps.findIndex(a => !a.gid && a.appId.toLowerCase() === dragId.toLowerCase());
                if (idx !== -1) {
                    movedItems.push(apps[idx]);
                    apps.splice(idx, 1);
                }
            }

            if (movedItems.length === 0)
                return;

            const targetIsGroup = root.isGroup;

            if (targetIsGroup && (dragIsGroup ? wasCenterDrop : true)) {
                movedItems.forEach(item => {
                    item.gid = targetId;
                });
                var lastGroupIdx = -1;
                for (var i = 0; i < apps.length; i++) {
                    if (apps[i].gid && apps[i].gid.toLowerCase() === targetId.toLowerCase())
                        lastGroupIdx = i;
                }
                apps.splice(lastGroupIdx !== -1 ? lastGroupIdx + 1 : apps.length, 0, ...movedItems);
            } else {
                if (fromGroup !== "")
                    movedItems.forEach(item => {
                        item.gid = null;
                    });
                const targetIdx = apps.findIndex(a => targetIsGroup ? (a.gid && a.gid.toLowerCase() === targetId.toLowerCase()) : (!a.gid && a.appId.toLowerCase() === targetId.toLowerCase()));
                apps.splice(targetIdx !== -1 ? targetIdx : apps.length, 0, ...movedItems);
            }

            Mem.states.favorites.apps = apps;
        }
    }

    Rectangle {
        id: dropIndicator
        visible: {
            if (appListRoot.dropTargetAppId !== appToplevel.appId)
                return false;
            if (appListRoot.draggingAppId === appToplevel.appId)
                return false;
            if (root.isGroup && appListRoot.draggingIsGroup && root.dropIsCenter)
                return false;
            return true;
        }
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: -3
        width: 2
        radius: 1
        color: Colors.colPrimary
        z: 100
    }

    Rectangle {
        id: mergeHighlight
        visible: {
            if (appListRoot.dropTargetAppId !== appToplevel.appId)
                return false;
            if (!root.isGroup)
                return false;
            if (appListRoot.draggingIsGroup && !root.dropIsCenter)
                return false;
            return true;
        }
        anchors.fill: parent
        radius: root.buttonRadius
        color: Colors.colPrimary
        opacity: 0.18
        z: 99
    }
}
