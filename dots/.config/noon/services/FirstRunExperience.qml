import Quickshell
import qs.common
import qs.common.functions
import qs.common.utils
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    property string firstRunFilePath: `${Directories.standard.state}/user/first_run.txt`
    property string firstRunFileContent: "This file is just here to confirm you've been greeted :>"
    property string firstRunNotifSummary: "Welcome!"
    property string firstRunNotifBody: "Hit Super+/ for a list of keybinds"
    property string defaultWallpaperPath: FileUtils.trimFileProtocol(`${Directories.standard.config}/noon/assets/images/default_wallpaper.png`)

    function load() {
        firstRunFileView.reload();
    }

    function handleFirstRun() {
        NoonUtils.toast({
            id: 0,
            content: `${root.firstRunNotifSummary} '${root.firstRunNotifBody}'`,
            icon: "tune"
        });
        Appearance.getCurrentIconTheme();
    }

    FileView {
        id: firstRunFileView

        path: Qt.resolvedUrl(firstRunFilePath)
        onLoadFailed: (error) => {
            if (error == FileViewError.FileNotFound) {
                firstRunFileView.setText(root.firstRunFileContent);
                root.handleFirstRun();
            }
        }
    }

}
