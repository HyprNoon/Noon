import QtQuick.Layouts
import QtQuick
import Quickshell
import qs.common
import qs.store
import qs.common.widgets
import qs.services
import "popups"

StyledRect {
    id: root
    required property var mainBg
    property bool reveal
    property Component imageComponent: BeamImagePopupItem {}
    property Component iconComponent: BeamIconPopupItem {}
    property Component symbolComponent: BeamSymbolPopupItem {}

    readonly property var appData: {
        return hintText.length > 0 ? (DesktopEntries.byId(hintText) || null) : null;
    }
    readonly property string hintText: BeamData.getHint() || ""
    readonly property string catIcon: BeamData.getIcon() || ""
    readonly property string activeState: BeamData.activeState || "all"

    readonly property var contentMap: {
        "launch": {
            "comp": iconComponent,
            "data": appData ? (appData.icon || "") : "",
            "active": hintText.length > 1
        },
        "ai": {
            "comp": imageComponent,
            "data": Ai.pendingFilePath || "",
            "active": (Ai.pendingFilePath || "").length > 1
        },
        "all": {
            "comp": symbolComponent,
            "data": root.catIcon,
            "active": true
        }
    }
    readonly property bool topMode: Mem.options.beam.behavior.topMode ?? false
    readonly property var currentConf: contentMap[activeState] || contentMap["all"]

    z: -1
    visible: opacity > 0
    opacity: root.reveal && (root.hintText.length > 0) ? 1 : 0

    anchors {
        top: topMode ? mainBg.bottom : undefined
        bottom: !topMode ? mainBg.top : undefined
        margins: Padding.normal
        horizontalCenter: parent.horizontalCenter
    }

    Anim on anchors.bottomMargin {
        from: -implicitHeight - Padding.large
        to: Padding.huge
    }

    Behavior on width {
        Anim {
            duration: Animations.durations.small
            easing.bezierCurve: Animations.curves.standardDecel
        }
    }

    width: Math.max(200, Math.min(hintText.length * 80, mainBg.width))
    height: 136
    color: Colors.colLayer0
    enableBorders: true
    radius: Rounding.massive

    RowLayout {
        id: contentRow
        clip: true
        anchors.fill: parent
        anchors.margins: Padding.massive
        spacing: Padding.massive

        StyledLoader {
            active: root.currentConf && root.currentConf.active
            asynchronous: true
            visible: active
            sourceComponent: root.currentConf ? root.currentConf.comp : null
            onLoaded: {
                if (ready && item && "content" in item && root.currentConf) {
                    item.content = Qt.binding(() => root.currentConf.data);
                }
            }
        }

        ColumnLayout {
            visible: root.hintText.length > 0
            Layout.maximumHeight: 100
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                id: popupText
                text: root.hintText || ""
                color: Colors.colOnLayer1
                Layout.fillWidth: true
                font {
                    family: Fonts.family.monospace
                    pixelSize: Fonts.sizes.subTitle
                }
            }

            StyledText {
                id: popupDescriptionText
                visible: text.length > 0 && root.activeState === "launch"
                Layout.fillWidth: true
                Layout.maximumWidth: 300
                truncate: true
                text: root.appData ? (root.appData.comment || "") : ""
                color: Colors.colSubtext
                font {
                    family: Fonts.family.monospace
                    pixelSize: Fonts.sizes.huge
                }
            }
        }
    }
}
