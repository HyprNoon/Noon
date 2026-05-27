import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

BottomDialog {
    id: root

    property int comboWidth: 240

    z: 9999
    bottomAreaReveal: true
    hoverHeight: 230
    collapsedHeight: 195
    enableStagedReveal: false

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: Padding.large
        clip: true
        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.rightMargin: 40
            Layout.leftMargin: Padding.large
            spacing: Padding.normal
            interactive: true
            orientation: Qt.Horizontal
            model: ThemeStore.predefinedColors
            delegate: PaletteDelegation {}
        }
        RLayout {
            Layout.fillWidth: true
            spacing: Padding.large

            StyledComboBox {
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                model: ThemeStore.themes
                textRole: "name"
                valueRole: "value"
                currentIndex: 0
                displayText: "Gowall"
                onActivated: index => {
                    if (index >= 0 && index < ThemeStore.themes.length)
                        GowallService.convertTheme(ThemeStore.themes[index]);
                }
            }

            StyledComboBox {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                model: ThemeStore.modes
                textRole: "name"
                valueRole: "value"
                currentIndex: ThemeStore.modes.findIndex(i => i.value === Mem.looks.scheme)
                onActivated: index => {
                    if (index >= 0 && index < ThemeStore.modes.length)
                        WallpaperService.updateScheme(ThemeStore.modes[index].value);
                }
            }

            StyledComboBox {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                model: ThemeStore.palettes
                textRole: "name"
                valueRole: "name"
                displayText: ThemeStore.palettes.find(t => t.path === Mem.options.appearance.colors.palattePath)?.name
                onActivated: index => {
                    if (index >= 0 && index < ThemeStore.palettes.length) {
                        const newTheme = ThemeStore.palettes[index];
                        Mem.options.appearance.colors.palattePath = newTheme.path;
                    }
                }
            }
        }
        RowLayout {
            Layout.preferredHeight: 45
            Layout.fillWidth: true

            StyledTextField {
                id: folderEntry
                Layout.preferredHeight: 45
                Layout.fillWidth: true
                text: FileUtils.collapsePath(Mem.looks.currentFolder)
                placeholderText: "Wallpaper folder path..."
                placeholderTextColor: Colors.colOnLayer3
                color: Colors.colOnLayer1
                bg.color: Colors.colLayer4
                Keys.onEscapePressed: focus = false
                onAccepted: Mem.looks.currentFolder = FileUtils.expandPath(folderEntry.text)
            }

            StyledComboBox {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                model: OnlineWallpaperService.methods.map(i => i.name)
                currentIndex: model.indexOf(OnlineWallpaperService.currentMethod)
                displayText: model[currentIndex] !== undefined ? model[currentIndex] : ""

                onActivated: index => {
                    if (index >= 0 && index < model.length) {
                        Mem.options.services.wallpapers.method = model[index];
                    }
                }
            }
        }
    }
}
