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
    readonly property var manager: downloadModel
    readonly property var model: {
        let model = [];
        for (let i = 0; i < downloadModel.count; i++) {
            model.push(downloadModel.get(i));
        }
        return model;
    }
    DownloadModel {
        id: downloadModel
        jsonPath: Directories.standard.state + "/downloads.json"
        userAgent: Mem.options.networking.userAgent
        onDownloadFinished: (index, success) => {
            const name = downloadModel.get(index).label;
            success ? NoonUtils.toast({
                id: 4,
                content: name + " Finished",
                icon: "check"
            }) : NoonUtils.toast({
                id: 4,
                content: name + " Failed",
                icon: "close"
            });
        }
    }
}
