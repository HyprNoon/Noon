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

    property string searchQuery: ""

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
    }

    StyledGridView {
        id: contentView
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
            width: contentView.cellWidth
            height: contentView.cellHeight

            StyledRect {
                id: groupTile
                anchors.fill: parent
                anchors.margins: Padding.normal
                anchors.bottomMargin: 40
                color: Colors.colLayer2
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
