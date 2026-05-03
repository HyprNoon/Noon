import QtQuick
import qs.common
import qs.services
import qs.common.widgets
import qs.common.functions

StyledMenu {
    required property var fileData
    content: [
        {
            "text": "Open Externally",
            "materialIcon": "open_in_new",
            "action": () => {
                if (fileData && fileData.filePath) {
                    Qt.openUrlExternally(fileData.filePath);
                }
            }
        },
        {
            "text": "Summarize",
            "materialIcon": "summarize",
            "action": () => {
                if (fileData && fileData.filePath) {
                    Ai.summarizePDF(fileData.filePath);
                    NoonUtils.callIpc("sidebar reveal API");
                }
            }
        },
        {
            "text": "Delete",
            "materialIcon": "delete",
            "action": () => {
                if (fileData && fileData.filePath) {
                    NoonUtils.deleteFile(fileData.filePath);
                }
            }
        },
    ]
}
