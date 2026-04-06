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
        tintColor: ColorUtils.colorWithLightness(Colors.colPrimaryContainer, 0.3)
        tintLevel: 0.8
        blur: true
        blurSize: 2
        blurMax: 42

        Anim on opacity {
            from: 0
            to: 1
        }
    }

    LockProfilePicture {}

    LockClock {}
    LockControls {}

    LockBeam {
        id: beam
        context: root.context
    }

    CLayout {
        anchors.margins: Padding.massive
        spacing: -Padding.huge
        anchors.top: parent.top
        anchors.right: parent.right
        LockMusic {}
        LockWeather {}
        Anim on anchors.rightMargin {
            from: -width
            to: Padding.massive
            duration: 800
        }
    }
}
