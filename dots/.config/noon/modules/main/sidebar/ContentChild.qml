import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: panel
    visible: category.length > 0
    anchors.fill: parent
    anchors.margins: Padding.huge

    required property string category
    required property QtObject colors
    readonly property bool effectiveSearchable: SidebarData.isSearchable(category)
    property string previousCategory: ""
    property bool _detached: false
    property bool _expanded: parentRoot?.expanded
    property bool _aux: false
    property alias searchInput: searchBar.searchInput

    property var parentRoot: GlobalStates.main.sidebar
    readonly property var contentItem: contentStack.currentItem

    signal contentFocusRequested
    signal searchFocusRequested

    onCategoryChanged: {
        if (!category) {
            contentStack.clear();
            previousCategory = category;
            return;
        }
        contentStack.slideDirection = SidebarData.getCategoryDirection(previousCategory, category);
        contentStack.replace(null, SidebarData.getComponentPath(category));
        previousCategory = category;
    }

    ColumnLayout {
        spacing: Padding.large
        clip: true
        anchors.fill: parent

        StyledStackView {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            slideDirection: 1

            onCurrentItemChanged: {
                const item = currentItem;
                const b = b => Qt.binding(() => b);
                if (!item)
                    return;
                // if ("preloadData" in item)
                //     item.preloadData = Qt.binding(() => SidebarData.getPreloadData(panel.category));
                if ("web_view" in item)
                    GlobalStates.web_session = Qt.binding(() => item.web_view);
                if ("searchQuery" in item)
                    item.searchQuery = Qt.binding(() => searchBar.searchText);
                if ("detached" in item)
                    item.detached = Qt.binding(() => _detached);
                if ("expanded" in item && !_aux)
                    item.expanded = Qt.binding(() => _expanded);
                if ("panelWindow" in item)
                    item.panelWindow = Qt.binding(() => parentRoot);

                if (item.searchFocusRequested)
                    item.searchFocusRequested.connect(() => {
                        if (!_aux && searchBar.searchInput && panel.effectiveSearchable)
                            searchBar.searchInput.forceActiveFocus();
                    });

                if (item.dismiss)
                    item.dismiss.connect(parentRoot.hide);
            }
        }

        SearchBar {
            id: searchBar
            root: panel
            colors: panel.colors
            contentY: contentStack.y
            onContentFocusRequested: {
                if (panel.contentItem && "contentFocusRequested" in panel.contentItem)
                    panel.contentItem.contentFocusRequested();
            }
        }
    }
}
