pragma Singleton
import Noon.Services
import QtQuick
import Quickshell

import qs.common
import qs.common.widgets
import qs.common.utils
import qs.services

Singleton {
    id: root

    property string query: ""
    property string activeState: "ai"
    property string modelName: Ai?.currentModelId ?? ""
    property string activeSubState: ""
    property var suggestedApp: null
    readonly property string cleanQuery: {
        if (query.length === 0)
            return "";
        const prefix = config?.prefix || "";
        return prefix !== "" ? query.substring(prefix.length).trim() : query.trim();
    }

    readonly property var config: registry[activeState]
    readonly property var subConfig: {
        if (!activeSubState || !config.subStates)
            return null;
        return config.subStates[activeSubState] || null;
    }
    property string activeHint

    property var registry: rebuildRegistry()
    readonly property var pluginsContent: PluginsManager?.beamPlugins
    readonly property var rawBeamPlugins: PluginsManager?.beamPlugins
    onRawBeamPluginsChanged: rebuildRegistry()

    readonly property var mainContent: {
        "ai": {
            prefix: "",
            icon: "thread_unread",
            shape: "Ghostish",
            placeholder: "Ask " + root.modelName + " Any Thing ..",
            showHint: false,
            showOsrButton: true,
            hinter: () => "",
            executor: () => {
                if (Mem.options.beam.behavior.clearAiChatBeforeSearch)
                    Ai.clearMessages();
                Ai.sendUserMessage(query);
                NoonUtils.callIpc("sidebar reveal API");
            }
        },
        "commands": {
            prefix: ";",
            icon: "keyboard_return",
            shape: "Oval",
            placeholder: "Command Master ..",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (NoonUtils.avilableSystemCommands.length < 1)
                    NoonUtils.fetchCommands();
                const q = cleanQuery.toLowerCase();
                for (let cmd of NoonUtils.avilableSystemCommands) {
                    if (cmd.toLowerCase().startsWith(q))
                        return cmd;
                }
                return "";
            },
            executor: () => Quickshell.execDetached(["bash", "-c", cleanQuery])
        },
        "calc": {
            prefix: "=",
            icon: "calculate",
            shape: "Hexagon",
            placeholder: "Calculate ..",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (cleanQuery.length > 0) {
                    QalcService.calculate(cleanQuery, result => {
                        if (activeState === "calc")
                            activeHint = result;
                    });
                }
                return activeHint;
            },
            executor: () => {
                if (QalcService.result)
                    ClipboardService.copy(QalcService.result);
            }
        },
        "install": {
            prefix: "$",
            icon: "deployed_code_update",
            shape: "SoftBurst",
            placeholder: "Install ..",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => NoonUtils.installPkg(cleanQuery)
        },
        "note": {
            prefix: ",",
            icon: "stylus",
            shape: "Slanted",
            placeholder: "Note ..",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => {
                const separator = Mem.options.beam.behavior.addSeparatorForNotes ? "\n - - - " : "";
                NotesService.note(cleanQuery + separator);
            }
        },
        "alarm": {
            prefix: "`",
            icon: "timer",
            shape: "Diamond",
            placeholder: "I Can Wake You ..",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => {
                AlarmService.addTimer(cleanQuery, "Beam Timer");
                if (Mem.options.beam.behavior.revealLauncherOnAction) {
                    Mem.states.sidebar.misc.selectedTabIndex = 3;
                    NoonUtils.callIpc("sidebar reveal Alarms");
                }
            }
        },
        "find": {
            prefix: "@",
            icon: "folder",
            shape: "PixelCircle",
            placeholder: "I Can Search Files ..",
            showHint: true,
            showOsrButton: false,
            model: FindService.resultsModel,
            debounce: 100,
            executor: () => {}
        },
        "launch": {
            prefix: ".",
            icon: "rocket_launch",
            shape: "Pentagon",
            placeholder: "Launch App ..",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (cleanQuery === "") {
                    suggestedApp = null;
                    return "";
                }
                const allApps = [...DesktopEntries.applications.values];
                const q = cleanQuery.toLowerCase();
                let bestMatch = null;
                let bestScore = 0;
                for (let app of allApps) {
                    const name = (app.name || "").toLowerCase();
                    const genericName = (app.genericName || "").toLowerCase();
                    let score = 0;
                    if (name.startsWith(q))
                        score = 100 + (100 - name.length);
                    else if (name.includes(q))
                        score = 50;
                    if (genericName.startsWith(q))
                        score = Math.max(score, 90);
                    else if (genericName.includes(q))
                        score = Math.max(score, 45);
                    const acronym = name.split(/\s+/).map(w => w[0]).join("").toLowerCase();
                    if (acronym === q)
                        score = Math.max(score, 95);
                    if (score > bestScore) {
                        bestScore = score;
                        bestMatch = app;
                    }
                }
                suggestedApp = bestMatch;
                return bestMatch ? bestMatch.name : "";
            },
            executor: () => {
                if (suggestedApp) {
                    const entry = DesktopEntries.byId(suggestedApp.id);
                    if (entry)
                        entry.execute();
                }
            }
        },
        "timer": {
            prefix: "~",
            icon: "hourglass",
            shape: "Clover8Leaf",
            placeholder: "How Long ..",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => {
                const duration = TimerService.parseTimeString(cleanQuery);
                if (duration > 0)
                    TimerService.addTimer("Focus Time", duration, true, true);
                if (Mem.options.beam.behavior.revealLauncherOnAction)
                    NoonUtils.callIpc("sidebar reveal Timers");
            }
        },
        "todo": {
            prefix: "/",
            icon: "task_alt",
            shape: "Cookie4Sided",
            placeholder: "Any plans ..?",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => TodoService.addTask(cleanQuery)
        },
        "ipc": {
            prefix: "!",
            icon: "moon_stars",
            shape: "Pentagon",
            placeholder: "Just Order ..?",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (NoonUtils.avilableIpcCommands.length < 1)
                    NoonUtils.fetchIpcCommands();
                const q = cleanQuery.toLowerCase();
                for (let cmd of NoonUtils.avilableIpcCommands) {
                    if (cmd.toLowerCase().startsWith(q))
                        return cmd;
                }
                return "";
            },
            executor: () => NoonUtils.callIpc(cleanQuery)
        },
        "search": {
            prefix: "?",
            icon: "search",
            shape: "PixelCircle",
            placeholder: "Wanna Search Google ..?",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (BookmarksService.bookmarkTitles.length > 0) {
                    const q = cleanQuery.toLowerCase();
                    for (let bookmark of BookmarksService.bookmarkTitles) {
                        if (bookmark.toLowerCase().startsWith(q))
                            return bookmark;
                    }
                }
                return "";
            },
            executor: () => {
                const searchUrl = subConfig?.searchQuery || Mem.options.networking.searchPrefix;
                const searchText = subConfig ? cleanQuery.substring(subConfig.prefix.length) : cleanQuery;
                Quickshell.execDetached(["xdg-open", searchUrl + encodeURIComponent(searchText)]);
            },
            subStates: {
                "search": {
                    prefix: "",
                    icon: "search",
                    searchQuery: Mem.options.networking.searchPrefix,
                    shape: "PixelCircle"
                },
                "yt_music": {
                    prefix: "m",
                    icon: "music_note",
                    searchQuery: "https://music.youtube.com/search?q=",
                    shape: "Bun"
                },
                "spotify": {
                    prefix: "s",
                    icon: "music_cast",
                    searchQuery: "https://open.spotify.com/search/",
                    shape: "Cookie7Sided"
                },
                "m3": {
                    prefix: "i",
                    icon: "glyphs",
                    searchQuery: "https://fonts.google.com/icons?icon.query=",
                    shape: "Cookie12Sided"
                },
                "github": {
                    prefix: "g",
                    icon: "commit",
                    searchQuery: "https://github.com/search?q=",
                    shape: "Oval"
                }
            }
        },
        "translate": {
            prefix: ">",
            icon: "translate",
            shape: "Arrow",
            placeholder: "Translate ..?",
            showHint: true,
            showOsrButton: false,
            hinter: () => {
                if (cleanQuery.length > 0) {
                    TranslatorService.translate(cleanQuery, result => {
                        if (activeState === "translate")
                            activeHint = result;
                    });
                }
                return activeHint;
            },
            executor: () => {
                if (TranslatorService.translatedText)
                    ClipboardService.copy(TranslatorService.translatedText);
            }
        },
        "download": {
            prefix: "-",
            icon: "download",
            shape: "Arrow",
            placeholder: "Download ..?",
            showHint: false,
            showOsrButton: false,
            hinter: () => "",
            executor: () => {
                const params = subConfig?.parameters || "";
                const searchQuery = subConfig ? cleanQuery.substring(subConfig.prefix.length).trim() : cleanQuery.trim();
                const processedParams = params.replace(/%q/g, searchQuery);
                const cmd = params.includes("%q") ? `yt-dlp -f ${processedParams}` : `yt-dlp -f ${processedParams} '${searchQuery}'`;
                BeatsService.downloadByCommand(cmd);
            },
            subStates: {
                "video": {
                    prefix: "v",
                    icon: "play_arrow",
                    parameters: "bestvideo[height<=720]+bestaudio/best[height<=720]",
                    shape: "PixelCircle"
                },
                "audio": {
                    prefix: "m",
                    icon: "music_note",
                    parameters: `bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -P "${Directories.beats.downloads}" `,
                    shape: "PixelCircle"
                },
                "audio_search": {
                    prefix: "?m",
                    icon: "music_note",
                    parameters: `bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -P "${Directories.beats.downloads}" 'ytsearch1:%q'`,
                    shape: "PixelCircle"
                }
            }
        }
    }
    function updateStateFromQuery(fullQuery) {
        query = fullQuery;

        if (fullQuery.length === 0) {
            activeState = "ai";
            activeSubState = "";
            return;
        }

        const firstChar = fullQuery[0];

        for (let key in registry) {
            const stateConfig = registry[key];
            if (stateConfig.prefix === firstChar && firstChar !== "") {
                activeState = key;
                if (stateConfig.subStates) {
                    updateSubState(fullQuery.substring(1), stateConfig.subStates);
                } else {
                    activeSubState = "";
                }
                return;
            }
        }

        activeState = "ai";
        activeSubState = "";
    }

    function updateSubState(remainder, subStates) {
        if (!remainder) {
            activeSubState = "";
            return;
        }

        for (let subKey in subStates) {
            const subPrefix = subStates[subKey].prefix;
            if (subPrefix !== "" && remainder.startsWith(subPrefix)) {
                activeSubState = subKey;
                return;
            }
        }

        activeSubState = Object.keys(subStates)[0] || "";
    }
    function reset() {
        query = "";
        activeState = "ai";
        activeSubState = "";
        suggestedApp = null;
    }

    function getIcon() {
        if (subConfig)
            return subConfig.icon;
        return config?.icon || "question_mark";
    }

    function getShape() {
        if (subConfig)
            return subConfig.shape;
        return MaterialShape.Shape[config?.shape];
    }

    function getHint() {
        if (!config.showHint) {
            activeHint = "";
            return "";
        }
        debounceTimer.restart();
        return activeHint;
    }

    Timer {
        id: debounceTimer
        interval: config?.debounce ?? 120
        onTriggered: activeHint = config?.hinter ? config.hinter() : ""
    }

    Process {
        id: shellRunner

        property string data: ""
        property var pendingCb: null
        property string lastQuery: ""

        function run(cmd, cb) {
            if (running)
                running = false;
            data = "";
            pendingCb = cb ?? null;
            command = ["bash", "-c", cmd.replace(/\$q/g, root.cleanQuery)];
            running = true;
        }

        stdout: SplitParser {
            onRead: data => shellRunner.data += data + "\n"
        }

        onExited: {
            const out = data.trim();
            root.activeHint = out;
            if (pendingCb)
                pendingCb(out);
            pendingCb = null;
            data = "";
        }
    }

    function buildPlugins() {
        const raw = rawBeamPlugins;
        if (!raw || Object.keys(raw).length === 0)
            return {};

        const ctx = {
            get cleanQuery() {
                return root.cleanQuery;
            },
            get activeState() {
                return root.activeState;
            },
            get activeHint() {
                return root.activeHint;
            },
            set activeHint(v) {
                root.activeHint = v;
            },
            exec: cmd => Quickshell.execDetached(["bash", "-c", cmd.replace(/\$q/g, root.cleanQuery)]),
            shell: (cmd, cb) => {
                if (root.cleanQuery === shellRunner.lastQuery)
                    return;
                shellRunner.lastQuery = root.cleanQuery;
                shellRunner.run(cmd, cb);
            }
        };

        const wrap = fn => fn ? new Function("ctx", `with(ctx){ return (${fn.replace(/%q/g, "ctx.cleanQuery")}) }`)(ctx) : null;

        const result = {};
        for (let key in raw) {
            const p = raw[key];
            const isEnabled = p.enabled === undefined ? true : p.enabled === true;
            if (!isEnabled)
                continue;
            result[key] = Object.assign({}, p, {
                hinter: wrap(p.hinter) ?? (() => ""),
                executor: wrap(p.executor) ?? (() => {})
            });
        }
        return result;
    }

    function rebuildRegistry() {
        registry = Object.assign({}, mainContent, buildPlugins());
    }

    function executeCommand() {
        if (cleanQuery.length === 0 && activeState !== "ai")
            return;
        if (config?.executor)
            config.executor();
    }

    function autocomplete(hintText) {
        if (!hintText)
            return query;

        const prefix = config?.prefix || "";

        const resultStates = ["calc", "translate", "find"];
        if (resultStates.includes(activeState))
            return query;

        return prefix + hintText;
    }
}
