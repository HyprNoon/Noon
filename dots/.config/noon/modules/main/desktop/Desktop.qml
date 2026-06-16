import QtQuick
import qs.services

import qs.common
import qs.common.utils

import "widgets"
import "icons"
import "dialogs"
import "toasts"
import "clock"

Scope {
    id: root
    DialogPanel {}
    WidgetLoader {
        enabled: !Mem.options.desktop.bg.depthMode && !WallpaperService.fgReady && Mem.options.desktop.clock.enabled
        DesktopClock {}
    }
    WidgetLoader {
        enabled: Mem.options.desktop.screenCorners > 0
        ScreenCorners {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.widgets.enabled
        reloadOn: Mem.options.bar.behavior.position
        DesktopWidgets {}
    }

    WidgetLoader {
        enabled: Mem.options.desktop.icons.enabled
        DesktopIcons {}
    }

    WidgetLoader {
        enabled: Globals.toasts.data.length > 0
        Toasts {}
    }
}
