<template>
  <div class="library">
    <div class="lib-toolbar">
      <div class="search-wrap">
        <span class="icon search-icon">search</span>
        <input
          class="search-input" type="text" placeholder="Search…"
          v-model="search"
        />
      </div>
      <select class="sort-select" v-model="sort">
        <option value="">Default</option>
        <option value="title">Title</option>
        <option value="artist">Artist</option>
        <option value="album">Album</option>
        <option value="date">Date</option>
      </select>
    </div>

    <div class="lib-tabs">
      <button
        v-for="f in filters" :key="f"
        class="tab-btn"
        :class="{ active: activeFilter === f }"
        @click="setFilter(f)"
      >{{ f }}</button>
    </div>

    <div v-if="!loaded" class="loading">Loading library…</div>

    <div v-else class="lib-body">
      <template v-if="activeFilter === 'tracks'">
        <button
          v-for="(t, i) in filteredTracks"
          :key="t.file"
          class="row-item"
          @click="playTrack(t)"
        >
          <span class="row-idx">{{ i + 1 }}</span>
          <div class="row-art">
            <img v-if="t.cover" :src="mpd.coverUrl(t.cover)" loading="lazy"
              @error="e => e.target.style.display='none'"
            />
            <div class="row-art-fallback"><span class="icon">music_note</span></div>
          </div>
          <div class="row-body">
            <div class="row-title">{{ t.title || t.file.split('/').pop() }}</div>
            <div class="row-meta">{{ t.artist }}{{ t.album ? ' · ' + t.album : '' }}</div>
          </div>
          <span class="row-dur">{{ fmtDur(t.duration) }}</span>
        </button>
      </template>

      <template v-else-if="activeFilter === 'albums'">
        <button
          v-for="a in filteredAlbums"
          :key="a.artist + a.album"
          class="row-item"
          @click="playAlbum(a.artist, a.album)"
        >
          <div class="row-art">
            <img v-if="a.cover" :src="mpd.coverUrl(a.cover)" loading="lazy"
              @error="e => e.target.style.display='none'"
            />
            <div class="row-art-fallback"><span class="icon">album</span></div>
          </div>
          <div class="row-body">
            <div class="row-title">{{ a.album }}</div>
            <div class="row-meta">{{ a.artist }} · {{ a.trackCount }} tracks</div>
          </div>
          <span class="row-icon icon">play_arrow</span>
        </button>
      </template>

      <template v-else-if="activeFilter === 'artists'">
        <button
          v-for="a in filteredArtists"
          :key="a.name"
          class="row-item"
          @click="playArtist(a.name)"
        >
          <div class="row-art row-art-avatar">
            <div class="row-art-fallback"><span class="icon">person</span></div>
          </div>
          <div class="row-body">
            <div class="row-title">{{ a.name }}</div>
            <div class="row-meta">{{ a.trackCount }} tracks</div>
          </div>
          <span class="row-icon icon">play_arrow</span>
        </button>
      </template>

      <div v-if="empty" class="empty">No results</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useMpd } from '../composables/useMpd.js'
import { useLibrary } from '../composables/useLibrary.js'

const route = useRoute()
const mpd = useMpd()
const { load, tracks, albums, artists } = useLibrary()

const loaded = ref(false)
const search = ref('')
const sort = ref('')
const activeFilter = ref('tracks')
const filters = ['tracks', 'albums', 'artists']

watch(() => route.name, (name) => {
  if (['tracks', 'albums', 'artists'].includes(name)) {
    activeFilter.value = name
  }
}, { immediate: true })

function setFilter(f) {
  activeFilter.value = f
}

function filterItems(items) {
  const q = search.value.toLowerCase()
  if (!q) return items
  return items.filter(i => JSON.stringify(i).toLowerCase().includes(q))
}

function sortItems(items) {
  const s = sort.value
  if (!s) return items
  return [...items].sort((a, b) => {
    const va = (a[s] || '').toLowerCase()
    const vb = (b[s] || '').toLowerCase()
    return va.localeCompare(vb)
  })
}

const filteredTracks = computed(() => sortItems(filterItems(tracks.value)))
const filteredAlbums = computed(() => sortItems(filterItems(albums.value)))
const filteredArtists = computed(() => sortItems(filterItems(artists.value)))

const empty = computed(() => {
  if (!loaded.value) return false
  if (activeFilter.value === 'tracks') return filteredTracks.value.length === 0
  if (activeFilter.value === 'albums') return filteredAlbums.value.length === 0
  if (activeFilter.value === 'artists') return filteredArtists.value.length === 0
  return false
})

function fmtDur(sec) {
  if (!sec || isNaN(sec)) return '-:--'
  const m = Math.floor(sec / 60)
  const s = Math.floor(sec % 60)
  return `${m}:${s.toString().padStart(2, '0')}`
}

async function playTrack(t) {
  await fetch(`/api/play-by-name/${encodeURIComponent(t.file)}`)
  await mpd.refresh()
}

