import QtQuick
import qs.common
import qs.common.functions
import qs.common.widgets

RippleButton {
    id: root

    property bool active: false

    horizontalPadding: Rounding.large
    verticalPadding: 12
    clip: true
    pointingHandCursor: !active
    implicitWidth: contentItem.implicitWidth + horizontalPadding * 2
    implicitHeight: contentItem.implicitHeight + verticalPadding * 2
    colBackground: ColorUtils.transparentize(Colors.colLayer3)
    colBackgroundHover: active ? colBackground : Colors.colLayer3Hover
    colRipple: Colors.colLayer3Active
    buttonRadius: Rounding.small

    Behavior on implicitHeight {
        Anim {}
    }
}
