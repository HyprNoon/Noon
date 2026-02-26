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
import qs.common.functions
import qs.services
import qs.store

Scope {
    id: background
    Variants {
        model: MonitorsInfo.all
        StyledPanel {
            id: backgroundPanel
            property ShellScreen modelData
            screen: modelData
            name: "bg"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            color: Colors.colLayer0

            // Properties
            readonly property bool enableDepthMode: Mem.options.desktop.bg.depthMode // New config toggle for depth mode
            readonly property bool enableParallax: Mem.options.desktop.bg.parallax.enabled
            property string wallpaper: WallpaperService.currentWallpaper
            property var workspaceList: Hyprland.workspaces.values.filter(ws => ws.id >= 0).sort((a, b) => a.id - b.id)
            property real currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1
            onWallpaperChanged: fgLoader.item && fgLoader.item.refresh
            readonly property real wallpaperScale: Mem.options.desktop.bg.parallax.parallaxStrength + 1
            readonly property real effectiveWallpaperScale: enableParallax ? wallpaperScale : 1.0
            readonly property real effectiveMovableXSpace: (effectiveWallpaperScale - 1) / 2 * screen.width
            readonly property real effectiveMovableYSpace: (effectiveWallpaperScale - 1) / 2 * screen.height
            exclusiveZone: -1
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Item {
                anchors.fill: parent
                Item {
                    id: bgLayerWrapper
                    anchors.fill: parent
                    Image {
                        id: bgImage
                        z: 0
                        fillMode: Image.PreserveAspectCrop
                        source: backgroundPanel.wallpaper
                        asynchronous: true
                        cache: true
                        mipmap: true
                        anchors.fill: enableParallax ? undefined : bgLayerWrapper
                        property bool imageLoaded: status === Image.Ready
                        property bool verticalParallaxMode: Mem.options.desktop.bg.parallax.verticalParallax

                        property real parallaxFactor: {
                            const firstId = workspaceList[0]?.id || 1;
                            const lastId = workspaceList[workspaceList.length - 1]?.id || Mem.options.bar.workspaces.shown;
                            const range = lastId - firstId;
                            const workspaceOffset = range > 0 ? ((currentWorkspace - firstId) / range) : 0.5;
                            return Math.max(0, Math.min(1, workspaceOffset));
                        }
                        function calculate_widget_margin() {
                            let _widget_direction_offset = Mem.options.bar.behavior.position === "left" ? -1 : 1;
                            let _widget_width = GlobalStates.main.sidebar.sidebarWidth;
                            if (Mem.options.desktop.bg.parallax.widgetParallax && enableParallax)
                                return _widget_direction_offset * Mem.options.desktop.bg.parallax.parallaxStrength * _widget_width;
                            else
                                return 0;
                        }
                        sourceSize: Qt.size(screen.width, screen.height)
                        width: parent.width * effectiveWallpaperScale
                        height: parent.height * effectiveWallpaperScale

                        x: (verticalParallaxMode ? calculate_widget_margin() : -effectiveMovableXSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableXSpace)
                        y: (verticalParallaxMode ? -effectiveMovableYSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableYSpace : 0)

                        Behavior on x {
                            Anim {
                                duration: Animations.durations.large
                                easing.bezierCurve: Animations.curves.standardDecel
                            }
                        }
                        Behavior on y {
                            Anim {
                                duration: Animations.durations.large
                                easing.bezierCurve: Animations.curves.standardDecel
                            }
                        }

                        opacity: imageLoaded ? 1.0 : 0.0
                        Behavior on opacity {
                            Anim {
                                duration: Animations.durations.large
                            }
                        }
                    }
                    Loader {
                        id: layerClock
                        active: fgLoader.item && fgLoader.item.status === Image.Ready && backgroundPanel.enableDepthMode
                        sourceComponent: LayerClock {}
                        asynchronous: true
                    }
                    StyledLoader {
                        shown: Mem.options.desktop.widgets.enabled
                        readonly property bool rightMode: Mem.options.bar.behavior.position === "left"
                        anchors {
                            right: rightMode ? parent.right : undefined
                            left: !rightMode ? parent.left : undefined

                            top: parent.top
                            bottom: parent.bottom
                            margins: Math.max(Sizes.hyprland.gapsOut, Sizes.elevationMargin)
                        }
                        sourceComponent: DesktopWidgets {}
                    }
                    DesktopClock {
                        z: 9999
                        visible: Mem.options.desktop.clock.enabled && (!backgroundPanel.enableDepthMode || !layerClock.active)
                    }
                    StyledLoader {
                        id: fgLoader
                        anchors.fill: parent
                        visible: active
                        fade: true
                        asynchronous: true
                        active: backgroundPanel.enableDepthMode
                        sourceComponent: Fg {}
                    }
                }
            }
        }
    }
}
