import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

Scope {
    IpcHandler {
        target: "noon"

        function toggle_expose() {
            GlobalStates.main.exposeView = !GlobalStates.main.exposeView;
        }
        function toggle_beam() {
            GlobalStates.main.showBeam = !GlobalStates.main.showBeam;
        }
        function translate(query: string): string {
            BeamData.query = "< " + query;
            toggle_beam();
        }
        function toggle_bar_mode() {
            Mem.options.bar.behavior.position = BarData.toggleLayout();
        }
        function swap_bar_position() {
            BarData.swapPosition();
        }
        function toggle_dock_pin() {
            Mem.states.dock.pinned = !Mem.states.dock.pinned;
        }
    }
}
