import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.common
import qs.common.widgets

StyledRect {
    id: root
    color: Colors.colLayer1
    radius: Rounding.verylarge
    focus: true
    Component.onCompleted: Qt.callLater(() => inputField.forceActiveFocus())
    function submit() {
        PolkitService.submit(inputField.text);
    }

    Connections {
        target: PolkitService
        function onInteractionAvailableChanged() {
            if (!PolkitService.interactionAvailable)
                return;
            inputField.text = "";
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.veryhuge
        spacing: Padding.huge

        Spacer {}

        MaterialShapeWrappedMaterialSymbol {
            Layout.alignment: Qt.AlignHCenter
            iconSize: 180
            text: "security"
            shape: MaterialShape.Cookie6Sided
        }

        WindowDialogTitle {
            id: titleText
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "Permission Request"
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: Padding.huge
            spacing: Padding.huge

            MaterialTextField {
                id: inputField
                Layout.fillWidth: true
                enabled: PolkitService.interactionAvailable
                placeholderText: PolkitService.flow?.inputPrompt.trim().slice(0, -1) || ""
                echoMode: !PolkitService.flow?.responseVisible ? TextInput.Password : TextInput.Normal
                onAccepted: root.submit()

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        PolkitService.cancel();
                    }
                }
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: PolkitService?.flow?.message ?? ""
                color: Colors.colOnSurfaceVariant
                wrapMode: Text.Wrap

                font.weight: 900
                font.family: Fonts.family.monospace
                font.pixelSize: Fonts.sizes.normal
            }
        }

        Spacer {}

        WindowDialogButtonRow {
            Item {
                Layout.fillWidth: true
            }
            DialogButton {
                buttonText: "Cancel"
                onClicked: PolkitService.cancel()
            }
            DialogButton {
                enabled: PolkitService.interactionAvailable
                buttonText: "OK"
                onClicked: root.submit()
            }
        }
    }
}
