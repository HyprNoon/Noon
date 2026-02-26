import qs.common.utils

JsonAdapter {
    property JsonObject misc: JsonObject {
        property list<string> ipcCommands: []
        property list<string> systemCommands: []
    }

    property JsonObject services: JsonObject {
        property JsonObject ambientSounds
        property JsonObject icons
        property JsonObject emojis
        property JsonObject backlight

        backlight: JsonObject {
            property list<var> devices: []
        }

        icons: JsonObject {
            property list<var> availableIconThemes: []
        }
        ambientSounds: JsonObject {
            property list<var> availableSounds: []
        }
    }
}
