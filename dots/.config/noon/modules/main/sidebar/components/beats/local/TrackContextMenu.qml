import QtQuick
import qs.common.functions
import qs.common.widgets
import qs.services

StyledMenu {
    property string trackPath: ""
    property string trackName: ""

    colors: BeatsService.colors
    content: [
        {
            "text": "Play",
            "materialIcon": "play_arrow",
            "action": () => {
                if (trackPath)
                    BeatsService.playTrackByPath(trackPath);
            }
        },
        {
            "text": "Share",
            "materialIcon": "share",
            "enabled": KdeConnectService.selectedDeviceId !== "",
            "action": () => {
                if (trackPath)
                    KdeConnectService.shareFile(KdeConnectService.selectedDeviceId, trackPath);
            }
        },
        {
            "text": "Show in Files",
            "materialIcon": "folder_open",
            "action": () => {
                if (trackPath) {
                    const dirPath = trackPath.substring(0, trackPath.lastIndexOf('/'));
                    Qt.openUrlExternally("file://" + dirPath);
                }
            }
        },
        {
            "text": "Delete",
            "materialIcon": "delete",
            "action": () => {
                if (trackPath) {
                    NoonUtils.deleteFile(trackPath);
                }
            }
        }
    ]
}
