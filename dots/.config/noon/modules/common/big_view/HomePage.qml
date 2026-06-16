import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: homePage

    property var registry
    property string backdrop: ""
    signal requestPage(string name)

    StyledGridView {
        id: grid
        anchors.fill: parent
        anchors.margins: Padding.massive
        cellWidth: 360
        cellHeight: 240
        model: homePage?.registry.filter(cat => cat.name !== "Home") ?? []
        delegate: CategoryCard {
            _selected: index === grid.currentIndex
            implicitHeight: grid.cellHeight - Padding.small
            implicitWidth: grid.cellWidth - Padding.small
            mouseArea {
                onEntered: grid.currentIndex = index
                onClicked: requestPage(modelData.name)
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up) {
                if (currentIndex - (width / cellWidth) < 0) {
                    currentIndex = -1;
                    homePage.searchFocusRequested();
                } else {
                    moveCurrentIndexUp();
                }
            } else if (event.key === Qt.Key_Down) {
                moveCurrentIndexDown();
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0 && currentIndex < count) {
                    requestPage(currentIndex);
                }
            } else if (event.key === Qt.Key_Escape) {
                Globals.common.openGameUI = false;
            } else
                return;

            event.accepted = true;
        }
    }

    Connections {
        target: GamePadService.secondary

        function onDUpPressed() {
            if (grid.currentIndex > 0)
                grid.moveCurrentIndexUp();
        }

        function onDDownPressed() {
            grid.moveCurrentIndexDown();
        }

        function onDLeftPressed() {
            grid.moveCurrentIndexLeft();
        }

        function onDRightPressed() {
            grid.moveCurrentIndexRight();
        }

        function onFaceDownPressed() {
            if (grid.currentIndex >= 0 && grid.currentIndex < grid.count) {
                homePage.requestPage(grid.currentItem.modelData.name);
            }
        }

        function onFaceRightPressed() {
            Globals.common.openGameUI = false;
        }
    }

    component CategoryCard: Item {
        id: root
        required property var modelData
        required property int index
        property bool _selected
        property alias mouseArea: mouseArea

        scale: _selected ? 1.0 : 0.88
        opacity: _selected ? 1.0 : 0.5

        Behavior on scale {
            Anim {}
        }

        StyledRectangularShadow {
            target: card
            glowRadius: _selected ? 40 : 0
            opacity: _selected ? 1 : 0
        }

        StyledRect {
            id: card
            anchors.fill: parent
            radius: Rounding.silly
            color: _selected ? Colors.colSurfaceContainerHighest : Colors.colSurfaceContainer
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Padding.massive
                spacing: Padding.normal

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Symbol {
                        anchors.centerIn: parent
                        fill: root._selected
                        icon: modelData.icon
                        iconSize: 52
                        color: Colors.colPrimary
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    text: modelData.name
                    font.pixelSize: Fonts.sizes.huge
                    font.family: Fonts.family.variable
                    font.variableAxes: Fonts.variableAxes.title
                    color: Colors.colOnSurface
                    horizontalAlignment: Text.AlignHCenter
                }

                StyledRect {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 4
                    Layout.preferredWidth: 40
                    radius: Rounding.full
                    color: root._selected ? Colors.colPrimary : "transparent"
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
