<template>
    <div id="player-view">
        <div class="player-layout">
            <div class="player-main">
                <div
                    class="artwork-frame"
                    :class="{ spinning: s.state === 'play' }"
                >
                    <img
                        v-if="coverUrl && !coverErr"
                        :src="coverUrl"
                        class="artwork-img"
                        @error="coverErr = true"
                    />
                    <div v-else class="artwork-fallback">
                        <span class="icon">music_note</span>
                    </div>
                </div>

                <Transition name="fade" mode="out-in">
                    <div class="lyric-line" :key="currentLineIdx">
                        {{ currentLine?.text }}
                    </div>
                </Transition>

                <div class="track-section">
                    <div class="track-info">
                        <h1 class="track-title">
                            {{
                                cs.Title ||
                                cs.file?.split("/").pop() ||
                                "Not Playing"
                            }}
                        </h1>
                        <h2 class="track-artist">
                            {{ cs.Artist || "Unknown Artist" }}
                        </h2>
                    </div>

                    <div class="scrubber">
                        <div
                            class="slider"
                            ref="seekEl"
                            @pointerdown="onSeekDown"
                        >
                            <div class="slider-track"></div>
                            <div
                                class="slider-fill"
                                :style="{ width: barPct + '%' }"
                            ></div>
                            <div
                                class="slider-thumb"
                                :style="{ left: barPct + '%' }"
                            ></div>
                        </div>
                        <div class="time-row">
                            <span>{{ fmtTime(seekVal) }}</span>
                            <span
                                >-{{
                                    fmtTime(Math.max(0, dur - seekVal))
                                }}</span
                            >
                        </div>
                    </div>

                    <div class="transport">
                        <button class="tport-btn" @click="doCmd('previous')">
                            <span class="icon fill-icon">skip_previous</span>
                        </button>
                        <button
                            class="tport-btn play-btn"
                            @click="
                                doCmd(
                                    s.state === 'play' ? 'pause 1' : 'pause 0',
                                )
                            "
                        >
                            <span class="icon fill-icon">{{
                                s.state === "play" ? "pause" : "play_arrow"
                            }}</span>
                        </button>
                        <button class="tport-btn" @click="doCmd('next')">
                            <span class="icon fill-icon">skip_next</span>
                        </button>
                    </div>

                    <div class="volume">
                        <span class="icon vol-icon">volume_mute</span>
                        <div
                            class="slider vol-slider"
                            ref="volEl"
                            @pointerdown="onVolDown"
                        >
                            <div class="slider-track"></div>
                            <div
                                class="slider-fill"
                                :style="{ width: volPct + '%' }"
                            ></div>
                            <div
                                class="slider-thumb"
                                :style="{ left: volPct + '%' }"
                            ></div>
                        </div>
                        <span class="icon vol-icon">volume_up</span>
                    </div>
                </div>
            </div>

            <aside class="queue-panel">
                <h3 class="queue-heading">Up Next</h3>
                <div class="queue-list">
                    <div
                        v-for="(item, pos) in queue"
                        :key="item.index"
                        class="queue-item"
                        :class="{
                            now: item.current,
                            'drag-over': dropPos === pos,
                        }"
                        :draggable="!item.current"
                        @click="playItem(item)"
                        @dragstart="onDragStart($event, pos, item)"
                        @dragover.prevent="onDragOver(pos)"
                        @dragleave="onDragLeave"
                        @drop="onDrop($event, pos)"
                    >
                        <div class="queue-icon">
                            <span class="icon" v-if="item.current"
                                >volume_up</span
                            >
                            <span class="icon" v-else>music_note</span>
                        </div>
                        <div class="queue-body">
                            <div class="queue-title">
                                {{ item.title || item.file.split("/").pop() }}
                            </div>
                            <div class="queue-artist-name">
                                {{ item.artist || "Unknown Artist" }}
                            </div>
                        </div>
                        <span v-if="!item.current" class="queue-drag icon"
                            >drag_indicator</span
                        >
                    </div>
                    <div v-if="!queue.length" class="queue-empty">
                        No upcoming tracks
                    </div>
                </div>
            </aside>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { useMpd } from "../composables/useMpd.js";

const mpd = useMpd();

const s = computed(() => mpd.status);
const cs = computed(() => mpd.currentSong.value);
const queue = computed(() => mpd.queue.value);

const seeking = ref(false);
const seekVal = ref(0);
const coverErr = ref(false);
const seekEl = ref(null);
const volEl = ref(null);

const dragIndex = ref(null);
const dropPos = ref(null);

