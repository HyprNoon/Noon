import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import Noon.Utils
import org.kde.syntaxhighlighting

Item {
    id: root
    focus: true
    required property var window
    property string currentFile: Globals.applications.editor.currentFile
    property bool modified: false
    property int fontSizeOffset: 0

    function edit(filePath) {
        Globals.applications.editor.currentFile = filePath;
        loadFile(FileUtils.trimFileProtocol(filePath));
    }

    function navigate(pos, select) {
        textEdit.moveCursorSelection(pos, select ? TextEdit.SelectCharacter : TextEdit.MoveAnchor);
    }

    function findText(query, forward = true) {
        if (!query)
            return;
        let start = forward ? textEdit.selectionEnd : textEdit.selectionStart - 1;
        let idx = forward ? textEdit.text.indexOf(query, start) : textEdit.text.lastIndexOf(query, start);
        if (idx === -1)
            idx = forward ? textEdit.text.indexOf(query, 0) : textEdit.text.lastIndexOf(query, textEdit.text.length);
        if (idx !== -1) {
            textEdit.select(idx, idx + query.length);
            textEdit.cursorPosition = idx + query.length;
        }
    }

    function toggleSearchBar() {
        searchBar.visible = !searchBar.visible;
        if (searchBar.visible) {
            searchBar.inputArea.forceActiveFocus();
            searchBar.inputArea.selectAll();
        } else {
            textEdit.forceActiveFocus();
        }
    }

    function formatJSON() {
        try {
            textEdit.text = JSON.stringify(JSON.parse(textEdit.text), null, 4);
        } catch (e) {}
    }

    function loadFile(path) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "file://" + path);
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && (xhr.status === 200 || xhr.status === 0)) {
                textEdit.text = xhr.responseText;
                modified = false;
                window.title = "editing - " + path;
            }
        };
        xhr.send();
    }

    function save() {
        if (!currentFile)
            return;
        var path = FileUtils.trimFileProtocol(currentFile);
        var xhr = new XMLHttpRequest();
        xhr.open("PUT", "file://" + path);
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && (xhr.status === 200 || xhr.status === 0)) {
                modified = false;
                window.title = "editing - " + path;
            }
        };
        xhr.send(textEdit.text);
    }

    Rectangle {
        id: editorContainer
        anchors.fill: parent
        visible: root.currentFile.length > 0
        color: Colors.colLayer0

        RowLayout {
            anchors.fill: parent
            spacing: 0

            StyledRect {
                id: lineNumberArea
                Layout.preferredWidth: 42
                Layout.fillHeight: true
                color: Colors.colLayer1
                Flickable {
                    anchors.fill: parent
                    contentY: flickable.contentY
                    interactive: false
                    Column {
                        Repeater {
                            model: textEdit.lineCount
                            StyledText {
                                width: 32
                                height: textEdit.contentHeight / Math.max(1, textEdit.lineCount)
                                text: index + 1
                                font: textEdit.font
                                color: Colors.colOnLayer1Inactive
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                clip: true
                StyledFlickable {
                    id: flickable
                    anchors.fill: parent
                    anchors.margins: Padding.normal
                    contentWidth: textEdit.paintedWidth
                    contentHeight: textEdit.paintedHeight

                    TextEdit {
                        id: textEdit
                        width: Math.max(flickable.width, paintedWidth)
                        height: Math.max(flickable.height, paintedHeight)
                        font {
                            family: Fonts.family.monospace
                            pixelSize: Fonts.sizes.huge + root.fontSizeOffset
                            weight: Font.DemiBold
                        }
                        color: Colors.colOnLayer0
                        selectByMouse: true
                        selectByKeyboard: true
                        selectionColor: Colors.colPrimaryContainer
                        selectedTextColor: Colors.colOnPrimaryContainer
                        cursorVisible: true
                        persistentSelection: true

                        SyntaxHighlighter {
                            textEdit: textEdit
                            repository: Repository
                            definition: Repository.definitionForFileName(FileUtils.trimFileProtocol(root.currentFile))
                            theme: Colors.m3.darkmode ? "Monokai" : "ayu Light"
                        }

                        Rectangle {
                            id: lineIndicator
                            y: Math.floor(textEdit.cursorRectangle.y)
                            x: flickable.contentX
                            width: flickable.width
                            height: textEdit.cursorRectangle.height
                            color: Colors.colLayer2
                            opacity: 0.4
                            z: -1
                        }

                        onCursorRectangleChanged: {
                            if (cursorRectangle.y < flickable.contentY)
                                flickable.contentY = cursorRectangle.y;
                            else if (cursorRectangle.y + cursorRectangle.height > flickable.contentY + flickable.height)
                                flickable.contentY = cursorRectangle.y + cursorRectangle.height - flickable.height;
                        }

                        Keys.onPressed: event => {
                            const ctrl = event.modifiers & Qt.ControlModifier;
                            const shift = event.modifiers & Qt.ShiftModifier;
                            const mods = event.modifiers & (Qt.ControlModifier | Qt.ShiftModifier);

                            if (mods === (Qt.ControlModifier | Qt.ShiftModifier) && event.key === Qt.Key_F) {
                                root.formatJSON();
                                return event.accepted = true;
                            }

                            if (ctrl && !shift) {
                                switch (event.key) {
                                case Qt.Key_S:
                                    root.save();
                                    break;
                                case Qt.Key_F:
                                    root.toggleSearchBar();
                                    break;
                                case Qt.Key_Plus:
                                    root.fontSizeOffset += 2;
                                    break;
                                case Qt.Key_Minus:
                                    root.fontSizeOffset -= 2;
                                    break;
                                case Qt.Key_A:
                                    selectAll();
                                    break;
                                case Qt.Key_Backspace:
                                    navigate(cursorPosition, true);
                                    remove(selectionStart, selectionEnd);
                                    break;
                                default:
                                    return;
                                }
                                return event.accepted = true;
                            }

                            switch (event.key) {
                            case Qt.Key_Tab:
                                insert(cursorPosition, "    ");
                                break;
                            case Qt.Key_Home:
                                navigate(text.lastIndexOf("\n", cursorPosition - 1) + 1, shift);
                                break;
                            case Qt.Key_End:
                                let e = text.indexOf("\n", cursorPosition);
                                navigate(e === -1 ? length : e, shift);
                                break;
                            case Qt.Key_PageUp:
                                navigate(positionAt(cursorRectangle.x, Math.max(0, cursorRectangle.y - flickable.height)), shift);
                                break;
                            case Qt.Key_PageDown:
                                navigate(positionAt(cursorRectangle.x, Math.min(contentHeight, cursorRectangle.y + flickable.height)), shift);
                                break;
                            case Qt.Key_Left:
                                if (ctrl)
                                    cursorWordBackward(shift);
                                else
                                    return;
                                break;
                            case Qt.Key_Right:
                                if (ctrl)
                                    cursorWordForward(shift);
                                else
                                    return;
                                break;
                            default:
                                return;
                            }
                            event.accepted = true;
                        }

                        Keys.onReturnPressed: event => {
                            let line = text.substring(0, cursorPosition).split('\n').pop();
                            let indent = line.match(/^\s*/)[0] + (line.trim().endsWith('{') || line.trim().endsWith('[') ? '    ' : '');
                            insert(cursorPosition, '\n' + indent);
                            event.accepted = true;
                        }

                        onTextChanged: if (root.currentFile.length > 0 && !root.modified) {
                            root.modified = true;
                            window.title = "editing - " + root.currentFile + " *";
                        }
                    }
                }
            }
        }

        EditorStatusIsland {}
        ApplicationSearchBar {
            id: searchBar
            visible: false
            placeholderText: "Find..."
            inputArea.onTextChanged: root.findText(searchBar.inputArea.text, true)
            inputArea.onAccepted: root.findText(searchBar.inputArea.text, true)

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    root.toggleSearchBar();
                    event.accepted = true;
                }
                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    root.findText(searchBar.inputArea.text, !(event.modifiers & Qt.ShiftModifier));
                    event.accepted = true;
                }
            }
        }
    }

    Timer {
        running: root.currentFile.length > 0 && root.modified
        interval: 200
        onTriggered: root.window.expandSidebar = false
    }

    Connections {
        target: Globals.applications.editor
        function onCurrentFileChanged() {
            edit(currentFile);
        }
    }

    PagePlaceholder {
        anchors.centerIn: parent
        icon: "code"
        shown: root.currentFile.length === 0
        title: "No File Opened"
        description: "Choose a file or drop it to edit"
    }
}
