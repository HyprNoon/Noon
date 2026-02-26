import QtQuick.Controls.Material
import QtQuick
import QtQuick.Controls
import qs.common

/**
 * Material 3 styled TextArea (filled style)
 * https://m3.material.io/components/text-fields/overview
 * Note: We don't use NativeRendering because it makes the small placeholder text look weird
 */
TextArea {
    id: root

    Material.theme: Material.System
    Material.accent: Colors.m3.m3primary
    Material.primary: Colors.m3.m3primary
    Material.background: Colors.m3.m3surface
    Material.foreground: Colors.m3.m3onSurface
    Material.containerStyle: Material.Filled
    renderType: Text.QtRendering
    selectedTextColor: Colors.m3.m3onSecondaryContainer
    selectionColor: Colors.colSecondaryContainer
    placeholderTextColor: Colors.m3.m3outline
    wrapMode: TextEdit.Wrap

    font {
        family: Fonts.family.main
        pixelSize: Fonts.sizes.small ?? 15
        hintingPreference: Font.PreferFullHinting
        variableAxes: Fonts.variableAxes.main
    }

    background: Rectangle {
        implicitHeight: 56
        color: Colors.m3.m3surface
        topLeftRadius: 4
        topRightRadius: 4

        Rectangle {
            height: 1
            color: root.focus ? Colors.m3.m3primary : root.hovered ? Colors.m3.m3outline : Colors.m3.m3outlineVariant

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Behavior on color {
                CAnim {}
            }
        }
    }
}