const syncedLines = ref([]);
const plainLyrics = ref("");
const lyricsLoaded = ref(false);
const lyricsPos = ref(0);

const currentLineIdx = computed(() => {
    const lines = syncedLines.value;
    if (!lines.length) return -1;
    for (let i = lines.length - 1; i >= 0; i--) {
        if (lines[i].time <= lyricsPos.value) return i;
    }
    return -1;
});

const currentLine = computed(() => {
    const idx = currentLineIdx.value;
    const lines = syncedLines.value;
    if (idx < 0 || !lines.length) return null;
    return {
        text: lines[idx].text,
        next: idx < lines.length - 1 ? lines[idx + 1].text : "",
    };
});

onMounted(() => {
    seekVal.value = parseFloat(s.value.elapsed || 0);
});

let lyricsTimer = null;

function tickLyrics() {
    lyricsPos.value += 0.1;
}

function startLyricsLoop() {
    clearInterval(lyricsTimer);
    if (s.value.state !== "play") return;
    lyricsPos.value = seekVal.value;
    lyricsTimer = setInterval(tickLyrics, 100);
}

function stopLyricsLoop() {
    clearInterval(lyricsTimer);
    lyricsTimer = null;
}

async function fetchLyrics() {
    const title = cs.value.Title;
    const artist = cs.value.Artist;
    if (!title) {
        lyricsLoaded.value = false;
        return;
    }
    try {
        const resp = await fetch(
            `/api/lyrics?title=${encodeURIComponent(title)}&artist=${encodeURIComponent(artist || "")}`,
        );
        if (!resp.ok) {
            lyricsLoaded.value = false;
            return;
        }
        const data = await resp.json();
        if (data.syncedLyrics) {
            syncedLines.value = data.syncedLyrics
                .split("\n")
                .map((l) => {
                    const m = l.match(/\[(\d+):(\d+\.?\d*)\](.*)/);
                    if (!m) return null;
                    return {
                        time: parseInt(m[1]) * 60 + parseFloat(m[2]),
                        text: m[3].trim(),
                    };
                })
                .filter((l) => l && l.text);
            plainLyrics.value = "";
        } else {
            syncedLines.value = [];
            plainLyrics.value = data.plainLyrics || "";
        }
        lyricsLoaded.value = true;
        if (s.value.state === "play") startLyricsLoop();
    } catch {
        lyricsLoaded.value = false;
    }
}

const songKey = computed(() => cs.value.file || "");

watch(songKey, (file, oldFile) => {
    if (!file || file === oldFile) return;
    stopLyricsLoop();
    syncedLines.value = [];
    plainLyrics.value = "";
    lyricsLoaded.value = false;
    lyricsPos.value = 0;
    fetchLyrics();
});

watch(
    () => s.value.state,
    (state) => {
        stopLyricsLoop();
        if (state === "play" && syncedLines.value.length) startLyricsLoop();
    },
);

watch(seeking, (v) => {
    if (!v) lyricsPos.value = seekVal.value;
});

const volPct = computed(() =>
    Math.min(100, Math.max(0, parseInt(s.value.volume || 0, 10))),
);
const dur = computed(() => parseFloat(s.value.duration || 0));
const coverUrl = computed(() =>
    cs.value.file ? mpd.coverUrl(cs.value.file) : "",
);

const barPct = computed(() => {
    if (!dur.value) return 0;
    return Math.min(100, (seekVal.value / dur.value) * 100);
});

watch(coverUrl, (val) => {
    if (val) coverErr.value = false;
});

watch(
    () => mpd.status.elapsed,
    (val) => {
        if (!seeking.value) {
            seekVal.value = parseFloat(val || 0);
        }
    },
);

function fmtTime(sec) {
    if (!sec || isNaN(sec)) return "0:00";
    const m = Math.floor(sec / 60);
    const sc = Math.floor(sec % 60);
    return `${m}:${sc.toString().padStart(2, "0")}`;
}

function handlePointer(e, el, callback) {
    e.preventDefault();
    const rect = el.getBoundingClientRect();

    const update = (evt) => {
        const clientX = evt.touches ? evt.touches[0].clientX : evt.clientX;
        let pct = (clientX - rect.left) / rect.width;
        pct = Math.max(0, Math.min(1, pct));
        callback(pct, false);
    };

    update(e);

    const onMove = (evt) => update(evt);
    const onUp = (evt) => {
        const clientX = evt.changedTouches
            ? evt.changedTouches[0].clientX
            : evt.clientX;
        let pct = (clientX - rect.left) / rect.width;
        pct = Math.max(0, Math.min(1, pct));

        window.removeEventListener("pointermove", onMove);
        window.removeEventListener("pointerup", onUp);
        window.removeEventListener("touchmove", onMove);
        window.removeEventListener("touchend", onUp);

        callback(pct, true);
    };

    window.addEventListener("pointermove", onMove);
    window.addEventListener("pointerup", onUp);
    window.addEventListener("touchmove", onMove, { passive: false });
    window.addEventListener("touchend", onUp);
}

