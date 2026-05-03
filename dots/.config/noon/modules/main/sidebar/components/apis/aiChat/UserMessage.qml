import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    property int messageIndex
    property var messageData
    property var messageInputField
    property bool enableMouseSelection: false
    property bool renderMarkdown: true
    readonly property bool editing: actionBar.editing

    anchors.left: parent?.left
    anchors.right: parent?.right
    clip: true
    height: Math.max(contentCol.implicitHeight + Padding.massive, 50)

    HoverHandler {
        id: hovered
    }

    ColumnLayout {
        id: contentCol
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Padding.normal

        Loader {
            Layout.fillWidth: true
            active: root.messageData?.files?.length > 0
            sourceComponent: AttachedFileIndicator {
                filePath: root.messageData.files[0] ?? ""
                canRemove: false
            }
        }

        StyledText {
            visible: root.messageData?.queued ?? false
            Layout.rightMargin: Padding.massive + 5
            Layout.alignment: Qt.AlignRight
            text: "Queued"
            font.pixelSize: Fonts.sizes.small
            color: Colors.colSubtext
        }

        WrapperRectangle {
            Layout.maximumWidth: root.width - Padding.huge
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Padding.huge
            color: Colors.colLayer3
            radius: Rounding.large
            margin: Padding.small
            child: MessageTextBlock {
                focus: root.editing
                editing: root.editing
                renderMarkdown: root.renderMarkdown
                enableMouseSelection: root.enableMouseSelection
                segmentContent: root.messageData?.content ?? ""
                messageData: root.messageData
                done: root.messageData?.done ?? false
                forceDisableChunkSplitting: root.messageData?.content?.includes("```") ?? true
            }
        }

        MessageActionBar {
            id: actionBar
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Padding.massive
            messageIndex: root.messageIndex
            messageData: root.messageData
        }
    }
}
