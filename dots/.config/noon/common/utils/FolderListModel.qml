import Qt.labs.folderlistmodel

FolderListModel {
    id: root
    function getArray(required) {
        let names = [];
        for (var i = 0; i < root.count; i++) {
            names.push(root.get(i, required));
        }
        return names;
    }
}
