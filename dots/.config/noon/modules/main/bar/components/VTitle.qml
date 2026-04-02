import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: root

    readonly property string appId: MonitorsInfo.topLevel.appId ?? ""
    readonly property var titleSubstitutions: {
        "org.kde.dolphin": "Files",
        "dev.zed.Zed": "Zed",
        "hyprland-share-picker": "Screen Share",
        "org.kde.kdeconnect.app": "KDE Connect",
        "kcm_bluetooth": "Bluetooth",
        "org.kde.plasmawindowed": "KDE Window",
        "org.telegram.desktop": "Telegram"
    }

    function getDisplayName(id) {
        if (!id)
            return "Desktop";

        return titleSubstitutions[id] || id;
    }

    height: nameText.contentWidth + Padding.massive
    Layout.fillWidth: true
    StyledText {
        id: nameText
        anchors.centerIn: parent
        text: getDisplayName(root.appId).toUpperCase()
        color: Colors.colOnLayer1
        elide: Text.ElideRight
        maximumLineCount: 1
        animateChange: true
        rotation: -90

        font.pixelSize: Fonts.family.verylarge
        font.letterSpacing: 1.5
        font.weight: 900
        font.family: Fonts.family.monospace
    }
}
