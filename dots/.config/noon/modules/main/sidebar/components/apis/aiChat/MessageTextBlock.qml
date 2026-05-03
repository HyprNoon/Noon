import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ColumnLayout {
    id: root

    property bool editing: false
    property bool renderMarkdown: false
    property bool enableMouseSelection: false
    property string segmentContent: ""
    property var messageData: {}
    property bool done: true
    property bool forceDisableChunkSplitting: false

    property string shownText: ""
    property bool fadeChunkSplitting: !forceDisableChunkSplitting && !editing && !/\n\|/.test(shownText) && Mem.options.sidebar.behavior.aiTextFadeIn

    property var textLineOpacities: []

    Layout.fillWidth: true
    spacing: 0

    function processText(input) {
        if (!input)
            return "";
        return editing ? input : LatexService.cleanFormula(input);
    }

    function computeChunks() {
        if (!root.shownText)
            return [];
        return root.fadeChunkSplitting ? root.shownText.split(/\n\n(?= {0,2})|\n(?= {0,2}[-\*])/g).filter(line => line.trim() !== "") : [root.shownText];
    }

    function syncOpacities(chunks) {
        const prev = root.textLineOpacities;
        const next = [];
        for (let i = 0; i < chunks.length; i++) {
            if (i < prev.length) {
                next.push(prev[i]);
            } else {
                next.push(root.messageData?.done ? 1 : 0);
            }
        }
        root.textLineOpacities = next;
    }

    onEditingChanged: {
        shownText = processText(segmentContent);
    }

    onSegmentContentChanged: {
        if (segmentContent)
            shownText = processText(segmentContent);
    }

    onShownTextChanged: {
        const chunks = computeChunks();
        syncOpacities(chunks);
        chunksModel.values = chunks;
    }

    onFadeChunkSplittingChanged: {
        const chunks = computeChunks();
        syncOpacities(chunks);
        chunksModel.values = chunks;
    }

    Repeater {
        id: textLinesRepeater

        model: ScriptModel {
            id: chunksModel
            values: []
        }

        delegate: TextArea {
            id: textArea

            required property int index
            required property string modelData

            Layout.fillWidth: true
            visible: opacity > 0
            opacity: root.fadeChunkSplitting ? (root.textLineOpacities[index] ?? (root.messageData?.done ? 1 : 0)) : 1
            readOnly: !editing
            selectByMouse: enableMouseSelection || editing
            renderType: Text.NativeRendering
            font.family: Fonts.family.reading
            font.hintingPreference: Font.PreferNoHinting
            font.pixelSize: Fonts.sizes.large * Mem.states.sidebar.apis.fontScale
            selectedTextColor: Colors.m3.m3onSecondaryContainer
            selectionColor: Colors.colSecondaryContainer
            wrapMode: TextEdit.Wrap
            color: root.messageData?.thinking ? Colors.colSubtext : Colors.colOnLayer1
            textFormat: renderMarkdown ? TextEdit.MarkdownText : TextEdit.PlainText
            text: modelData

            Behavior on opacity {
                Anim {}
            }

            Connections {
                target: root
                function onTextLineOpacitiesChanged() {
                    if (index > 0 && index < root.textLineOpacities.length) {
                        if (root.textLineOpacities[index - 1] >= 1) {
                            const next = [...root.textLineOpacities];
                            next[index] = 1;
                            root.textLineOpacities = next;
                        }
                    }
                }
            }

            onTextChanged: {
                if (root.editing)
                    segmentContent = text;
            }

            onLinkActivated: link => {
                Qt.openUrlExternally(link);
                NoonUtils.callIpc("sidebar hide");
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                hoverEnabled: true
                cursorShape: parent.hoveredLink !== "" ? Qt.PointingHandCursor : (enableMouseSelection || editing) ? Qt.IBeamCursor : Qt.ArrowCursor
            }
        }
    }
}
