import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pam
import qs.common
import qs.common.utils
import qs.services

Scope {
    id: root

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            Globals.main.locked = false;
        }
    }

    Connections {
        function onLockedChanged() {
            if (Globals.main.locked) {
                NoonUtils.playSound("locked");
                lock.locked = true;
            } else if (!Globals.main.locked) {
                NoonUtils.playSound("unlocked");
                lock.locked = false;
            }
        }

        target: Globals.main
    }

    Timer {
        interval: 300000
        running: lock.locked
        onTriggered: NoonUtils.execDetached(["loginctl", "suspend"])
    }

    WlSessionLock {
        id: lock

        locked: Globals.main.locked

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }
}
