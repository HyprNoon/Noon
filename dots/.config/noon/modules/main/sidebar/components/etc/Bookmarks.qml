import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    property string searchQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    clip: true
    color: Colors.colLayer1
    radius: Rounding.verylarge

    onContentFocusRequested: {
        if (listView.count > 0) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    ScriptModel {
        id: filteredBookmarks

        values: {
            const data = BookmarksService.bookmarks;
            const query = root.searchQuery.toLowerCase();
            if (!query)
                return data;
            return data.filter(item => (item.title && item.title.toLowerCase().includes(query)) || (item.url && item.url.toLowerCase().includes(query)));
        }
    }

    ScrollEdgeFade {
        target: listView
        anchors.fill: parent
    }

    StyledListView {
        id: listView
        hint: false
        anchors.fill: parent
        anchors.margins: Padding.large
        model: filteredBookmarks
        spacing: Padding.small
        currentIndex: -1

        delegate: StyledDelegateItem {
            required property var modelData
            required property int index
            readonly property bool alternateStripes: Mem.options.sidebar.appearance.alternateListStripes
            colBackground: alternateStripes && (index % 2 === 0) ? "transparent" : Colors.colLayer2
            width: listView.width
            title: modelData.title
            subtext: modelData.url
            iconSource: FaviconService.get(modelData.url)
            toggled: listView.currentIndex === index
            shape: MaterialShape.Shape.Clover4Leaf
            releaseAction: () => {
                BookmarksService.openUrl(modelData.url);
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
                    BookmarksService.openUrl(filteredBookmarks.values[currentIndex].url);
                    root.dismiss();
                }
            } else {
                return;
            }
            event.accepted = true;
        }
    }
}
