import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store
import "components/web"

Item {
    id: panel
    visible: category.length > 0
    anchors.fill: parent
    anchors.margins: Padding.huge

    required property string category
    readonly property bool effectiveSearchable: SidebarData.isSearchable(category)

    property string previousCategory: ""
    property bool _aux: false
    property alias contentOpacity: contentLoader.opacity
    property alias searchInput: searchBar.searchInput
    property real contentYOffset: 0

    property var parentRoot: GlobalStates.main.sidebar
    readonly property QtObject colors: parentRoot.colors || Colors
    readonly property var contentItem: contentLoader._item

    signal contentFocusRequested
    signal searchFocusRequested

    function getCategoryDirection(oldCat, newCat) {
        if (!oldCat || !newCat || oldCat === newCat)
            return 1;

        const categories = SidebarData.enabledCategories || [];
        const oldIndex = categories.indexOf(oldCat);
        const newIndex = categories.indexOf(newCat);

        if (oldIndex !== -1 && newIndex !== -1)
            return newIndex > oldIndex ? -1 : 1;

        return 1;
    }

    onCategoryChanged: {
        if (category) {
            const direction = getCategoryDirection(previousCategory, category);
            contentYOffset = direction * 100;
            contentOpacity = 0;
            resetAnimation.restart();
        }
        previousCategory = category;
    }

    ColumnLayout {
        spacing: Padding.large
        clip: true
        anchors.fill: parent

        ParallelAnimation {
            id: resetAnimation
            Anim {
                target: panel
                property: "contentYOffset"
                to: 0
            }
            Anim {
                target: panel
                property: "contentOpacity"
                to: 1
            }
        }

        Loader {
            id: web_loader
            visible: active && selectedCategory === "Web"
            active: Mem.options.sidebar.content.web
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            sourceComponent: WebBrowser {}
        }

        Binding {
            target: GlobalStates
            property: "web_session"
            value: web_loader.item && web_loader.item !== null ? web_loader.item.web_view : null
            when: Mem.options.sidebar.content.web && web_loader.item !== null
        }

        StyledLoader {
            id: contentLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            opacity: contentOpacity
            focus: active
            visible: active
            active: selectedCategory !== "Web"
            source: SidebarData.getComponentPath(category)
            onLoaded: if (item) {
                if ("searchQuery" in item)
                    item.searchQuery = Qt.binding(() => searchBar.searchText);

                if ("expanded" in item && !_aux)
                    item.expanded = Qt.binding(() => parentRoot.expanded);

                if ("panelWindow" in item)
                    item.panelWindow = Qt.binding(() => parentRoot);

                if (item.searchFocusRequested) {
                    item.searchFocusRequested.connect(() => {
                        if (!_aux && searchBar.searchInput && panel.effectiveSearchable)
                            searchBar.searchInput.forceActiveFocus();
                    });
                }

                if (item.dismiss) {
                    item.dismiss.connect(parentRoot.hide);
                }
            }

            transform: Translate {
                y: contentYOffset
            }
        }

        SearchBar {
            id: searchBar
            root: panel
            onContentFocusRequested: if (panel.contentItem && "contentFocusRequested" in panel.contentItem)
                panel.contentItem.contentFocusRequested()
        }
    }
    Behavior on Layout.preferredWidth {
        Anim {}
    }
}
