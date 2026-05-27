import QtQuick

import "bg"
import "big_view"

import qs.common
import qs.common.utils

Scope {
    id: root

    WidgetLoader {
        active: GlobalStates.common.openGameUI
        BigView {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.bg.borderMultiplier > 0
        Border {}
    }

    WidgetLoader {
        Bg {}
    }
}
