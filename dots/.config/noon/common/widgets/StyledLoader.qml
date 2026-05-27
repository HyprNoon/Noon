import QtQuick
import qs.common
import qs.common.widgets

Loader {
    id: root

    property bool shown: true
    property alias animationDuration: fadeAnim.duration
    property alias fade: opacityBehavior.enabled
    property var _item: ready ? item : null
    readonly property bool ready: item && item !== null
    opacity: shown ? 1 : 0
    visible: opacity > 0
    active: opacity > 0

    function reload() {
        if (!root.active)
            return;
        root.active = false;
        root.active = true;
    }

    function sanitizeSource(basePath, component) {
        return basePath + component + ".qml";
    }

    function debouncedReload(delay = 100) {
        NoonUtils.singleshot(() => {
            root.reload();
        }, delay);
    }

    Behavior on opacity {
        id: opacityBehavior

        Anim {
            id: fadeAnim
        }
    }
}
