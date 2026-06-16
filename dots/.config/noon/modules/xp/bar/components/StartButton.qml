import "../../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.widgets

Button {
    id: root
    Layout.fillHeight: true
    Layout.preferredWidth: 140
    background: StyledRect {
        rightRadius: 12
        color: XColors.colors.colTertiary
        RowLayout {
            anchors {
                horizontalCenterOffset: -4
                centerIn: parent
            }
            spacing: XPadding.tiny
            Image {
                id: logo
                clip: true
                sourceSize: Qt.size(34, 34)
                source: Directories.assets + "/icons/xp_logo.png"
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 4
                    horizontalOffset: 3
                    opacity: 0.6
                    color: XColors.colors.colShadows
                    radius: 5
                    samples: 5
                }
            }
            StyledText {
                text: "Start"
                layer.enabled: true
                layer.effect: logo.layer.effect

                font {
                    weight: 700
                    family: XFonts.family.main
                    pixelSize: XFonts.sizes.huge - 2
                }
            }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 4
            horizontalOffset: 3
            color: XColors.colors.colShadows
            samples: 4
            radius: 5
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: root.pointingHandCursor ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: event => {
            switch (event.button) {
            case Qt.LeftButton:
                Globals.xp.showStartMenu = !Globals.xp.showStartMenu;
                break;
            }
        }
        onReleased: event => {}
    }
}
