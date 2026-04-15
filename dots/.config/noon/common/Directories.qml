pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Qt.labs.platform
import qs.common.functions

Singleton {
    id: root

    // misc directories
    readonly property string venv: FileUtils.trimFileProtocol(standard.state + "/.venv")
    readonly property string records: FileUtils.trimFileProtocol(standard.videos + "/records")
    readonly property string sounds: FileUtils.trimFileProtocol(assets + "/sounds/")
    readonly property string store: FileUtils.trimFileProtocol(standard.config + "/noon/store")
    readonly property string assets: FileUtils.trimFileProtocol(standard.config + "/noon/assets")
    readonly property string gallery: FileUtils.trimFileProtocol(standard.pictures + "/Gallary/")
    readonly property string shellConfigs: FileUtils.trimFileProtocol(standard.config + "/HyprNoon/")
    readonly property string shellDir: FileUtils.trimFileProtocol(standard.config + "/noon")
    readonly property string scriptsDir: shellDir + "/scripts"
    readonly property string favicons: FileUtils.trimFileProtocol(standard.cache + "/media/favicons")
    readonly property string hyprConfigs: FileUtils.trimFileProtocol(shellDir + "/hypr")
    // standard directories
    readonly property QtObject standard: QtObject {
        readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
        readonly property string state: home + "/.local/state/noon"
        readonly property string cache: home + "/.cache/noon"
        readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
        readonly property string music: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        readonly property string documents: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
        readonly property string videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
    }

    // services directories
    readonly property QtObject services: QtObject {
        readonly property string notifications: FileUtils.trimFileProtocol(standard.cache + "/notifications/notifications.json")
        readonly property string latex: FileUtils.trimFileProtocol(standard.cache + "/media/latex")
        readonly property string aiChats: FileUtils.trimFileProtocol(standard.state + "/user/generated/ai")
        readonly property string m3path: FileUtils.trimFileProtocol(standard.state + "/user/generated/colors.json")
        readonly property string gamesCoverArts: FileUtils.trimFileProtocol(standard.state + "/user/generated/gamesCoverArts")
        readonly property string screenshots: FileUtils.trimFileProtocol(standard.pictures + "/Screenshots")
    }

    // wallpapers directories
    readonly property QtObject wallpapers: QtObject {
        readonly property string switchScript: FileUtils.trimFileProtocol(root.scriptsDir + "/appearance_service.py")
        readonly property string thumbScript: FileUtils.trimFileProtocol(root.scriptsDir + "/thumbnails_service.py")
        readonly property string main: FileUtils.trimFileProtocol(standard.pictures + "/Wallpapers/")
        readonly property string depthDir: FileUtils.trimFileProtocol(standard.cache + "/user/generated/depth/")
        readonly property string gowallDir: FileUtils.trimFileProtocol(standard.cache + "/user/generated/gowall/")
        readonly property string favorite: FileUtils.trimFileProtocol(standard.pictures + "/favourite")
    }

    // beats directories
    readonly property QtObject beats: QtObject {
        readonly property string main: FileUtils.trimFileProtocol(standard.cache + "/beats")
        readonly property string downloads: FileUtils.trimFileProtocol(standard.home + "/Music")
        readonly property string coverArt: FileUtils.trimFileProtocol(main + "/coverart")
        readonly property string lyrics: FileUtils.trimFileProtocol(main + "/lyrics")
        readonly property string tracks: FileUtils.trimFileProtocol(standard.music)
    }

    // plugins
    readonly property QtObject plugins: QtObject {
        readonly property string main: FileUtils.trimFileProtocol(standard.home + "/.noon_plugins")
        readonly property string sidebar: main + "/sidebar"
        readonly property string palettes: main + "/palettes"
    }

    Component.onCompleted: {
        FileUtils.mkdir([
            // standard
            standard.state, standard.cache,
            // misc
            venv, assets, records, gallery, sounds, scriptsDir, shellConfigs, favicons,
            // services
            services.notifications, services.latex, services.aiChats, services.gamesCoverArts, services.screenshots,
            // wallpapers
            wallpapers.main, wallpapers.switchScript, wallpapers.depthDir, wallpapers.gowallDir, wallpapers.favorite,
            // beats
            beats.main, beats.coverArt, beats.lyrics, beats.tracks,
            // plugins
            plugins.main, plugins.palettes, plugins.sidebar]);
    }
}
