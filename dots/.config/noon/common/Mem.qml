pragma Singleton
pragma ComponentBehavior: Bound
import qs.common.utils
import qs.store

Singleton {
    id: root

    readonly property bool ready: optionsView.loaded && statesView.loaded
    readonly property alias states: statesView.data
    readonly property alias options: optionsView.data
    readonly property alias store: storeView.data

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
}
