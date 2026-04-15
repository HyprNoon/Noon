import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: panel
    visible: category.length > 0
    anchors.fill: parent
    anchors.margins: Padding.huge

    required property string category
    required property QtObject colors
    readonly property bool effectiveSearchable: SidebarData.isSearchable(category)
    property string previousCategory: ""
    property bool _detached: false
    property bool _aux: false
    property alias searchInput: searchBar.searchInput

    property var parentRoot: GlobalStates.main.sidebar
    readonly property var contentItem: contentStack.currentItem

    signal contentFocusRequested
    signal searchFocusRequested

    onCategoryChanged: {
        if (!category) {
            contentStack.clear();
            previousCategory = category;
            return;
        }
        contentStack.slideDirection = SidebarData.getCategoryDirection(previousCategory, category);
        contentStack.replace(null, SidebarData.getComponentPath(category));
        previousCategory = category;
    }

    ColumnLayout {
        spacing: Padding.large
        clip: true
        anchors.fill: parent

        StackView {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            property int slideDirection: 1

            replaceEnter: Transition {
                ParallelAnimation {
                    PropertyAnimation {
                        property: "y"
                        from: -contentStack.slideDirection * contentStack.height
                        to: 0
                        duration: Animations.durations.large
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasizedDecel
                    }
                    PropertyAnimation {
                        property: "scale"
                        from: 0.65
                        to: 1
                        duration: Animations.durations.huge
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasized
                    }
                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: Animations.durations.small
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasized
                    }
                }
            }
            replaceExit: Transition {
                ParallelAnimation {
                    PropertyAnimation {
                        property: "y"
                        from: 0
                        to: contentStack.slideDirection * contentStack.height
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasizedAccel
                        duration: Animations.durations.large
                    }
                    PropertyAnimation {
                        property: "scale"
                        from: 1
                        to: 0.65
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasized
                        duration: Animations.durations.huge
                    }
                    PropertyAnimation {
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: Animations.durations.small
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Animations.curves.emphasized
                    }
                }
            }

            onCurrentItemChanged: {
                const item = currentItem;
                if (!item)
                    return;

                if ("web_view" in item)
                    GlobalStates.web_session = Qt.binding(() => item.web_view);
                if ("searchQuery" in item)
                    item.searchQuery = Qt.binding(() => searchBar.searchText);
                if ("detached" in item)
                    item.detached = Qt.binding(() => _detached);
                if ("expanded" in item && !_aux)
                    item.expanded = Qt.binding(() => parentRoot.expanded);
                if ("panelWindow" in item)
                    item.panelWindow = Qt.binding(() => parentRoot);

                if (item.searchFocusRequested)
                    item.searchFocusRequested.connect(() => {
                        if (!_aux && searchBar.searchInput && panel.effectiveSearchable)
                            searchBar.searchInput.forceActiveFocus();
                    });

                if (item.dismiss)
                    item.dismiss.connect(parentRoot.hide);
            }
        }

        SearchBar {
            id: searchBar
            root: panel
            colors: panel.colors
            contentY: contentStack.y
            onContentFocusRequested: {
                if (panel.contentItem && "contentFocusRequested" in panel.contentItem)
                    panel.contentItem.contentFocusRequested();
            }
        }
    }
}
