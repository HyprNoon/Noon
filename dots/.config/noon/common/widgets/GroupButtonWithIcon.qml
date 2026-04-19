import QtQuick
import QtQuick.Controls
import qs.common
import qs.common.widgets

GroupButton {
    property alias materialIconFill: symb.fill
    property alias materialIcon: symb.text
    property alias animateIcon: symb.animateChange
    property alias colSymbol: symb.color
    property int implicitSize: 36
    baseWidth: implicitSize
    baseHeight: implicitSize
    colBackground: Colors.colLayer2
    buttonRadius: Rounding.huge
    buttonRadiusPressed: Rounding.small

    Symbol {
        id: symb
        color: parent.toggled ? Colors.colOnPrimary : Colors.colOnLayer2
        font.pixelSize: Fonts.sizes.large
        anchors.centerIn: parent
        fill: 1
    }
}
