import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.common
import qs.common.utils
import "bar"

Scope {
    id: root
    WidgetLoader {
        ZBar {}
    }
}
