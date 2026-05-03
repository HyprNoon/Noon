pragma Singleton
pragma ComponentBehavior: Bound
import Noon.Utils
import QtQuick
import Quickshell
import Quickshell.Io
import qs.store
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
    readonly property var modelPoses: posesView.data

    property var sessions: []
    property var messageIDs: []
    property var messageQueue: []
    property var messageByID: ({})
    property string pendingSkillName: ""
    property string pendingFilePath: ""
    property var postResponseHook

    function idForMessage(message) {
        return Date.now().toString(36) + Math.random().toString(36).substr(2, 8);
    }
    function openInTerm(sessionId = root.states.currentSessionId) {
        NoonUtils.runInTerminal(`opencode -s '${sessionId}'`);
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
        root.messageQueue = [];
        root.states.currentSessionId = "";
        refreshSessions();
    }

    function loadChat(id) {
        if (!id)
            return;
        root.clearMessages();
        root.messageQueue = [];
        root.states.currentSessionId = id.trim().toString();
        loadMessages(root.states.currentSessionId);
    }

    function loadMessages(id) {
        db.queryAsync("SELECT m.id as msg_id, m.data as msg_data, p.data as part_data " + "FROM message m LEFT JOIN part p ON p.message_id = m.id " + "WHERE m.session_id = ? " + "ORDER BY m.rowid ASC", [id]);
    }

    function getModel() {
        return {
            name: root.currentModelId
        };
    }

    function setSkill(skillName) {
        const trimmed = skillName.trim();
        if (root.skills.includes(trimmed))
            root.pendingSkillName = trimmed;
    }

    function setModel(modelId) {
        if (!modelId || modelId.length === 0)
            return;
        states.model = modelId;
        root.addMessage("Model set to " + modelId, root.interfaceRole);
    }

    function sendUserMessage(message) {
        if (message.length === 0)
            return;
        const filePath = root.pendingFilePath;
        const aiMessage = aiMessageComponent.createObject(root, {
            "role": "user",
            "content": message,
            "rawContent": message,
            "thinking": false,
            "done": true,
            "queued": true,
            "files": filePath.length > 0 ? [filePath] : []
        });
        const id = idForMessage(aiMessage);
        root.messageIDs = [...root.messageIDs, id];
        root.messageByID[id] = aiMessage;
        root.messageQueue = [...root.messageQueue,
            {
                id: id,
                text: message
            }
        ];
        if (!requester.running)
            processQueue();
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
        root.messageQueue = [...root.messageQueue,
            {
                id: id,
                text: message
            }
        ];
        if (!requester.running)
            processQueue();
    }

    function processQueue() {
        if (root.messageQueue.length === 0)
            return;
        const next = root.messageQueue[0];
        root.messageQueue = root.messageQueue.slice(1);
        const msg = root.messageByID[next.id];
        if (msg)
            msg.queued = false;
        requester.makeRequest(next.text);
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
        if (lastUser) {
            const fakeId = root.idForMessage(lastUser);
            root.messageQueue = [
                {
                    id: fakeId,
                    text: lastUser.rawContent
                },
                ...root.messageQueue];
            root.messageByID[fakeId] = lastUser;
            if (!requester.running)
                processQueue();
        }
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
        refreshSessions();
        root.responseFinished();
        processQueue();
    }

    function refreshSessions() {
        root.sessions = db.tables.session.all().map(r => ({
                    id: r.id,
                    title: r.title,
                    created: r.time_created,
                    updated: r.time_updated,
                    directory: r.directory,
                    projectId: r.project_id
                }));
    }

    Process {
        id: openCodeServer
        running: true
        command: ["opencode", "serve", "--port", "4096", "--hostname", "127.0.0.1"]
    }

    Process {
        id: skillsDiscovery
        running: true
        command: ["sh", "-c", "grep -rPl '^name:\\s*\\S+' " + Directories.services.skills + " --include='SKILL.md' | xargs -n1 dirname | xargs -n1 basename"]
        stdout: StdioCollector {
            onStreamFinished: {
                states.skills = text.trim().split("\n").filter(Boolean);
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

    SQLReader {
        id: db
        path: Directories.services.opencodeDb
        onLoaded: refreshSessions()
    }

    Connections {
        target: db
        function onQueryFinished(rows) {
            const grouped = {};
            const order = [];

            rows.forEach(row => {
                const msgId = row.msg_id;
                if (!grouped[msgId]) {
                    grouped[msgId] = {
                        msg_data: row.msg_data,
                        parts: []
                    };
                    order.push(msgId);
                }
                if (row.part_data)
                    grouped[msgId].parts.push(JSON.parse(row.part_data));
            });

            order.forEach(msgId => {
                const {
                    msg_data,
                    parts
                } = grouped[msgId];
                const mData = JSON.parse(msg_data);

                const content = parts.filter(p => p.type === "text").map(p => p.text).join("");
                const tools = parts.filter(p => p.type === "tool").map(p => ({
                            tool: p.tool,
                            callID: p.callID,
                            status: p.state.status,
                            input: p.state.input,
                            output: p.state.output
                        }));
                const files = parts.filter(p => p.type === "file").map(p => p.url).filter(Boolean);

                if (content.length === 0 && tools.length === 0 && files.length === 0)
                    return;

                const aiMessage = root.aiMessageComponent.createObject(root, {
                    "role": mData.role,
                    "content": content,
                    "rawContent": content,
                    "model": mData.model?.modelID ?? "",
                    "thinking": false,
                    "done": true,
                    "tools": tools,
                    "files": files
                });
                const newId = root.idForMessage(aiMessage);
                root.messageIDs = [...root.messageIDs, newId];
                root.messageByID[newId] = aiMessage;
            });
        }
    }

    Item {
        id: requester
        property AiMessageData message
        property bool startedReasoning: false
        property bool running: false
        property int lastProcessedIndex: 0

        function makeRequest(userMessage) {
            requester.running = true;
            requester.startedReasoning = false;
            requester.lastProcessedIndex = 0;

            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false
            });

            const id = root.idForMessage(requester.message);
            root.messageIDs = [...root.messageIDs, id];
            root.messageByID[id] = requester.message;

            const sessionId = root.currentSessionId || "default";
            const xhr = new XMLHttpRequest();

            let body = {
                "parts": [
                    {
                        "type": "text",
                        "text": userMessage
                    }
                ]
            };

            if (root.currentModelId.length > 0) {
                const modelParts = root.currentModelId.split("/");
                body["model"] = {
                    "providerID": modelParts.length > 1 ? modelParts[0] : "opencode",
                    "modelID": modelParts.length > 1 ? modelParts.slice(1).join("/") : modelParts[0]
                };
            }

            xhr.onreadystatechange = () => {
                if (xhr.readyState === XMLHttpRequest.LOADING || xhr.readyState === XMLHttpRequest.DONE) {
                    const responseText = xhr.responseText;
                    const newContent = responseText.substring(requester.lastProcessedIndex);
                    requester.lastProcessedIndex = responseText.length;
                    processChunks(newContent);
                }

                if (xhr.readyState === XMLHttpRequest.DONE) {
                    requester.running = false;
                    markDone();
                }
            };

            xhr.open("POST", `http://127.0.0.1:4096/session/${sessionId}/message`);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.send(JSON.stringify(body));
        }

        function processChunks(chunkData) {
            const lines = chunkData.split(/\r?\n/);
            lines.forEach(line => {
                const trimmed = line.trim();
                if (!trimmed || trimmed.startsWith("<"))
                    return;

                try {
                    const event = JSON.parse(trimmed);
                    if (event.parts) {
                        event.parts.forEach(p => {
                            if (p.type === "reasoning" && p.text) {
                                requester.message.thinking = false;
                                if (!requester.startedReasoning) {
                                    requester.message.content += "<think>";
                                    requester.startedReasoning = true;
                                }
                                requester.message.content += p.text;
                            } else if (p.type === "text" && p.text) {
                                requester.message.thinking = false;
                                if (requester.startedReasoning) {
                                    requester.message.content += "</think>";
                                    requester.startedReasoning = false;
                                }
                                requester.message.content += p.text;
                                requester.message.rawContent += p.text;
                            }
                        });
                    }
                    if (event.info && event.info.done)
                        markDone();
                } catch (e) {}
            });
        }

        function markDone() {
            if (!requester.message || requester.message.done)
                return;

            if (requester.startedReasoning) {
                requester.message.content += "</think>";
                requester.startedReasoning = false;
            }

            requester.message.done = true;
            requester.message.thinking = false;

            refreshSessions();
            root.responseFinished();
            root.processQueue();
        }
    }

    ConfigFileView {
        id: posesView
        fileName: "poses"
        adapter: PosesSchema {}
    }
}
