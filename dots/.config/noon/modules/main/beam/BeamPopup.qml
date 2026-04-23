import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import org.kde.syntaxhighlighting

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
    property Component modelComponent: BeamModelDelegator {}

    readonly property var appData: {
        return hintText.length > 0 ? (DesktopEntries.byId(hintText) || null) : null;
    }
    readonly property string hintText: BeamData.getHint() || ""
    readonly property string catIcon: BeamData.getIcon() || ""
    readonly property string activeState: BeamData.activeState || "all"
    readonly property var currentConf: contentMap[activeState]
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
    width: Math.min(Sizes.beamPopupExpanded.width - 200, Math.max(popupText?.contentWidth + Padding.massive, mainBg.implicitWidth + Padding.massive))
    height: Math.max(136, Math.min(Sizes.beamPopupExpanded.height, popupText?.contentHeight + Padding.massive))
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
            active: root.currentConf && root.currentConf.active && root.height <= 260
            asynchronous: true
            visible: active
            sourceComponent: root.currentConf ? root.currentConf.comp : null
            onLoaded: {
                if (ready && item && "content" in item && root.currentConf) {
                    item.content = Qt.binding(() => root.currentConf.data);
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            StyledFlickable {
                visible: root.hintText.length > 0
                anchors.fill: parent
                anchors.topMargin: Padding.massive
                contentHeight: hintContent.implicitHeight
                clip: true
                ColumnLayout {
                    id: hintContent
                    anchors.fill: parent
                    spacing: 0

                    StyledTextArea {
                        id: popupText
                        wrapMode: root.width === Sizes.beamPopupExpanded.width ? Text.Wrap : Text.NoWrap
                        textFormat: Text.PlainText
                        text: root.hintText || ""
                        Layout.fillWidth: true
                        font {
                            family: Fonts.family.monospace
                            pixelSize: Fonts.sizes.subTitle
                        }

                        SyntaxHighlighter {
                            textEdit: popupText
                            repository: Repository
                            definition: Repository.definitionForName(BeamData.config?.isPlugin ? "bash" : "plaintext")
                            theme: Colors.m3.darkmode ? "Dracula" : "ayu Light"
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
    }
}
