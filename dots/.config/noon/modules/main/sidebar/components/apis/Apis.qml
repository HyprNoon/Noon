import QtQuick
import qs.common
import qs.common.widgets
import "medicalDictionary"
import "translator"

RedunduntMultiViewPanel {
    id: root
    path: Qt.resolvedUrl("./")
    tabButtonList: [
        {
            "icon": "neurology",
            "enabled": Mem.options.policies.ai > 0,
            "name": " AI ",
            "component": "AiChat"
        },
        {
            "icon": "rib_cage",
            "enabled": Mem.options.policies.medicalDictionary > 0,
            "name": "Medical",
            "component": "medicalDictionary/MedicalDictionary"
        },
        {
            "icon": "translate",
            "enabled": Mem.options.policies.translator > 0,
            "name": "Dicts",
            "component": "translator/Translator"
        }
    ]
}
