import qs.common
import qs.common.utils

JsonAdapter {
    property list<string> folders: []
    property JO hits: JO {
        property string recommendationsMode: "playlists"
    }
    property JO players: JO {
        property JO webClient: JO {
            property int port: 8090
        }
        property JO main: JO {
            property var library: []
            property string host: Directories.beats.mpd + "/main_socket"
            property int port: 6600
            property string password: ""
            property string musicDirectory: ""
        }

        property JO preview: JO {
            property string host: Directories.beats.mpd + "/preview_socket"
            property int port: 6601
            property string password: ""
            property string musicDirectory: ""
        }
    }
}
