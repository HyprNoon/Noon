import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: dragRect

    property var taskData
    property alias symbol: symb.text
    property alias colSymbol: symb.color

    width: 100
    height: 60
    radius: Rounding.large
    opacity: 0.9
    enableBorders: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        spacing: 15

        Symbol {
            id: symb
            font.pixelSize: Fonts.sizes.normal
        }

        ColumnLayout {
            Layout.fillWidth: true

            StyledText {
                width: 180
                Layout.fillWidth: true
                text: taskData.content
                truncate: true
                opacity: taskData.status === TodoService.Status.Done ? 0.7 : 1
                font.strikeout: taskData.status === TodoService.Status.Done
            }

            StyledText {
                id: state
                color: Colors.colSubtext
                text: TodoService.statusNames[taskData.status]
                opacity: taskData.status === TodoService.Status.Done ? 0.3 : 0.45
                font.pixelSize: 11
                Layout.fillWidth: true
            }
        }
    }
}
