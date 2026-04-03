import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: entryArea

    z: 99
    implicitHeight: 65
    implicitWidth: Sizes.beamSize.width
    radius: Rounding.full
    color: Colors.colLayer0
    enableBorders: false

    anchors {
        bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
        bottomMargin: -60 + Sizes.elevationMargin
    }
    Item {
        id: icon
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: Padding.massive
        }
        implicitWidth: 40

        MaterialShape {
            z: 999
            implicitSize: 42
            shape: MaterialShape.Cookie6Sided
            anchors.centerIn: parent

            readonly property string inputText: inputField.text

            color: inputField.focus ? Colors.colPrimary : Colors.colLayer3
            onInputTextChanged: if (inputField.text.length === 0)
                rotation = 0

            RotationAnimation on rotation {
                running: icon.inputText.length > 0
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 9000
                easing.type: Easing.Linear
            }
            Behavior on color {
                CAnim {}
            }
            Behavior on rotation {
                Anim {}
            }
        }

        StyledText {
            z: 999
            anchors.verticalCenterOffset: 2
            anchors.centerIn: parent
            color: Colors.colOnPrimary
            animateChange: true
            text: HyprlandService.keyboardLayoutShortName
            font.weight: 900
        }
    }

    StyledRect {
        id: rectArea
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: enter.left
            left: icon.right
            rightMargin: Padding.small
            leftMargin: Padding.large
            margins: Padding.normal
        }
        color: Colors.colLayer2
        radius: Rounding.full

        TextField {
            id: inputField
            anchors.fill: parent
            enabled: !root.context.unlockInProgress
            leftPadding: Padding.massive * 1.5
            rightPadding: Padding.massive * 1.5
            focus: true
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            placeholderText: "Enter your password"
            font.pixelSize: 16
            color: Colors.m3.m3onSurface
            selectionColor: Colors.m3.m3primary
            onAccepted: root.context.tryUnlock()
            onTextChanged: root.context.currentText = this.text
            scale: focus ? 1.05 : 1
            background: null

            Connections {
                function onCurrentTextChanged() {
                    inputField.text = root.context.currentText;
                }

                target: root.context
            }

            Behavior on scale {
                Anim {}
            }
        }
    }

    RippleButtonWithIcon {
        id: enter
        buttonRadius: Rounding.full
        enabled: inputField.text.length > 0 && !root.context.unlockInProgress
        materialIcon: "arrow_forward"
        implicitSize: 45
        releaseAction: () => {
            root.context.tryUnlock();
        }

        anchors {
            right: parent.right
            rightMargin: Padding.normal
            verticalCenter: parent.verticalCenter
        }

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }

    Behavior on implicitWidth {
        Anim {}
    }

    Anim on anchors.bottomMargin {
        from: -implicitHeight
        to: Sizes.elevationMargin
    }
}
