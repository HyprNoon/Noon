import Noon.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.store
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root

    required property bool show
    required property bool rightMode
    required property string selectedCategory
    property QtObject colors: Colors
    readonly property var bubbles: [
        {
            "cat": "Walls",
            "bubbles": [
                {
                    "icon": "colorize",
                    "enabled": true,
                    "action": () => {
                        WallpaperService.pickAccentColor();
                    }
                },
                {
                    "icon": "shuffle",
                    "enabled": true,
                    "action": () => {
                        WallpaperService.shuffleWallpapers();
                    }
                },
                {
                    "icon": GowallService.isBusy ? "hourglass" : "auto_fix_high",
                    "enabled": !GowallService.isBusy,
                    "action": () => {
                        GowallService.upscaleCurrentWallpaper();
                    }
                },
                {
                    "enabled": !RemBgService.isBusy,
                    "icon": RemBgService.isBusy ? "hourglass" : "content_cut",
                    "action": () => {
                        RemBgService.process_current_bg();
                    }
                },
                {
                    "icon": WallpaperService._generatingThumbnails ? "hourglass" : "restart_alt",
                    "enabled": !WallpaperService._generatingThumbnails,
                    "action": () => {
                        WallpaperService.generateThumbnailsForCurrentFolder();
                    }
                }
            ]
        },
        {
            "cat": "API",
            "bubbles": [
                {
                    "icon": "clear_all",
                    "action": () => {
                        Ai.clearMessages();
                    }
                },
                {
                    "icon": "restart_alt",
                    "action": () => {
                        Ai.regenerate(Ai.messageIDs.length - 1);
                    }
                },
                {
                    "icon": "save",
                    "action": () => {
                        Ai.saveChat("lastSession");
                    }
                },
                {
                    "icon": "upload",
                    "action": () => {
                        Ai.loadChat("lastSession");
                    }
                }
            ]
        },
        {
            "cat": "Web",
            "bubbles": [
                {
                    "icon": "open_in_new",
                    "action": () => {
                        Qt.openUrlExternally(GlobalStates.web_session?.url ?? "");
                        NoonUtils.callIpc("sidebar hide");
                    }
                },
                {
                    "icon": "keyboard_double_arrow_left",
                    "enabled": GlobalStates.web_session?.canGoBack ?? false,
                    "action": () => {
                        GlobalStates.web_session.goBack();
                    }
                },
                {
                    "icon": "keyboard_double_arrow_right",
                    "enabled": GlobalStates.web_session?.canGoForward ?? false,
                    "action": () => {
                        GlobalStates.web_session.goForward();
                    }
                },
                {
                    "icon": "restart_alt",
                    "enabled": !GlobalStates.web_session?.loading ?? false,
                    "action": () => {
                        GlobalStates.web_session.reload();
                    }
                }
            ]
        },
        {
            "cat": "History",
            "bubbles": [
                {
                    "icon": "clear_all",
                    "action": () => {
                        ClipboardService.wipe();
                    }
                }
            ]
        },
        {
            "cat": "Shelf",
            "bubbles": [
                {
                    "icon": "clear_all",
                    "action": () => {
                        Mem.states.sidebar.shelf.filePaths = [];
                    }
                }
            ]
        },
        {
            "cat": "Tasks",
            "bubbles": [
                {
                    "icon": TodoService.SyncState.Offline ? "cloud_off" : TodoService.SyncState.Error ? "error" : "sync",
                    "action": () => {
                        TodoService.syncWithTodoist();
                    }
                }
            ]
        },
        {
            "cat": "Beats",
            "bubbles": [
                {
                    "icon": "restart_alt",
                    "extraVisibleCondition": BeatsService.isCurrentPlayer(),
                    "action": () => BeatsService.startConnection()
                },
                {
                    "icon": "download",
                    "extraVisibleCondition": !BeatsService.isCurrentPlayer(),
                    "action": () => BeatsService.downloadCurrentSong()
                },
                {
                    "icon": "close",
                    "extraVisibleCondition": BeatsService.isCurrentPlayer(),
                    "action": () => BeatsService.stopPlayer()
                }
            ]
        }
    ]

    visible: bg.width > 0
    height: content.implicitHeight + 2 * Padding.large
    width: show ? 55 : 0
    clip: true

    StyledRect {
        id: bg

        radius: Rounding.verylarge
        color: colors.colLayer0
        anchors.fill: parent

        MouseArea {
            id: mouse

            acceptedButtons: Qt.NoButton
            anchors.fill: parent
            propagateComposedEvents: false
            hoverEnabled: true
        }

        ColumnLayout {
            id: content

            spacing: Padding.verysmall
            anchors.centerIn: parent

            Repeater {
                id: repeater
                model: bubbles

                ColumnLayout {
                    spacing: parent.spacing
                    visible: modelData.cat === root.selectedCategory

                    ColumnLayout {
                        spacing: parent.spacing

                        Repeater {
                            id: repeater
                            model: modelData.bubbles

                            RippleButtonWithIcon {
                                colors: root.colors
                                visible: modelData?.extraVisibleCondition ?? true
                                Layout.fillWidth: true
                                enabled: modelData.enabled !== undefined ? modelData.enabled : true
                                materialIcon: modelData.icon
                                releaseAction: modelData.action
                            }
                        }
                    }

                    Separator {
                        visible: modelData.cat === root.selectedCategory && repeater.model.length > 0
                    }
                }
            }
            RippleButtonWithIcon {
                colors: root.colors
                materialIcon: "close"
                visible: GlobalStates.main.sidebar.auxWidth > 0
                releaseAction: () => GlobalStates.main.sidebar.close_aux()
            }
            RippleButtonWithIcon {
                colors: root.colors
                toggled: SidebarData.detachedContent.includes(GlobalStates.main.sidebar.selectedCategory)
                enabled: !toggled
                visible: SidebarData.isDetachable(GlobalStates.main.sidebar.selectedCategory)
                materialIcon: "ad"
                releaseAction: () => GlobalStates.main.sidebar.detach()
            }
            RippleButtonWithIcon {
                colors: root.colors
                materialIcon: "push_pin"
                toggled: GlobalStates.main.sidebar.pinned
                releaseAction: () => GlobalStates.main.sidebar.pinned = !toggled
            }
            RippleButtonWithIcon {
                colors: root.colors
                materialIcon: {
                    if (GlobalStates.main.sidebar.rightMode) {
                        return !GlobalStates.main.sidebar.expanded ? "keyboard_double_arrow_left" : "keyboard_double_arrow_right";
                    } else
                        return GlobalStates.main.sidebar.expanded ? "keyboard_double_arrow_left" : "keyboard_double_arrow_right";
                }
                releaseAction: () => GlobalStates.main.sidebar.expanded = !GlobalStates.main.sidebar.expanded
            }
        }
    }
}
