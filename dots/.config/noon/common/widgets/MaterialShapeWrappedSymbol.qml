import QtQuick
import qs.common
import qs.common.widgets

MaterialShape {
    id: root

    property alias text: symbol.text
    property alias iconSize: symbol.iconSize
    property alias font: symbol.font
    property alias animateChange: symbol.animateChange
    property alias colSymbol: symbol.color
    property alias fill: symbol.fill
    property real padding: 6
    property QtObject colors: Colors
    color: colors.colSecondaryContainer
    colSymbol: colors.colOnSecondaryContainer
    shape: MaterialShape.Shape.Clover4Leaf
    implicitSize: Math.max(symbol.implicitWidth, symbol.implicitHeight) + padding * 2

    Symbol {
        id: symbol

        anchors.centerIn: parent
        color: root.colSymbol
    }

    Behavior on colSymbol {
        CAnim {}
    }

    Behavior on color {
        CAnim {}
    }
}
