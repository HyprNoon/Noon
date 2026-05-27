import QtQuick.Controls.Material
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ComboBox {
    id: root
    implicitHeight: 45
    implicitWidth: 110
    Material.theme: Material.System

    delegate: ItemDelegate {
        id: delegated
        width: ListView.view.width
        height: 45
        highlighted: root.highlightedIndex === index
        readonly property bool isSelected: index === root.currentIndex
        contentItem: RowLayout {
            anchors.centerIn: parent
            spacing: Padding.normal

            Symbol {
                text: isSelected ? "check" : modelData?.icon ?? ""
                font.pixelSize: 24
                color: delegated.highlighted ? Colors.m3.m3onPrimary : Colors.colOnSurface
            }

            StyledText {
                Layout.fillWidth: true
                text: modelData?.name ?? modelData ?? ""
                font.pixelSize: 14
                truncate: true
                color: delegated.highlighted ? Colors.m3.m3onPrimary : Colors.colOnSurface
            }
        }

        background: Rectangle {
            color: parent.highlighted ? Colors.m3.m3primary : "transparent"
            radius: Rounding.large
        }
    }

    contentItem: StyledText {
        anchors.left: parent.left
        anchors.right: parent.right
        font.variableAxes: Fonts.variableAxes.main
        text: root.displayText
        color: Colors.colOnLayer2
        leftPadding: Padding.huge
        rightPadding: Padding.huge
        truncate: true
    }

    background: Rectangle {
        color: Colors.colLayer3
        radius: Rounding.small
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible ? popup.close() : popup.open()
    }

    popup: Popup {
        id: popup
        padding: Padding.normal
        implicitWidth: root.width + padding * 4
        implicitHeight: Math.min(contentItem.implicitHeight + padding, 300)
        height: 0
        opacity: 0
        x: (root.width - width) / 2
        y: root.height + 1.5 * padding
        closePolicy: Popup.NoAutoClose

        onAboutToShow: {
            height = 0;
            opacity = 0;
            openAnim.restart();
        }

        onAboutToHide: {
            closeAnim.restart();
        }

        background: StyledRect {
            color: Colors.colSurfaceContainerHigh
            radius: Rounding.verylarge
            // enableBorders: true
        }

        contentItem: StyledListView {
            clip: true
            hint: false
            radius: Rounding.large
            implicitHeight: contentHeight
            currentIndex: root.highlightedIndex
            spacing: Padding.tiny
            model: root.popup.visible ? root.delegateModel : []
        }

        ParallelAnimation {
            id: openAnim
            PropertyAnimation {
                target: popup
                property: "opacity"
                to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                target: popup
                property: "height"
                to: popup.implicitHeight
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        ParallelAnimation {
            id: closeAnim
            PropertyAnimation {
                target: popup
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.InCubic
            }
            PropertyAnimation {
                target: popup
                property: "y"
                from: popup.y
                to: popup.y + 2 * popup.padding
                duration: 150
                easing.type: Easing.InCubic
            }
            onStopped: {
                popup.visible = false;
                popup.y = Qt.binding(() => root.height + 1.5 * popup.padding);
            }
        }
    }
}
