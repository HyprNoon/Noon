pragma Singleton
pragma ComponentBehavior: Bound
import qs.common.utils
import qs.store

Singleton {
    id: root

    property bool ready: colorsView.loaded && optionsView.loaded && statesView.loaded
    property alias states: statesView.data
    property alias options: optionsView.data
    property alias timers: timersView.data
    property alias todo: todoView.data
    property alias store: storeView.data
    property alias colors: colorsView.data

    ConfigFileView {
        id: optionsView

        state: false
        fileName: "options"
        OptionsSchema {}
    }

    ConfigFileView {
        id: todoView

        fileName: "todo"
        TodoSchema {}
    }

    ConfigFileView {
        id: statesView

        fileName: "states"
        StatesSchema {}
    }

    ConfigFileView {
        id: timersView

        fileName: "timers"
        TimersSchema {}
    }

    ConfigFileView {
        id: colorsView

        fileName: "colors"
        ColorsSchema {}
    }

    ConfigFileView {
        id: storeView

        watchChanges: false
        fileName: "store"
        StoreSchema {}
    }
}