function onSeekDown(e) {
    seeking.value = true;
    handlePointer(e, seekEl.value, (pct, isEnd) => {
        seekVal.value = pct * dur.value;
        if (isEnd) {
            mpd.do("seekcur", seekVal.value);
            seeking.value = false;
        }
    });
}

function onVolDown(e) {
    handlePointer(e, volEl.value, (pct) => {
        mpd.do("setvol", Math.round(pct * 100));
    });
}

function doCmd(cmd, ...args) {
    mpd.do(cmd, ...args);
}

async function playItem(item) {
    await mpd.do("play", item.index);
}

function onDragStart(e, pos, item) {
    dragIndex.value = item.index;
    e.dataTransfer.effectAllowed = "move";
    e.dataTransfer.setData("text/plain", String(item.index));
}

function onDragOver(pos) {
    dropPos.value = pos;
}

function onDragLeave() {
    dropPos.value = null;
}

function onDrop(e, dropQueuePos) {
    dropPos.value = null;
    const from = dragIndex.value;
    const to = queue.value[dropQueuePos]?.index;
    if (from == null || to == null || from === to) return;
    mpd.do("move", from, to);
    dragIndex.value = null;
}

onMounted(() => {
    seekVal.value = parseFloat(s.value.elapsed || 0);
});
</script>

<style scoped>
#player-view {
    position: relative;
    width: 100%;
    min-height: 100%;
    display: flex;
    justify-content: center;
    overflow: hidden;
    background: transparent;
    /*radial-gradient(ellipse at 20% 30%, rgba(128,128,128,0.08), transparent 60%),
                var(--bg);*/
}

.player-layout {
    position: relative;
    display: flex;
    flex-direction: row;
    width: 100%;
    max-width: 1120px;
    padding: 40px;
    gap: 48px;
    align-items: flex-start;
}

.player-main {
    flex: 1;
    max-width: 460px;
    display: flex;
    flex-direction: column;
    gap: 32px;
}

.artwork-frame {
    width: 100%;
    aspect-ratio: 1;
    border-radius: var(--radius-lg);
    overflow: hidden;
    background: var(--surface2);
    box-shadow: var(--shadow-lg);
    transition: box-shadow var(--transition);
    position: relative;
}

.artwork-frame.spinning {
    box-shadow:
        0 0 40px var(--accent-glow),
        var(--shadow-lg);
}

.artwork-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.artwork-fallback {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text3);
}

.artwork-fallback .icon {
    font-size: 80px;
}

