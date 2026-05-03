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

    property bool isSeparator: appToplevel.appId === "SEPARATOR"
    property bool isPinned: appToplevel.pinned === true

    readonly property bool dragHandlerActive: dragHandler.active

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
    Drag.onDragStarted: appListRoot.draggingAppId = appToplevel.appId
    Drag.onDragFinished: appListRoot.draggingAppId = ""

    DragHandler {
        id: dragHandler
        enabled: root.isPinned && !root.isSeparator
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

    DropArea {
        anchors.fill: parent
        enabled: appListRoot.draggingAppId !== "" && root.isPinned && appToplevel.appId !== appListRoot.draggingAppId
        keys: ["text/plain"]
        onEntered: appListRoot.dropTargetAppId = appToplevel.appId
        onExited: {
            if (appListRoot.dropTargetAppId === appToplevel.appId)
                appListRoot.dropTargetAppId = "";
        }
        onDropped: {
            appListRoot.dropTargetAppId = "";
            const dragId = appListRoot.draggingAppId;
            const targetId = appToplevel.appId;
            if (!dragId || dragId === targetId)
                return;

            var apps = appListRoot.pinnedApps.slice();
            const fromGroup = appListRoot.draggingFromGroup || "";

            // 1. Find the item(s) to move
            var movedItems = [];
            if (fromGroup !== "") {
                const idx = apps.findIndex(a => a.appId.toLowerCase() === dragId.toLowerCase() && a.gid && a.gid.toLowerCase() === fromGroup.toLowerCase());
                if (idx !== -1) {
                    movedItems.push(apps[idx]);
                    apps.splice(idx, 1);
                }
            } else {
                const isDragGroup = apps.some(a => a.gid && a.gid.toLowerCase() === dragId.toLowerCase());
                if (isDragGroup) {
                    const remaining = [];
                    for (var i = 0; i < apps.length; i++) {
                        if (apps[i].gid && apps[i].gid.toLowerCase() === dragId.toLowerCase()) {
                            movedItems.push(apps[i]);
                        } else {
                            remaining.push(apps[i]);
                        }
                    }
                    apps = remaining;
                } else {
                    const idx = apps.findIndex(a => !a.gid && a.appId.toLowerCase() === dragId.toLowerCase());
                    if (idx !== -1) {
                        movedItems.push(apps[idx]);
                        apps.splice(idx, 1);
                    }
                }
            }

            if (movedItems.length === 0)
                return;

            // 2. Determine target position and updated group properties
            const isTargetGroup = apps.some(a => a.gid && a.gid.toLowerCase() === targetId.toLowerCase());

            if (isTargetGroup) {
                movedItems.forEach(item => {
                    item.gid = targetId;
                });

                var lastGroupIdx = -1;
                for (var i = 0; i < apps.length; i++) {
                    if (apps[i].gid && apps[i].gid.toLowerCase() === targetId.toLowerCase()) {
                        lastGroupIdx = i;
                    }
                }
                if (lastGroupIdx !== -1) {
                    apps.splice(lastGroupIdx + 1, 0, ...movedItems);
                } else {
                    apps.push(...movedItems);
                }
            } else {
                if (fromGroup !== "") {
                    movedItems.forEach(item => {
                        item.gid = null;
                    });
                }

                const targetIdx = apps.findIndex(a => !a.gid && a.appId.toLowerCase() === targetId.toLowerCase());
                if (targetIdx !== -1) {
                    apps.splice(targetIdx, 0, ...movedItems);
                } else {
                    apps.push(...movedItems);
                }
            }

            Mem.states.favorites.apps = apps;
        }
    }

    Rectangle {
        id: dropIndicator
        visible: appListRoot.dropTargetAppId === appToplevel.appId && appListRoot.draggingAppId !== appToplevel.appId
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: -3
        width: 2
        radius: 1
        color: Colors.colPrimary
        z: 100
    }
}