function playAlbum(artist, album) {
  const t = tracks.value.filter(tr => tr.artist === artist && tr.album === album)
  if (!t.length) return
  mpd.cmd('clear').then(() => {
    return Promise.all(t.map(tr => mpd.cmd('add', `"${tr.file}"`)))
  }).then(() => mpd.cmd('play', '0')).then(() => mpd.refresh())
}

function playArtist(artist) {
  const t = tracks.value.filter(tr => tr.artist === artist)
  if (!t.length) return
  mpd.cmd('clear').then(() => {
    return Promise.all(t.map(tr => mpd.cmd('add', `"${tr.file}"`)))
  }).then(() => mpd.cmd('play', '0')).then(() => mpd.refresh())
}

onMounted(async () => {
  await load()
  loaded.value = true
})
</script>

<style scoped>
.library {
  animation: libFade 400ms ease both;
  width: 100%;
}

@keyframes libFade {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.lib-toolbar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.search-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 0 14px;
  transition: border-color var(--transition);
}

.search-wrap:focus-within {
  border-color: var(--text);
}

.search-icon {
  font-size: 20px;
  color: var(--text3);
  font-variation-settings: 'FILL' 0;
}

.search-input {
  flex: 1;
  padding: 11px 0;
  border: none;
  background: transparent;
  color: var(--text);
  font-size: 14px;
  font-family: var(--font-body);
  outline: none;
}

.search-input::placeholder {
  color: var(--text3);
}

.sort-select {
  padding: 11px 36px 11px 14px;
  border-radius: var(--radius);
  border: 1px solid var(--border);
  background: var(--surface);
  color: var(--text);
  font-size: 13px;
  font-family: var(--font-body);
  outline: none;
  cursor: pointer;
  -webkit-appearance: none;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2371717a' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 10px center;
  transition: border-color var(--transition);
}
.sort-select:focus { border-color: var(--text); }

.lib-tabs {
  display: flex;
  gap: 2px;
  margin-bottom: 24px;
  padding: 2px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
}

.tab-btn {
  flex: 1;
  background: none;
  border: none;
  color: var(--text2);
  padding: 8px 12px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
  font-family: var(--font-body);
  transition: background 120ms, color 120ms;
  text-transform: capitalize;
}

.tab-btn:hover {
  background: var(--surface2);
  color: var(--text);
}

.tab-btn.active {
  color: var(--accent);
  font-weight: 600;
}

.loading {
  color: var(--text3);
  font-size: 14px;
  text-align: center;
  padding: 60px 40px;
}

.empty {
  color: var(--text3);
  text-align: center;
  padding: 60px 40px;
}

.lib-body {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.row-item {
  display: flex;
  align-items: center;
  gap: 14px;
  width: 100%;
  padding: 14px 16px;
  background: none;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  text-align: left;
  color: var(--text);
  transition: background 120ms;
}

.row-item:hover {
  background: var(--surface);
}

.row-item:active {
  background: var(--surface2);
}

.row-idx {
  width: 28px;
  font-size: 12px;
  font-weight: 400;
  color: var(--text3);
  text-align: right;
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
  font-family: var(--font-body);
}

.row-art {
  width: 52px;
  height: 52px;
  border-radius: 6px;
  background: var(--surface2);
  flex-shrink: 0;
  overflow: hidden;
}

.row-art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.row-art-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text3);
}

.row-art-fallback .icon {
  font-size: 26px;
  font-variation-settings: 'FILL' 0;
}

.row-art-avatar .row-art-fallback .icon {
  font-size: 30px;
}

.row-body {
  flex: 1;
  min-width: 0;
}

.row-title {
  font-family: var(--font-body);
  font-size: 15px;
  font-weight: 500;
  color: var(--text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.3;
}

.row-meta {
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 400;
  color: var(--text3);
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.row-dur {
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 400;
  color: var(--text3);
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
}

.row-icon {
  font-size: 18px;
  color: var(--text3);
  flex-shrink: 0;
  font-variation-settings: 'FILL' 0;
}

.row-item:hover .row-icon {
  color: var(--text);
}

@media (max-width: 640px) {
  .lib-toolbar { flex-direction: column; gap: 8px; }
  .search-wrap { padding: 0 12px; }
  .search-input { padding: 12px 0; font-size: 16px; }
  .sort-select { padding: 12px 36px 12px 12px; }
  .lib-tabs { margin-bottom: 16px; }
  .tab-btn { font-size: 14px; padding: 10px 12px; }
  .row-item { padding: 10px 12px; gap: 10px; }
  .row-idx { width: 24px; }
  .row-art { width: 44px; height: 44px; }
  .row-title { font-size: 14px; }
  .row-meta { font-size: 12px; }
}

@media (max-width: 420px) {
  .row-art { width: 38px; height: 38px; }
  .row-idx { width: 18px; font-size: 11px; }
  .row-title { font-size: 13px; }
}
</style>
