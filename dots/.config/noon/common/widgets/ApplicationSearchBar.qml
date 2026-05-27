import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root
    property alias query: inputArea.text
    property alias placeholderText: inputArea.placeholderText
    property alias text: inputArea.text
    property alias inputArea: inputArea
    visible: false
    implicitHeight: 50
    implicitWidth: 325

    anchors {
        bottom: parent.bottom
        bottomMargin: Padding.massive
        horizontalCenter: parent.horizontalCenter
    }
    Anim on anchors.bottomMargin {
        from: -implicitHeight - Padding.massive
        to: Padding.massive
        duration: Animations.durations.verylarge
    }
    StyledRectangularShadow {
        target: bg
    }
    StyledRect {
        id: bg
        anchors.fill: parent
        radius: Rounding.verylarge
        color: Colors.colLayer2
        enableBorders: true
        RowLayout {
            anchors {
                leftMargin: Padding.verylarge
                rightMargin: Padding.verylarge
                fill: parent
            }
            spacing: Padding.normal
            Symbol {
                icon: "search"
                font.pixelSize: 24
                fill: 1
                color: Colors.colSubtext
            }
            StyledTextField {
                id: inputArea
                focus: true
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
