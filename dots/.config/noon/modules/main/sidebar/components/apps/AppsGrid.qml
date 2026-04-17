import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true
    readonly property alias gridView: contentView
    property string searchQuery: ""
    signal dismiss
    signal searchFocusRequested
    signal contentFocusRequested
    onContentFocusRequested: {
        contentView.forceActiveFocus();
        contentView.currentIndex = 0;
    }
    ScriptModel {
        id: filteredModel
        values: {
            const query = root.searchQuery.toLowerCase().trim();
            const groups = {};
            const others = new Set();

            DesktopEntries.applications.values.forEach(app => {
                if (query && !app.name.toLowerCase().includes(query))
                    return;
                const cats = app.categories?.length ? app.categories : ["Other"];
                cats.forEach(c => (groups[c] = groups[c] || []).push(app));
            });

            const result = Object.keys(groups).filter(k => {
                if (k !== "Other" && groups[k].length >= 3)
                    return true;
                groups[k].forEach(item => others.add(item));
                return false;
            }).sort().map(k => ({
                        category: k,
                        items: groups[k]
                    }));

            if (others.size > 0)
                result.push({
                    category: "Other",
                    items: Array.from(others)
                });
            return result;
        }
    }

    function openCategory(items, visualItem, title) {
        let coords = visualItem.mapToItem(root, 0, 0);
        popup.startX = coords.x;
        popup.startY = coords.y;
        popup.startW = visualItem.width;
        popup.startH = visualItem.height;

        popup.categoryTitle = title;
        popup.appsData = items;
        popup.active = true;
        Qt.callLater(() => {
            popup.forceActiveFocus();
        });
    }
    ScrollEdgeFade {
        target: contentView
        anchors.margins: -Padding.huge
    }
    StyledGridView {
        id: contentView
        focus: true
        currentIndex: -1
        anchors.fill: parent
        anchors.margins: Padding.huge
        model: filteredModel
        cellWidth: 181
        cellHeight: 200
        opacity: popup.active ? 0 : 1
        Behavior on opacity {
            Anim {}
        }

        delegate: Item {
            required property int index
            required property var modelData
            readonly property bool isSelected: index === contentView.currentIndex
            width: contentView.cellWidth
            height: contentView.cellHeight

            StyledRect {
                id: groupTile
                anchors.fill: parent
                anchors.margins: Padding.normal
                anchors.bottomMargin: 40
                color: isSelected ? Colors.colSecondaryContainer : Colors.colLayer2
                radius: Rounding.large

                MouseArea {
                    anchors.fill: parent
                    onClicked: openCategory(modelData.items, groupTile, modelData.category)
                }

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: Padding.large
                    columns: 2
                    rows: 2
                    Repeater {
                        model: modelData.items.slice(0, 4)
                        StyledIconImage {
                            implicitSize: 60
                            _source: modelData.icon
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    modelData.execute();
                                    root.dismiss();
                                }
                            }
                        }
                    }
                }
            }

            StyledText {
                text: modelData.category
                anchors.top: groupTile.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: Padding.small
            }
        }

        Keys.onPressed: event => {
            // Dynamically calculate columns based on width and cellWidth
            const cols = Math.floor(contentView.width / contentView.cellWidth);
            const lastIndex = contentView.count - 1;

            if (event.key === Qt.Key_Up) {
                if (currentIndex < cols) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex -= cols;
                }
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex + cols <= lastIndex) {
                    currentIndex += cols;
                }
            } else if (event.key === Qt.Key_Left) {
                if (currentIndex % cols !== 0) {
                    currentIndex--;
                }
            } else if (event.key === Qt.Key_Right) {
                if (currentIndex < lastIndex && (currentIndex + 1) % cols !== 0) {
                    currentIndex++;
                }
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    const data = model.values[currentIndex];
                    openCategory(data.items, root, data.category);
                }
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    AppPopupGroupList {
        id: popup
    }

    PagePlaceholder {
        shown: contentView.count === 0 && !popup.active
        icon: "search"
        title: "No results for '" + root.searchQuery + "'"
        anchors.centerIn: parent
    }
}
