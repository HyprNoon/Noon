import QtQuick
import QtQuick.Controls
import qs.store
import qs.common
import qs.common.widgets
import QtQuick.Layouts
import qs.modules.main.desktop.widgets

Item {
    id: root
    anchors.fill: parent
    property bool expanded: false
    property bool isDragging: false
    property int pinnedCount: 0

    readonly property int columns: expanded ? 4 : 2
    readonly property int cellSize: 180
    readonly property int gridSpacing: 20
    readonly property int unit: cellSize + gridSpacing

    readonly property var db: WidgetsData.db

    function arrangeAll() {
        let pinned = [], unpinned = [];

        for (let i = 0; i < widgetRepeater.count; i++) {
            let item = widgetRepeater.itemAt(i);
            if (!item?.active)
                continue;

            if (i >= root.db.length) {
                console.error(`Widget arrangement error: item index ${i} exceeds db length ${root.db.length}`);
                continue;
            }

            let widgetId = root.db[i].id;
            let shouldExpand = root.db[i].expandable && Mem.states.sidebar.widgets.expanded.indexOf(widgetId) !== -1;

            let data = {
                item: item,
                width: shouldExpand ? 2 : 1,
                index: i
            };
            Mem.states.sidebar.widgets.pinned.indexOf(widgetId) !== -1 ? pinned.push(data) : unpinned.push(data);
        }

        let x = 0, y = 0;

        function placeItems(items) {
            for (let data of items) {
                if (x < 0 || y < 0) {
                    console.error(`Widget arrangement error: invalid position x=${x}, y=${y}`);
                    x = Math.max(0, x);
                    y = Math.max(0, y);
                }

                if (x + data.width > columns) {
                    x = 0;
                    y++;
                }

                let actualWidth = Math.min(data.width, columns - x);
                if (actualWidth < data.width) {
                    console.warn(`Widget width reduced from ${data.width} to ${actualWidth} to prevent overflow`);
                    data.width = actualWidth;
                }

                data.item.gX = x;
                data.item.gY = y;
                data.item.isExpanded = data.width === 2;

                x += data.width;
                if (x >= columns) {
                    x = 0;
                    y++;
                }
            }
        }

        placeItems(pinned);

        if (pinned.length > 0) {
            root.pinnedCount = y + (x > 0 ? 1 : 0);
            if (x > 0) {
                x = 0;
                y++;
            }
        } else {
            root.pinnedCount = 0;
        }

        placeItems(unpinned);
    }

    onExpandedChanged: {
        Qt.callLater(arrangeAll);
    }

    Connections {
        target: Mem.states.sidebar.widgets
        function onEnabledChanged() {
            Qt.callLater(root.arrangeAll);
        }
        function onPinnedChanged() {
            Qt.callLater(root.arrangeAll);
        }
        function onExpandedChanged() {
            Qt.callLater(root.arrangeAll);
        }
        function onPilledChanged() {
            Qt.callLater(root.arrangeAll);
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: container.childrenRect.height + 100
        interactive: !root.isDragging
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Item {
            id: container
            width: parent.width
            anchors.margins: Padding.massive

            Separator {
                visible: root.pinnedCount > 0
                width: parent.width - Padding.massive
                y: root.pinnedCount * root.unit - root.gridSpacing / 2 - 1.5
                opacity: 0.85
            }

            Repeater {
                id: widgetRepeater
                model: root.db

                delegate: Loader {
                    id: loader
                    active: Mem.states.sidebar.widgets.enabled.indexOf(modelData.id) !== -1
                    visible: active
                    source: active ? `${Directories.shellDir}/modules/main/desktop/widgets/${modelData.component}.qml` : ""

                    property int gX: 0
                    property int gY: 0
                    property bool isExpanded: false
                    property bool isPinned: Mem.states.sidebar.widgets.pinned.indexOf(modelData.id) !== -1
                    property bool isDesktop: Mem.states.sidebar.widgets.desktop.indexOf(modelData.id) !== -1
                    property bool isPill: Mem.states.sidebar.widgets.pilled.indexOf(modelData.id) !== -1
                    readonly property bool canExpand: modelData.expandable
                    readonly property string widgetId: modelData.id

                    width: active ? (isExpanded ? cellSize * 2 + gridSpacing : cellSize) : 0
                    height: active ? cellSize : 0
                    x: dragArea.pressed ? dragArea.dragX : gX * unit
                    y: dragArea.pressed ? dragArea.dragY : gY * unit
                    z: dragArea.pressed ? 1000 : 1

                    Behavior on x {
                        enabled: !dragArea.pressed && active
                        Anim {}
                    }
                    Behavior on y {
                        enabled: !dragArea.pressed && active
                        Anim {}
                    }
                    Behavior on width {
                        Anim {}
                    }

                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        z: 999
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        property real dragX: loader.x
                        property real dragY: loader.y
                        property point startPos

                        onPressed: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                widgetMenu.popup(mouse.x, mouse.y);
                                mouse.accepted = true;
                                return;
                            }
                            if (loader.isPinned) {
                                mouse.accepted = false;
                                return;
                            }

                            root.isDragging = true;
                            startPos = Qt.point(mouse.x, mouse.y);
                            dragX = loader.x;
                            dragY = loader.y;
                        }

                        onPositionChanged: mouse => {
                            if (loader.isPinned || !pressed || !(mouse.buttons & Qt.LeftButton))
                                return;
                            dragX += mouse.x - startPos.x;
                            dragY += mouse.y - startPos.y;
                        }

                        onReleased: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                mouse.accepted = true;
                                return;
                            }
                            if (mouse.button !== Qt.LeftButton || loader.isPinned)
                                return;
                            root.isDragging = false;

                            let targetY = Math.round(dragY / unit);
                            let targetX = Math.round(dragX / unit);

                            if (targetY < root.pinnedCount) {
                                let list = Mem.states.sidebar.widgets.pinned;
                                if (list.indexOf(loader.widgetId) === -1) {
                                    list.push(loader.widgetId);
                                    Mem.states.sidebar.widgets.pinned = list.slice();
                                }
                                return;
                            }

                            Qt.callLater(root.arrangeAll);
                        }
                    }

                    StyledMenu {
                        id: widgetMenu
                        content: {
                            let items = [
                                {
                                    text: loader.isPinned ? "Unpin" : "Pin",
                                    materialIcon: "push_pin",
                                    action: () => {
                                        let list = Mem.states.sidebar.widgets.pinned;
                                        let idx = list.indexOf(loader.widgetId);
                                        if (idx === -1) {
                                            list.push(loader.widgetId);
                                        } else {
                                            list.splice(idx, 1);
                                        }
                                        Mem.states.sidebar.widgets.pinned = list.slice();
                                        widgetMenu.close();
                                    }
                                },
                                {
                                    text: loader.isDesktop ? "Remove from desktop" : "Send To Desktop",
                                    materialIcon: "open_in_new",
                                    action: () => {
                                        let list = Mem.states.sidebar.widgets.desktop;
                                        let idx = list.indexOf(loader.widgetId);
                                        if (idx === -1) {
                                            list.push(loader.widgetId);
                                        } else {
                                            list.splice(idx, 1);
                                        }
                                        Mem.states.sidebar.widgets.desktop = list.slice();
                                        widgetMenu.close();
                                    }
                                },
                                {
                                    text: loader.isPill ? "Island" : "Pill",
                                    materialIcon: loader.isPill ? "capture" : "pill",
                                    action: () => {
                                        let list = Mem.states.sidebar.widgets.pilled;
                                        let idx = list.indexOf(loader.widgetId);
                                        if (idx === -1) {
                                            list.push(loader.widgetId);
                                        } else {
                                            list.splice(idx, 1);
                                        }
                                        Mem.states.sidebar.widgets.pilled = list.slice();
                                        widgetMenu.close();
                                    }
                                },
                                {
                                    text: "Disable",
                                    materialIcon: "visibility_off",
                                    action: () => {
                                        let list = Mem.states.sidebar.widgets.enabled;
                                        let idx = list.indexOf(loader.widgetId);
                                        if (idx !== -1) {
                                            list.splice(idx, 1);
                                            Mem.states.sidebar.widgets.enabled = list.slice();
                                        }
                                        widgetMenu.close();
                                    }
                                }
                            ];

                            if (loader.canExpand) {
                                items.push({
                                    text: loader.isExpanded ? "Collapse" : "Expand",
                                    materialIcon: loader.isExpanded ? "close_fullscreen" : "open_in_full",
                                    action: () => {
                                        let list = Mem.states.sidebar.widgets.expanded;
                                        let idx = list.indexOf(loader.widgetId);
                                        if (idx === -1) {
                                            list.push(loader.widgetId);
                                        } else {
                                            list.splice(idx, 1);
                                        }
                                        Mem.states.sidebar.widgets.expanded = list.slice();
                                        widgetMenu.close();
                                    }
                                });
                            }

                            return items;
                        }
                    }

                    Binding {
                        when: loader.status === Loader.Ready
                        target: loader.item
                        property: "width"
                        value: loader.width
                    }
                    Binding {
                        when: loader.status === Loader.Ready
                        target: loader.item
                        property: "pill"
                        value: loader.isPill
                    }
                    Binding {
                        when: loader.status === Loader.Ready
                        target: loader.item
                        property: "expanded"
                        value: loader.isExpanded
                    }

                    Component.onCompleted: Qt.callLater(root.arrangeAll)
                }
            }
        }
    }
    PagePlaceholder {
        icon: "widgets"
        title: "No Enabled Widgets"
        description: "Scroll Below To Reveal Available Widgets"
        anchors.centerIn: parent
        shape: MaterialShape.Shapes.SoftBoom
        shown: Mem.states.sidebar.widgets.enabled.length === 0
    }
    WidgetsSpawnerDialog {
        db: root.db
    }
}
