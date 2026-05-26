pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    property string state: "idle"
    property string syncedLyrics: ""
    property string plainLyrics: ""

    property string _title: ""
    property string _artist: ""

    function fetchLyrics(artist, title) {
        if (!title) {
            state = "idle";
            syncedLyrics = "";
            plainLyrics = "";
            return;
        }
        _artist = artist || "";
        _title = title;
        state = "loading";
        syncedLyrics = "";
        plainLyrics = "";

        proc.running = false;
        proc.command = ["python3", Directories.scriptsDir + "/lyrics_service.py", "--title", title, "--artist", artist || "",];
        proc.running = true;
    }

    Process {
        id: proc
        running: false

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                if (root._title !== BeatsService.title || root._artist !== BeatsService.artist)
                    return;
                try {
                    const data = JSON.parse(text);
                    root.syncedLyrics = data.syncedLyrics || "";
                    root.plainLyrics = data.plainLyrics || "";
                    root.state = root.syncedLyrics || root.plainLyrics ? "loaded" : "notfound";
                } catch (e) {
                    root.state = "error";
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (root._title !== BeatsService.title || root._artist !== BeatsService.artist)
                    return;
                root.state = "error";
            }
        }
    }

    Timer {
        id: debounce
        interval: 50
        running: true
        onTriggered: fetchLyrics(BeatsService?.artist ?? "", BeatsService?.title ?? "")
    }

    Connections {
        target: BeatsService
        function onTitleChanged() {
            debounce.restart();
        }
    }
}
