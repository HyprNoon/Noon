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
    required property QtObject colors
    readonly property var sidebar: GlobalStates.main.sidebar
    ScriptModel {
        id: bubbles
        values: [
            {
                "cat": "Downloads",
                "bubbles": [
                    {
                        "icon": "clear_all",
                        "enabled": true,
                        "action": () => {
                            DownloadService.model.clearAll();
                        }
                    },
                ]
            },
            {
                "cat": "Tasks",
                "bubbles": [
                    {
                        "icon": "refresh",
                        "action": () => {
                            TodoService.pull();
                        }
                    }
                ]
            },
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
                        "enabled": !GowallService.isBusy,
                        "icon": GowallService.isBusy ? "hourglass" : "content_cut",
                        "action": () => {
                            GowallService.removeBackground(WallpaperService.currentWallpaper);
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
                        "icon": "globe",
                        "action": () => {
                            Ai.resumeInWeb(Ai.currentSessionId);
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
                "bubbles": []
            },
            {
                "cat": "Beats",
                "bubbles": [
                    {
                        "icon": "download",
                        "extraVisibleCondition": !BeatsService.isCurrentPlayer(),
                        "action": () => BeatsService.downloadCurrentSong()
                    },
                    {
                        "icon": "close",
                        "action": () => BeatsService.stopPlayer()
                    }
                ]
            }
        ]
    }
    readonly property var panelActionsModel: [
        {
            icon: "close",
            visible: sidebar.auxWidth > 0,
            action: () => sidebar.close_aux(),
            toggled: false
        },
        {
            icon: "select_window",
            toggled: SidebarData.detachedContent.includes(sidebar.selectedCategory),
            visible: SidebarData.isDetachable(sidebar.selectedCategory),
            enabled: !SidebarData.detachedContent.includes(sidebar.selectedCategory),
            action: () => sidebar.detach()
        },
        {
            icon: "push_pin",
            toggled: sidebar.pinned,
            action: () => sidebar.pinned = !sidebar.pinned
        },
        {
            icon: getExpandIcon(),
            action: () => sidebar.expanded = !sidebar.expanded
        }
    ]
    function getExpandIcon() {
        const direction = (root.sidebar.rightMode && !root.sidebar.expanded) || (!root.sidebar.rightMode && root.sidebar.expanded) ? "left" : "right";
        return `keyboard_double_arrow_${direction}`;
    }
    visible: bg.width > 0
    width: show ? 55 : 0
    clip: true
    height: bg.height

    StyledRect {
        id: bg

        radius: Rounding.verylarge
        color: root.colors.colLayer0
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: content.implicitHeight + Padding.massive

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
                    visible: modelData?.cat === root?.selectedCategory ?? true

                    Repeater {
                        id: repeater
                        model: ScriptModel {
                            values: modelData.bubbles
                        }

                        RippleButtonWithIcon {
                            colors: root.colors
                            visible: modelData?.extraVisibleCondition ?? true
                            Layout.fillWidth: true
                            enabled: modelData.enabled !== undefined ? modelData.enabled : true
                            materialIcon: modelData.icon
                            releaseAction: modelData.action
                        }
                    }

                    Separator {
                        visible: modelData.cat === root.selectedCategory && repeater.model.length > 0
                    }
                }
            }
            Repeater {
                model: root.panelActionsModel

                RippleButtonWithIcon {
                    colors: root.colors
                    Layout.fillWidth: true
                    visible: modelData?.visible ?? true
                    enabled: modelData?.enabled ?? true
                    materialIcon: modelData?.icon
                    releaseAction: modelData?.action
                }
            }
        }
    }
}
