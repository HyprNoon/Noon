import QtQuick.Controls.Material
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common

Menu {
    id: root

    required property var content
    property QtObject colors: Colors
    width: 240
    Material.theme: Colors.m3.darkmode ? Material.Dark : Material.Light
    Material.primary: colors.colPrimaryContainer
    Material.accent: colors.colSecondaryContainer
    Material.roundedScale: Rounding.normal
    Material.elevation: 8

    Repeater {
        model: content.filter(i => i.visible ?? true)

        StyledMenuItem {
            colors: root.colors
            materialIcon: modelData.materialIcon ?? ""
            text: modelData.text ?? ""
            onTriggered: modelData.action()
        }
    }

    background: StyledRect {
        implicitWidth: root.width
        implicitHeight: 26 * parent.contentItem.children.length
        color: Colors.colLayer0
        radius: Rounding.verylarge
    }

    enter: Transition {
        Anim {
            property: "opacity"
            from: 0
            to: 1
            duration: Animations.durations.small
        }

        Anim {
            property: "scale"
            from: 0.95
            to: 1
            duration: Animations.durations.small
        }
    }

    exit: Transition {
        Anim {
            property: "opacity"
            from: 1
            to: 0
            duration: Animations.durations.small
        }

        Anim {
            property: "scale"
            from: 1
            to: 0.95
            duration: Animations.durations.small
        }
    }
}
