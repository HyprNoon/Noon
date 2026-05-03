import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions

RedunduntMultiViewPanel {
    id: root
    path: Qt.resolvedUrl("./")

    lazy: true
    tabButtonList: [
        {
            "icon": "cognition_2",
            "name": "Chat",
            "component": "ChatView"
        },
        {
            "icon": "person",
            "name": "Waifu",
            "component": "ModelView"
        },
    ]
}
