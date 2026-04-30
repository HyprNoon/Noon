import QtQuick
import QtQuick.Controls
import qs.store
import qs.common
import qs.common.widgets
import QtQuick.Layouts
import qs.modules.main.desktop.widgets

Item {
    id: root
    property bool expanded: false
    property int pinnedCount: 0
    readonly property var store: Mem.states.sidebar.widgets
    readonly property int columns: expanded ? 4 : 2
    readonly property int cellSize: 200
    readonly property int gridSpacing: Padding.small
    readonly property int unit: cellSize + gridSpacing
    readonly property var db: WidgetsData.db

    function initOrder() {
        if (root.db.length === 0)
            return;
        let ids = root.db.map(e => e.id);
        let filtered = store.order.filter(id => ids.indexOf(id) !== -1);
        let missing = ids.filter(id => filtered.indexOf(id) === -1);
        store.order = filtered.concat(missing);
    }

    function moveItem(fromId, toGX, toGY) {
        let pinnedIds = Mem.states.sidebar.widgets.pinned;
        let enabledIds = Mem.states.sidebar.widgets.enabled;
        let isPinnedSection = toGY < root.pinnedCount;

        let order = store.order.slice();
        let fromIdx = order.indexOf(fromId);
        if (fromIdx === -1)
            return;

        let targetId = null;
        for (let i = 0; i < widgetRepeater.count; i++) {
            let item = widgetRepeater.itemAt(i);
            if (!item?.active)
                continue;
            if (item.widgetId === fromId)
                continue;
            if (item.gX === toGX && item.gY === toGY) {
                targetId = item.widgetId;
                break;
            }
        }

        if (targetId !== null) {
            let toIdx = order.indexOf(targetId);
            if (toIdx !== -1) {
                order.splice(fromIdx, 1);
                let newToIdx = order.indexOf(targetId);
                order.splice(fromIdx < toIdx ? newToIdx + 1 : newToIdx, 0, fromId);
                store.order = order;
            }
        }

        if (isPinnedSection) {
            if (pinnedIds.indexOf(fromId) === -1) {
                Mem.states.sidebar.widgets.pinned = [...pinnedIds, fromId];
            }
        } else {
            if (pinnedIds.indexOf(fromId) !== -1) {
                Mem.states.sidebar.widgets.pinned = pinnedIds.filter(id => id !== fromId);
            }
        }

        Qt.callLater(root.arrangeAll);
    }

    function arrangeAll() {
        if (store.order.length === 0) {
            initOrder();
        }

        let enabledSet = Mem.states.sidebar.widgets.enabled;
        let pinnedSet = Mem.states.sidebar.widgets.pinned;
        let expandedSet = Mem.states.sidebar.widgets.expanded;

        let itemMap = {};
        for (let i = 0; i < widgetRepeater.count; i++) {
            let item = widgetRepeater.itemAt(i);
            if (!item?.active)
                continue;
            if (i >= root.db.length) {
                console.error(`Widget arrangement error: item index ${i} exceeds db length ${root.db.length}`);
                continue;
            }
            itemMap[root.db[i].id] = {
                item,
                index: i
            };
        }

        let pinned = [], unpinned = [];

        for (let id of store.order) {
            if (enabledSet.indexOf(id) === -1)
                continue;
            let entry = itemMap[id];
            if (!entry)
                continue;
            let dbEntry = root.db[entry.index];
            let widened = dbEntry.expandable && expandedSet.indexOf(id) !== -1;
            let rec = {
                item: entry.item,
                width: widened ? 2 : 1
            };
            pinnedSet.indexOf(id) !== -1 ? pinned.push(rec) : unpinned.push(rec);
        }

        let x = 0, y = 0;

        function place(items) {
            for (let d of items) {
                if (x + d.width > columns) {
                    x = 0;
                    y++;
                }
                let w = Math.min(d.width, columns - x);
                if (w < d.width) {
                    console.warn(`Widget width clamped from ${d.width} to ${w}`);
                    d.width = w;
                }
                d.item.gX = x;
                d.item.gY = y;
                d.item.isExpanded = d.width === 2;
                x += d.width;
                if (x >= columns) {
                    x = 0;
                    y++;
                }
            }
        }

        place(pinned);

        root.pinnedCount = pinned.length > 0 ? y + (x > 0 ? 1 : 0) : 0;
        if (x > 0) {
            x = 0;
            y++;
        }

        place(unpinned);
    }

    onExpandedChanged: Qt.callLater(arrangeAll)

    Connections {
        target: Mem.states.sidebar.widgets
        function onEnabledChanged() {
            root.initOrder();
            Qt.callLater(arrangeAll);
        }
        function onPinnedChanged() {
            Qt.callLater(arrangeAll);
        }
        function onExpandedChanged() {
            Qt.callLater(arrangeAll);
        }
        function onPilledChanged() {
            Qt.callLater(arrangeAll);
        }
    }

    StyledFlickable {
        anchors.fill: parent
        contentHeight: container.childrenRect.height + 100
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Item {
            id: container
            anchors.fill: parent
            anchors.margins: Padding.large

            Repeater {
                id: widgetRepeater
                model: ScriptModel {
                    values: root.db
                }

                delegate: StyledLoader {
                    id: loader

                    property int gX: 0
                    property int gY: 0
                    property bool isExpanded: false
                    readonly property bool isDragged: dragArea.drag.active
                    readonly property bool isPinned: Mem.states.sidebar.widgets.pinned.indexOf(modelData.id) !== -1
                    readonly property bool isDesktop: Mem.states.sidebar.widgets.desktop.indexOf(modelData.id) !== -1
                    readonly property bool isPill: Mem.states.sidebar.widgets.pilled.indexOf(modelData.id) !== -1
                    readonly property bool canExpand: modelData.expandable
                    readonly property string widgetId: modelData.id

                    Component.onCompleted: {
                        root.initOrder();
                        Qt.callLater(root.arrangeAll);
                    }

                    shown: Mem.states.sidebar.widgets.enabled.indexOf(modelData.id) !== -1
                    source: sanitizeSource(Directories.shellDir + "/modules/main/desktop/widgets/", modelData.component)
                    width: isExpanded ? cellSize * 2 + gridSpacing : cellSize
                    height: cellSize

                    onLoaded: {
                        _item.pill = Qt.binding(() => isPill);
                        _item.pinned = Qt.binding(() => isPinned);
                        _item.expanded = Qt.binding(() => isExpanded);
                    }

                    Drag.active: dragArea.drag.active
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    x: isDragged ? x : gX * unit
                    y: isDragged ? y : gY * unit
                    z: isDragged ? 1000 : 1

                    Behavior on x {
                        enabled: !isDragged
                        Anim {}
                    }
                    Behavior on y {
                        enabled: !isDragged
                        Anim {}
                    }

                    MouseArea {
                        id: dragArea
                        z: 999
                        hoverEnabled: false
                        propagateComposedEvents: true
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        drag.target: loader.isPinned ? null : loader
                        drag.threshold: 8

                        onPressed: mouse => {
                            if (mouse.button === Qt.RightButton)
                                widgetMenu.popup(mouse.x, mouse.y);
                        }

                        onReleased: mouse => {
                            if (mouse.button === Qt.RightButton)
                                return;

                            let snapX = Math.max(0, Math.min(Math.round(loader.x / root.unit), root.columns - 1));
                            let snapY = Math.max(0, Math.round(loader.y / root.unit));

                            root.moveItem(loader.widgetId, snapX, snapY);
                        }
                    }

                    WidgetItemContextMenu {
                        id: widgetMenu
                        widgetData: modelData
                    }
                }
            }
        }
    }

    PagePlaceholder {
        icon: "widgets"
        title: "No Enabled Widgets"
        description: "Scroll Below To Reveal Available Widgets"
        anchors.centerIn: parent
        shape: MaterialShape.Shape.Clover8Leaf
        iconSize: 100
        shown: Mem.states.sidebar.widgets.enabled.length === 0
    }

    WidgetsSpawnerDialog {
        db: root.db
    }
}
