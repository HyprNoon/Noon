import QtQuick
import Quickshell
import qs.services
import qs.common
import qs.common.utils
import qs.modules.main
import qs.modules.main.sidebar
import qs.modules.main.osd
import "bar"
import "dock"
import "notifs"
import "db"

Scope {
    WidgetLoader {
        GBar {}
    }
    WidgetLoader {
        GDock {}
    }
    WidgetLoader {
        Sidebar {}
    }
    WidgetLoader {
        enabled: Mem.options.osd.enabled
        OSDs {}
    }
    WidgetLoader {
        enabled: GlobalStates.nobuntu.db.show
        DB {}
    }
    WidgetLoader {
        enabled: GlobalStates.nobuntu.notifs.show
        GNotifs {}
    }
    GIPC {}
}
