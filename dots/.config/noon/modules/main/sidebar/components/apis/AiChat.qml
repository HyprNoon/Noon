import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import "aiChat"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Noon.Services

Item {
    id: root
    property real padding: 0
    property var inputField: messageInputField
    property string commandPrefix: "/"
    property bool isRecording: false
    property var suggestionQuery: ""
    property var suggestionList: []
    signal expandRequested

    readonly property var allCommands: [
        {
            name: "scale",
            description: qsTr("Change response's font scale by decimal."),
            execute: args => {
                Mem.states.sidebar.apis.fontScale = args.join(" ").trim();
            }
        },
        {
            name: "attach",
            description: qsTr("Attach a file. Only works with Gemini."),
            execute: args => {
                Ai.attachFile(args.join(" ").trim());
            }
        },
        {
            name: "model",
            description: qsTr("Choose model"),
            execute: args => Ai.setModel(args[0])
        },
        {
            name: "skill",
            description: qsTr("Choose Skill"),
            execute: args => {
                Ai.setSkill(args[0]);
            }
        },
        {
            name: "load",
            description: qsTr("Load chat"),
            execute: args => {
                Ai.loadChat(args.join(" ").trim());
            }
        },
        {
            name: "clear",
            description: qsTr("Clear chat history"),
            execute: () => Ai.clearMessages()
        }
    ]

    function handleInput(inputText) {
        if (inputText.startsWith(root.commandPrefix)) {
            const parts = inputText.split(" ");
            const command = parts[0].substring(1);
            const args = parts.slice(1);
            const cmd = root.allCommands.find(c => c.name === command);
            cmd ? cmd.execute(args) : Ai.addMessage(qsTr("Unknown command: ") + command, Ai.interfaceRole);
        } else {
            Ai.sendUserMessage(inputText);
        }
        messageListView.positionViewAtEnd();
    }

    function decodeImageAndAttach(entry) {
        Ai.attachFile(ClipboardService.getImagePath(entry));
    }

    function handleCommandSuggestions(query) {
        const source = root.allCommands.map(cmd => ({
                    name: cmd.name,
                    prepared: Fuzzy.prepare(cmd.name)
                }));
        const results = query.length === 0 ? root.allCommands.map(cmd => ({
                    target: cmd.name
                })) : Fuzzy.go(query, source, {
            all: true,
            key: "name"
        });

        root.suggestionList = results.map(r => ({
                    name: root.commandPrefix + r.target,
                    displayName: root.commandPrefix + r.target,
                    description: root.allCommands.find(c => c.name === r.target)?.description ?? ""
                }));
    }

    function handleModelSuggestions() {
        const query = messageInputField.text.split(" ")[1] ?? "";
        const source = Ai.modelList.map(m => ({
                    name: m,
                    prepared: Fuzzy.prepare(m)
                }));
        const results = query.length === 0 ? Ai.modelList.map(m => ({
                    target: m
                })) : Fuzzy.go(query, source, {
            all: true,
            key: "name"
        });
        const isFirst = messageInputField.text.trim().split(" ").length === 1;

        root.suggestionQuery = query;
        root.suggestionList = results.map(r => ({
                    name: (isFirst ? root.commandPrefix + "model " : "") + r.target,
                    displayName: r.target,
                    description: qsTr("Set model to %1").arg(r.target)
                }));
    }

    function handleSkillsSuggestions() {
        const query = messageInputField.text.split(" ")[1] ?? "";

        const source = Ai.skills.map(f => ({
                    name: f,
                    prepared: Fuzzy.prepare(f)
                }));

        const results = query.length === 0 ? Ai.skills.map(f => ({
                    target: f
                })) : Fuzzy.go(query, source, {
            all: true,
            key: "name"
        });

        const isFirst = messageInputField.text.trim().split(" ").length === 1;

        root.suggestionQuery = query;
        root.suggestionList = results.map(r => ({
                    name: (isFirst ? root.commandPrefix + "skill " : "") + r.target,
                    displayName: r.target,
                    description: qsTr("Load %1 skill").arg(r.target)
                }));
    }

    function handleLoadSuggestions() {
        const query = messageInputField.text.split(" ")[1] ?? "";
        const source = Mem.states.services.ai.sessions.map(s => ({
                    name: s.title,
                    prepared: Fuzzy.prepare(s.title),
                    obj: s
                }));
        const results = query.length === 0 ? Mem.states.services.ai.sessions.map(s => ({
                    target: s
                })) : Fuzzy.go(query, source, {
            all: true,
            key: "name"
        }).map(r => ({
                    target: r.obj
                }));
        const isFirst = messageInputField.text.trim().split(" ").length === 1;

        root.suggestionQuery = query;
        root.suggestionList = results.map(r => ({
                    name: (isFirst ? root.commandPrefix + "load " : "") + r.target.id,
                    displayName: r.target.title,
                    description: qsTr("Load chat from %1").arg(new Date(r.target.updated).toLocaleString())
                }));
    }

    // suggestion dispatch table — keyed by command name
    readonly property var argHandlers: ({
            "model": handleModelSuggestions,
            "skill": handleSkillsSuggestions,
            "load": handleLoadSuggestions
        })

    function updateSuggestions() {
        const trimmed = messageInputField.text.trim();
        const words = trimmed.split(" ");
        const commandWord = words[0].substring(1);
        const hasArg = words.length > 1;

        if (!trimmed.startsWith(root.commandPrefix)) {
            root.suggestionList = [];
            return;
        }

        if (hasArg) {
            const handler = root.argHandlers[commandWord];
            handler ? handler() : (root.suggestionList = []);
        } else {
            const isExact = root.allCommands.some(c => c.name === commandWord);
            isExact && root.argHandlers[commandWord] ? root.argHandlers[commandWord]() : handleCommandSuggestions(commandWord);
        }
    }

    Keys.onPressed: event => {
        messageInputField.forceActiveFocus();
        if (event.modifiers === Qt.NoModifier) {
            if (event.key === Qt.Key_PageUp) {
                messageListView.contentY = Math.max(0, messageListView.contentY - messageListView.height / 2);
                event.accepted = true;
            } else if (event.key === Qt.Key_PageDown) {
                messageListView.contentY = Math.min(messageListView.contentHeight - messageListView.height / 2, messageListView.contentY + messageListView.height / 2);
                event.accepted = true;
            }
        }
        if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_L)
                Ai.clearMessages();
            if (event.key === Qt.Key_R)
                Ai.regenerate(Ai.messageIDs.length - 1);
            if (event.key === Qt.Key_O)
                root.expandRequested();
            event.accepted = true;
        }
    }

    function handleInputKeyPress(event) {
        switch (event.key) {
        case Qt.Key_Tab:
            suggestions.acceptSelectedWord();
            event.accepted = true;
            break;
        case Qt.Key_Up:
            if (suggestions.visible) {
                suggestions.selectedIndex = Math.max(0, suggestions.selectedIndex - 1);
                event.accepted = true;
            }
            break;
        case Qt.Key_Down:
            if (suggestions.visible) {
                suggestions.selectedIndex = Math.min(root.suggestionList.length - 1, suggestions.selectedIndex + 1);
                event.accepted = true;
            }
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (event.modifiers & Qt.ShiftModifier) {
                messageInputField.insert(messageInputField.cursorPosition, "\n");
            } else {
                const text = messageInputField.text;
                messageInputField.clear();
                root.handleInput(text);
            }
            event.accepted = true;
            break;
        case Qt.Key_Escape:
            if (Ai.pendingFilePath.length > 0) {
                Ai.attachFile("");
                event.accepted = true;
            }
            break;
        default:
            if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_V) {
                if (event.modifiers & Qt.ShiftModifier) {
                    messageInputField.text += Quickshell.clipboardText;
                    event.accepted = true;
                    return;
                }
                const entry = ClipboardService.entries[0];
                if (ClipboardService.isImage(0)) {
                    decodeImageAndAttach(entry);
                    event.accepted = true;
                } else if (StringUtils.cleanCliphistEntry(entry).startsWith("file://")) {
                    Ai.attachFile(decodeURIComponent(StringUtils.cleanCliphistEntry(entry)));
                    event.accepted = true;
                }
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        anchors {
            fill: parent
            margins: root.padding
        }
        spacing: root.padding

        StyledRect {
            clip: true
            color: "transparent"
            radius: Rounding.small
            Layout.fillWidth: true
            Layout.fillHeight: true

            StyledRectangularShadow {
                z: 1
                target: statusBg
                opacity: messageListView.atYBeginning ? 0 : 1
                visible: opacity > 0
                Behavior on opacity {
                    Anim {}
                }
            }

            StyledListView {
                id: messageListView
                z: 0
                anchors.fill: parent
                spacing: Padding.veryhuge
                animateMovement: true
                popin: true
                topMargin: statusBg.implicitHeight + statusBg.anchors.topMargin * 2
                fasterInteractions: false

                onContentHeightChanged: if (atYEnd)
                    positionViewAtEnd()
                onCountChanged: if (atYEnd)
                    positionViewAtEnd()

                model: ScriptModel {
                    values: Ai.messageIDs.filter(id => Ai.messageByID[id]?.visibleToUser ?? true)
                }
                delegate: AiMessage {
                    required property var modelData
                    required property int index
                    messageIndex: index
                    messageData: Ai.messageByID[modelData]
                    messageInputField: root.inputField
                }
            }

            PagePlaceholder {
                z: 2
                shown: Ai.messageIDs.length === 0
                icon: "neurology"
                title: "AI"
                description: "access various AI models\n press '/' for more options "
                shape: MaterialShape.Shape.PixelCircle
            }

            ScrollToBottomButton {
                z: 3
                target: messageListView
            }
        }

        DescriptionBox {
            text: root.suggestionList[suggestions.selectedIndex]?.description ?? ""
            showArrows: root.suggestionList.length > 1
        }

        FlowButtonGroup {
            id: suggestions
            visible: root.suggestionList.length > 0 && messageInputField.text.length > 0
            property int selectedIndex: 0
            Layout.fillWidth: true
            spacing: 5

            function acceptSuggestion(word) {
                const words = messageInputField.text.trim().split(/\s+/);
                words[words.length - 1] = word;
                messageInputField.text = words.join(" ") + " ";
                messageInputField.cursorPosition = messageInputField.text.length;
                messageInputField.forceActiveFocus();
            }

            function acceptSelectedWord() {
                if (suggestions.selectedIndex >= 0 && suggestions.selectedIndex < suggestionRepeater.count)
                    suggestions.acceptSuggestion(root.suggestionList[suggestions.selectedIndex].name);
            }

            Repeater {
                id: suggestionRepeater
                model: {
                    suggestions.selectedIndex = 0;
                    return root.suggestionList.slice(0, 10);
                }
                delegate: ApiCommandButton {
                    id: commandButton
                    colBackground: suggestions.selectedIndex === index ? Colors.colSecondaryContainerHover : Colors.colSecondaryContainer
                    bounce: false
                    contentItem: StyledText {
                        font.pixelSize: Fonts.sizes.small
                        color: Colors.m3.m3onSurface
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData.displayName ?? modelData.name
                    }
                    onHoveredChanged: if (commandButton.hovered)
                        suggestions.selectedIndex = index
                    onClicked: suggestions.acceptSuggestion(modelData.name)
                }
            }
        }

        Rectangle {
            id: inputWrapper
            property real spacing: 5
            Layout.fillWidth: true
            radius: Rounding.verylarge - root.padding
            color: Colors.colLayer1
            implicitHeight: Math.max(inputFieldRowLayout.implicitHeight + inputFieldRowLayout.anchors.topMargin + commandButtonsRow.implicitHeight + commandButtonsRow.anchors.bottomMargin + spacing, 45) + (attachedFileIndicator.implicitHeight + spacing + attachedFileIndicator.anchors.topMargin)
            clip: true
            Behavior on implicitHeight {
                Anim {}
            }

            AttachedFileIndicator {
                id: attachedFileIndicator
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: visible ? 5 : 0
                }
                filePath: Ai.pendingFilePath
                onRemove: Ai.attachFile("")
            }

            RowLayout {
                id: inputFieldRowLayout
                anchors {
                    top: attachedFileIndicator.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 5
                }
                spacing: 0

                StyledTextArea {
                    id: messageInputField
                    wrapMode: TextArea.Wrap
                    Layout.fillWidth: true
                    padding: 10
                    color: activeFocus ? Colors.m3.m3onSurface : Colors.m3.m3onSurfaceVariant
                    placeholderText: qsTr('Message the model... "%1" for commands').arg(root.commandPrefix)
                    background: null

                    onTextChanged: {
                        if (text.length === 0) {
                            root.suggestionQuery = "";
                            root.suggestionList = [];
                            return;
                        }
                        root.updateSuggestions();
                    }

                    Keys.onPressed: event => root.handleInputKeyPress(event)
                }

                Item {
                    id: sendButton
                    implicitHeight: 50
                    implicitWidth: 50
                    readonly property bool toggled: Ai.isResponding || messageInputField.text.length > 0

                    SequentialAnimation {
                        id: loadingAnimation
                        loops: Animation.Infinite
                        running: Ai.isResponding || root.isRecording
                        PropertyAction {
                            target: shape
                            property: "rotation"
                            value: 0
                        }
                        Anim {
                            target: shape
                            property: "rotation"
                            from: 0
                            to: 360
                            duration: 4500
                        }
                        onStopped: shape.rotation = 0
                    }

                    MaterialShape {
                        id: shape
                        implicitSize: 38
                        anchors.centerIn: parent
                        shape: {
                            if (!Ai.isResponding && messageInputField.text.length === 0)
                                return MaterialShape.Shape.Cookie6Sided;
                            if (Ai.isResponding)
                                return MaterialShape.Shape.Cookie12Sided;
                            return MaterialShape.Shape.Clover8Leaf;
                        }
                        color: Colors.colPrimary
                        Behavior on rotation {
                            enabled: !Ai.isResponding
                            Anim {}
                        }
                    }

                    Symbol {
                        text: {
                            if (!Ai.isResponding && messageInputField.text.length === 0)
                                return "mic";
                            if (Ai.isResponding)
                                return "stop";
                            return "arrow_upward";
                        }
                        fill: 1
                        font.pixelSize: 18
                        anchors.centerIn: parent
                        color: Colors.colOnPrimary
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: sendButton.toggled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (Ai.isResponding)
                                Ai.stop();
                            else if (messageInputField.text.length > 0) {
                                root.handleInput(messageInputField.text);
                                messageInputField.clear();
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: commandButtonsRow
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: 5
                    leftMargin: 10
                    rightMargin: 5
                }
                spacing: 4

                ApiInputBoxIndicator {
                    icon: "api"
                    text: Ai.getModel().name
                    tooltipText: qsTr("Current model: %1\nSet it with %2model MODEL").arg(Ai.getModel().name).arg(root.commandPrefix)
                }

                ApiInputBoxIndicator {
                    icon: "token"
                    text: Ai.tokenCount.total
                    tooltipText: qsTr("Total token count\nInput: %1\nOutput: %2").arg(Ai.tokenCount.input).arg(Ai.tokenCount.output)
                }

                Item {
                    Layout.fillWidth: true
                }

                ButtonGroup {
                    padding: 0
                    Repeater {
                        model: [
                            {
                                name: "",
                                sendDirectly: false,
                                dontAddSpace: true
                            },
                            {
                                name: "clear",
                                sendDirectly: true
                            }
                        ]
                        delegate: ApiCommandButton {
                            property string cmd: root.commandPrefix + modelData.name
                            buttonText: cmd
                            downAction: () => {
                                if (modelData.sendDirectly) {
                                    root.handleInput(cmd);
                                    messageInputField.text = "";
                                } else {
                                    messageInputField.text = cmd + (modelData.dontAddSpace ? "" : " ");
                                    messageInputField.cursorPosition = messageInputField.text.length;
                                    messageInputField.forceActiveFocus();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
