import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    property bool editing: false
    property int autoSaveInterval: 5000
    color: Colors.colLayer1
    radius: Rounding.verylarge
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    Component.onCompleted: {
        textArea.text = NotesService.content;
        textArea.forceActiveFocus();
    }

    // Auto-save timer
    Timer {
        id: autoSaveTimer

        interval: root.autoSaveInterval
        running: NotesService.isDirty
        repeat: false
        onTriggered: NotesService.save()
    }

    // Timer to update relative time display
    Timer {
        interval: 1000
        running: NotesService.lastSaved !== ""
        repeat: true
        onTriggered: {
            if (!NotesService.isDirty && NotesService.lastSaved)
                statusLabel.text = "Saved " + DateTimeService.getRelativeTime(NotesService.lastSaved);
        }
    }

    // Sync content changes from service
    Connections {
        function onContentChanged() {
            if (textArea.text !== NotesService.content)
                textArea.text = NotesService.content;
        }

        target: NotesService
    }

    // Background watermark
    StyledText {
        z: 0
        visible: true
        font.pixelSize: 500
        text: "text_snippet"
        font.family: Fonts.family.iconMaterial
        color: Colors.colLayer0

        anchors {
            left: parent.left
            leftMargin: 200
            bottom: parent.bottom
            bottomMargin: -120
        }

        transform: Rotation {
            angle: 45
        }
    }

    // Main layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Rounding.verylarge
        spacing: Padding.massive

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            spacing: 0

            StyledText {
                text: NotesService.fileName.replace(/.md/g, "")
                Layout.fillWidth: true
                color: Colors.colOnLayer1
                font.variableAxes: Fonts.variableAxes.title
                font.family: Fonts.family.main
                font.pixelSize: Fonts.sizes.title
            }

            StyledText {
                id: statusLabel
                text: NotesService.isDirty ? "Editing..." : (NotesService.lastSaved ? "Saved " + DateTimeService.getRelativeTime(NotesService.lastSaved) : "Ready")
                color: !NotesService.isDirty ? Colors.colTertiary : Colors.colPrimary
                Layout.fillWidth: true
                font.pixelSize: Fonts.sizes.small
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TextArea {
                id: textArea

                color: Colors.m3.m3onSurface
                font.pixelSize: Fonts.sizes.normal + 2
                font.family: Fonts.family.main
                selectByMouse: root.editing
                wrapMode: TextArea.Wrap
                readOnly: !root.editing
                focus: true
                textFormat: root.editing ? TextEdit.PlainText : TextEdit.MarkdownText
                selectedTextColor: Colors.m3.m3onSecondaryContainer
                selectionColor: Colors.colSecondaryContainer
                placeholderText: root.editing ? "Start typing your notes here..." : "Switch to edit mode to start writing..."
                placeholderTextColor: Colors.m3.m3onSurfaceVariant
                background: null
                onTextChanged: {
                    if (root.editing && text !== NotesService.content) {
                        NotesService.content = text;
                        NotesService.isDirty = true;
                        autoSaveTimer.restart();
                    }
                }
                onLinkActivated: link => {
                    return Qt.openUrlExternally(link);
                }
                Keys.onPressed: event => {
                    if (event.modifiers === Qt.ControlModifier) {
                        if (event.key === Qt.Key_S) {
                            NotesService.save();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_E) {
                            root.editing = !root.editing;
                            event.accepted = true;
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                    cursorShape: parent.hoveredLink !== "" ? Qt.PointingHandCursor : root.editing ? Qt.IBeamCursor : Qt.ArrowCursor
                }
            }
        }
    }
    NotesControls {}
}