.track-section {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.track-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.track-title {
    font-family: var(--font-body);
    font-size: 26px;
    font-weight: 700;
    color: var(--text);
    letter-spacing: -0.3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.2;
}

.track-artist {
    font-family: var(--font-body);
    font-size: 18px;
    font-weight: 400;
    color: var(--text2);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.3;
}

.scrubber {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.slider {
    position: relative;
    height: 24px;
    display: flex;
    align-items: center;
    cursor: pointer;
    touch-action: none;
}

.slider-track {
    position: absolute;
    left: 0;
    right: 0;
    height: 4px;
    border-radius: 2px;
    background: var(--border);
    transition: height 200ms ease;
}

.slider-fill {
    position: absolute;
    left: 0;
    height: 4px;
    border-radius: 2px;
    background: var(--accent);
    transition: height 200ms ease;
}

.slider-thumb {
    position: absolute;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: var(--accent);
    transform: translateX(-50%) scale(0);
    transition: transform 200ms ease;
    box-shadow: 0 0 6px var(--accent-glow);
}

.slider:hover .slider-track,
.slider:active .slider-track,
.slider:hover .slider-fill,
.slider:active .slider-fill {
    height: 6px;
}

.slider:hover .slider-thumb,
.slider:active .slider-thumb {
    transform: translateX(-50%) scale(1);
}

.time-row {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    font-weight: 500;
    color: var(--text3);
    font-variant-numeric: tabular-nums;
    font-family: var(--font-body);
}

.transport {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 32px;
}

.tport-btn {
    background: none;
    border: none;
    color: var(--text);
    cursor: pointer;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    transition:
        opacity 150ms,
        transform 100ms;
}

.tport-btn:active {
    opacity: 0.5;
    transform: scale(0.88);
}

.fill-icon {
    font-size: 40px;
    font-variation-settings: "FILL" 1;
}

.play-btn .fill-icon {
    font-size: 56px;
}

.volume {
    display: flex;
    align-items: center;
    gap: 14px;
}

.vol-icon {
    font-size: 18px;
    color: var(--text3);
    font-variation-settings: "FILL" 0;
}

.vol-slider {
    flex: 1;
}

.queue-panel {
    flex: 1;
    max-width: 400px;
    max-height: calc(100vh - 120px);
    display: flex;
    flex-direction: column;
    background: rgba(128, 128, 128, 0.03);
    backdrop-filter: blur(48px);
    -webkit-backdrop-filter: blur(48px);
    border: 1px solid rgba(128, 128, 128, 0.12);
    border-radius: var(--radius-lg);
    padding: 24px;
    position: sticky;
    top: 40px;
}

.queue-heading {
    font-family: var(--font-body);
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--text2);
    margin-bottom: 16px;
}

.lyric-line {
    text-align: center;
    font-family: var(--font-body);
    font-size: 26px;
    font-weight: 700;
    color: var(--text);
    line-height: 1.4;
    padding: 16px 0 8px;
    min-height: 52px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 250ms ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.lyrics-snippet.show {
    opacity: 1;
}

.lyric-line.current {
    font-family: var(--font-body);
    font-size: 18px;
    font-weight: 600;
    color: var(--text);
    line-height: 1.5;
}

.slide-enter-active {
    transition: all 250ms ease-out;
}
.slide-leave-active {
    transition: all 200ms ease-in;
}
.slide-enter-from {
    opacity: 0;
    transform: translateY(10px);
}
.slide-leave-to {
    opacity: 0;
    transform: translateY(-10px);
}

.lyric-line.next {
    font-family: var(--font-body);
    font-size: 14px;
    font-weight: 400;
    color: var(--text3);
    line-height: 1.5;
    margin-top: 4px;
    opacity: 0;
    transition: opacity 200ms;
}

.lyric-line.next.show {
    opacity: 1;
}

.queue-list {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.queue-list::-webkit-scrollbar {
    display: none;
}

.queue-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 10px;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: background 150ms;
}

.queue-item:hover {
    background: var(--surface2);
}

.queue-item.now {
    background: var(--surface2);
}

.queue-item.drag-over {
    border-top: 2px solid var(--accent);
}

.queue-drag {
    font-size: 18px;
    color: var(--text3);
    flex-shrink: 0;
    cursor: grab;
    opacity: 0;
    transition: opacity 150ms;
}

.queue-item:hover .queue-drag {
    opacity: 1;
}

.queue-icon {
    width: 36px;
    height: 36px;
    border-radius: 6px;
    background: var(--surface2);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.queue-icon .icon {
    font-size: 18px;
    color: var(--text3);
}

.queue-item.now .queue-icon {
    background: var(--accent-glow);
}

.queue-item.now .queue-icon .icon {
    color: var(--accent);
}

.queue-body {
    flex: 1;
    min-width: 0;
}

.queue-title {
    font-family: var(--font-body);
    font-size: 14px;
    font-weight: 500;
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.3;
}

.queue-artist-name {
    font-family: var(--font-body);
    font-size: 12px;
    color: var(--text3);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.3;
}

.queue-empty {
    text-align: center;
    color: var(--text3);
    margin-top: 32px;
    font-size: 14px;
}

@media (max-width: 960px) {
    .player-layout {
        flex-direction: column;
        align-items: center;
        padding: 24px 20px;
        gap: 32px;
    }

    .player-main {
        max-width: 100%;
        width: 100%;
    }

    .track-section {
        gap: 28px;
    }

    .artwork-frame {
        max-width: 320px;
        margin: 0 auto;
    }

    .queue-panel {
        max-width: 100%;
        width: 100%;
        max-height: 320px;
        position: static;
        border-radius: var(--radius);
        padding: 20px;
    }
}

@media (max-width: 480px) {
    .player-layout {
        padding: 16px 16px 80px;
        gap: 24px;
    }

    .artwork-frame {
        max-width: 260px;
    }

    .track-title {
        font-size: 22px;
    }

    .track-artist {
        font-size: 16px;
    }

    .track-section {
        gap: 24px;
    }

    .transport {
        gap: 28px;
    }

    .fill-icon {
        font-size: 36px;
    }

    .play-btn .fill-icon {
        font-size: 52px;
    }

    .artwork-frame {
        border-radius: var(--radius);
    }
}
</style>
