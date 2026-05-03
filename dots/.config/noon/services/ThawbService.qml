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
            NoonUtils.toast({
                id: 11,
                content: "Installation Started",
                icon: "apparel",
                status: "normal",
                title: "Thawb"
            });
        }
        onExited: code => {
            if (code === 0)
                NoonUtils.toast({
                    id: 11,
                    content: "Installation Finished",
                    icon: "apparel",
                    status: "success",
                    title: "Thawb"
                });
            else
                NoonUtils.toast({
                    id: 11,
                    content: "Installation Failed",
                    icon: "close",
                    status: "error",
                    title: "Thawb"
                });
        }
    }
}
