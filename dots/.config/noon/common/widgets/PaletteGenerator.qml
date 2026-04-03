import Quickshell
import QtQuick
import qs.common.utils
import qs.common

/*
    Palette Generator Takes source and return a colorPalette
*/

Item {
    id: root
    visible: false
    required property string source
    readonly property var colors: palette.keyColor ? palette.colors : Colors
    property alias depth: quantizer.depth
    property alias rescaleSize: quantizer.rescaleSize
    property bool active: source.length > 0

    ColorQuantizer {
        id: quantizer
        source: root.source
        depth: root.depth
        rescaleSize: root.rescaleSize
    }
    ColorsGenerator {
        id: palette
        active: root.active
        keyColor: quantizer?.colors[0] ?? "black"
    }
}
