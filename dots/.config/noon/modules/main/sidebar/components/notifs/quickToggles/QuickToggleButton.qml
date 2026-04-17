import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.store

GroupButton {
    id: root

    property string buttonIcon
    property string dialogName
    property string buttonName
    property string buttonSubtext
    property bool showButtonName: false
    property bool halfToggled: toggled
    readonly property int smallRadius: Rounding.large + 2
    readonly property int largeRadius: 50

    Layout.fillWidth: showButtonName
    Layout.fillHeight: false
    baseSize: !showButtonName ? 68 : 72
    baseWidth: baseSize + Padding.large
    clip: true
    toggled: false
    buttonRadius: !toggled ? largeRadius : smallRadius
    buttonRadiusPressed: !toggled ? largeRadius : smallRadius
    colBackground: Colors.colLayer2
    altAction: () => GlobalStates.main.dialogs.current = dialogName

    Loader {
        anchors.fill: parent
        active: true
        sourceComponent: !root.showButtonName ? symb : fullComp
    }

    readonly property Component symb: Item {
        anchors.fill: parent
        Symbol {
            text: buttonIcon
            anchors.centerIn: parent
            fill: 1
            font.pixelSize: 22
            color: root.toggled ? Colors.colOnPrimary : Colors.colOnLayer3
        }
    }

    readonly property Component fullComp: Item {
        anchors.fill: parent
        StyledRect {
            id: sideRect
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: Padding.large
            }
            implicitWidth: height
            color: {
                if (root.halfToggled)
                    return Colors.colPrimary;
                else if (root.toggled)
                    return "transparent";
                else if (!root.toggled && !root.hovered)
                    return !root.showButtonName ? "transparent" : Colors.colLayer3;
                else if (!root.toggled && root.hovered)
                    return Colors.colLayer3Hover;
                else
                    return Colors.colLayer3;
            }
            radius: root.halfToggled ? root.smallRadius : root.buttonRadius
            Behavior on radius {
                Anim {}
            }
            Symbol {
                anchors.centerIn: parent
                fill: 1
                text: root.buttonIcon
                font.pixelSize: 22
                color: (root.toggled || root.halfToggled) ? Colors.colOnPrimary : Colors.colOnLayer3
            }
        }
        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
                left: sideRect.right
                leftMargin: Padding.large
                right: parent.right
                rightMargin: Padding.huge
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: Padding.tiny
                StyledText {
                    visible: root.showButtonName
                    Layout.fillWidth: true
                    Layout.rightMargin: Padding.massive
                    text: root.buttonName.charAt(0).toUpperCase() + root.buttonName.slice(1)
                    horizontalAlignment: Text.AlignHLeft
                    truncate: true
                    font.pixelSize: Fonts.sizes.normal
                    font.family: Fonts.family.variable
                    font.variableAxes: Fonts.variableAxes.title
                    color: root.toggled ? Colors.colOnPrimary : Colors.colOnLayer2
                }

                StyledText {
                    visible: root.buttonSubtext.length > 0
                    Layout.fillWidth: true
                    Layout.rightMargin: Padding.massive
                    text: root.buttonSubtext.charAt(0).toUpperCase() + root.buttonSubtext.slice(1)
                    horizontalAlignment: Text.AlignHLeft
                    truncate: true
                    font.pixelSize: Fonts.sizes.small
                    color: root.toggled ? Colors.colOnPrimary : Colors.colOnLayer2
                    opacity: 0.6
                }
            }
            Symbol {
                visible: root.dialogName && root.toggled
                text: "keyboard_arrow_right"
                color: Colors.colOnPrimary
                font.pixelSize: 15
                fill: 1
            }
        }
    }
}
