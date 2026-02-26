import QtQuick.Controls.Material
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ComboBox {
    id: root
    Layout.preferredHeight: 45
    Layout.preferredWidth: 210
    Material.theme: Material.System

    delegate: ItemDelegate {
        id: delegated
        width: ListView.view.width
        height: 45
        highlighted: root.highlightedIndex === index

        contentItem: RowLayout {
            anchors.centerIn: parent
            spacing: Padding.normal

            Symbol {
                fill: 1
                text: modelData?.icon ?? ""
                font.pixelSize: 20
                color: delegated.highlighted ? Colors.m3.m3primary : Colors.colOnLayer1
            }

            StyledText {
                Layout.fillWidth: true
                text: modelData?.name ?? modelData ?? ""
                font.pixelSize: 14
                truncate: true
                color: delegated.highlighted ? Colors.m3.m3primary : Colors.colOnLayer1
            }
        }

        background: Rectangle {
            color: parent.highlighted ? Colors.m3.m3primaryContainer : "transparent"
            radius: Rounding.large
        }
    }

    contentItem: StyledText {
        anchors {
            left: parent.left
            right: parent.right
        }
        text: root.displayText
        color: Colors.colOnLayer1
        leftPadding: Padding.large
        rightPadding: Padding.verylarge
        truncate: true
    }

    background: Rectangle {
        color: Colors.colLayer2
        radius: Rounding.small
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible ? popup.close() : popup.open()
    }

    popup: Popup {
        id: popup
        width: root.width + Padding.massive * 3
        padding: Padding.large
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
            color: Colors.colLayer2
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
