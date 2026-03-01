import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import org.kde.iconthemes

Item {
    id: root
    required property var modelData
    height: Math.max(75, contentColumn.implicitHeight + Padding.massive * 2)
    property string sound: "eventAccepted"
    Component.onCompleted: {
        timeout.restart();
        let sound = "info";
        switch (root.state) {
        case "error":
            sound = "event_invalid";
        case "success":
            sound = "task_completed";
        case "warning":
            sound = "power_low";
        default:
            sound = "device_added";
        }
        NoonUtils.playSound(sound);
    }
    states: [
        State {
            name: "error"
            when: modelData.status === "error"
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
            when: modelData.status === "success"
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
            when: modelData.status === "warn"
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
            when: modelData.status === ""
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

    StyledRect {
        id: bg
        anchors.fill: parent
        enableBorders: true
        color: Colors.colLayer2
        radius: Rounding.verylarge

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Padding.massive
            anchors.rightMargin: Padding.massive
            spacing: Padding.normal

            MaterialShapeWrappedMaterialSymbol {
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
                    truncate: true
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
        interval: root.state === "error" ? 3500 : 2500
        onTriggered: dismiss()
    }
    function dismiss() {
        GlobalStates.toasts.data.remove(modelData);
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
        intensity: 0.5
    }
}
