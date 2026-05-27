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
                "path": Directories?.standard.state + "/user/generated/colors.json"
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
    readonly property list<var> predefinedColors: [
        {
            /* Chrome Blue */
            dark: {
                primary: "#a8c7fa",
                secondary: "#a2b8d9",
                primaryContainer: "#1e4a9c"
            },
            light: {
                primary: "#0b57d0",
                secondary: "#4a6a9c",
                primaryContainer: "#d3e3fd"
            }
        },
        {
            /* Chrome Red */
            dark: {
                primary: "#ff9388",
                secondary: "#c39c99",
                primaryContainer: "#8c1d1d"
            },
            light: {
                primary: "#ba1a1a",
                secondary: "#8c5f5a",
                primaryContainer: "#ffdad6"
            }
        },
        {
            /* Chrome Green */
            dark: {
                primary: "#7be89e",
                secondary: "#9bad9f",
                primaryContainer: "#0f5c2f"
            },
            light: {
                primary: "#188038",
                secondary: "#4f6b52",
                primaryContainer: "#ceead6"
            }
        },
        {
            /* Chrome Yellow */
            dark: {
                primary: "#ffe68c",
                secondary: "#b3a47a",
                primaryContainer: "#4a3f00"
            },
            light: {
                primary: "#705d00",
                secondary: "#6f6649",
                primaryContainer: "#fde293"
            }
        },
        {
            /* Chrome Purple */
            dark: {
                primary: "#d0bcff",
                secondary: "#a89bb9",
                primaryContainer: "#4f378b"
            },
            light: {
                primary: "#6750a4",
                secondary: "#605b71",
                primaryContainer: "#eaddff"
            }
        },
        {
            /* Chrome Pink */
            dark: {
                primary: "#ffb1c8",
                secondary: "#b38a9b",
                primaryContainer: "#7f1e4f"
            },
            light: {
                primary: "#bc005f",
                secondary: "#74565f",
                primaryContainer: "#ffd9e2"
            }
        },
        {
            /* Chrome Orange */
            dark: {
                primary: "#ffb686",
                secondary: "#a88a72",
                primaryContainer: "#7a3f0f"
            },
            light: {
                primary: "#994700",
                secondary: "#775844",
                primaryContainer: "#ffdcbe"
            }
        },
        {
            /* Chrome Cyan */
            dark: {
                primary: "#78d9ec",
                secondary: "#8eb0b6",
                primaryContainer: "#004f58"
            },
            light: {
                primary: "#006876",
                secondary: "#4a6267",
                primaryContainer: "#c6f0f7"
            }
        },
        {
            /* Chrome Grey */
            dark: {
                primary: "#e3e3e3",
                secondary: "#c6c6c6",
                primaryContainer: "#3f3f3f"
            },
            light: {
                primary: "#5e5e5e",
                secondary: "#5e5e5e",
                primaryContainer: "#e3e3e3"
            }
        },
        {
            /* Teal */
            dark: {
                primary: "#7ed9c8",
                secondary: "#8ca8a0",
                primaryContainer: "#004d44"
            },
            light: {
                primary: "#006d5f",
                secondary: "#4a635d",
                primaryContainer: "#c4f0e8"
            }
        },
        {
            /* Lime */
            dark: {
                primary: "#c9f28c",
                secondary: "#a8b37f",
                primaryContainer: "#374f00"
            },
            light: {
                primary: "#5c6f00",
                secondary: "#5f6649",
                primaryContainer: "#e8f5a8"
            }
        },
        {
            /* Indigo */
            dark: {
                primary: "#b8c4ff",
                secondary: "#9a9fc7",
                primaryContainer: "#3a3f8c"
            },
            light: {
                primary: "#3f51b5",
                secondary: "#5a5f8c",
                primaryContainer: "#e0e4ff"
            }
        },
        {
            /* Rose */
            dark: {
                primary: "#ffb4d1",
                secondary: "#b38a9f",
                primaryContainer: "#7f1e4f"
            },
            light: {
                primary: "#c2185b",
                secondary: "#7a4f5f",
                primaryContainer: "#ffe0e9"
            }
        },
        {
            /* Amber / Deep Orange */
            dark: {
                primary: "#ffcc80",
                secondary: "#b39e7a",
                primaryContainer: "#6f3f00"
            },
            light: {
                primary: "#ff8f00",
                secondary: "#7f5f3f",
                primaryContainer: "#ffe4b8"
            }
        }
    ]

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
