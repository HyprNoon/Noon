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
    property string modelName: Ai?.getModel(Mem.options.ai?.model ?? "")?.name ?? "AI"
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

    readonly property var registry: {
        "ai": {
            prefix: "",
            icon: "thread_unread",
            shape: MaterialShape.Shape.Ghostish,
            placeholder: "Ask " + root.modelName + " Any Thing ..",
            showHint: false,
            showOsrButton: true
        },
        "commands": {
            prefix: ";",
            icon: "keyboard_return",
            shape: MaterialShape.Shape.Oval,
            placeholder: "Command Master ..",
            showHint: true,
            showOsrButton: false
        },
        "calc": {
            prefix: "=",
            icon: "calculate",
            shape: MaterialShape.Shape.Hexagon,
            placeholder: "Calculate ..",
            showHint: true,
            showOsrButton: false
        },
        "install": {
            prefix: "$",
            icon: "deployed_code_update",
            shape: MaterialShape.Shape.SoftBurst,
            placeholder: "Install ..",
            showHint: false,
            showOsrButton: false
        },
        "note": {
            prefix: ",",
            icon: "stylus",
            shape: MaterialShape.Shape.Slanted,
            placeholder: "Note ..",
            showHint: false,
            showOsrButton: false
        },
        "alarm": {
            prefix: "`",
            icon: "timer",
            shape: MaterialShape.Shape.Diamond,
            placeholder: "I Can Wake You ..",
            showHint: false,
            showOsrButton: false
        },
        "launch": {
            prefix: ".",
            icon: "rocket_launch",
            shape: MaterialShape.Shape.Pentagon,
            placeholder: "Launch App ..",
            showHint: true,
            showOsrButton: false
        },
        "timer": {
            prefix: "~",
            icon: "hourglass",
            shape: MaterialShape.Shape.Clover8Leaf,
            placeholder: "How Long ..",
            showHint: false,
            showOsrButton: false
        },
        "todo": {
            prefix: "/",
            icon: "task_alt",
            shape: MaterialShape.Shape.Cookie4Sided,
            placeholder: "Any plans ..?",
            showHint: false,
            showOsrButton: false
        },
        "ipc": {
            prefix: "!",
            icon: "moon_stars",
            shape: MaterialShape.Shape.Pentagon,
            placeholder: "Just Order ..?",
            showHint: true,
            showOsrButton: false
        },
        "search": {
            prefix: "?",
            icon: "search",
            shape: MaterialShape.Shape.PixelCircle,
            placeholder: "Wanna Search Google ..?",
            showHint: true,
            showOsrButton: false,
            subStates: {
                "search": {
                    prefix: "",
                    icon: "search",
                    searchQuery: Mem.options.networking.searchPrefix,
                    shape: MaterialShape.Shape.PixelCircle
                },
                "yt_music": {
                    prefix: "m",
                    icon: "music_note",
                    searchQuery: "https://music.youtube.com/search?q=",
                    shape: MaterialShape.Shape.Bun
                },
                "spotify": {
                    prefix: "s",
                    icon: "music_cast",
                    searchQuery: "https://open.spotify.com/search/",
                    shape: MaterialShape.Shape.Cookie7Sided
                },
                "m3": {
                    prefix: "i",
                    icon: "glyphs",
                    searchQuery: "https://fonts.google.com/icons?icon.query=",
                    shape: MaterialShape.Shape.Cookie12Sided
                },
                "github": {
                    prefix: "g",
                    icon: "commit",
                    searchQuery: "https://github.com/search?q=",
                    shape: MaterialShape.Shape.Oval
                }
            }
        },
        "translate": {
            prefix: ">",
            icon: "translate",
            shape: MaterialShape.Shape.Arrow,
            placeholder: "Translate ..?",
            showHint: true,
            showOsrButton: false
        },
        "download": {
            prefix: "-",
            icon: "download",
            shape: MaterialShape.Shape.Arrow,
            placeholder: "Download ..?",
            showHint: false,
            showOsrButton: false,
            subStates: {
                "video": {
                    prefix: "v",
                    icon: "play_arrow",
                    parameters: "bestvideo[height<=720]+bestaudio/best[height<=720]",
                    shape: MaterialShape.Shape.PixelCircle
                },
                "audio": {
                    prefix: "m",
                    icon: "music_note",
                    parameters: `bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -P "${Directories.beats.downloads}" `,
                    shape: MaterialShape.Shape.PixelCircle
                },
                "audio": {
                    prefix: "?m",
                    icon: "music_note",
                    parameters: `bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -P "${Directories.beats.downloads}" 'ytsearch1:%q'`,
                    shape: MaterialShape.Shape.PixelCircle
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

        // Check main states
        for (let key in registry) {
            const stateConfig = registry[key];
            if (stateConfig.prefix === firstChar && firstChar !== "") {
                activeState = key;

                // Check for sub-states
                if (stateConfig.subStates) {
                    updateSubState(fullQuery.substring(1), stateConfig.subStates);
                } else {
                    activeSubState = "";
                }
                return;
            }
        }

        // Default to AI
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

        // Default sub-state (usually the first one or empty)
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
        return config?.shape || MaterialShape.Shape.Oval;
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
        interval: 120
        onTriggered: activeHint = getImmediateHint()
    }

    function getImmediateHint() {
        const handlers = {
            "commands": getCommandHint,
            "calc": getCalcHint,
            "launch": getLaunchHint,
            "ipc": getIpcHint,
            "search": getSearchHint,
            "translate": getTranslateHint
        };

        const handler = handlers[activeState];
        return handler ? handler() : "";
    }
    function getCommandHint() {
        return findMatchingCommand(NoonUtils.avilableSystemCommands, cleanQuery, () => NoonUtils.fetchCommands());
    }

    function getIpcHint() {
        return findMatchingCommand(NoonUtils.avilableIpcCommands, cleanQuery, () => NoonUtils.fetchIpcCommands());
    }

    function findMatchingCommand(commandList, searchQuery, fetchFn) {
        if (commandList.length < 1)
            fetchFn();

        const queryLower = searchQuery.toLowerCase();
        for (let cmd of commandList) {
            if (cmd.toLowerCase().startsWith(queryLower)) {
                return cmd;
            }
        }
        return "";
    }

    function getCalcHint() {
        if (cleanQuery.length > 0) {
            QalcService.calculate(cleanQuery, result => {
                if (activeState === "calc")
                    activeHint = result;
            });
        }
        return activeHint;
    }

    function getLaunchHint() {
        if (cleanQuery === "") {
            suggestedApp = null;
            return "";
        }

        const allApps = [...DesktopEntries.applications.values];
        const bestApp = findBestAppMatch(allApps, cleanQuery.toLowerCase());

        suggestedApp = bestApp;
        return bestApp ? bestApp.name : "";
    }

    function findBestAppMatch(apps, query) {
        let bestMatch = null;
        let bestScore = 0;

        for (let app of apps) {
            const score = calculateAppScore(app, query);
            if (score > bestScore) {
                bestScore = score;
                bestMatch = app;
            }
        }

        return bestMatch;
    }

    function calculateAppScore(app, query) {
        const name = (app.name || "").toLowerCase();
        const genericName = (app.genericName || "").toLowerCase();
        let score = 0;

        // Name matching
        if (name.startsWith(query)) {
            score = 100 + (100 - name.length);
        } else if (name.includes(query)) {
            score = 50;
        }

        // Generic name matching
        if (genericName.startsWith(query)) {
            score = Math.max(score, 90);
        } else if (genericName.includes(query)) {
            score = Math.max(score, 45);
        }

        // Acronym matching
        const acronym = name.split(/\s+/).map(w => w[0]).join('').toLowerCase();
        if (acronym === query) {
            score = Math.max(score, 95);
        }

        return score;
    }

    function getSearchHint() {
        if (FirefoxBookmarksService.bookmarkTitles.length > 0) {
            const queryLower = cleanQuery.toLowerCase();
            for (let bookmark of FirefoxBookmarksService.bookmarkTitles) {
                if (bookmark.toLowerCase().startsWith(queryLower)) {
                    return bookmark;
                }
            }
        }
        return "";
    }

    function getTranslateHint() {
        if (cleanQuery.length > 0) {
            TranslatorService.translate(cleanQuery, result => {
                if (activeState === "translate")
                    activeHint = result;
            });
        }
        return activeHint;
    }

    function executeCommand() {
        if (cleanQuery.length === 0 && activeState !== "ai")
            return;

        const executors = {
            "ai": executeAi,
            "commands": executeCommands,
            "calc": executeCalc,
            "install": executeInstall,
            "note": executeNote,
            "alarm": executeAlarm,
            "launch": executeLaunch,
            "timer": executeTimer,
            "todo": executeTodo,
            "ipc": executeIpc,
            "search": executeSearch,
            "translate": executeTranslate,
            "download": executeDownload
        };

        const executor = executors[activeState];
        if (executor)
            executor();
    }

    function executeAi() {
        if (Mem.options.beam.behavior.clearAiChatBeforeSearch) {
            Ai.clearMessages();
        }
        Ai.sendUserMessage(query);
        NoonUtils.callIpc("sidebar reveal API");
    }

    function executeCommands() {
        Quickshell.execDetached(["bash", "-c", cleanQuery]);
    }

    function executeCalc() {
        if (QalcService.result) {
            ClipboardService.copy(QalcService.result);
        }
    }

    function executeInstall() {
        NoonUtils.installPkg(cleanQuery);
    }

    function executeNote() {
        const separator = Mem.options.beam.behavior.addSeparatorForNotes ? "\n - - - " : "";
        NotesService.note(cleanQuery + separator);
    }

    function executeAlarm() {
        AlarmService.addTimer(cleanQuery, "Beam Timer");
        if (Mem.options.beam.behavior.revealLauncherOnAction) {
            Mem.states.sidebar.misc.selectedTabIndex = 3;
            NoonUtils.callIpc("sidebar reveal Misc");
        }
    }

    function executeLaunch() {
        if (suggestedApp) {
            const entry = DesktopEntries.byId(suggestedApp.id);
            if (entry)
                entry.execute();
        }
    }

    function executeTimer() {
        const duration = TimerService.parseTimeString(cleanQuery);
        if (duration > 0) {
            const id = TimerService.addTimer("Focus Time", duration);
            TimerService.startTimer(id);
            if (Mem.options.beam.behavior.revealLauncherOnAction) {
                Mem.states.sidebar.misc.selectedTabIndex = 2;
                NoonUtils.callIpc("sidebar reveal Misc");
            }
        }
    }

    function executeTodo() {
        TodoService.addTask(cleanQuery);
    }

    function executeIpc() {
        NoonUtils.callIpc(cleanQuery);
    }

    function executeSearch() {
        const searchUrl = subConfig?.searchQuery || Mem.options.networking.searchPrefix;
        const searchText = subConfig ? cleanQuery.substring(subConfig.prefix.length) : cleanQuery;
        Quickshell.execDetached(["xdg-open", searchUrl + encodeURIComponent(searchText)]);
    }

    function executeTranslate() {
        if (TranslatorService.translatedText) {
            ClipboardService.copy(TranslatorService.translatedText);
        }
    }

    function executeDownload() {
        const params = subConfig?.parameters || "";
        const searchQuery = subConfig ? cleanQuery.substring(subConfig.prefix.length).trim() : cleanQuery.trim();
        const processedParams = params.replace(/%q/g, searchQuery);
        let cmd;
        // extract %q and replace with query
        if (params.includes("%q")) {
            cmd = `yt-dlp -f ${processedParams}`;
        } else {
            cmd = `yt-dlp -f ${processedParams} '${searchQuery}'`;
        }
        BeatsService.downloadByCommand(cmd);
    }

    function autocomplete(hintText) {
        if (!hintText)
            return query;

        const prefix = config?.prefix || "";

        const resultStates = ["calc", "translate"];
        if (resultStates.includes(activeState)) {
            return query;
        }

        // For suggestion-type hints, replace with suggestion
        return prefix + hintText;
    }
}
