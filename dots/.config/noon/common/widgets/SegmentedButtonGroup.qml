import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.common
import qs.common.utils
import qs.common.widgets

StyledRect {
    id: root

    color: "transparent"
    implicitHeight: 40
    implicitWidth: row.implicitWidth
    radius: Rounding.full
    border.width: 1
    border.color: Colors.m3.m3outlineVariant
    clip: true
    required property list<string> content
    property int selectedIndex: 0
    Behavior on implicitWidth {
        enabled: false
    }
    RowLayout {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 0
        Repeater {
            model: root.content
            delegate: Btn {
                required property var modelData
                required property int index
                Layout.fillHeight: true
                text: modelData
                isActive: index === root.selectedIndex
                onClicked: root.selectedIndex = index
                showSeparator: index < root.content.length - 1
            }
        }
    }

    component Btn: StyledRect {
        id: root
        property string text
        property bool isActive: false
        property bool showSeparator: false
        signal clicked
        Layout.fillHeight: true
        implicitWidth: row.implicitWidth + Padding.massive
        color: isActive ? Colors.colPrimaryContainer : Colors.colLayer2
        RowLayout {
            id: row
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -4
            Symbol {
                icon: isActive ? "check" : ""
                fill: root.isActive
                color: text.color
                font.pixelSize: 20
                animateChange: true
            }
            StyledText {
                id: text
                text: root.text
                font.pixelSize: Fonts.sizes.normal
                color: root.isActive ? Colors.colOnPrimaryContainer : Colors.colOnLayer1
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: root.clicked()
        }

        Rectangle {
            visible: root.showSeparator
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            implicitWidth: 1
            color: Colors.m3.m3outlineVariant
        }
    }
}
