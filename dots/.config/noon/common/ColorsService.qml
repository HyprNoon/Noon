pragma Singleton
pragma ComponentBehavior: Bound
import qs.common.utils
import qs.store
import qs.services

Singleton {
    id: root

    readonly property alias colors: colorsView.data

    readonly property string currentFilePath: {
        const current = Mem?.options?.appearance?.colors?.palatteName ?? "auto";
        const m3 = Directories?.standard.state + "/colors.json";
        const palettesDir = Qt.resolvedUrl(Directories.store);
        if (current === "auto")
            return m3;
        else
            return palettesDir + "/colorPresets/" + current + ".json";
    }

    ConfigFileView {
        id: colorsView

        path: currentFilePath
        ColorsSchema {}
        onPathChanged: {
            if (!root.currentFilePath?.includes("colors.json")) {
                Qt.callLater(() => {
                    WallpaperService.changeAccentColor(Colors?.m3.m3primaryContainer);
                });
            }
        }
    }
}
