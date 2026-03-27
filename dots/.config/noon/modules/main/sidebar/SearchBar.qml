import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: searchBar
    signal contentFocusRequested

    property QtObject colors: Colors
    required property var root
    property var action
    property alias searchText: searchInput.text
    property alias searchInput: searchInput
    property int contentY

    visible: root.effectiveSearchable && root.category !== ""
    Layout.preferredHeight: root.effectiveSearchable ? 50 : 0
    Layout.leftMargin: Padding.large
    Layout.rightMargin: Padding.large

    Layout.fillWidth: true

    RLayout {
        anchors.fill: parent
        spacing: Padding.huge

        MaterialShapeWrappedSymbol {
            padding: 8
            iconSize: 20
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            color: searchInput.focus ? Colors.colPrimary : Colors.colPrimaryContainer
            colSymbol: searchInput.focus ? Colors.colOnPrimary : Colors.colOnPrimaryContainer
            shape: searchInput.focus ? MaterialShape.Shape.Cookie12Sided : SidebarData.getShape(root.category)
            text: SidebarData.getIcon(root.category) || ""
            fill: 1
        }

        StyledRect {
            Layout.fillWidth: true
            radius: Rounding.verylarge
            height: 46
            color: searchInput.focus ? Colors.colSecondaryContainer : Colors.colLayer1

            StyledTextField {
                id: searchInput
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                visible: root.effectiveSearchable
                enabled: root.effectiveSearchable
                background: null
                placeholderText: "Search..."
                placeholderTextColor: focus ? Colors.colOnSecondaryContainer : Colors.colOutline
                selectionColor: searchBar.colors.colSecondary
                selectedTextColor: Colors.colOnSecondary
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
                    if (event.key === Qt.Key_Down || event.key === Qt.Key_PageDown) {
                        searchBar.contentFocusRequested();
                        event.accepted = true;
                    }
                }
            }
        }

        RippleButtonWithIcon {
            buttonRadius: 12
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            colBackground: "transparent"
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
}
