import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets

Item {
    z:99999
    visible:opacity > 0 && icon !== ""
    implicitWidth: Sizes.mediaPlayer.overlaySize
    implicitHeight: Sizes.mediaPlayer.overlaySize
    anchors.centerIn: parent
    required property var player
    property alias icon: symbol.text
    Behavior on opacity {
        Anim {}
    }
    // modes toggle_playing , seek_forward,seek_backward
    function hide () {
        opacity = 0
    }
    function show(mode){
        opacity = 1
        if(mode === "toggle_playing"){
            if (player._playing){
                symbol.text = "pause"
            } else {
                symbol.text = "play_arrow"
            }
        }
        if(mode === "seek_forward"){
            symbol.text = "forward_10"
        }
        if(mode === "seek_backward"){
            symbol.text = "replay_10"
        }
    }
    StyledRect {
        id:bg
        anchors.fill: parent
        enableBorders:true
        radius:Rounding.verylarge
        color:Colors.m3.m3surfaceContainer
        Symbol {
            id:symbol
            fill:1
            font.pixelSize: parent.width / 2
            anchors.centerIn: parent
        }
    }
    StyledRectangularShadow {
        target:bg
    }
}
