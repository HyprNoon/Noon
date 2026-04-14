pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import qs.common

Singleton {
    id: root

    readonly property var modes: [
        {
            "name": "Tonal Spot",
            "value": "scheme-tonal-spot",
            "icon": "palette"
        },
        {
            "name": "Neutral",
            "value": "scheme-neutral",
            "icon": "contrast"
        },
        {
            "name": "Expressive",
            "value": "scheme-expressive",
            "icon": "colorize"
        },
        {
            "name": "Fidelity",
            "value": "scheme-fidelity",
            "icon": "image"
        },
        {
            "name": "Content",
            "value": "scheme-content",
            "icon": "image"
        },
        {
            "name": "Monochrome",
            "value": "scheme-monochrome",
            "icon": "monochrome_photos"
        },
        {
            "name": "Rainbow",
            "value": "scheme-rainbow",
            "icon": "gradient"
        },
        {
            "name": "Fruit Salad",
            "value": "scheme-fruit-salad",
            "icon": "nature"
        },
        {
            "name": "Vibrant",
            "value": "scheme-vibrant",
            "icon": "palette"
        }
    ]

    property var themes: []
    readonly property var palettes: {
        let list = [
            {
                "name": "auto",
                "isPlugin": false,
                "path": Directories?.standard.state + "/colors.json"
            }
        ];

        for (let i = 0; i < palettesModel.count; i++) {
            list.push({
                "name": palettesModel.get(i, "fileBaseName"),
                "isPlugin": false,
                "path": Qt.resolvedUrl(palettesModel.get(i, "filePath"))
            });
        }

        for (let i = 0; i < pluginsPalettesModel.count; i++) {
            list.push({
                "name": pluginsPalettesModel.get(i, "fileBaseName"),
                "isPlugin": true,
                "path": Qt.resolvedUrl(pluginsPalettesModel.get(i, "filePath"))
            });
        }

        return list;
    }

    PModel {
        id: palettesModel
        folder: Qt.resolvedUrl(Directories.assets) + "/db/palettes"
    }

    PModel {
        id: pluginsPalettesModel
        folder: Qt.resolvedUrl(Directories.plugins.palettes)
    }

    Process {
        id: getGowallThemes
        running: true
        command: ["gowall", "list"]
        stdout: StdioCollector {
            onStreamFinished: root.themes = text.trim().split('\n')
        }
    }

    component PModel: FolderListModel {
        nameFilters: ["*.json"]
        showDirs: false
    }
}
