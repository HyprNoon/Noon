import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

StyledRect {
    id: root
    color: Colors.colLayer1
    radius: Rounding.verylarge
    property string searchQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    onContentFocusRequested: {
        if (listView.count > 0) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    ScriptModel {
        id: filteredBookmarks
        values: {
            const data = FirefoxBookmarksService.bookmarks;
            const query = root.searchQuery.toLowerCase();
            if (!query)
                return data;

            return data.filter(item => (item.title && item.title.toLowerCase().includes(query)) || (item.url && item.url.toLowerCase().includes(query)));
        }
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        model: filteredBookmarks
        spacing: Padding.small
        currentIndex: -1

        delegate: StyledDelegateItem {
            width: listView.width
            required property var modelData
            required property int index

            title: modelData.title
            subtext: modelData.url
            iconSource: modelData.favicon_local
            toggled: listView.currentIndex === index
            shape: MaterialShape.Shape.Clover4Leaf

            releaseAction: () => {
                FirefoxBookmarksService.openUrl(modelData.url);
                NoonUtils.playSound("event_accepted");
                root.dismiss();
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up && currentIndex <= 0) {
                currentIndex = -1;
                root.searchFocusRequested();
            } else if (event.key === Qt.Key_Down && currentIndex < count - 1) {
                currentIndex++;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    FirefoxBookmarksService.openUrl(filteredBookmarks.values[currentIndex].url);
                    root.dismiss();
                }
            } else
                return;
            event.accepted = true;
        }
    }
}
