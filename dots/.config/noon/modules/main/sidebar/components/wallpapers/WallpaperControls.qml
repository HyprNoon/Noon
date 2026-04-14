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

    function findIndex(array, value, valueRole) {
        for (let i = 0; i < array.length; i++) {
            if (array[i][valueRole] === value)
                return i;
        }
        return 0;
    }
    z: 9999
    bottomAreaReveal: true
    hoverHeight: 320
    color: Colors.colLayer1
    collapsedHeight: 165
    enableStagedReveal: false
    bgAnchors {
        rightMargin: Padding.large
        leftMargin: Padding.large
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: Padding.large
        RLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 32
            Repeater {
                model: ["Primary", "Secondary", "Tertiary", "PrimaryContainer", "SecondaryContainer", "TertiaryContainer", "Error", "ErrorContainer"]
                delegate: StyledRect {
                    radius: 999
                    color: Colors["col" + modelData]
                    implicitSize: 28
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        StyledToolTip {
                            extraVisibleCondition: parent.containsMouse
                            content: modelData.replace("Container", " Container")
                        }
                    }
                }
            }
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
                currentIndex: root.findIndex(ThemeStore.modes, Mem.states.desktop.appearance.scheme, "value")
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
        StyledTextField {
            property string sanitizedAddress: "~" + FileUtils.trimFileProtocol(Mem.states.desktop.bg.currentFolder.slice(Directories.standard.home.length))
            Layout.preferredHeight: 45
            Layout.fillWidth: true
            text: sanitizedAddress
            placeholderText: "Wallpaper folder path..."
            placeholderTextColor: Colors.colOnLayer1
            color: Colors.colOnLayer1
            Keys.onEscapePressed: focus = false
            onAccepted: Mem.states.desktop.bg.currentFolder = Qt.resolvedUrl(text.replace("~", Directories.standard.home))
        }
    }
}
