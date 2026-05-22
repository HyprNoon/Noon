import qs.common.utils

JsonAdapter {
    property JO hits: JO {
        property string recommendationsMode: "playlists"
    }

    property JO players: JO {
        property JO webClient: JO {
            property int port: 8090
        }
        property JO main: JO {
            property string host: "localhost"
            property int port: 6600
            property string password: ""
        }

        property JO preview: JO {
            property string host: "localhost"
            property int port: 6601
            property string password: ""
        }
    }
}
