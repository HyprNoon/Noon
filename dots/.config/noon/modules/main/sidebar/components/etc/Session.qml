import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root

    readonly property var contentModel: [
        {
            "icon": "lock",
            "tooltip": qsTr("Lock"),
            "command": "",
            "c": Colors.colSecondary,
            "hc": Colors.colSecondaryHover,
            "i": Colors.colOnSecondary,
            "shape": "Ghostish"
        },
        {
            "icon": "arrow_warm_up",
            "tooltip": qsTr("Reboot to UEFI"),
            "command": "systemctl reboot --firmware-setup",
            "c": Colors.colPrimary,
            "hc": Colors.colPrimaryHover,
            "i": Colors.colOnPrimary,
            "shape": "Cookie6Sided"
        },
        {
            "icon": "logout",
            "tooltip": qsTr("Logout"),
            "command": "loginctl terminate-user ''",
            "c": Colors.colPrimaryContainerActive,
            "hc": Colors.colPrimaryContainerHover,
            "i": Colors.colOnPrimaryContainer,
            "shape": "PixelCircle"
        },
        {
            "icon": "restart_alt",
            "tooltip": qsTr("Restart"),
            "command": "reboot || loginctl reboot",
            "c": Colors.colSuccess,
            "hc": Colors.colSuccessHover,
            "i": Colors.colOnSuccess,
            "shape": "Cookie9Sided"
        },
        {
            "icon": "dark_mode",
            "tooltip": qsTr("Sleep"),
            "command": "systemctl suspend || loginctl suspend",
            "c": Colors.colTertiary,
            "hc": Colors.colTertiaryHover,
            "i": Colors.colOnTertiary,
            "shape": "Clover8Leaf"
        },
        {
            "icon": "power_settings_new",
            "tooltip": qsTr("Shutdown"),
            "command": "systemctl poweroff || loginctl poweroff",
            "c": Colors.colError,
            "hc": Colors.colErrorHover,
            "i": Colors.colOnError,
            "shape": "Bun"
        }
    ]

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Padding.large

        Repeater {
            model: ScriptModel {
                values: root.contentModel
            }
            delegate: MaterialShapeWrappedSymbol {
                required property var modelData
                readonly property int buttonSize: root.width * 0.86
                implicitSize: buttonSize
                color: eventArea.containsMouse ? modelData.hc : modelData.c
                iconSize: buttonSize * 0.6
                colSymbol: modelData.i
                text: modelData.icon
                shape: eventArea.containsMouse ? MaterialShape.Shape.Cookie12Sided : MaterialShape.Shape[modelData.shape]
                fill: eventArea.containsMouse ? 1 : 0
                MouseArea {
                    id: eventArea
                    z: 999
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData?.command === "" ? NoonUtils.callIpc("global lock") : NoonUtils.execDetached(modelData.command)
                }
            }
        }
    }
}
