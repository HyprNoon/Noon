import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import qs.common.functions

Scope {
    id: root
    IpcHandler {
        id: ipc
        target: "nobuntu"
        function toggle_db() {
            Globals.nobuntu.db.show = !Globals.nobuntu.db.show;
        }
        function toggle_overview() {
            Globals.nobuntu.overview.show = !Globals.nobuntu.overview.show;
        }
        function toggle_notifs() {
            Globals.nobuntu.notifs.show = !Globals.nobuntu.notifs.show;
        }
        function toggle_clipboard() {
            Globals.nobuntu.clipboard.show = !Globals.nobuntu.clipboard.show;
        }
    }
}
