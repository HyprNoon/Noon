import QtQuick
import qs.common
import qs.common.widgets
import qs.services

GroupButton {
    id: button

    property string buttonIcon
    property bool activated: false

    toggled: activated
    baseWidth: height

    contentItem: Symbol {
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Fonts.sizes.verylarge
        text: buttonIcon
        color: button.activated ? Colors.m3.m3onPrimary : button.enabled ? Colors.m3.m3onSurface : Colors.colOnLayer1Inactive

        Behavior on color {
            CAnim {}
        }
    }
}
