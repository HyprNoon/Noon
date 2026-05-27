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
    property bool editing: false

    readonly property list<var> messageBlocks: StringUtils.splitMarkdownBlocks(root.messageData?.content)

    anchors.left: parent?.left
    anchors.right: parent?.right
    clip: true
    height: Math.max(columnLayout.implicitHeight + Padding.massive, 50)

    HoverHandler {
        id: hovered
    }

    MessageLoadingIndicator {
        id: loading
        messageData: root.messageData
        blockCount: root.messageBlocks.length
    }

    ColumnLayout {
        id: columnLayout
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Padding.normal

        StyledText {
            visible: root.messageData?.queued ?? false
            Layout.alignment: Qt.AlignLeft
            text: "Queued"
            font.pixelSize: Fonts.sizes.small
            color: Colors.colSubtext
        }

        ColumnLayout {
            spacing: Padding.small
            Layout.fillWidth: true

            Repeater {
                model: ScriptModel {
                    values: root.messageBlocks
                }
                delegate: DelegateChooser {
                    role: "type"

                    DelegateChoice {
                        roleValue: "text"
                        MessageTextBlock {
                            editing: root.editing
                            renderMarkdown: root.renderMarkdown
                            enableMouseSelection: root.enableMouseSelection
                            segmentContent: modelData.content
                            messageData: root.messageData
                            done: root.messageData?.done ?? false
                            forceDisableChunkSplitting: root.messageData?.content?.includes("```") ?? true
                        }
                    }

                    DelegateChoice {
                        roleValue: "code"
                        MessageCodeBlock {
                            editing: root.editing
                            renderMarkdown: root.renderMarkdown
                            enableMouseSelection: root.enableMouseSelection
                            segmentContent: modelData.content
                            segmentLang: modelData.lang
                            messageData: root.messageData
                        }
                    }

                    DelegateChoice {
                        roleValue: "think"
                        MessageThinkBlock {
                            editing: actionBar.editing
                            renderMarkdown: root.renderMarkdown
                            enableMouseSelection: root.enableMouseSelection
                            segmentContent: modelData.content
                            messageData: root.messageData
                            done: root.messageData?.done ?? false
                            completed: modelData.completed ?? false
                        }
                    }
                }
            }
        }

        Repeater {
            model: root.messageData?.tools ?? []
            delegate: ToolCallBlock {
                required property var modelData
                Layout.fillWidth: true
                tool: modelData?.tool ?? ""
                input: modelData?.input ?? ""
                output: modelData?.output ?? ""
                status: modelData.status
            }
        }

        Flow {
            visible: (root.messageData?.annotationSources?.length ?? 0) > 0
            spacing: 5
            Layout.fillWidth: true

            Repeater {
                model: ScriptModel {
                    values: root.messageData?.annotationSources ?? []
                }
                delegate: AnnotationSourceButton {
                    required property var modelData
                    displayText: modelData.text
                    url: modelData.url
                }
            }
        }

        MessageActionBar {
            id: actionBar
            visible: messageData?.done
            Layout.leftMargin: Padding.large
            Layout.alignment: Qt.AlignLeft
            messageIndex: root.messageIndex
            messageData: root.messageData
        }
    }
}
