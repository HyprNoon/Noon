pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services

Singleton {
    id: root

    property int sidebarWidth
    property var detachedContent: []
    readonly property QtObject sizePresets: Sizes.sidebar
    property var enabledCategories: ({})
    property var registry: ({})
    readonly property var shellReg: {
        "Apps": {
            icon: "rocket",
            activeIcon: "rocket_launch",
            shell: "main",
            componentPath: "apps/Apps",
            expandable: true,
            searchable: true,
            expandSize: sizePresets.half,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.apps
        },
        "API": {
            icon: "cognition",
            activeIcon: "cognition_2",
            componentPath: "apis/Apis",
            expandable: true,
            incubatable: true,
            detachable: true,
            shape: "PixelCircle",
            enabled: Mem.options.sidebar.content.apis
        },
        "Notifs": {
            icon: "notifications",
            activeIcon: "notifications_active",
            shell: "main",
            componentPath: "notifs/Notifs",
            expandSize: sizePresets.quarter,
            enabled: Mem.options.sidebar.content.notifs
        },
        "Walls": {
            icon: "gallery_thumbnail",
            activeIcon: "image",
            componentPath: "wallpapers/WallpaperSelector",
            async: true,
            searchable: true,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.wallpapers
        },
        "Tasks": {
            icon: "task_alt",
            activeIcon: "add_task",
            componentPath: "tasks/Todo",
            searchable: true,
            shape: "Clover8Leaf",
            enabled: true
        },
        "Notes": {
            icon: "stylus",
            activeIcon: "stylus_note",
            componentPath: "notes/Notes",
            expandable: true,
            incubatable: true,
            detachable: true,
            shape: "Slanted",
            enabled: Mem.options.sidebar.content.notes
        },
        "View": {
            icon: "workspaces",
            incubatable: true,
            componentPath: "view/Overview",
            expandable: true,
            preExpand: true,
            baseSize: sizePresets.overview,
            expandSize: sizePresets.overviewExpanded,
            enabled: Mem.options.sidebar.content.overview
        },
        "Downloads": {
            icon: "download",
            incubatable: true,
            activeIcon: "view_cozy",
            componentPath: "downloads/DownloadManager",
            enabled: true
        },
        "Beats": {
            icon: "music_note",
            activeIcon: "music_note_add",
            shell: "main",
            componentPath: "beats/Beats",
            expandable: true,
            incubatable: true,
            detachable: true,
            shape: "Bun",
            enabled: Mem.options.sidebar.content.beats,
            colors: BeatsService.colors
        },
        "History": {
            icon: "content_paste",
            activeIcon: "inventory",
            shell: "main",
            componentPath: "etc/History",
            searchable: true,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.history
        },
        "Bookmarks": {
            icon: "bookmark",
            activeIcon: "bookmark_heart",
            componentPath: "etc/Bookmarks",
            searchable: true,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.bookmarks
        },
        "Emojis": {
            icon: "sentiment_calm",
            componentPath: "etc/Emojis",
            searchable: true,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.emojis
        },
        "Shelf": {
            icon: "shelves",
            activeIcon: "book_ribbon",
            incubatable: true,
            componentPath: "shelf/Shelf",
            enabled: Mem.options.sidebar.content.shelf
        },
        "Widgets": {
            icon: "ripples",
            expandable: true,
            baseSize: sizePresets.largerQuarter,
            expandSize: sizePresets.half,
            componentPath: "widgets/Widgets",
            enabled: Mem.options.sidebar.content.widgets
        },
        "Sounds": {
            icon: "graphic_eq",
            componentPath: "sounds/Sounds",
            detachable: true,
            shape: "Gem",
            enabled: Mem.options.sidebar.content.sounds
        },
        "Timers": {
            icon: "timer",
            componentPath: "timers/Timers",
            detachable: true,
            incubatable: true,
            shape: "Cookie4Sided",
            enabled: Mem.options.sidebar.content.timers
        },
        "Tweaks": {
            icon: "settings",
            activeIcon: "settings_heart",
            shell: "main",
            componentPath: "settings/Tweaks",
            searchable: true,
            shape: "Ghostish",
            enabled: Mem.options.sidebar.content.tweaks
        },
        "Session": {
            icon: "power_settings_new",
            componentPath: "etc/Session",
            baseSize: sizePresets.session,
            enabled: Mem.options.sidebar.content.session
        },
        "Plugins": {
            icon: "extension",
            componentPath: "plugins/Plugins",
            shape: "PixelTriangle"
        },
        "DMenu": {
            icon: "dashboard",
            componentPath: "etc/DMenu",
            searchable: true,
            stealth: true
        },
        "Bars": {
            componentPath: "etc/BarSwitcher",
            shape: "Ghostish",
            searchable: true,
            shell: "main",
            stealth: true
        },
        "Auth": {
            componentPath: "etc/Polkit",
            stealth: true
        }
    }
    function _get(id) {
        return registry[id];
    }
    function rebuildAll() {
        registry = rebuildRegistry();
        enabledCategories = getEnabledCategories();
    }
    onShellRegChanged: rebuildAll()
    Component.onCompleted: rebuildAll()

    function getEnabledCategories() {
        return Object.keys(registry).filter(key => {
            const item = registry[key];
            const isEnabled = item.enabled ?? true;
            const isNotStealth = !item.stealth;
            const matchesShell = item.shell === undefined || item.shell === Mem.options.desktop.shell.mode;

            return isEnabled && isNotStealth && matchesShell;
        });
    }

    function rebuildRegistry() {
        return Object.assign({}, shellReg, PluginsManager.sidebarPlugins);
    }

    function getColors(id) {
        return _get(id)?.colors ?? Colors;
    }
    function getCategory(id) {
        return _get(id);
    }
    function getShape(id) {
        return MaterialShape.Shape[_get(id)?.shape || ""];
    }
    function getIcon(id, active = false) {
        if (active && _get(id)?.activeIcon)
            return _get(id)?.activeIcon;
        else
            return _get(id)?.icon;
    }
    function getComponentPath(id) {
        const c = _get(id);
        if (!c)
            return "";
        return c.isPlugin ? c.entry : "components/" + c.componentPath + ".qml";
    }
    function getPreloadData(id) {
        return _get(id)?.preloadData ?? "";
    }

    function isSearchable(id) {
        return !!_get(id)?.searchable;
    }
    function isIncubatable(id) {
        return !!_get(id)?.incubatable;
    }
    function isDetachable(id) {
        return !!_get(id)?.detachable;
    }
    function isAsync(id) {
        return !!_get(id)?.async;
    }
    function isExpandable(id) {
        return !!_get(id)?.expandable;
    }
    function usePreExpand(id) {
        return !!_get(id)?.preExpand;
    }
    function isStealth(id) {
        return !!_get(id)?.stealth;
    }
    function isDetached(id) {
        return SidebarData.detachedContent.includes(id);
    }
    function currentSize(barMode, expanded, id) {
        const content = registry[id];
        if (barMode || !content)
            return sizePresets.bar;
        if (expanded && content.expandable)
            return content.expandSize ?? sizePresets.half;
        else
            return content?.baseSize ?? sizePresets.quarter;
    }

    function _navigate(id, step) {
        const v = enabledCategories;
        const i = v.indexOf(id);
        return i > 0 ? v[(i + step + v.length) % v.length] : v[0];
    }

    function getCategoryDirection(oldCat, newCat) {
        return enabledCategories.indexOf(newCat) > enabledCategories.indexOf(oldCat) ? -1 : 1;
    }

    function getNextEnabledCategory(id) {
        return _navigate(id, 1);
    }
    function getPreviousEnabledCategory(id) {
        return _navigate(id, -1);
    }
}
