import qs.services
import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property int messageIndex
    property var messageData
    property bool editing: false
    property bool copied: false
    spacing: Padding.small

    Repeater {
        model: [
            {
                icon: copied ? "check" : "content_copy",
                action: () => {
                    ClipboardService.copy(root.messageData.content);
                    root.copied = true;
                }
            },
            {
                visible: messageData.role === "user",
                icon: "refresh",
                action: () => Ai.regenerate(root.messageIndex)
            },
            {
                visible: messageData.role === "user",
                icon: root.editing ? "check" : "stylus",
                action: () => {
                    root.editing = !root.editing;
                }
            },
            {
                icon: "delete",
                action: () => Ai.removeMessage(root.messageIndex)
            }
        ]
        delegate: Symbol {
            required property var modelData
            visible: modelData?.visible ?? true
            text: modelData.icon
            font.pixelSize: 18
            color: Colors.colSubtext
            fill: 0
            MouseArea {
                anchors.fill: parent
                onClicked: () => modelData.action()
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
