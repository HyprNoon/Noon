import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    property real maxWindowPreviewHeight: 216
    property real maxWindowPreviewWidth: 384
    property real windowControlsHeight: 30

    property Item lastHoveredButton
    property bool buttonHovered: false
    property bool requestDockShow: false
    property bool verticalMode: false
    property var pinnedApps: Mem.states.favorites.apps

    property string draggingAppId: ""
    property string dropTargetAppId: ""
    property string draggingFromGroup: ""

    Layout.preferredWidth: listView.implicitWidth
    Layout.preferredHeight: listView.implicitHeight
    Layout.margins: Padding.normal

    ListView {
        id: listView
        clip: true
        spacing: height / 12
        orientation: ListView.Horizontal
        implicitWidth: contentWidth
        implicitHeight: Mem.options.dock.appearance.iconSize
        model: ScriptModel {
            objectProp: "appId"
            values: {
                var toplevelMap = new Map();
                var pinnedAppIds = new Set();
                var runningAppIds = new Set();

                for (const entry of root.pinnedApps) {
                    pinnedAppIds.add(entry.appId.toLowerCase());
                }

                for (const toplevel of ToplevelManager.toplevels.values) {
                    const key = toplevel.appId.toLowerCase();
                    runningAppIds.add(key);
                    if (!toplevelMap.has(key))
                        toplevelMap.set(key, []);
                    toplevelMap.get(key).push(toplevel);
                }

                var groupMap = new Map();
                var order = [];

                for (const entry of root.pinnedApps) {
                    const key = entry.appId.toLowerCase();
                    const gid = entry.gid;

                    if (gid) {
                        if (!groupMap.has(gid)) {
                            groupMap.set(gid, {
                                appId: gid,
                                gid: gid,
                                isGroup: true,
                                pinned: true,
                                entries: [],
                                toplevels: []
                            });
                            order.push({
                                type: "group",
                                gid: gid
                            });
                        }
                        const grp = groupMap.get(gid);
                        grp.entries.push(entry);
                        if (toplevelMap.has(key))
                            grp.toplevels.push(...toplevelMap.get(key));
                    } else {
                        order.push({
                            type: "app",
                            appId: entry.appId,
                            pinned: true,
                            toplevels: toplevelMap.get(key) ?? []
                        });
                    }
                }

                var values = [];
                var seen = new Set();

                for (const item of order) {
                    if (item.type === "group") {
                        if (!seen.has(item.gid)) {
                            seen.add(item.gid);
                            values.push(groupMap.get(item.gid));
                        }
                    } else {
                        values.push(item);
                    }
                }

                const hasUnpinnedRunning = Array.from(runningAppIds).some(id => !pinnedAppIds.has(id));
                if (root.pinnedApps.length > 0 && hasUnpinnedRunning) {
                    values.push({
                        appId: "SEPARATOR",
                        isGroup: false,
                        pinned: false,
                        toplevels: []
                    });
                }

                for (const [key, toplevels] of toplevelMap) {
                    if (!pinnedAppIds.has(key)) {
                        values.push({
                            appId: toplevels[0].appId,
                            gid: null,
                            isGroup: false,
                            pinned: false,
                            toplevels: toplevels
                        });
                    }
                }

                return values;
            }
        }

        delegate: DelegateChooser {
            role: "isGroup"
            DelegateChoice {
                roleValue: true
                DockGroupButton {
                    required property var modelData
                    appToplevel: modelData
                    appListRoot: root
                }
            }
            DelegateChoice {
                DockAppButton {
                    required property var modelData
                    appToplevel: modelData
                    appListRoot: root
                }
            }
        }
    }
}
