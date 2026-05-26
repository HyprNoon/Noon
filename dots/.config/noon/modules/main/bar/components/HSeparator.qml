import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.store

RowLayout {
    id: root
    visible: Mem.options.bar.appearance.enableSeparators
    height: bg.height
    Layout.fillWidth: true
    Layout.leftMargin: Padding.large
    Layout.rightMargin: Padding.large
    Layout.margins: 4
    spacing: 2
    state: Mem.options.bar.appearance.separatorsMode
    Rectangle {
        id: bg
        color: Colors.colOutlineVariant
        state: root.state
        states: [
            State {
                name: "dot"
                PropertyChanges {
                    target: bg
                    implicitHeight: 4
                    implicitWidth: 4
                    radius: 999
                }
            },
            State {
                name: "thick"
                PropertyChanges {
                    target: bg
                    implicitHeight: 3
                    implicitWidth: 20
                    radius: 999
                }
            },
            State {
                name: "thin"
                PropertyChanges {
                    target: bg
                    implicitHeight: 1
                    implicitWidth: 20
                    radius: 4
                }
            }
        ]
    }
}
