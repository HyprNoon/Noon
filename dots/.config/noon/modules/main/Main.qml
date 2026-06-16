import QtQuick
import qs.services
import qs.common
import qs.common.utils

import "bar"
import "beam"
import "dock"
import "lock"
import "notificationPopup"
import "osd"
import "sidebar"
import "screenshot"
import "toolbar"
import "desktop"

Scope {
    Desktop {}
    NIPC {}
    // NotifPanel {}
    WidgetLoader {
        enabled: Notifications.popupAppNameList.length > 0
        NotificationPopup {}
    }

    WidgetLoader {
        reloadOn: Mem.options.bar.behavior.position
        Sidebar {}
    }

    WidgetLoader {
        enabled: Mem.options.dock.enabled
        Dock {}
    }

    WidgetLoader {
        enabled: Globals.main.locked
        Lock {}
    }

    WidgetLoader {
        reloadOn: Mem.options.bar.behavior.position
        Bar {}
    }

    WidgetLoader {
        enabled: Mem.options.osd.enabled
        OSDs {}
    }

    WidgetLoader {
        reloadOn: Mem.options.beam.behavior.topMode
        Beam {}
    }

    WidgetLoader {
        enabled: Globals.main.showScreenshot
        Screenshot {}
    }
}
