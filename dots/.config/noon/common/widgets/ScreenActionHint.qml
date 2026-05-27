import QtQuick
import QtQuick.Layouts

import qs.common
import qs.common.widgets

StyledRect {
    id: root
    z: 999
    opacity: isActive ? 1 : 0
    anchors.fill: parent
    property color hintColor: Colors.colPrimaryContainer
    property string text: "You Can Drop it Now!"
    property string icon: "keyboard_double_arrow_down"
    required property var target
    property bool extraVisiblilityCondition: true
    readonly property bool isActive: extraVisiblilityCondition && (target?.containsDrag ?? false)
    property real scale: 1
    CLayout {
        z: 9999
        anchors.centerIn: parent
        Symbol {
            id: symbol
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: Colors.colOnLayer0
            font.pixelSize: 120 * root.scale
            text: root.icon
            fill: 1
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Fonts.sizes.title * root.scale
            font.variableAxes: Fonts.variableAxes.title
            color: Colors.colOnLayer0
            text: root.text
        }
    }

    gradient: Gradient {
        GradientStop {
            position: 0
            color: "transparent"
        }
        GradientStop {
            position: 0.999
            color: root.hintColor
        }
    }
}
