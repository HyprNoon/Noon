import QtQuick
import qs.common
import qs.common.widgets

RedunduntMultiViewPanel {
    id: root
    path: Qt.resolvedUrl("./")

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss
    property bool expanded
    property string searchQuery: ""
    lazy: false
    onExpandedChanged: console.log("Root.expanded: ", expanded)
    tabButtonList: [
        {
            "icon": "window",
            "name": "Group",
            "component": "AppsGrid",
            "preloadTable": {
                "searchQuery": searchQuery,
                "expanded": expanded
            }
        },
        {
            "icon": "list",
            "name": "All",
            "component": "AppsList",
            "preloadTable": {
                "searchQuery": searchQuery,
                "expanded": expanded
            }
        }
    ]
    Connections {
        target: item
        function onSearchFocusRequested() {
            root.searchFocusRequested();
        }
        function onDismiss() {
            root.dismiss();
        }
    }
    onSelectedTabIndexChanged: {
        if (item && selectedTabIndex > -1)
            item.contentFocusRequested();
    }
    onContentFocusRequested: {
        item.contentFocusRequested();
    }
}
