import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.widgets

Button {
    id: root
    property QtObject colors: XColors.colors
    property color colBackground: colors.colTertiary
    property color colBackgroundHover: colors.colTertiary
    property color colBackgroundActive: colors.colTertiary
    property color colOnBackgroundHover: colors.colPrimary
    property color colOnBackgroundActive: colors.colPrimary
    property color colBorder: colors.colTertiaryBorder
    property int implicitSize: 40
    property int buttonRadius: XRounding.small
    implicitWidth: implicitSize
    implicitHeight: implicitSize
    background: StyledRect {
        radius: buttonRadius
        color: {
            if (mouseArea.pressed) {
                root.colBackgroundActive;
            } else if (mouseArea.containsMouse) {
                root.colBackgroundHover;
            } else {
                root.colBackground;
            }
        }
        border {
            color: root.colBorder
            width: 2
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
