import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

StyledRect {
    id: searchBar
    property QtObject colors: Colors
    required property var root
    property var action

    visible: root.effectiveSearchable && root.category !== ""
    property alias searchText: searchInput.text
    property alias searchInput: searchInput
    property int contentY
    radius: Rounding.verylarge
    enableBorders: searchInput.focus
    color: searchBar.colors.colLayer1
    Layout.preferredHeight: root.effectiveSearchable ? 50 : 0
    Layout.fillWidth: true
    signal contentFocusRequested

    MaterialShapeWrappedMaterialSymbol {
        id: shape
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: Padding.verylarge
        }
        iconSize: 18
        padding: 6
        color: Colors.colPrimaryContainer
        shape: SidebarData.getShape(root.category)
        text: SidebarData.getIcon(root.category) || ""
        fill: 1
    }

    RowLayout {
        spacing: Padding.small
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            left: shape.right
            leftMargin: Padding.large
            rightMargin: Padding.large
        }

        StyledTextField {
            id: searchInput
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.effectiveSearchable
            enabled: root.effectiveSearchable
            text: searchText || ""
            placeholderText: "Search..."
            placeholderTextColor: Colors.colOutline
            background: null
            selectionColor: searchBar.colors.colSecondaryContainer
            selectedTextColor: Colors.colOnSecondaryContainer
            color: Colors.colOnLayer1
            selectByMouse: true
            font {
                family: Fonts.family.main
                pixelSize: Fonts.sizes.small
            }
            Connections {
                target: root
                function onCategoryChanged() {
                    searchInput.text = "";
                }
            }
            onAccepted: if (SidebarData._get(root.category).on_accepted_only || false)
                GlobalStates.web_session.url = Mem.options.networking.searchPrefix + text

            Keys.onPressed: event => {
                if (!root.effectiveSearchable)
                    return;
                if (event.key === Qt.Return) {
                    if (searchBar.action)
                        searchBar.action();
                    event.accepted = true;
                }
                if ((event.key === Qt.Key_Down || event.key === Qt.Key_PageDown)) {
                    searchBar.contentFocusRequested();
                    event.accepted = true;
                }
            }
        }
        SideButton {
            materialIcon: "close"
            visible: searchInput.text.length > 0
            releaseAction: () => {
                searchInput.clear();
                searchInput.focus = true;
            }
        }
    }

    transform: Translate {
        y: contentY
    }
    Behavior on Layout.preferredHeight {
        Anim {}
    }
    component SideButton: RippleButtonWithIcon {
        buttonRadius: 12
        Layout.preferredWidth: 24
        Layout.preferredHeight: 24
        colBackground: "transparent"
    }
}
