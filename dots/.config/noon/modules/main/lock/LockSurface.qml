import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.modules.main.desktop.bg
import qs.services
import qs.store

Rectangle {
    id: root

    required property LockContext context
    property alias blurredArt: backgroundImage
    color: Colors.colLayer0

    BlurImage {
        id: backgroundImage
        z: 0
        anchors.fill: parent
        source: WallpaperService.currentWallpaper
        fillMode: Image.PreserveAspectCrop
        tint: true
        tintColor: Colors.colPrimaryContainer
        tintLevel: 0.9
        blur: true
        blurSize: 2
        blurMax: 40

        Anim on opacity {
            from: 0
            to: 1
        }
    }

    LockProfilePicture {}

    LockQuotes {}

    LockContentArea {}

    LockControls {}

    LockBeam {}
}
