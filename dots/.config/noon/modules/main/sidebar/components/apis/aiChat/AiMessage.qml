import Noon.Services
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

StyledRect {
    id: root
    property int messageIndex
    property var messageData
    property var messageInputField

    property bool enableMouseSelection: false
    property bool renderMarkdown: true
    property bool editing: false
    property bool rightMode: messageData.role === "user"
    property list<var> messageBlocks: StringUtils.splitMarkdownBlocks(root.messageData?.content)
    property size loadingSize: Qt.size(62, 32)
    color: rightMode ? Colors.colPrimaryContainer : Colors.colLayer1
    clip: true
    anchors.left: !rightMode ? parent?.left : undefined
    anchors.right: rightMode ? parent?.right : undefined
    property int attachedWidth: messageData.annotationSources.length > 0 ? loadingSize.width : 0
    implicitHeight: Math.max(attachedWidth, loadingSize.height, columnLayout.implicitHeight)
    implicitWidth: Math.max(attachedWidth, loadingSize.width, Math.min(messageData.content.length * (Fonts.sizes.normal), parent.width - Padding.massive * 2))
    radius: Math.max(24, Rounding.verylarge)
    animationDuration: Animations.durations.small

    function saveMessage() {
        if (!root.editing)
            return;
        // Get all Loader children (each represents a segment)
        const segments = messageContentColumnLayout.children.map(child => child.segment).filter(segment => (segment));

        // Reconstruct markdown
        const newContent = segments.map(segment => {
            if (segment.type === "code") {
                const lang = segment.lang ? segment.lang : "";
                // Remove trailing newlines
                const code = segment.content.replace(/\n+$/, "");
                return "```" + lang + "\n" + code + "\n```";
            } else {
                return segment.content;
            }
        }).join("");

        root.editing = false;
        root.messageData.content = newContent;
    }

    Keys.onPressed: event => {
        if ( // Prevent de-select
        event.key === Qt.Key_Control || event.key == Qt.Key_Shift || event.key == Qt.Key_Alt || event.key == Qt.Key_Meta) {
            event.accepted = true;
        }
        // Ctrl + S to save
        if ((event.key === Qt.Key_S) && event.modifiers == Qt.ControlModifier) {
            root.saveMessage();
            event.accepted = true;
        }
    }

    StyledText {
        z: 999
        visible: (root.messageBlocks.length < 1) && (!root.messageData.done)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -4
        text: "..."
        font.family: Fonts.family.reading
        font.pixelSize: Fonts.sizes.large
        color: Colors.colSubtext
    }

    ColumnLayout { // Main layout of the whole thing
        id: columnLayout
        anchors.fill: parent
        anchors.leftMargin: Padding.normal
        anchors.rightMargin: Padding.normal
        spacing: Padding.large

        Loader {
            Layout.fillWidth: true
            active: root.messageData?.localFilePath && root.messageData?.localFilePath.length > 0
            sourceComponent: AttachedFileIndicator {
                filePath: root.messageData?.localFilePath
                canRemove: false
            }
        }

        ColumnLayout { // Message content
            id: messageContentColumnLayout
            spacing: 0

            Repeater {
                model: ScriptModel {
                    values: root.messageBlocks
                }
                delegate: DelegateChooser {
                    id: messageDelegate
                    role: "type"

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
                            editing: root.editing
                            renderMarkdown: root.renderMarkdown
                            enableMouseSelection: root.enableMouseSelection
                            segmentContent: modelData.content
                            messageData: root.messageData
                            done: root.messageData?.done ?? false
                            completed: modelData.completed ?? false
                        }
                    }
                    DelegateChoice {
                        roleValue: "text"
                        MessageTextBlock {
                            editing: root.editing
                            renderMarkdown: root.renderMarkdown
                            enableMouseSelection: root.enableMouseSelection
                            segmentContent: modelData.content
                            messageData: root.messageData
                            done: root.messageData?.done ?? false
                            forceDisableChunkSplitting: root.messageData?.content.includes("```") ?? true
                        }
                    }
                }
            }
        }

        Flow {
            // Annotations
            visible: root.messageData?.annotationSources?.length > 0
            spacing: 5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft

            Repeater {
                model: ScriptModel {
                    values: root.messageData?.annotationSources || []
                }
                delegate: AnnotationSourceButton {
                    required property var modelData
                    displayText: modelData.text
                    url: modelData.url
                }
            }
        }

        Flow {
            // Search queries
            visible: root.messageData?.searchQueries?.length > 0
            spacing: 5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft

            Repeater {
                model: ScriptModel {
                    values: root.messageData?.searchQueries || []
                }
                delegate: SearchQueryButton {
                    required property var modelData
                    query: modelData
                }
            }
        }
    }
    StyledMenu {
        id: contextMenu
        content: [
            {
                "text": "Pronounce",
                "materialIcon": "text_to_speech",
                "action": () => {
                    TtsService.pronounce(root.messageData?.content);
                }
            },
            {
                "text": "Copy",
                "materialIcon": "content_copy",
                "action": () => {
                    ClipboardService.copy(root.messageData?.content);
                }
            },
            {
                "text": "Edit",
                "materialIcon": "stylus",
                "action": () => {
                    root.editing = !root.editing;
                    if (!root.editing) {
                        root.saveMessage();
                    }
                }
            },
            {
                "text": "Delete",
                "materialIcon": "delete",
                "action": () => {
                    Ai.removeMessage(messageIndex);
                }
            },
            {
                "materialIcon": "code",
                "text": "LaTex",
                "action": () => {
                    renderMarkdown = !renderMarkdown;
                }
            },
            {
                "text": "Regenerate",
                "materialIcon": "restart_alt",
                "action": () => {
                    Ai.regenerate(messageIndex);
                }
            }
        ]
    }
    MouseArea {
        id: eventArea
        z: 999
        anchors.fill: root
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: event => {
            if (event.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }
    }
}
