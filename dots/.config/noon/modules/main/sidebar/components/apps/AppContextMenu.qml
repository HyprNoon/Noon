import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledMenu {
    id: contextMenu
    required property var modelData
    property bool isPinned: Mem.states.favorites.apps.some(obj => obj.appId.toLowerCase() === modelData.id.toLowerCase())
    signal dismiss
    content: [
        {
            "text": "Launch",
            "materialIcon": "launch",
            "action": () => {
                modelData.execute();
                dismiss();
            }
        },
        {
            "text": isPinned ? "Unpin" : "Pin",
            "materialIcon": "push_pin",
            "action": () => {
                const id = modelData.id;
                Mem.states.favorites.apps = isPinned ? Mem.states.favorites.apps.filter(x => x.appId !== id) : [...Mem.states.favorites.apps,
                    {
                        appId: id,
                        gid: null
                    }
                ];
            }
        }
    ]
}
