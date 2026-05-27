pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import qs.store
import qs.common
import qs.services
import qs.common.utils
import qs.common.functions

Singleton {
    id: root

    readonly property alias colors: colorsView.data
    readonly property bool isDynamic: FileUtils.getEscapedFileNameWithoutExtension(palettePath) === "colors"
    readonly property string dynamicPath: Directories.standard.state + "/user/generated/colors.json"
    readonly property string palettePath: Mem.options.appearance.colors?.palattePath

    Timer {
        id: regenTimer
        interval: 400
        onTriggered: {
            if (!root.isDynamic)
                WallpaperService.changeAccentColor(colorsView.data.m3primary);
        }
    }

    ConfigFileView {
        id: colorsView
        path: palettePath
        ColorsSchema {}
        onPathChanged: regenTimer.restart()
    }
}
