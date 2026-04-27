pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    property string distroName: "Unknown"
    property string distroId: "unknown"
    property string distroIcon: "arch-symbolic"
    property string username: "user"
    property string userPfp: Directories.standard.home + "/.face.png"
    readonly property var oauthData: JSON.parse(oauthView.text().trim())
    Component.onCompleted: console.log(JSON.stringify(oauthData))
    Timer {
        triggeredOnStart: true
        interval: 1
        running: true
        repeat: false
        onTriggered: {
            usernameProc.running = true;
            osView.reload();
            const textOsRelease = osView.text();
            // Extract the friendly name (PRETTY_NAME field, fallback to NAME)
            const prettyNameMatch = textOsRelease.match(/^PRETTY_NAME="(.+?)"/m);
            const nameMatch = textOsRelease.match(/^NAME="(.+?)"/m);
            distroName = prettyNameMatch ? prettyNameMatch[1] : (nameMatch ? nameMatch[1].replace(/Linux/i, "").trim() : "Unknown");
            // Extract the ID (LOGO field, fallback to "unknown")
            const logoMatch = textOsRelease.match(/^LOGO=(.+)$/m);
            distroId = logoMatch ? logoMatch[1].replace(/"/g, "") : "unknown";
            // Update the distroIcon property based on distroId
            switch (distroId) {
            case "arch":
                distroIcon = "arch-symbolic";
                break;
            case "endeavouros":
                distroIcon = "endeavouros-symbolic";
                break;
            case "cachyos":
                distroIcon = "cachyos-symbolic";
                break;
            case "nixos":
                distroIcon = "nixos-symbolic";
                break;
            case "fedora":
                distroIcon = "fedora-symbolic";
                break;
            case "linuxmint":
            case "ubuntu":
            case "zorin":
            case "popos":
                distroIcon = "ubuntu-symbolic";
                break;
            case "debian":
            case "raspbian":
            case "kali":
                distroIcon = "debian-symbolic";
                break;
            default:
                distroIcon = "arch-symbolic";
                break;
            }
        }
    }

    Process {
        id: usernameProc
        command: ["whoami"]
        stdout: SplitParser {
            onRead: data => username = data.trim()
        }
    }

    FileView {
        id: oauthView
        path: Directories.standard.state + "/user/generated/oauth.json"
    }

    FileView {
        id: osView
        path: "/etc/os-release"
    }
}
