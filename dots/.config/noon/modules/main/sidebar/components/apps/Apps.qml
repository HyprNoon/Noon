import QtQuick
import qs.common
import qs.common.widgets

RedunduntMultiViewPanel {
    id: root
    path: Qt.resolvedUrl("./")

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss
    property string searchQuery: ""
    lazy: false
    tabButtonList: [
        {
            "icon": "window",
            "name": "Group",
            "component": "AppsGrid",
            "preload": "searchQuery",
            "preloadData": searchQuery
        },
        {
            "icon": "list",
            "name": "All",
            "component": "AppsList",
            "preload": "searchQuery",
            "preloadData": searchQuery
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
