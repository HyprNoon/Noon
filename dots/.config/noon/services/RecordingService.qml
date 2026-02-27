pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions

Singleton {
    id: root

    // State
    property bool isRecording: false
    property int recordingDuration: 0

    // Settings — indices match UI order
    // recordingMode: 0=Screen, 1=Region, 2=Window
    // audioMode:     0=Muted,  1=System, 2=Mic
    // quality:       0=720@30, 1=1080@30, 2=1080@60
    property int recordingMode: 0
    property int audioMode: 1
    property int quality: 1
    property bool showCursor: true

    // Public API
    function setRecordingMode(i) {
        if (!isRecording)
            recordingMode = i;
    }
    function setAudioMode(i) {
        if (!isRecording)
            audioMode = i;
    }
    function setQuality(i) {
        if (!isRecording)
            quality = i;
    }

    function toggleRecording() {
        isRecording ? _stop() : _start();
    }

    function getFormattedDuration() {
        const m = Math.floor(recordingDuration / 60).toString().padStart(2, "0");
        const s = (recordingDuration % 60).toString().padStart(2, "0");
        return `${m}:${s}`;
    }

    // Internals
    function _outputPath() {
        const ts = new Date().toISOString().replace(/[:.]/g, "-").slice(0, 19);
        return `${FileUtils.trimFileProtocol(Directories.records)}/recording-${ts}.mp4`;
    }

    function _buildArgs(output) {
        const fps = [30, 30, 60][quality];
        const crf = [28, 23, 20][quality];

        // Region and Window modes need a shell pipeline to get geometry first,
        // so we wrap them in sh -c
        if (recordingMode === 1) {
            const audio = _audioFlags();
            const cursor = showCursor ? "" : " --no-damage";
            return ["sh", "-c", `slurp | xargs -I {} wf-recorder -g "{}" -f ${output} -r ${fps} -c libx264 -p preset=fast -p crf=${crf}${cursor}${audio}`];
        }

        if (recordingMode === 2) {
            const audio = _audioFlags();
            const cursor = showCursor ? "" : " --no-damage";
            return ["sh", "-c", `GEOM=$(hyprctl -j activewindow | jq -r '"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"') && wf-recorder -g "$GEOM" -f ${output} -r ${fps} -c libx264 -p preset=fast -p crf=${crf}${cursor}${audio}`];
        }

        // Full screen — direct args, no shell needed
        let args = ["wf-recorder", "-f", output, "-r", fps.toString(), "-c", "libx264", "-p", "preset=fast", "-p", `crf=${crf}`];
        if (!showCursor)
            args.push("--no-damage");
        if (audioMode === 1)
            args.push("--audio");
        if (audioMode === 2)
            args.push("--audio", "--audio-device=default");
        return args;
    }

    function _audioFlags() {
        if (audioMode === 0)
            return "";
        if (audioMode === 2)
            return " --audio --audio-device=default";
        return " --audio";
    }

    function _start() {
        const args = _buildArgs(_outputPath());
        recorderProcess.command = args;
        recorderProcess.running = true;
        isRecording = true;
        recordingDuration = 0;
    }

    function _stop() {
        recorderProcess.running = false; //.signal(2); // SIGINT — lets wf-recorder finalize the file
    }

    Process {
        id: recorderProcess
        onExited: (code, status) => {
            root.isRecording = false;
            root.recordingDuration = 0;
        }
    }

    Timer {
        interval: 1000
        running: root.isRecording
        repeat: true
        onTriggered: root.recordingDuration++
    }
}
