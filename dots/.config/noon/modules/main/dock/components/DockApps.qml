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
    property bool draggingIsGroup: false

    Layout.preferredWidth: listView.implicitWidth
    Layout.preferredHeight: listView.implicitHeight
    Layout.margins: Padding.normal

    function insertSeparator(nearAppId) {
        var apps = pinnedApps.slice();
        const idx = apps.findIndex(a => a.appId === nearAppId || a.gid === nearAppId);
        apps.splice(idx !== -1 ? idx + 1 : apps.length, 0, {
            appId: "SEPARATOR"
        });
        Mem.states.favorites.apps = apps;
    }

    function removeSeparatorAt(idx) {
        var apps = pinnedApps.slice();
        apps.splice(idx, 1);
        Mem.states.favorites.apps = apps;
    }

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
                    if (entry.appId !== "SEPARATOR")
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
                var seenGroups = new Set();
                var values = [];
                var sepIndex = 0;

                for (const entry of root.pinnedApps) {
                    if (entry.appId === "SEPARATOR") {
                        values.push({
                            appId: "SEPARATOR_" + sepIndex++,
                            isSeparator: true,
                            isGroup: false
                        });
                    } else if (entry.gid) {
                        const gid = entry.gid;
                        if (!groupMap.has(gid)) {
                            groupMap.set(gid, {
                                appId: gid,
                                gid: gid,
                                isGroup: true,
                                isSeparator: false,
                                pinned: true,
                                entries: [],
                                toplevels: []
                            });
                        }
                        const grp = groupMap.get(gid);
                        grp.entries.push(entry);
                        if (toplevelMap.has(entry.appId.toLowerCase()))
                            grp.toplevels.push(...toplevelMap.get(entry.appId.toLowerCase()));
                        if (!seenGroups.has(gid)) {
                            seenGroups.add(gid);
                            values.push(grp);
                        }
                    } else {
                        values.push({
                            appId: entry.appId,
                            isGroup: false,
                            isSeparator: false,
                            pinned: true,
                            toplevels: toplevelMap.get(entry.appId.toLowerCase()) ?? []
                        });
                    }
                }

                const hasUnpinnedRunning = Array.from(runningAppIds).some(id => !pinnedAppIds.has(id));
                if (hasUnpinnedRunning) {
                    values.push({
                        appId: "RUNNING_SEPARATOR",
                        isSeparator: true,
                        isGroup: false
                    });
                    for (const [key, toplevels] of toplevelMap) {
                        if (!pinnedAppIds.has(key))
                            values.push({
                                appId: toplevels[0].appId,
                                gid: null,
                                isGroup: false,
                                isSeparator: false,
                                pinned: false,
                                toplevels: toplevels
                            });
                    }
                }

                return values;
            }
        }

        delegate: DelegateChooser {
            role: "isSeparator"
            DelegateChoice {
                roleValue: true
                DockSeparator {}
            }
            DelegateChoice {
                roleValue: false
                DelegateChooser {
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
                        roleValue: false
                        DockAppButton {
                            required property var modelData
                            appToplevel: modelData
                            appListRoot: root
                        }
                    }
                }
            }
        }
    }
}
