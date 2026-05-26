import QtQuick
import Noon.Utils

QtObject {
    property var gamepad: null
    property int button: GamePadTranslator.Button.Unknown
    property int window: 350
    signal triggered

    property bool _waiting: false

    property Timer _timer: Timer {
        interval: window
        repeat: false
        onTriggered: _waiting = false
    }

    property Connections _conn: Connections {
        target: gamepad
        function onButtonEvent(btn, pressed) {
            if (btn !== button || !pressed)
                return;
            if (_waiting) {
                triggered();
                _waiting = false;
                _timer.stop();
            } else {
                _waiting = true;
                _timer.restart();
            }
        }
    }
}
