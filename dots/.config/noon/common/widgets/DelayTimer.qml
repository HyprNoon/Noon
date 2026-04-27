import QtQuick
import Quickshell
import qs.common

Timer {
    interval: Mem.options.hacks.arbitraryRaceConditionDelay
}
