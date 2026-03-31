pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import qs.services
import Noon.Utils.Download

Singleton {
    property alias model: downloadModel

    DownloadModel {
        id: downloadModel
        // jsonPath: Directories.standard.state + "/downloads.json"
        // userAgent: Mem.options.networking.userAgent
        onDownloadFinished: (index, success) => {
            const name = downloadModel.get(index).label;
            if (success)
                NoonUtils.toast(name + " Finished", "check");
            else
                NoonUtils.toast(name + " Failed", "close");
        }
        function clearAll() {
            for (let i = downloadModel.count - 1; i >= 0; i--) {
                downloadModel.remove(i);
            }
        }
    }
}
