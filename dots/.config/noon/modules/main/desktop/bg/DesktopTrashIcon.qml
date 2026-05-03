import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.widgets
import qs.common.utils

Item {
    id: trashIcon

    required property int iconSize
    required property int iconW
    required property int iconH
    required property int iconPad
    required property int labelSize
    required property int labelWidth
    required property int labelLines
    required property bool externalHovered

    width: iconW
    height: iconH

    property bool hovered: false
    readonly property bool anyHovered: hovered || externalHovered

    StyledRect {
        anchors.fill: parent
        radius: Rounding.verysmall
        color: trashIcon.anyHovered ? Qt.rgba(1.0, 0.25, 0.25, 0.3) : "transparent"
        border.color: trashIcon.anyHovered ? Qt.rgba(1.0, 0.4, 0.4, 0.7) : "transparent"
        border.width: 1
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: trashIcon.iconPad
        spacing: 4
        width: parent.width

        StyledIconImage {
            Layout.alignment: Qt.AlignHCenter
            implicitSize: trashIcon.iconSize
            _source: trashIcon.anyHovered ? "user-trash-full" : "user-trash"
            Behavior on implicitSize {
                Anim {}
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: trashIcon.labelWidth
            horizontalAlignment: Text.AlignHCenter
            text: "Trash"
            color: Colors.colOnSurface
            font.pixelSize: trashIcon.labelSize
            elide: Text.ElideRight
            maximumLineCount: trashIcon.labelLines
            wrapMode: Text.WordWrap
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4
        samples: 9
        color: "#aa000000"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton

        onEntered: trashIcon.hovered = true
        onExited: trashIcon.hovered = false

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton)
                trashMenu.popup();
        }
    }

    Menu {
        id: trashMenu
        Material.theme: Material.Dark
        Material.accent: Material.Blue
        Material.roundedScale: Material.SmallScale
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            implicitWidth: 200
            color: Qt.rgba(0.13, 0.13, 0.16, 0.97)
            radius: 10
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 20
                samples: 41
                color: "#55000000"
                verticalOffset: 6
            }
        }

        MenuItem {
            text: "Open Trash"
            icon.name: "folder-open"
            Material.foreground: "white"
            onTriggered: NoonUtils.execDetached(["gio", "open", "trash:///"])
            background: Rectangle {
                color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                radius: 6
            }
        }

        MenuSeparator {
            contentItem: Separator {}
            background: Item {}
        }

        MenuItem {
            text: "Empty Trash"
            icon.name: "edit-delete"
            Material.foreground: "#ff6b6b"
            onTriggered: NoonUtils.execDetached(["gio", "trash", "--empty"])
            background: Rectangle {
                color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                radius: 6
            }
        }
    }
}
