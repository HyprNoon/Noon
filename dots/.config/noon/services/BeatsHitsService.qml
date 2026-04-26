pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions

Singleton {
    id: root
    readonly property var hits: Mem.states.services.beats.hits
    readonly property bool isBusy: searchProc.running || fetchProc.running
    readonly property int searchLimit: Mem.options.mediaPlayer.fetchLimit ?? 18
    property int _limit: searchLimit
    property var searchResults

    function search(query, limit = _limit) {
        _limit = limit;
        var cmd = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/hits_service.py", "search", "--query", query, "--limit", limit];
        root.searchResults = null;
        searchProc.running = false;
        searchProc.command = cmd;
        searchProc.running = true;
    }

    function searchMore(query) {
        search(query, _limit + 32);
    }

    function request(limit = _limit) {
        var cmd = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/hits_service.py"];

        if (BeatsService.daemonOptions.isAuth) {
            cmd.push("discover");
        } else {
            cmd.push("recommend", FileUtils.trimFileProtocol(BeatsService._metadataPath));
        }

        cmd.push("--limit", limit.toString());

        fetchProc.running = false;
        fetchProc.command = cmd;
        fetchProc.running = true;
    }

    function auth() {
        if (!BeatsService.daemonOptions.isAuth)
            _cmd(["auth"]);
    }

    function _cmd(...arg) {
        const cmd = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/hits_service.py"];
        cmd.push(...arg);
        actionProc.command = cmd;
        actionProc.running = true;
    }
    function refresh(limit = _limit) {
        Mem.states.services.beats.hits = [];
        Qt.callLater(() => request(limit));
    }
    Process {
        id: actionProc
    }
    Process {
        id: searchProc
        stdout: StdioCollector {
            onStreamFinished: root.searchResults = JSON.parse(text.trim())
        }
    }
    Process {
        id: fetchProc
        stdout: StdioCollector {
            onStreamFinished: {
                const out = JSON.parse(text.trim());
                if (out.length > 0)
                    Mem.states.services.beats.hits = [...Mem.states.services.beats.hits, ...out];
            }
        }
    }
}
