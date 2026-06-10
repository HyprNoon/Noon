pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

import qs.common
import qs.common.utils
import Noon.TaskManager

Singleton {
    id: root
    readonly property TaskManager manager: TaskManager {}
}
