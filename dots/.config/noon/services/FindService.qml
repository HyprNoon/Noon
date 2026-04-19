pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common.functions

Singleton {
    id: root
    readonly property alias resultsModel: styledResults
    property list<string> results: []
    onResultsChanged: console.log(JSON.stringify(results))

    ScriptModel {
        id: styledResults
        values: {
            let list = [];
            results.forEach(result => {
                list.push({
                    name: FileUtils.getEscapedFileName(result),
                    path: result,
                    ext: FileUtils.getEscapedFileExtension(result)
                });
            });
            return list;
        }
    }

    function clean() {
        searchProc.running = false;
        root.results = [];
        searchProc.cmd = "";
    }

    function find(query, showHidden, max) {
        clean();
        let cmd = "plocate --limit 10 ";
        // if (max > 0) {
        //     cmd += " --max-depth " + max.toString();
        // }

        if (showHidden) {
            cmd += " --hidden ";
        }
        if (query.length > 0) {
            cmd += query;
            searchProc.cmd = cmd;
            searchProc.running = true;
        }
    }

    Process {
        id: searchProc
        command: ["bash", "-c", cmd]
        property string cmd: ""
        stdout: SplitParser {
            onRead: line => {
                let tmp = root.results;
                tmp.push(line);
                root.results = tmp;
            }
        }
    }
}
