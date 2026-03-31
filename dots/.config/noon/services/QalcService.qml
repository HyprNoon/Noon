pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common.utils

Singleton {
    id: root
    property string result: ""
    property bool isBusy: calcProcess.running
    property var _callback: null
    function calculate(expression: string, callback: var) {
        if (!expression) {
            root.result = "";
            callback?.("");
            return;
        }
        root._callback = callback ?? null;
        calcProcess.command = ["qalc", "-terse", expression];
        calcProcess.running = true;
    }
    function _finish(value: string) {
        root.result = value;
        root._callback?.(value);
        root._callback = null;
    }
    Process {
        id: calcProcess
        onExited: exitCode => {
            if (exitCode !== 0)
                root._finish("Error: " + exitCode);
        }
        stdout: SplitParser {
            onRead: data => root._finish(data.trim())
        }
    }
}
