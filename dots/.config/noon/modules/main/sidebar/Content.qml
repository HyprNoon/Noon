import QtQuick
import QtQuick.Layouts
import Quickshell
import "components/apis"
import "components/beats"
import "components/games"
import "components/misc"
import "components/notes"
import "components/notifs"
import "components/polkit"
import "components/session"
import "components/settings"
import "components/shelf"
import "components/tasks"
import "components/view"
import "components/wallpapers"
import "components/web"
import "components/lock"
import "components/widgets"
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: root

    required property var panelWindow
    readonly property bool effectiveSearchable: SidebarData.isSearchable(selectedCategory) ?? false
    property QtObject colors: SidebarData.getColors(selectedCategory) || Colors
    property bool auxVisible: false
    property string selectedCategory: ""
    property string auxCategory: ""
    property string auxSearchText: ""

    function focusMainSearchInput() {
        if (main_child && main_child.searchInput && effectiveSearchable)
            main_child.searchInput.forceActiveFocus();
    }

    function changeContent(newCategoryKey) {
        if (!newCategoryKey || !SidebarData.enabledCategories.includes(newCategoryKey) && !SidebarData.isStealth(newCategoryKey))
            return;

        if (selectedCategory === newCategoryKey) {
            panelWindow.hide();
            return;
        }
        if (!panelWindow.show)
            panelWindow.hoverMode = false;

        selectedCategory = newCategoryKey;
    }

    function toggleAux(categoryKey) {
        const enabled = SidebarData.enabledCategories.includes(categoryKey);
        if (!categoryKey || !enabled || categoryKey === "")
            return;

        if (auxVisible && auxCategory === categoryKey) {
            closeAux();
            return;
        }
        openAux(categoryKey);
    }

    function openAux(cat) {
        auxSearchText = "";
        auxCategory = cat;
        auxVisible = true;
    }

    function closeAux() {
        auxVisible = false;
        auxCategory = "";
        auxSearchText = "";
    }

    anchors.fill: parent
    anchors.margins: Padding.large
    clip: true
    focus: true
    onAuxCategoryChanged: toggleAux()
    onEffectiveSearchableChanged: effectiveSearchable ? focusMainSearchInput() : null

    Keys.onPressed: event => {
        const {
            key,
            modifiers: mods
        } = event;
        const isCtrl = mods === Qt.ControlModifier;
        const isShift = mods === Qt.ShiftModifier || mods === (Qt.ControlModifier | Qt.ShiftModifier);

        // Single-key actions
        if (key === Qt.Key_Slash)
            return focusMainSearchInput(), event.accepted = true;
        if (key === Qt.Key_Escape)
            return dismiss(), event.accepted = true;
        if (key === Qt.Key_Tab || key === Qt.Key_Backtab) {
            const target = SidebarData[isShift ? "getPreviousEnabledCategory" : "getNextEnabledCategory"](selectedCategory);
            return target && changeContent(target), event.accepted = true;
        }

        // Modifier actions (Ctrl + Key)
        const ctrlMap = {
            [Qt.Key_O]: () => SidebarData.isExpandable(selectedCategory) && !auxVisible && (panelWindow.expanded = !panelWindow.expanded),
            [Qt.Key_P]: () => panelWindow.pinned = !panelWindow.pinned,
            [Qt.Key_Q]: () => Qt.callLater(closeAux),
            [Qt.Key_R]: () => selectedCategory === "History" && ClipboardService.wipe()
        };

        if (isCtrl && ctrlMap[key])
            return ctrlMap[key](), event.accepted = true;
    }
    Connections {
        function onTransferRequest() {
            if (selectedCategory !== "Share")
                changeContent("Share");
        }
        target: QuickShareService
    }

    Connections {
        function onFlowChanged() {
            if (PolkitService.flow)
                changeContent("Auth");
            else
                root.panelWindow.hide();
        }

        target: PolkitService
    }

    RowLayout {
        anchors.fill: parent
        layoutDirection: !panelWindow.rightMode ? Qt.LeftToRight : Qt.RightToLeft
        spacing: Padding.large

        SidebarNavigationRail {
            selectedCategory: root.selectedCategory
            colors: root.colors
        }

        ContentChild {
            id: main_child

            Layout.maximumWidth: root.auxVisible ? SidebarData.currentSize(false, false, category) : Sizes.infinity
            _aux: false
            category: root.selectedCategory
        }

        VerticalSeparator {
            visible: root.auxVisible
        }

        Loader {
            id: aux_loader
            asynchronous: true
            visible: active
            active: root.auxVisible
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: SidebarData.currentSize(false, false, root.selectedCategory)

            sourceComponent: ContentChild {
                anchors.fill: parent
                _aux: true
                category: auxCategory
            }

            onLoaded: if (item && ("category" in item)) {
                item.category = Qt.binding(() => {
                    return root.auxCategory;
                });
            }
        }
    }
}
