import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true
    readonly property int columns: 3
    property string searchQuery: ""
    property string _debouncedQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    function first_action() {
        filteredModel.values[0].execute();
    }

    Timer {
        id: debounceTimer
        interval: 200
        onTriggered: root._debouncedQuery = root.searchQuery
    }

    onSearchQueryChanged: debounceTimer.restart()

    ScriptModel {
        id: filteredModel
        values: {
            const query = root._debouncedQuery.toLowerCase().trim();
            const apps = DesktopEntries.applications.values;
            if (query === "")
                return apps;
            return apps.filter(entry => entry.name.toLowerCase().includes(query) || entry.genericName.toLowerCase().includes(query) || entry.keywords.some(k => k.toLowerCase().includes(query)));
        }
    }
    StyledListView {
        id: contentView
        hint: false
        anchors.fill: parent
        anchors.margins: Padding.large
        readonly property real viewScale: Mem.options.sidebar.appearance.itemListScale ?? 1
        model: filteredModel
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 300
        animateAppearance: true
        animateMovement: true
        popin: true
        reuseItems: false
        Connections {
            target: root
            function onContentFocusRequested() {
                if (contentView.count > 0) {
                    contentView.currentIndex = 0;
                    contentView.forceActiveFocus();
                }
            }
        }

        delegate: StyledDelegateItem {
            id: appButton
            required property int index
            required property var modelData
            readonly property bool alternateStripes: Mem.options.sidebar.appearance.alternateListStripes
            colBackground: alternateStripes && (index % 2 === 0) ? "transparent" : Colors.colLayer2
            toggled: contentView.currentIndex === index && contentView.activeFocus
            title: modelData?.name ?? ""
            subtext: modelData?.genericName ?? ""
            implicitHeight: 68 * mainScale
            anchors.right: parent?.right
            anchors.left: parent?.left
            iconSource: NoonUtils.iconPath(modelData.icon)
            mainScale: contentView.viewScale
            releaseAction: () => {
                GlobalStates.main.sidebar.hide();
                modelData.execute();
            }
            altAction: () => {
                contextMenu.popup();
            }

            AppContextMenu {
                id: contextMenu
                modelData: appButton.modelData
                onDismiss: root.dismiss()
            }
        }

        Keys.onPressed: event => {
            const cols = root.columns;
            if (event.key === Qt.Key_Up) {
                if (currentIndex < cols) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else
                    currentIndex--;
            } else if (event.key === Qt.Key_Down) {
                currentIndex++;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    model.values[currentIndex].execute();
                    root.dismiss();
                }
            } else
                return;
            event.accepted = true;
        }
    }
    ScrollEdgeFade {
        target: contentView
        anchors.fill: root
    }

    BottomScaleDialog {}
    PagePlaceholder {
        shown: contentView.count === 0
        title: root.searchQuery === "" ? "No applications found" : "No results for '" + root.searchQuery + "'"
        icon: "search_off"
        anchors.centerIn: parent
    }
}
