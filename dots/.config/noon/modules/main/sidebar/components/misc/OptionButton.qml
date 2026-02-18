import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

GroupButton {
    id: optBtn
    property string label
    property string materialIcon
    buttonRadius: Rounding.massive
    buttonRadiusPressed: Rounding.small
    Layout.fillWidth: true
    Layout.fillHeight: true
    buttonTextPadding: Padding.huge
    baseHeight: 42
    contentItem: RLayout {
        spacing: 4
        Symbol {
            color: optBtn.toggled ? Colors.colOnPrimary : Colors.colOnLayer1
            Layout.leftMargin: Padding.massive
            text: optBtn.materialIcon
            fill: optBtn.toggled ? 1 : 0
            font.pixelSize: 20
        }
        StyledText {
            text: optBtn.label
            color: optBtn.toggled ? Colors.colOnPrimary : Colors.colOnLayer1
            font.pixelSize: Fonts.sizes.large
        }
    }
}
