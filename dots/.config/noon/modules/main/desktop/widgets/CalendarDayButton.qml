import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Layouts

RippleButton {
    id: button
    property string day
    property int isToday
    property bool bold

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 24
    implicitHeight: 24
    colBackground: "transparent"
    toggled: (isToday == 1)
    buttonRadius: Rounding.normal

    contentItem: StyledText {
        anchors.fill: parent
        text: day
        horizontalAlignment: Text.AlignHCenter
        color: (isToday == 1) ? Colors.m3.m3onPrimary : (isToday == 0) ? Colors.colOnLayer1 : Colors.colOutlineVariant
        font.pixelSize: Fonts.sizes.verysmall
        font.weight: 800
        font.variableAxes: Fonts.variableAxes.title
        Behavior on color {
            CAnim {}
        }
    }
}
