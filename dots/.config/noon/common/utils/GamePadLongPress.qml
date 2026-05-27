import QtQuick
import Noon.Devices

QtObject {
    id: root

    property var gamepad: null
    property string _watchButton: "ButtonUnknown"
    property int watchButton: GamePadTranslator.Button[_watchButton]
    property int holdDuration: 1700
    signal triggered

    property Timer _timer: Timer {
        interval: root.holdDuration
        repeat: false
        onTriggered: root.triggered()
    }

    property Connections _conn: Connections {
        target: root.gamepad
        function onButtonEvent(btn, pressed) {
            if (btn !== root.watchButton)
                return;

            pressed ? root._timer.restart() : root._timer.stop();
        }
    }
}
