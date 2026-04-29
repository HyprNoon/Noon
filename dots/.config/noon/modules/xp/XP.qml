import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.common
import qs.common.utils
import "startMenu"
import "wallpaper"
import "controlPanel"
import "bar"
import "run"

/*  TODOs -->
    - [-] Bar
        - [ ] System Tray Finalization
            - [ ] New Menu Items
        - [-] Figure out A Better Gradiant Border Thingie
        - [X] Pinned Apps Section
    - [ ] Animation Feedbacks
    - [ ] Colors
        - [-] Support for 3 other palettes
        - [X] Enhance Shadows
    - [-] Control Panel Window
    - [X] StartMenu
        - [ ] Handle Popups
        - [X] Just A Dummy on Beam IPC
    - [ ] Desktop Shortcuts
    - [ ] Nixus Dock Replica
    - [ ] A Sort of Wallpaper Selector
    - [ ] An integration with external Qt, GTK Theming, Icon
        - [X] Found / Packed an Icon theme
    - [ ] Configuration Way for not missing Main Noon
        - [ ] Preferably Modularized Plugins System
*/

Scope {
    WidgetLoader {
        Bar {}
    }
    WidgetLoader {
        StartMenu {}
    }
    WidgetLoader {
        Run {}
    }

    WidgetLoader {
        enabled: WallpaperService._loaded
        Wallpaper {}
    }
    XIPC {}
}
