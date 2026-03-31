import QtQuick
import qs.common
import qs.common.widgets
import "translator"

RedunduntMultiViewPanel {
    id: root
    path: Qt.resolvedUrl("./")
    tabButtonList: [
        {
            "icon": "neurology",
            "enabled": Mem.options.policies.ai > 0,
            "name": "Assistant",
            "component": "AiChat"
        },
        {
            "icon": "translate",
            "enabled": Mem.options.policies.translator > 0,
            "name": "Translator",
            "component": "translator/Translator"
        }
    ]
}
