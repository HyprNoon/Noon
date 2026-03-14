pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    readonly property bool isBusy: installer.running
    property string url: ""

    function install(ocs: string) {
        root.url = ocs;
        installer.running = true;
    }

    Process {
        id: installer

        command: ["python3", Directories.scriptsDir + "/thawb_service.py", root.url]

        onStarted: {
            NoonUtils.toast("Installation Started", "apparel", "normal", "Thawb");
        }
        onExited: code => {
            if (code === 0)
                NoonUtils.toast("Installation Finished", "apparel", "success", "Thawb");
            else
                NoonUtils.toast("Installation Failed", "close", "error", "Thawb");
        }
    }
}
