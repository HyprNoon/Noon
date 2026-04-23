import "components/plugins"
import "components/apps"
import "components/downloads"
import "components/notes"
import "components/timers"
import "components/apis"
import "components/beats"
import "components/sounds"
import "components/etc"
import "components/notifs"
import "components/settings"
import "components/shelf"
import "components/tasks"
import "components/view"
import "components/wallpapers"
import "components/widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell
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
        if (mainLoader._item && mainLoader._item.searchInput && effectiveSearchable)
            mainLoader._item.searchInput.forceActiveFocus();
    }
    function dismiss() {
        panelWindow.hide();
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

    function incubateContent(cat) {
        panelWindow.incubate(cat);
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
    // Connections {
    //     function onTransferRequest() {
    //         if (selectedCategory !== "Share")
    //             changeContent("Share");
    //     }
    //     target: QuickShareService
    // }

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
        spacing: Padding.normal

        SidebarNavigationRail {
            content: root
            selectedCategory: root.selectedCategory
            colors: root?.colors
            radius: panelWindow.appearanceMode > 0 ? panelWindow.rounding : 0
        }

        StyledLoader {
            id: mainLoader

            asynchronous: SidebarData.isAsync(root.selectedCategory)

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: root.auxVisible ? SidebarData.currentSize(false, false, root.selectedCategory) : Sizes.infinity

            sourceComponent: SidebarData.detachedContent.includes(root.selectedCategory) ? placeholder : content

            property Component content: ContentChild {
                colors: root?.colors
                category: root?.selectedCategory
            }
            property Component placeholder: PagePlaceholder {
                colors: root.colors
                shape: SidebarData.getShape(root.selectedCategory)
                icon: SidebarData.getIcon(root.selectedCategory)
                iconSize: 80
                title: "This Content is Detached"
                description: "close it so u can access it here"
            }
        }

        VerticalSeparator {
            visible: root.auxVisible
        }

        StyledLoader {
            id: auxLoader
            asynchronous: true
            visible: active
            active: root.auxVisible
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: SidebarData.currentSize(false, false, root.auxCategory)

            sourceComponent: ContentChild {
                _aux: true
                category: auxCategory
            }
        }
    }
}
