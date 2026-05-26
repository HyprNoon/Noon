import QtQuick
import qs.common
import qs.common.utils
import "big_view"

Scope {
    id: root

    WidgetLoader {
        active: GlobalStates.common.openGameUI
        BigView {}
    }
}
