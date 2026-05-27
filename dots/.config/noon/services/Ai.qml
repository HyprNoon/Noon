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
    readonly property int port: 4096
    readonly property string interfaceRole: "interface"
    readonly property bool isResponding: requester.running
    readonly property bool currentModelHasApiKey: true
    readonly property var states: Mem.ai
    readonly property string currentSessionId: states.currentSessionId
    readonly property var tokenCount: states.tokenCount
    readonly property var modelList: states.models ?? []
    readonly property string currentModelId: states.model
    readonly property var skills: states.skills

    property var sessions: []
    property var messageIDs: []
    property var messageQueue: []
    property var messageByID: ({})
    property string _queryType: ""
    property string pendingSkillName: ""
    property string pendingFilePath: ""
    property var postResponseHook
    property var sseXhr: null
    property string sseBuffer: ""

    function connectSSE() {
        if (root.sseXhr)
            return;
        var xhr = new XMLHttpRequest();
        root.sseXhr = xhr;
        root.sseBuffer = "";
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.LOADING || xhr.readyState === XMLHttpRequest.DONE) {
                var newData = xhr.responseText.substring(root.sseBuffer.length);
                root.sseBuffer = xhr.responseText;
                newData.split("\n\n").slice(0, -1).forEach(function (block) {
                    var data = "";
                    block.split("\n").forEach(function (l) {
                        if (l.indexOf("data: ") === 0)
                            data += l.substring(6);
                    });
                    if (data)
                        try {
                            root.handleSSE(JSON.parse(data));
                        } catch (e) {}
                });
            }
            if (xhr.readyState === XMLHttpRequest.DONE)
                root.sseXhr = null;
        };
        xhr.open("GET", `http://127.0.0.1:${port}/event`);
        xhr.send();
    }

    function handleSSE(event) {
        if (event.type === "session.status") {
            var s = event.properties && event.properties.status;
            if (s) {
                requester._sessionBusy = s.type === "busy";
                if (s.type === "idle" && requester.running)
                    requester.markDone();
            }
            return;
        }
        if (!requester.running)
            return;
        if (event.type === "message.updated") {
            var info = event.properties && event.properties.info;
            if (info && info.role === "user")
                requester._userMessageId = info.id;
        }
        if (event.type === "message.part.updated") {
            var part = event.properties && event.properties.part;
            if (part && part.messageID !== requester._userMessageId)
                requester.processPart(part);
        }
    }

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
        root.messageByID[id] = aiMessage;
        root.messageIDs = [...root.messageIDs, id];
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
        _queryType = "messages";
        db.query("SELECT m.id as msg_id, m.data as msg_data, p.data as part_data " + "FROM message m LEFT JOIN part p ON p.message_id = m.id " + "WHERE m.session_id = ? " + "ORDER BY m.rowid ASC", [id]);
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

    function createSessionAndSend(message) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", `http://127.0.0.1:${port}/session`);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status >= 200 && xhr.status < 300) {
                var resp = JSON.parse(xhr.responseText);
                root.states.currentSessionId = resp.id;
                requester._sessionBusy = false;
            }
            finishSend(message);
        };
        xhr.send(JSON.stringify({
            title: message.substring(0, 50)
        }));
    }

    function sendUserMessage(message) {
        if (message.length === 0)
            return;
        if (requester._sessionBusy)
            createSessionAndSend(message);
        else if (!root.currentSessionId)
            createSessionAndSend(message);
        else
            finishSend(message);
    }

    function finishSend(message) {
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
        root.messageByID[id] = aiMessage;
        root.messageIDs = [...root.messageIDs, id];
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
        root.messageByID[id] = aiMessage;
        root.messageIDs = [...root.messageIDs, id];
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
        if (requester._xhr)
            requester._xhr.abort();
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
        _queryType = "sessions";
        db.query("SELECT id, title, time_created, time_updated, directory, project_id FROM session ORDER BY time_updated DESC");
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
        onStarted: console.log("[AI]: Pulling Models")
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
            if (!rows.length || !_queryType)
                return;
            if (_queryType === "sessions") {
                root.sessions = rows.map(r => ({
                            id: r.id,
                            title: r.title,
                            created: r.time_created,
                            updated: r.time_updated,
                            directory: r.directory,
                            projectId: r.project_id
                        }));
                return;
            }
            const groups = {}, order = [];
            rows.forEach(r => {
                if (!groups[r.msg_id]) {
                    groups[r.msg_id] = {
                        d: JSON.parse(r.msg_data),
                        p: []
                    };
                    order.push(r.msg_id);
                }
                if (r.part_data)
                    groups[r.msg_id].p.push(JSON.parse(r.part_data));
            });
            let i = 0;
            (function ins() {
                    const end = Math.min(i + 5, order.length);
                    const batch = [];
                    for (; i < end; ++i) {
                        const g = groups[order[i]];
                        const txt = g.p.filter(p => p.type === "text").map(p => p.text).join("");
                        const tools = g.p.filter(p => p.type === "tool").map(p => ({
                                    tool: p.tool,
                                    callID: p.callID,
                                    status: p.state.status,
                                    input: p.state.input,
                                    output: p.state.output
                                }));
                        const files = g.p.filter(p => p.type === "file").map(p => p.url).filter(Boolean);
                        if (!txt && !tools.length && !files.length)
                            continue;
                        const msg = root.aiMessageComponent.createObject(root, {
                            role: g.d.role,
                            content: txt,
                            rawContent: txt,
                            model: g.d.model?.modelID ?? "",
                            thinking: false,
                            done: true,
                            tools,
                            files
                        });
                        const id = root.idForMessage(msg);
                        root.messageByID[id] = msg;
                        batch.push(id);
                    }
                    if (batch.length)
                        root.messageIDs = root.messageIDs.concat(batch);
                    if (i < order.length)
                        Qt.callLater(ins);
                })();
        }
    }

    Item {
        id: requester
        property AiMessageData message
        property bool startedReasoning: false
        property bool running: false
        property var _xhr: null
        property string _parsed: ""
        property string _userMessageId: ""
        property bool _sessionBusy: false

        function processPart(p) {
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
        }

        function makeRequest(userMessage) {
            requester.running = true;
            requester.startedReasoning = false;
            requester._parsed = "";
            requester._userMessageId = "";

            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false
            });

            const id = root.idForMessage(requester.message);
            root.messageByID[id] = requester.message;
            root.messageIDs = [...root.messageIDs, id];

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

            const sessionId = root.currentSessionId || "default";
            if (!root.sseXhr)
                root.connectSSE();
            const xhr = new XMLHttpRequest();
            requester._xhr = xhr;

            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status >= 400) {
                    requester.markDone();
                }
            };

            xhr.open("POST", `http://127.0.0.1:${port}/session/` + sessionId + "/message");
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.send(JSON.stringify(body));
        }

        function markDone() {
            if (!requester.message || requester.message.done)
                return;

            requester.running = false;

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
}
