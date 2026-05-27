import qs.common.utils

JsonAdapter {
    id: root
    property list<var> skills: []
    property list<var> models: []
    property string model: ""
    property string currentSessionId: ""
    property JO tokenCount: JO {
        property int input
        property int output
        property int total
    }
}
