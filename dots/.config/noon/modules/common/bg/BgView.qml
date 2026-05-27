import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions
import qs.services
import qs.store

Item {
    id: root

    readonly property string wallpaper: WallpaperService.currentWallpaper
    readonly property bool enableDepthMode: Mem.options.desktop.bg.depthMode
    readonly property bool enableParallax: Mem.options.desktop.bg.parallax.enabled
    readonly property var workspaceList: Hyprland.workspaces.values.filter(ws => ws.id >= 0).sort((a, b) => a.id - b.id)
    readonly property real currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1
    readonly property real wallpaperScale: Mem.options.desktop.bg.parallax.parallaxStrength + 1
    readonly property real effectiveWallpaperScale: enableParallax ? wallpaperScale : 1.0
    readonly property real effectiveMovableXSpace: (effectiveWallpaperScale - 1) / 2 * screen.width
    readonly property real effectiveMovableYSpace: (effectiveWallpaperScale - 1) / 2 * screen.height

    readonly property bool verticalParallaxMode: Mem.options.desktop.bg.parallax.verticalParallax
    readonly property real parallaxFactor: {
        const firstId = workspaceList[0]?.id || 1;
        const lastId = workspaceList[workspaceList.length - 1]?.id || Mem.options.bar.workspaces.shown;
        const range = lastId - firstId;
        const offset = range > 0 ? ((currentWorkspace - firstId) / range) : 0.5;
        return Math.max(0, Math.min(1, offset));
    }

    function calculateWidgetMargin() {
        if (!Mem.options.desktop.bg.parallax.widgetParallax || !enableParallax)
            return 0;
        const directionOffset = Mem.options.bar.behavior.position === "left" ? -1 : 1;
        return directionOffset * Mem.options.desktop.bg.parallax.parallaxStrength * GlobalStates.main.sidebar.sidebarWidth;
    }

    readonly property real bgParallaxX: verticalParallaxMode ? calculateWidgetMargin() : -effectiveMovableXSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableXSpace
    readonly property real bgParallaxY: verticalParallaxMode ? -effectiveMovableYSpace - (parallaxFactor - 0.5) * 2 * effectiveMovableYSpace : 0

    Component.onCompleted: bgLayer.load(wallpaper)

    onWallpaperChanged: {
        bgLayer.load(wallpaper);
    }

    anchors.fill: parent

    StyledLoader {
        fade: true
        shown: NameFilters.video.some(format => wallpaper.endsWith(format.substring(1)))
        anchors.fill: parent
        sourceComponent: VidLayer {}
    }

    BgLayer {
        id: bgLayer
        z: 0
        anchors.fill: parent
        enableParallax: root.enableParallax
        effectiveWallpaperScale: root.effectiveWallpaperScale
        effectiveMovableXSpace: root.effectiveMovableXSpace
        effectiveMovableYSpace: root.effectiveMovableYSpace
        bgParallaxX: root.bgParallaxX
        bgParallaxY: root.bgParallaxY
    }

    Loader {
        id: layerClock
        active: fgLoader.item && fgLoader.item.status === Image.Ready && root.enableDepthMode
        sourceComponent: LayerClock {}
        asynchronous: true
    }

    StyledLoader {
        id: fgLoader
        anchors.fill: parent
        visible: active
        fade: true
        asynchronous: true
        active: WallpaperService.fgReady && root.enableDepthMode
        sourceComponent: FgLayer {}
    }
}
