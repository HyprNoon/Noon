pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Noon.Utils
import Noon.Hypr
import qs.common.utils
import qs.store

Singleton {
    id: root

    readonly property bool ready: optionsView.loaded && statesView.loaded
    readonly property alias states: statesView.data
    readonly property alias options: optionsView.data
    readonly property alias store: storeView.data
    readonly property alias looks: looksView.data
    readonly property alias ai: aiView.data
    readonly property alias todo: todoView.data

    readonly property alias hypr: hyprView.variables
    readonly property alias env: envView.data

    ConfigFileView {
        id: optionsView

        state: false
        fileName: "options"
        OptionsSchema {}
    }

    ConfigFileView {
        id: statesView

        fileName: "states"
        StatesSchema {}
    }

    ConfigFileView {
        id: storeView

        watchChanges: false
        fileName: "store"
        StoreSchema {}
    }

    ConfigFileView {
        id: looksView
        fileName: "looks"
        LooksSchema {}
    }

    ConfigFileView {
        id: aiView
        parentDir: "user/generated/"
        fileName: "ai"
        AiSchema {}
    }

    ConfigFileView {
        id: todoView
        parentDir: "user/generated/"
        fileName: "todo"
        TodoSchema {}
    }

    EnvManager {
        id: envView
        path: Directories.standard.home + "/.env"
    }

    HyprParser {
        id: hyprView
        path: Directories.hyprConfigs + "/lua/variables.lua"
    }
}
