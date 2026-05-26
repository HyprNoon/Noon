import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store
import Noon.Utils

ColumnLayout {
    anchors.fill: parent
    property var gamepad: GamePadService.main
    property alias currentItem: gameCarousel.currentItem
    property string backdrop: gameCarousel.model[gameCarousel.currentIndex].coverImage

    ListView {
        id: gameCarousel
        Layout.fillWidth: true
        Layout.fillHeight: true

        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width - cardWidth) / 2
        preferredHighlightEnd: (width - cardWidth) / 2 + cardWidth
        clip: true
        spacing: Padding.large
        highlightMoveDuration: 400
        maximumFlickVelocity: 2000
        flickDeceleration: 3500
        interactive: true

        readonly property int cardWidth: 500
        readonly property int cardHeight: 660

        model: Mem.states.services.games.list

        delegate: GameItem {
            isSelected: index === gameCarousel.currentIndex
            cardWidth: gameCarousel.cardWidth
            cardHeight: gameCarousel.cardHeight
        }
    }

    RowLayout {
        z: 9999
        Layout.rightMargin: Padding.massive
        Layout.leftMargin: Padding.massive
        Layout.fillWidth: true
        Layout.maximumHeight: 52
        Layout.bottomMargin: Padding.large
        spacing: Padding.normal
        visible: root.currentPage === 1 && gameCarousel

        GroupButtonWithIcon {
            z: 3
            materialIcon: "chevron_left"
            implicitSize: 48
            Layout.fillHeight: false
            Layout.fillWidth: false
            colBackground: root.colors.colSurfaceContainerHigh
            colBackgroundHover: root.colors.colSurfaceContainerHighestHover
            colBackgroundActive: root.colors.colSurfaceContainerHighestActive
            enabled: gameCarousel && gameCarousel.currentIndex > 0
            releaseAction: () => {
                if (gameCarousel)
                    gameCarousel.currentIndex = Math.max(0, gameCarousel.currentIndex - 1);
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Repeater {
            model: gameCarousel ? gameCarousel.count : 0
            delegate: StyledRect {
                required property int index
                property bool active: index === (gameCarousel ? gameCarousel.currentIndex : -1)
                implicitWidth: active ? 55 : 20
                implicitHeight: 20
                radius: height / 2
                color: active ? root.colors.colPrimary : root.colors.colOnLayer0
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: if (gameCarousel)
                        gameCarousel.currentIndex = index
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        WrapperRectangle {
            margin: Padding.large
            color: root.colors.colLayer3
            radius: Rounding.full
            ButtonGroup {
                opacity: gamepad.connected ? 1 : 0
                GroupButtonWithIcon {
                    implicitSize: 28
                    colBackgroundHover: root.colors.colSurfaceContainerHighestHover
                    colBackgroundActive: root.colors.colSurfaceContainerHighestActive
                    colBackground: gamepad.faceDown ? root.colors.colPrimary : root.colors.colSurfaceContainerHigh
                    colSymbol: root.colors.colPrimary
                    materialIcon: "close"
                    releaseAction: () => gamepad.faceDown = false
                }
                GroupButtonWithIcon {
                    implicitSize: 28
                    colBackground: gamepad.faceRight ? root.colors.colPrimary : root.colors.colSurfaceContainerHigh
                    colBackgroundHover: root.colors.colSurfaceContainerHighestHover
                    colBackgroundActive: root.colors.colSurfaceContainerHighestActive
                    colSymbol: root.colors.colError
                    materialIcon: "radio_button_unchecked"
                    releaseAction: () => gamepad.faceRight = false
                }
            }
        }

        GroupButtonWithIcon {
            z: 3
            materialIcon: "chevron_right"
            implicitSize: 48
            Layout.fillHeight: false
            Layout.fillWidth: false
            colBackground: root.colors.colSurfaceContainerHigh
            colBackgroundHover: root.colors.colSurfaceContainerHighestHover
            colBackgroundActive: root.colors.colSurfaceContainerHighestActive
            enabled: gameCarousel && gameCarousel.currentIndex < gameCarousel.count - 1
            releaseAction: () => {
                if (gameCarousel)
                    gameCarousel.currentIndex = Math.min(gameCarousel.count - 1, gameCarousel.currentIndex + 1);
            }
        }
    }
}
