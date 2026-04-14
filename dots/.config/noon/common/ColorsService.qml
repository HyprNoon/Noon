pragma Singleton
pragma ComponentBehavior: Bound
import qs.store
import qs.services
import qs.common.utils

Singleton {
    id: root

    readonly property alias colors: colorsView.data

    ConfigFileView {
        id: colorsView

        path: Mem.options.appearance.colors?.palattePath
        ColorsSchema {}
        onPathChanged: {
            Qt.callLater(() => {
                WallpaperService.changeAccentColor(Colors?.m3.m3primaryContainer);
            });
        }
    }
}
