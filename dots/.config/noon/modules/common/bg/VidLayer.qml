import QtQuick
import Noon.Utils
import qs.common

MpvPlayer {
    anchors.fill: parent
    autoplay: true
    loop: true
    mute: true
    source: Mem.looks.currentBg
    framerate: Mem.options.desktop.bg.live.framerate ?? 16
}
