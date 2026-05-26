pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick

Singleton {
    readonly property var all: ["*"]
    readonly property var audio: ["*.mp3", "*.flac", "*.ogg", "*.wav", "*.m4a", "*.aac", "*.wma", "*.opus"]
    readonly property var picture: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.svg"]
    readonly property var video: ["*.mp4", "*.mov", "*.m4v", "*.avi", "*.mkv", "*.webm"]
    readonly property var executable: ["*.exe", "*.sh"]
    readonly property var document: ["*.txt", "*.md", "*.log", "*.json", "*.xml", "*.yaml", "*.yml", "*.ini", "*.conf", "*.cfg", "*.pdf", "*.doc", "*.docx", "*.txt", "*.rtf", "*.odt", "*.xls", "*.xlsx", "*.ppt", "*.pptx", "*.csv"]
    readonly property var archive: ["*.zip", "*.tar", "*.gz", "*.bz2", "*.xz", "*.7z", "*.rar", "*.tar.gz", "*.tar.bz2", "*.tar.xz"]
    readonly property var code: ["*.json", "*.qml"]
}
