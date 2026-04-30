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
        if ((event.modifiers & Qt.ControlModifier)) {
            if (event.key === Qt.Key_L)
                Ai.clearMessages();
            if (event.key === Qt.Key_R) {
                Ai.regenerate(Ai.messageIDs.length - 1);
            }
            if (event.key === Qt.Key_O) {
                root.expandRequested();
            }

            event.accepted = true;
        }
    }
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
            // Handle special commands
            const command = inputText.split(" ")[0].substring(1);
            const args = inputText.split(" ").slice(1);
            const commandObj = root.allCommands.find(cmd => cmd.name === `${command}`);
            if (commandObj) {
                commandObj.execute(args);
            } else {
                Ai.addMessage(qsTr("Unknown command: ") + command, Ai.interfaceRole);
            }
        } else {
            Ai.sendUserMessage(inputText);
        }

        // Always scroll to bottom when user sends a message
        messageListView.positionViewAtEnd();
    }
    function decodeImageAndAttach(entry) {
        Ai.attachFile(ClipboardService.getImagePath(entry));
    }
    component StatusItem: MouseArea {
        id: statusItem
        property string icon
        property string statusText
        property string description
        hoverEnabled: true
        implicitHeight: statusItemRowLayout.implicitHeight
        implicitWidth: statusItemRowLayout.implicitWidth

        RowLayout {
            id: statusItemRowLayout
            spacing: 4
            Symbol {
                text: statusItem.icon
                iconSize: Fonts.sizes.huge
                color: Colors.colSubtext
            }
            StyledText {
                visible: text.length > 0
                font.pixelSize: Fonts.sizes.small
                text: statusItem.statusText
                color: Colors.colSubtext
                animateChange: true
            }
        }

        StyledToolTip {
            content: statusItem.description
            extraVisibleCondition: false
            alternativeVisibleCondition: statusItem.containsMouse
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

            StyledListView { // Message list
                id: messageListView
                z: 0
                anchors.fill: parent
                spacing: Padding.veryhuge
                animateMovement: true
                popin: true
                topMargin: statusBg.implicitHeight + statusBg.anchors.topMargin * 2
                fasterInteractions: false
                property int lastResponseLength: 0
                onContentHeightChanged: {
                    if (atYEnd)
                        positionViewAtEnd();

                    // Qt.callLater(positionViewAtEnd);
                }
                onCountChanged: {
                    // Auto-scroll when new messages are added
                    if (atYEnd)
                        positionViewAtEnd();
                }

                model: ScriptModel {
                    values: Ai.messageIDs.filter(id => {
                        const message = Ai.messageByID[id];
                        return message?.visibleToUser ?? true;
                    })
                }
                delegate: AiMessage {
                    required property var modelData
                    required property int index
                    messageIndex: index
                    messageData: {
                        Ai.messageByID[modelData];
                    }
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

        FlowButtonGroup { // Suggestions
            id: suggestions
            visible: root.suggestionList.length > 0 && messageInputField.text.length > 0
            property int selectedIndex: 0
            Layout.fillWidth: true
            spacing: 5

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

                    onHoveredChanged: {
                        if (commandButton.hovered) {
                            suggestions.selectedIndex = index;
                        }
                    }
                    onClicked: {
                        suggestions.acceptSuggestion(modelData.name);
                    }
                }
            }

            function acceptSuggestion(word) {
                const words = messageInputField.text.trim().split(/\s+/);
                if (words.length > 0) {
                    words[words.length - 1] = word;
                } else {
                    words.push(word);
                }
                const updatedText = words.join(" ") + " ";
                messageInputField.text = updatedText;
                messageInputField.cursorPosition = messageInputField.text.length;
                messageInputField.forceActiveFocus();
            }

            function acceptSelectedWord() {
                if (suggestions.selectedIndex >= 0 && suggestions.selectedIndex < suggestionRepeater.count) {
                    const word = root.suggestionList[suggestions.selectedIndex].name;
                    suggestions.acceptSuggestion(word);
                }
            }
        }

        Rectangle { // Input area
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

            RowLayout { // Input field and send button
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

                        root.suggestionList = results.map(result => ({
                                    name: root.commandPrefix + result.target,
                                    displayName: root.commandPrefix + result.target,
                                    description: root.allCommands.find(c => c.name === result.target)?.description ?? ""
                                }));
                    }

                    function handleModelSuggestions() {
                        root.suggestionQuery = messageInputField.text.split(" ")[1] ?? "";

                        const results = root.suggestionQuery.length === 0 ? Ai.modelList.map(model => ({
                                    target: model
                                })) : Fuzzy.go(root.suggestionQuery, Ai.modelList.map(model => ({
                                    name: model,
                                    prepared: Fuzzy.prepare(model)
                                })), {
                            all: true,
                            key: "name"
                        });

                        root.suggestionList = results.map(result => ({
                                    name: `${messageInputField.text.trim().split(" ").length == 1 ? (root.commandPrefix + "model ") : ""}${result.target}`,
                                    displayName: result.target,
                                    description: qsTr("Set model to %1").arg(result.target)
                                }));
                    }

                    function handlePromptSuggestions() {
                        root.suggestionQuery = messageInputField.text.split(" ")[1] ?? "";

                        const results = root.suggestionQuery.length === 0 ? Ai.promptFiles.map(file => ({
                                    target: file
                                })) : Fuzzy.go(root.suggestionQuery, Ai.promptFiles.map(file => ({
                                    name: file,
                                    prepared: Fuzzy.prepare(file)
                                })), {
                            all: true,
                            key: "name"
                        });

                        root.suggestionList = results.map(result => ({
                                    name: `${messageInputField.text.trim().split(" ").length == 1 ? (root.commandPrefix + "prompt ") : ""}${result.target}`,
                                    displayName: FileUtils.trimFileExt(FileUtils.fileNameForPath(result.target)),
                                    description: qsTr("Load prompt from %1").arg(result.target)
                                }));
                    }

                    function handleLoadSuggestions() {
                        root.suggestionQuery = messageInputField.text.split(" ")[1] ?? "";

                        const results = root.suggestionQuery.length === 0 ? Mem.states.services.ai.sessions.map(session => ({
                                    target: session
                                })) : Fuzzy.go(root.suggestionQuery, Mem.states.services.ai.sessions.map(session => ({
                                    name: session.title,
                                    prepared: Fuzzy.prepare(session.title),
                                    obj: session
                                })), {
                            all: true,
                            key: "name"
                        }).map(result => ({
                                    target: result.obj
                                }));

                        root.suggestionList = results.map(result => {
                            const session = result.target;
                            return {
                                name: `${messageInputField.text.trim().split(" ").length == 1 ? (root.commandPrefix + "load ") : ""}${session.id}`,
                                displayName: session.title,
                                description: qsTr("Load chat from %1").arg(new Date(session.updated).toLocaleString())
                            };
                        });
                    }

                    onTextChanged: {
                        if (messageInputField.text.length === 0) {
                            root.suggestionQuery = "";
                            root.suggestionList = [];
                            return;
                        }

                        const trimmed = messageInputField.text.trim();
                        const words = trimmed.split(" ");

                        if (!trimmed.startsWith(root.commandPrefix)) {
                            root.suggestionList = [];
                            return;
                        }

                        const commandWord = words[0].substring(1);
                        const hasArgument = words.length > 1;

                        const argHandlers = {
                            "model": handleModelSuggestions,
                            "prompt": handlePromptSuggestions,
                            "load": handleLoadSuggestions
                        };

                        if (hasArgument) {
                            if (argHandlers[commandWord]) {
                                argHandlers[commandWord]();
                            } else {
                                root.suggestionList = [];
                            }
                        } else {
                            const isExactCommand = root.allCommands.some(cmd => cmd.name === commandWord);
                            if (isExactCommand && argHandlers[commandWord]) {
                                argHandlers[commandWord]();
                            } else {
                                handleCommandSuggestions(commandWord);
                            }
                        }
                    }

                    function accept() {
                        root.handleInput(text);
                        text = "";
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Tab) {
                            suggestions.acceptSelectedWord();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up && suggestions.visible) {
                            suggestions.selectedIndex = Math.max(0, suggestions.selectedIndex - 1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down && suggestions.visible) {
                            suggestions.selectedIndex = Math.min(root.suggestionList.length - 1, suggestions.selectedIndex + 1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                            if (event.modifiers & Qt.ShiftModifier) {
                                messageInputField.insert(messageInputField.cursorPosition, "\n");
                                event.accepted = true;
                            } else {
                                const inputText = messageInputField.text;
                                messageInputField.clear();
                                root.handleInput(inputText);
                                event.accepted = true;
                            }
                        } else if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_V) {
                            if (event.modifiers & Qt.ShiftModifier) {
                                messageInputField.text += Quickshell.clipboardText;
                                event.accepted = true;
                                return;
                            }
                            const currentClipboardEntry = ClipboardService.entries[0];
                            const cleanCliphistEntry = StringUtils.cleanCliphistEntry(currentClipboardEntry);
                            if (ClipboardService.isImage(0)) {
                                decodeImageAndAttach(currentClipboardEntry);
                                event.accepted = true;
                                return;
                            } else if (cleanCliphistEntry.startsWith("file://")) {
                                Ai.attachFile(decodeURIComponent(cleanCliphistEntry));
                                event.accepted = true;
                                return;
                            }
                            event.accepted = false;
                        } else if (event.key === Qt.Key_Escape) {
                            if (Ai.pendingFilePath.length > 0) {
                                Ai.attachFile("");
                                event.accepted = true;
                            } else {
                                event.accepted = false;
                            }
                        }
                    }
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
                            let shape;
                            if (messageInputField.text.length === 0 && !Ai.isResponding) {
                                shape = "Cookie6Sided";
                            } else if (Ai.isResponding) {
                                shape = "Cookie12Sided";
                            } else
                                shape = "Clover8Leaf";
                            return MaterialShape.Shape[shape];
                        }
                        color: Colors.colPrimary
                        Behavior on rotation {
                            enabled: !Ai.isResponding
                            Anim {}
                        }
                    }

                    Symbol {
                        text: {
                            if (messageInputField.text.length === 0 && !Ai.isResponding) {
                                return "mic";
                            } else if (Ai.isResponding) {
                                return "stop";
                            } else
                                return "arrow_upward";
                        }
                        fill: 1
                        font.pixelSize: 18
                        anchors.centerIn: parent
                        color: Colors.colOnPrimary
                        // rotation: -shape.rotation
                    }

                    MouseArea {
                        id: eventArea
                        enabled: sendButton.toggled
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (messageInputField.text.length === 0 && !Ai.isResponding) {
                                // Ai.record();
                            } else if (Ai.isResponding) {
                                Ai.stop();
                            } else {
                                root.handleInput(messageInputField.text);
                                messageInputField.clear();
                            }
                        }
                    }
                }
            }

            RowLayout { // Controls
                id: commandButtonsRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                spacing: 4

                property var commandsShown: [
                    {
                        name: "",
                        sendDirectly: false,
                        dontAddSpace: true
                    },
                    {
                        name: "clear",
                        sendDirectly: true
                    },
                ]

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
                    // Command buttons
                    padding: 0

                    Repeater {
                        // Command buttons
                        model: commandButtonsRow.commandsShown
                        delegate: ApiCommandButton {
                            property string commandRepresentation: `${root.commandPrefix}${modelData.name}`
                            buttonText: commandRepresentation
                            downAction: () => {
                                if (modelData.sendDirectly) {
                                    root.handleInput(commandRepresentation);
                                } else {
                                    messageInputField.text = commandRepresentation + (modelData.dontAddSpace ? "" : " ");
                                    messageInputField.cursorPosition = messageInputField.text.length;
                                    messageInputField.forceActiveFocus();
                                }
                                if (modelData.name === "clear") {
                                    messageInputField.text = "";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
