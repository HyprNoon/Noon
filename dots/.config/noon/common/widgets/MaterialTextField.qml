import QtQuick.Controls.Material
import QtQuick
import QtQuick.Controls
import qs.common

TextField {
    id: root

    Material.theme: Material.System
    Material.accent: Colors.m3.m3primary
    Material.primary: Colors.m3.m3primary
    Material.background: Colors.m3.m3surface
    Material.foreground: Colors.m3.m3onSurface
    Material.containerStyle: Material.Outlined
    renderType: Text.QtRendering
    selectedTextColor: Colors.m3.m3onSecondaryContainer
    selectionColor: Colors.colSecondaryContainer
    placeholderTextColor: Colors.m3.m3outline
    clip: true
    wrapMode: TextEdit.Wrap
    font.family: Fonts.family.main ?? "sans-serif"
    font.pixelSize: Fonts.sizes.small ?? 15
    font.hintingPreference: Font.PreferFullHinting

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
    }
}
