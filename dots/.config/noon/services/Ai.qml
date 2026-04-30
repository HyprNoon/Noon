pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.utils
import qs.common.functions

Singleton {
    id: root

    signal responseFinished

    readonly property Component aiMessageComponent: AiMessageData {}
    readonly property string interfaceRole: "interface"
    readonly property bool isResponding: requester.running
    readonly property bool currentModelHasApiKey: true
    readonly property var states: Mem.states.services.ai
    readonly property string currentSessionId: states.currentSessionId
    readonly property var tokenCount: states.tokenCount
    readonly property var modelList: states.models ?? []
    readonly property string currentModelId: states.model
    readonly property var skills: states.skills
    property var messageIDs: []
    property var messageByID: ({})
    property string pendingSkillName: ""
    property string pendingFilePath: ""
    property var postResponseHook

    function resumeInWeb(sessionId) {
        NoonUtils.execDetached(["opencode", "web"]);
    }

    function idForMessage(message) {
        return Date.now().toString(36) + Math.random().toString(36).substr(2, 8);
    }

    function addMessage(message, role) {
        if (message.length === 0)
            return;
        const aiMessage = aiMessageComponent.createObject(root, {
            "role": role,
            "content": message,
            "rawContent": message,
            "thinking": false,
            "done": true
        });
        const id = idForMessage(aiMessage);
        root.messageIDs = [...root.messageIDs, id];
        root.messageByID[id] = aiMessage;
    }

    function removeMessage(index) {
        if (index < 0 || index >= messageIDs.length)
            return;
        const id = root.messageIDs[index];
        root.messageIDs.splice(index, 1);
        root.messageIDs = [...root.messageIDs];
        delete root.messageByID[id];
    }

    function clearMessages() {
        root.messageIDs = [];
        root.messageByID = ({});
        root.tokenCount.input = -1;
        root.tokenCount.output = -1;
        root.tokenCount.total = -1;
    }

    function newSession() {
        root.clearMessages();
        root.states.currentSessionId = "";
        getSessions.running = true;
    }

    function loadChat(id) {
        root.clearMessages();
        root.states.currentSessionId = id.trim().toString();
    }

    function attachFile(filePath) {
        root.pendingFilePath = FileUtils.trimFileProtocol(filePath);
    }

    function getModel() {
        return {
            name: root.currentModelId
        };
    }
    function setSkill(skillName) {
        if (!skillName.includes(skills))
            return;
        root.pendingSkillName = skillName.trim();
    }
    function setModel(modelId) {
        if (!modelId || modelId.length === 0)
            return;
        root.currentModelId = modelId;
        states.model = modelId;
        root.addMessage("Model set to " + modelId, root.interfaceRole);
    }

    function sendUserMessage(message) {
        if (message.length === 0)
            return;
        root.addMessage(message, "user");
        requester.makeRequest(message);
    }

    function sendStealthMessage(message) {
        if (message.length === 0)
            return;
        const aiMessage = aiMessageComponent.createObject(root, {
            "role": "user",
            "content": message,
            "rawContent": message,
            "thinking": false,
            "done": true,
            "visibleToUser": false
        });
        const id = idForMessage(aiMessage);
        root.messageIDs = [...root.messageIDs, id];
        root.messageByID[id] = aiMessage;
        requester.makeRequest(message);
    }

    function regenerate(messageIndex) {
        if (messageIndex < 0 || messageIndex >= messageIDs.length)
            return;
        const id = root.messageIDs[messageIndex];
        const message = root.messageByID[id];
        if (message.role !== "assistant")
            return;
        for (let i = root.messageIDs.length - 1; i >= messageIndex; i--)
            root.removeMessage(i);
        const lastUserID = root.messageIDs[root.messageIDs.length - 1];
        const lastUser = root.messageByID[lastUserID];
        if (lastUser)
            requester.makeRequest(lastUser.rawContent);
    }

    function stop() {
        if (!requester.running)
            return;
        requester.running = false;
        if (requester.message) {
            requester.message.thinking = false;
            requester.message.done = true;
            requester.message.rawContent += "\n\n*[Stopped]*";
            requester.message.content += "\n\n*[Stopped]*";
        }
        getSessions.running = true;
        root.responseFinished();
    }

    function summarizePDF(pdf) {
        root.addMessage(qsTr("PDF summarization not available in this mode"), root.interfaceRole);
    }

    Process {
        id: skillsDiscovery
        running: true
        command: ["sh", "-c", "grep -rPl '^name:\\s*\\S+' " + Directories.services.skills + " --include='SKILL.md' | xargs -n1 dirname | xargs -n1 basename"]
        stdout: StdioCollector {
            onStreamFinished: {
                const skillNames = text.trim().split("\n").filter(Boolean);
                states.skills = skillNames;
            }
        }
    }

    Process {
        id: getModels
        running: states.models.length === 0
        command: ["sh", "-c", "opencode models < /dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const models = text.trim().split("\n").filter(m => m.trim().length > 0);
                states.models = models;
                if (!states.model || states.model.length === 0)
                    states.model = models[0];
            }
        }
    }

    Process {
        id: getSessions
        command: ["sh", "-c", "opencode session list --format json < /dev/null"]
        stdout: StdioCollector {
            onStreamFinished: data => root.states.sessions = JSON.parse(text)
        }
    }

    Process {
        id: requester
        property AiMessageData message

        function buildCommand(userMessage) {
            let flags = "--format json";
            if (root.pendingSkillName.length > 0)
                userMessage += " , using skill " + root.pendingSkillName;
            if (root.pendingFilePath.length > 0)
                flags += ` -f ${root.pendingFilePath}`;
            if (root.currentModelId.length > 0)
                flags += ` -m ${root.currentModelId}`;
            if (Mem.states.services.ai.currentSessionId.length > 0)
                flags += ` -s ${Mem.states.services.ai.currentSessionId}`;

            const cmd = ["sh", "-c", `opencode run '${userMessage}' ${flags} < /dev/null`];
            console.log("[Ai:requester] command:", cmd[2]);
            return cmd;
        }

        function makeRequest(userMessage) {
            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false
            });
            const id = root.idForMessage(requester.message);
            root.pendingFilePath = "";
            root.messageIDs = [...root.messageIDs, id];
            root.messageByID[id] = requester.message;
            requester.command = buildCommand(userMessage);
            requester.running = true;
        }

        function markDone() {
            requester.message.done = true;
            requester.message.thinking = false;
            if (root.postResponseHook) {
                root.postResponseHook();
                root.postResponseHook = null;
            }
            getSessions.running = true;
            root.responseFinished();
        }

        stdout: SplitParser {
            onRead: data => {
                const event = JSON.parse(data);

                if (event.sessionID && root.currentSessionId.length === 0) {
                    root.states.currentSessionId = event.sessionID;
                    console.log("[Ai:requester] session captured:", root.currentSessionId);
                }

                if (requester.message.thinking)
                    requester.message.thinking = false;

                switch (event.type) {
                case "text":
                    requester.message.rawContent += event.part.text;
                    requester.message.content += event.part.text;
                    break;
                case "step_finish":
                    const tokens = event.part.tokens;
                    if (tokens) {
                        root.tokenCount.input = tokens.input;
                        root.tokenCount.output = tokens.output;
                        root.tokenCount.total = tokens.total;
                    }
                    if (event.part.reason === "stop")
                        requester.markDone();
                    break;
                case "step_start":
                default:
                    break;
                }
            }
        }

        onExited: exitCode => {
            if (!requester.message.done && exitCode === 0)
                requester.markDone();
        }
    }
}
