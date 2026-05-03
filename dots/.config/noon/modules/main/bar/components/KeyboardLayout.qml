import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarGroup {
    id: root

    implicitHeight: 20 + (active ? Padding.massive : 0)

    StyledText {
        anchors.centerIn: parent
        text: HyprlandService.keyboardLayoutShortName
        animateChange: true
        font.weight: 900
        font.family: Fonts.family.monospace
        font.pixelSize: Fonts.sizes.normal
        color: Colors.colSecondary
        Layout.alignment: Qt.AlignHCenter
    }
    MouseArea {
        anchors.fill: parent
        onClicked: HyprlandService.switchKeyboardLayout()
    }
}
