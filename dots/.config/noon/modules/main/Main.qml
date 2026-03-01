import QtQuick
import qs.services
import qs.common
import qs.common.utils

import "bar"
import "beam"
import "desktop/bg"
import "dock"
import "lock"
import "notificationPopup"
import "osd"
import "sidebar"
import "view"
import "screenshot"
import "toolbar"
import "desktop/dialogs"
import "desktop/toasts"

Scope {
    WidgetLoader {
        enabled: WallpaperService._loaded
        Bg {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.bg.borderMultiplier > 0
        Border {}
    }

    WidgetLoader {
        enabled: true
        reloadOn: Mem.options.bar.behavior.position
        Sidebar {}
    }

    // WidgetLoader {
    //     NotificationPopup {}
    // }

    WidgetLoader {
        DialogPanel {}
    }

    WidgetLoader {
        enabled: Mem.options.dock.enabled
        Dock {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.lock.enabled
        Lock {}
    }

    WidgetLoader {
        enabled: false
        NotifPanel {}
    }

    WidgetLoader {
        enabled: Mem.options.bar.enabled
        reloadOn: Mem.options.bar.behavior.position
        Bar {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.screenCorners > 0 ?? false
        ScreenCorners {}
    }

    WidgetLoader {
        enabled: Mem.options.osd.enabled
        OSDs {}
    }

    WidgetLoader {
        Hyprview {}
    }

    WidgetLoader {
        Beam {}
    }
    WidgetLoader {
        Toasts {}
    }
    // WidgetLoader {
    //     enabled: GlobalStates.main.showScreenshot
    //     Screenshot {}
    // }

    NIPC {}
}
