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
    color: "transparent"
    radius: Rounding.verylarge

    property string searchQuery: ""
    readonly property var content_model: GlobalStates.main.dmenu.items
    readonly property var action: GlobalStates.main.dmenu.action
    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    onContentFocusRequested: listView.forceActiveFocus()

    function executeAction(x) {
        const sanitized = x.toLowerCase(); // .replace(/[^a-z0-9]/g, '');
        NoonUtils.execDetached(sanitized);
    }

    ScriptModel {
        id: genericModel
        values: {
            if (!root.content_model)
                return [];

            const processed = root.content_model.map((item, idx) => {
                if (typeof item === 'string') {
                    return {
                        name: item,
                        subtext: "",
                        icon: "",
                        originalData: item,
                        index: idx
                    };
                } else {
                    return {
                        name: item.title || item.name || String(item),
                        subtext: item.subtitle || item.description || "",
                        icon: item.icon || "",
                        originalData: item.value || item.title || item.name || item,
                        index: idx
                    };
                }
            });

            const query = root.searchQuery.trim();
            if (!query)
                return processed;

            const results = Fuzzy.go(query, processed, {
                key: 'name',
                threshold: -5000
            });

            return results.map(r => r.obj);
        }
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        spacing: Padding.small
        model: genericModel

        delegate: StyledDelegateItem {
            width: listView.width
            required property var modelData
            required property int index

            title: modelData.name
            subtext: modelData.subtext
            materialIcon: modelData.icon
            toggled: listView.currentIndex === index

            releaseAction: () => {
                root.executeAction(modelData.name);
                root.dismiss();
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up && currentIndex <= 0) {
                root.searchFocusRequested();
            } else if (event.key === Qt.Key_Down && currentIndex < count - 1) {
                currentIndex++;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0 && currentIndex < model.values.length) {
                    const data = model.values[currentIndex];
                    root.executeAction(data.name);
                    root.dismiss();
                }
            } else {
                return;
            }
            event.accepted = true;
        }
    }
}
