import qs.common.utils

JsonAdapter {
    property bool isAuth: false
    property JsonObject account: JsonObject {
        property string accountName: ""
        property string accountPhoto: ""
        property string accountHandle: ""
    }
    property JsonObject hits: JsonObject {
        property string recommendationsMode: "playlists"
    }

    property JsonObject ytmusicapi: JsonObject {
        property var headers: ({})
        property string cookies: ""
    }

    property JsonObject players: JsonObject {
        property JsonObject main: JsonObject {
            property string socketPath: "/tmp/beats_main.sock"
            property string mpvLog: "/tmp/beats_main.log"
            property bool loopPlaylist: true
            property var queue: []
            property JsonObject volumeNormalization: JsonObject {
                property bool enabled: true
                property string replaygain: "track"
            }

            property JsonObject eq: JsonObject {
                property bool enabled: true
                property var eqBands: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            }
        }

        property JsonObject preview: JsonObject {
            property string socketPath: "/tmp/beats_preview.sock"
            property string mpvLog: "/tmp/beats_preview.log"
            property bool loopPlaylist: false
            property var queue: []

            property JsonObject volumeNormalization: JsonObject {
                property bool enabled: false
                property string replaygain: "track"
            }

            property JsonObject eq: JsonObject {
                property bool enabled: false
                property var eqBands: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            }
        }
    }

    readonly property list<var> eqPresets: [
        {
            name: "Flat",
            materialIcon: "horizontal_rule",
            bands: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        },
        {
            name: "Bass Boost",
            materialIcon: "speaker",
            bands: [6, 5, 4, 3, 1, 0, 0, 0, 0, 0]
        },
        {
            name: "Bass Cut",
            materialIcon: "speaker_notes_off",
            bands: [-6, -5, -4, -3, -1, 0, 0, 0, 0, 0]
        },
        {
            name: "Treble Boost",
            materialIcon: "arrow_upward",
            bands: [0, 0, 0, 0, 0, 0, 1, 3, 5, 6]
        },
        {
            name: "Treble Cut",
            materialIcon: "arrow_downward",
            bands: [0, 0, 0, 0, 0, 0, -1, -3, -5, -6]
        },
        {
            name: "Loudness",
            materialIcon: "volume_up",
            bands: [6, 4, 0, 0, -2, 0, 0, 2, 4, 5]
        },
        {
            name: "Vocal Boost",
            materialIcon: "mic",
            bands: [0, 0, 2, 4, 5, 5, 4, 2, 0, 0]
        },
        {
            name: "Vocal Cut",
            materialIcon: "mic_off",
            bands: [0, 0, -2, -4, -5, -5, -4, -2, 0, 0]
        },
        {
            name: "Classical",
            materialIcon: "piano",
            bands: [4, 3, 2, 2, 0, 0, 0, 2, 3, 4]
        },
        {
            name: "Rock",
            materialIcon: "electric_bolt",
            bands: [5, 3, 2, 0, -1, 0, 1, 3, 4, 5]
        },
        {
            name: "Pop",
            materialIcon: "star",
            bands: [-1, 2, 4, 4, 2, 0, -1, -1, -1, -1]
        },
        {
            name: "Jazz",
            materialIcon: "music_note",
            bands: [3, 2, 1, 2, 0, 0, 0, 1, 2, 3]
        },
        {
            name: "Blues",
            materialIcon: "nights_stay",
            bands: [4, 3, 2, 1, 0, -1, 0, 1, 2, 3]
        },
        {
            name: "Electronic",
            materialIcon: "memory",
            bands: [5, 4, 2, 0, -2, -1, 1, 3, 4, 5]
        },
        {
            name: "Dance",
            materialIcon: "nightlife",
            bands: [5, 3, 1, 0, -1, 0, 1, 2, 3, 4]
        },
        {
            name: "Hip Hop",
            materialIcon: "headphones",
            bands: [5, 4, 3, 1, 0, -1, 0, 2, 3, 4]
        },
        {
            name: "R&B",
            materialIcon: "favorite",
            bands: [4, 3, 2, 2, 0, -1, 0, 2, 3, 4]
        },
        {
            name: "Soul",
            materialIcon: "self_improvement",
            bands: [3, 2, 1, 2, 1, 0, 0, 2, 3, 3]
        },
        {
            name: "Metal",
            materialIcon: "whatshot",
            bands: [6, 4, 2, 0, -2, -2, 0, 2, 4, 6]
        },
        {
            name: "Punk",
            materialIcon: "flash_on",
            bands: [4, 2, 0, -1, -1, 0, 1, 2, 3, 4]
        },
        {
            name: "Acoustic",
            materialIcon: "acoustic_echo",
            bands: [3, 2, 2, 1, 0, 0, 1, 2, 2, 3]
        },
        {
            name: "Soft",
            materialIcon: "air",
            bands: [2, 2, 1, 1, 0, 0, 0, 1, 2, 2]
        },
        {
            name: "Piano",
            materialIcon: "piano",
            bands: [0, 0, 1, 2, 3, 3, 2, 2, 1, 0]
        },
        {
            name: "Orchestra",
            materialIcon: "queue_music",
            bands: [3, 2, 1, 0, 0, 0, 1, 2, 3, 4]
        },
        {
            name: "Latin",
            materialIcon: "celebration",
            bands: [4, 2, 0, 0, -2, 0, 0, 2, 3, 4]
        },
        {
            name: "Reggae",
            materialIcon: "wb_sunny",
            bands: [0, 0, 0, -2, 0, 2, 2, 0, 0, 0]
        },
        {
            name: "Ska",
            materialIcon: "music_video",
            bands: [-1, -2, 0, 2, 3, 2, 0, -1, -2, -2]
        },
        {
            name: "Country",
            materialIcon: "landscape",
            bands: [3, 2, 1, 0, -1, 0, 1, 2, 3, 4]
        },
        {
            name: "Folk",
            materialIcon: "forest",
            bands: [2, 1, 1, 0, 0, 0, 1, 1, 2, 2]
        },
        {
            name: "Podcasts",
            materialIcon: "podcasts",
            bands: [0, 0, 1, 3, 4, 4, 3, 1, 0, 0]
        },
        {
            name: "Spoken Word",
            materialIcon: "record_voice_over",
            bands: [-2, -1, 1, 4, 5, 4, 2, 0, -1, -2]
        },
        {
            name: "Small Speaker",
            materialIcon: "phone_in_talk",
            bands: [4, 3, 2, 1, 0, 0, 1, 2, 3, 4]
        },
        {
            name: "Headphones",
            materialIcon: "headset",
            bands: [4, 3, 1, 0, -1, -1, 0, 2, 3, 4]
        },
        {
            name: "Night Mode",
            materialIcon: "bedtime",
            bands: [-2, -1, 0, 1, 2, 2, 1, 0, -1, -2]
        },
        {
            name: "Party",
            materialIcon: "party_mode",
            bands: [5, 3, 0, 0, 0, 0, 0, 0, 3, 5]
        },
        {
            name: "Live",
            materialIcon: "stadium",
            bands: [-2, 0, 2, 3, 3, 3, 2, 1, 1, 0]
        },
        {
            name: "Stadium",
            materialIcon: "sport_soccer",
            bands: [4, 2, 1, 0, 0, 0, 1, 2, 3, 4]
        },
        {
            name: "Deep",
            materialIcon: "water",
            bands: [5, 4, 3, 1, 0, -1, -2, -3, -3, -3]
        },
        {
            name: "Lounge",
            materialIcon: "local_bar",
            bands: [-1, 0, 1, 2, 2, 1, 0, 0, 1, 1]
        },
        {
            name: "Club",
            materialIcon: "nightlife",
            bands: [0, 0, 3, 4, 4, 3, 2, 0, 0, 0]
        },
    ]
}
