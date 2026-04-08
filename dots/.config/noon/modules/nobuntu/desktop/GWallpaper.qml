import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import qs.store

Scope {
    id: background
    Variants {
        model: Quickshell.screens
        StyledPanel {
            id: backgroundPanel
            property ShellScreen modelData
            screen: modelData
            name: "bg"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            readonly property bool _overview_enabled: true
            readonly property bool _overview: GlobalStates.nobuntu.overview.show
            readonly property bool enableDepthMode: Mem.options.desktop.bg.depthMode // New config toggle for depth mode
            readonly property bool enableParallax: Mem.options.desktop.bg.parallax.enabled
            readonly property string wallpaper: WallpaperService.currentWallpaper
            readonly property real currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1
            readonly property var workspaceList: Hyprland.workspaces.values.filter(ws => ws.id >= 0).sort((a, b) => a.id - b.id)
            readonly property real wallpaperScale: Mem.options.desktop.bg.parallax.parallaxStrength + 1
            readonly property real effectiveWallpaperScale: enableParallax ? wallpaperScale : 1.0
            readonly property real effectiveMovableXSpace: (effectiveWallpaperScale - 1) / 2 * screen.width
            readonly property real effectiveMovableYSpace: (effectiveWallpaperScale - 1) / 2 * screen.height
            exclusiveZone: -1

            fill: true
            FocusHandler {
                windows: [backgroundPanel]
                active: _overview
                onActiveChanged: searchbar.searchInput.focus = active
                onCleared: GlobalStates.nobuntu.overview.show = false
            }
            Item {
                anchors.fill: parent
                Loader {
                    z: -1
                    active: _overview_enabled
                    anchors.fill: parent
                    sourceComponent: BlurImage {
                        blur: true
                        anchors.fill: parent
                        source: wallpaper
                    }
                }
                ColumnLayout {
                    spacing: Padding.huge
                    anchors {
                        top: parent.top
                        topMargin: 60
                        horizontalCenter: parent.horizontalCenter
                    }
                    GSearchbar {
                        id: searchbar
                        results: appsResults.searchResults
                    }
                    GSearchResults {
                        id: appsResults
                        searchQuery: searchbar.searchInput.text
                    }
                }

                StyledRectangularShadow {
                    z: target.z
                    target: bgLayerWrapper
                    enabled: _overview
                    intensity: 0.5
                }

                Rectangle {
                    id: bgLayerWrapper
                    color: "transparent"
                    anchors {
                        fill: parent
                        bottomMargin: _overview ? 60 : 0
                        margins: _overview ? 280 : 0
                    }
                    Behavior on anchors.margins {
                        Anim {
                            duration: Animations.durations.large
                        }
                    }
                    Behavior on anchors.bottomMargin {
                        Anim {
                            duration: Animations.durations.large
                        }
                    }

                    CroppedImage {
                        id: bgImage
                        z: 0
                        fillMode: Image.PreserveAspectCrop
                        source: backgroundPanel.wallpaper
                        asynchronous: true
                        cache: true
                        mipmap: true
                        anchors.fill: enableParallax ? undefined : bgLayerWrapper
                        radius: 30
                        opacity: imageLoaded ? 1.0 : 0.0

                        property bool imageLoaded: status === Image.Ready
                        property bool verticalParallaxMode: Mem.options.desktop.bg.parallax.verticalParallax
                        property int widgetMargin: Mem.options.desktop.bg.parallax.widgetParallax && enableParallax && GlobalStates.main.sidebar.expanded ? (Mem.options.bar.behavior.position === "left" ? -1 : 1) * Math.max(Mem.options.desktop.bg.parallax.parallaxStrength, 0.1) * 12 * (SidebarData.launcherWidth > 500 ? 20 : 50) : 0

                        property real parallaxFactor: {
                            const firstId = workspaceList[0]?.id || 1;
                            const lastId = workspaceList[workspaceList.length - 1]?.id || Mem.options.bar.workspaces.shown;
                            const range = lastId - firstId;
                            const workspaceOffset = range > 0 ? ((currentWorkspace - firstId) / range) : 0.5;
                            return Math.max(0, Math.min(1, workspaceOffset));
                        }

                        sourceSize: Qt.size(screen.width, screen.height)
                        width: imageLoaded ? parent.width * effectiveWallpaperScale : parent.width
                        height: imageLoaded ? parent.height * effectiveWallpaperScale : parent.height

                        x: imageLoaded ? (verticalParallaxMode ? widgetMargin : -effectiveMovableXSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableXSpace) : 0
                        y: imageLoaded ? (verticalParallaxMode ? -effectiveMovableYSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableYSpace : 0) : 0

                        GDesktopApplications {
                            anchors.fill: parent
                            anchors.leftMargin: 100
                        }
                        Behavior on x {
                            Anim {
                                duration: Animations.durations.verylarge
                            }
                        }
                        Behavior on y {
                            Anim {
                                duration: Animations.durations.verylarge
                            }
                        }

                        Behavior on opacity {
                            Anim {
                                duration: Animations.durations.verylarge
                            }
                        }
                    }
                    Image {
                        id: fgImage
                        visible: backgroundPanel.enableDepthMode && source !== ""
                        z: 9999
                        anchors.fill: bgImage
                        fillMode: Image.PreserveAspectCrop
                        source: FileUtils.trimFileProtocol(Directories.wallpapers.depthDir + Qt.md5(FileUtils.trimFileProtocol(Mem.states.desktop.bg.currentBg)) + ".png") || ""
                        asynchronous: true
                        cache: true
                        mipmap: true
                        sourceSize: bgImage.sourceSize
                        x: bgImage.x
                        y: bgImage.y
                        function refresh() {
                            fgImage.source = "";
                            fgImage.source = FileUtils.trimFileProtocol(Directories.wallpapers.depthDir + Qt.md5(FileUtils.trimFileProtocol(Mem.states.desktop.bg.currentBg)) + ".png");
                        }
                        opacity: fgImage.status === Image.Ready ? 1 : 0
                        Behavior on opacity {
                            Anim {}
                        }
                    }
                }
            }
        }
    }
}
