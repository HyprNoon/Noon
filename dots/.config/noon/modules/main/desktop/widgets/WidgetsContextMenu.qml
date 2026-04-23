import QtQuick
import QtQuick.Controls
import qs.store
import qs.common
import qs.common.widgets
import QtQuick.Layouts
import qs.modules.main.desktop.widgets

StyledMenu {
    id: root
    required property var modelData
    readonly property string widgetId: modelData.id
    readonly property bool isExpanded: modelData?.expanded ?? false
    readonly property bool isPill: modelData?.pilled ?? false
    readonly property var store: Mem.states.sidebar.widgets
    content: {
        let items = [
            {
                text: root.isPill ? "Square" : "Pill",
                materialIcon: root.isPill ? "capture" : "pill",
                action: () => {
                    if (!root.isPill) {
                        store.pilled.push(modelData.id);
                    } else {
                        const index = store.pilled.indexOf(root.widgetId);
                        store.pilled.splice(index, 1);
                    }
                    root.close();
                }
            },
            {
                text: "Remove",
                materialIcon: "close",
                action: () => {
                    if (root.widgetId) {
                        const index = store.desktop.indexOf(root.widgetId);
                        store.desktop.splice(index, 1);
                    }
                    root.close();
                }
            }
        ];

        if (modelData.expandable) {
            items.push({
                text: root.isExpanded ? "Collapse" : "Expand",
                materialIcon: root.isExpanded ? "close_fullscreen" : "open_in_full",
                action: () => {
                    if (root.widgetId) {
                        const index = store.expanded.indexOf(root.widgetId);
                        if (isExpanded)
                            store.expanded.splice(index, 1);
                        else
                            store.expanded.push(root.widgetId);
                    }
                    root.close();
                }
            });
        }

        return items;
    }
}
