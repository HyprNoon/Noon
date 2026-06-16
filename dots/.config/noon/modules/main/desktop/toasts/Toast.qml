import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    required property var modelData
    required property int index
    required property Item list
    implicitHeight: Math.max(75, contentColumn.implicitHeight + Padding.massive * 2)

    Component.onCompleted: {
        timeout.restart();
        let sound = () => {
            switch (root.state) {
            case "error":
                return "event_invalid";
            case "success":
                return "task_completed";
            case "warning":
                return "power_low";
            default:
                return "device_added";
            }
        };
        NoonUtils.playSound(sound);
    }

    state: modelData?.status ?? "normal"

    states: [
        State {
            name: "error"
            PropertyChanges {
                target: shape
                color: Colors.colErrorContainer
                colSymbol: Colors.colOnErrorContainer
                shape: MaterialShape.Shape.Cookie9Sided
            }
            PropertyChanges {
                target: bg
                color: Colors.colError
            }
            PropertyChanges {
                target: title
                color: Colors.colErrorContainer
            }
        },
        State {
            name: "success"
            PropertyChanges {
                target: shape
                color: Colors.colSuccessContainer
                colSymbol: Colors.colOnSuccessContainer
                shape: MaterialShape.Shape.Cookie9Sided
            }
            PropertyChanges {
                target: bg
                color: Colors.colSuccess
            }
            PropertyChanges {
                target: title
                color: Colors.colSuccessContainer
            }
        },
        State {
            name: "warning"
            PropertyChanges {
                target: shape
                color: Colors.colTertiary
                colSymbol: Colors.colOnTertiary
                shape: MaterialShape.Shape.Cookie12Sided
            }
            PropertyChanges {
                target: bg
                color: Colors.colTertiaryContainer
            }
        },
        State {
            name: "normal"
            PropertyChanges {
                target: shape
                color: Colors.colPrimaryContainer
                colSymbol: Colors.colOnPrimaryContainer
                shape: MaterialShape.Shape.Cookie6Sided
            }
            PropertyChanges {
                target: bg
                color: Colors.colLayer2
            }
        }
    ]

    ShaderRect {
        id: bg
        anchors.fill: parent
        enableBorders: false
        color: Colors.colLayer2
        radius: Rounding.huge

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Padding.massive
            anchors.rightMargin: Padding.massive
            spacing: Padding.normal

            MaterialShapeWrappedSymbol {
                id: shape
                text: modelData.icon
                iconSize: 24
                implicitSize: 48
                fill: 1
            }

            ColumnLayout {
                id: contentColumn
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                spacing: Padding.tiny
                StyledText {
                    id: title
                    text: modelData.message
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: Fonts.sizes.normal
                    font.variableAxes: Fonts.variableAxes.title
                }
                StyledText {
                    text: modelData.title
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    color: root.state === "normal" ? Colors.colSubtext : ColorUtils.adaptToAccent(Colors.colSurfaceContainer, title.color)
                    font.pixelSize: Fonts.sizes.normal
                    font.variableAxes: Fonts.variableAxes.main
                }
            }
        }
    }
    Timer {
        id: timeout
        interval: root.state === "error" ? 4000 : 2500
        onTriggered: dismiss()
    }
    function dismiss() {
        Globals.toasts.data = Globals.toasts.data.filter(item => item.id !== modelData.id);
    }

    MouseArea {
        z: 999
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: dismiss()
        onEntered: timeout.running = false
        onExited: timeout.running = true
    }
    StyledRectangularShadow {
        target: bg
    }
}
