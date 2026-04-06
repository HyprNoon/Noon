import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    property bool isSelected: false
    property size itemSize
    clip: true
    width: parent.width
    height: 125
    radius: Rounding.verylarge
    color: colors.colLayer2
    signal gameStarted
    property QtObject colors: Colors

    BlurImage {
        id: coverImageBackdrop
        z: 0
        blur: true
        tint: true
        tintLevel: 0.7
        tintColor: Colors.colScrim
        anchors.fill: parent
        source: root.modelData.coverImage && root.modelData.coverImage !== "" ? (root.modelData.coverImage.startsWith("file://") ? root.modelData.coverImage : "file://" + root.modelData.coverImage) : ""
        smooth: true
        mipmap: true
        antialiasing: true
        sourceSize: Qt.size(width, height)
        asynchronous: true
    }

    StyledRect {
        id: selectedMark
        z: 999
        opacity: root.isSelected ? 1 : 0
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 4
        height: 40
        color: colors.colPrimary
        rightRadius: 6
    }

    RLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        anchors.rightMargin: Padding.massive

        spacing: Padding.verylarge

        StyledRect {
            Layout.fillHeight: true
            implicitWidth: height
            radius: Rounding.normal
            color: root.colors.colLayer3
            clip: true

            StyledImage {
                id: coverImage
                anchors.fill: parent
                source: root.modelData.coverImage && root.modelData.coverImage !== "" ? (root.modelData.coverImage.startsWith("file://") ? root.modelData.coverImage : "file://" + root.modelData.coverImage) : ""
                smooth: true
                antialiasing: true
                asynchronous: true
            }

            Symbol {
                anchors.centerIn: parent
                text: "sports_esports"
                font.pixelSize: 54
                fill: 1
                color: root.colors.colOnLayer0
                visible: !root.modelData.coverImage || root.modelData.coverImage === "" || coverImage.status === Image.Error
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            StyledText {
                text: root.modelData.name
                font.pixelSize: Fonts.sizes.verylarge
                font.weight: Font.Medium
                color: root.colors.colOnLayer2
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            StyledText {
                text: GameLauncherService.statusNames[root.modelData.status]
                font.pixelSize: Fonts.sizes.small
                color: root.colors.colSubtext
            }
        }
        Spacer {}
        RowLayout {
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            spacing: Padding.large
            RippleButtonWithIcon {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                buttonRadius: Rounding.normal
                toggled: true
                materialIcon: "play_arrow"
                releaseAction: () => {
                    root.gameStarted();
                    GameLauncherService.launchGame(root.modelData.id);
                }
            }
            RippleButtonWithIcon {
                implicitSize: 36
                buttonRadius: Rounding.normal
                colBackground: root.colors.colSecondaryContainer
                materialIcon: "delete"
                releaseAction: () => {
                    GameLauncherService.deleteGame(root.modelData.id);
                }
            }
        }
    }
}
