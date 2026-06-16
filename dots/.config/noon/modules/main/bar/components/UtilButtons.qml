import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BarGroup {
    id: root
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    readonly property var content: [
        {
            "icon": "colorize",
            "action": () => {
                NoonUtils.execDetached(["hyprpicker", "-a", "-q"]);
            }
        },
        {
            "icon": "screenshot",
            "action": () => ScreenShotService.takeScreenShot()
        },
        {
            "icon": "dashboard",
            "action": () => {
                NoonUtils.callIpc("sidebar reveal Apps");
            }
        }
    ]

    GridLayout {
        id: content

        rows: !root.vertical ? 1 : 4
        columns: root.vertical ? 1 : 4
        columnSpacing: 4
        rowSpacing: 4
        anchors.centerIn: parent
        Repeater {
            id: repeater
            model: root.content
            delegate: RippleButtonWithIcon {
                toggled: false
                materialIcon: modelData.icon
                materialIconFill: hovered
                implicitSize: Math.round(Math.min(root.width, root.height) * 0.75)
                releaseAction: () => modelData.action()
            }
        }
    }
}
