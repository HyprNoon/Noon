<template>
  <div class="libv1">
    <header class="v1-header">
      <div class="search-wrap">
        <span class="icon search-icon">search</span>
        <input
          class="search-input" type="text" placeholder="Search library…"
          v-model="search"
        />
      </div>
    </header>

    <div v-if="!loaded" class="loading">Loading library…</div>

    <template v-else>
      <section class="hero-section" v-if="heroAlbum">
        <div class="hero-art" @click="playAlbum(heroAlbum.artist, heroAlbum.album)">
          <img v-if="heroAlbum.cover" :src="mpd.coverUrl(heroAlbum.cover)" loading="lazy"
            @error="e => e.target.style.display='none'"
          />
          <div class="hero-fallback" v-else><span class="icon">album</span></div>
        </div>
        <div class="hero-body">
          <span class="hero-label">Featured Album</span>
          <h2 class="hero-title">{{ heroAlbum.album }}</h2>
          <p class="hero-artist">{{ heroAlbum.artist }}</p>
          <span class="hero-count">{{ heroAlbum.trackCount }} tracks</span>
        </div>
      </section>

      <div class="section-head">
        <h3 class="section-title">Albums</h3>
      </div>

      <div class="album-gallery" ref="galleryEl">
        <button
          v-for="a in filteredAlbums"
          :key="a.artist + a.album"
          class="album-tile"
          :class="{ featured: a === heroAlbum }"
          @click="playAlbum(a.artist, a.album)"
        >
          <div class="tile-art">
            <img v-if="a.cover" :src="mpd.coverUrl(a.cover)" loading="lazy"
              @error="e => e.target.style.display='none'"
            />
            <div class="tile-fallback" v-else><span class="icon">music_note</span></div>
            <div class="tile-overlay">
              <span class="tile-play-icon icon">play_arrow</span>
            </div>
          </div>
          <div class="tile-info">
            <div class="tile-album">{{ a.album }}</div>
            <div class="tile-artist">{{ a.artist }}</div>
          </div>
        </button>
      </div>

      <div v-if="emptyAlbums" class="empty">No albums match</div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useMpd } from '../composables/useMpd.js'
import { useLibrary } from '../composables/useLibrary.js'

const mpd = useMpd()
const { load, tracks, albums, artists } = useLibrary()

const loaded = ref(false)
const search = ref('')
const galleryEl = ref(null)

const heroAlbum = computed(() => {
  if (!albums.value.length) return null
  return albums.value[0]
})

function filterItems(items) {
  const q = search.value.toLowerCase()
  if (!q) return items
  return items.filter(i => JSON.stringify(i).toLowerCase().includes(q))
}

const filteredAlbums = computed(() => filterItems(albums.value))
const emptyAlbums = computed(() => loaded.value && filteredAlbums.value.length === 0)

function playAlbum(artist, album) {
  const t = tracks.value.filter(tr => tr.artist === artist && tr.album === album)
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
.libv1 {
  animation: fadeUp 500ms ease both;
  width: 100%;
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.v1-header {
  margin-bottom: 40px;
}

.search-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
  background: transparent;
  border-bottom: 1.5px solid var(--border);
  padding: 0 0 10px;
  transition: border-color var(--transition);
}

.search-wrap:focus-within {
  border-color: var(--text);
}

.search-icon {
  font-size: 20px;
  color: var(--text3);
  font-variation-settings: 'FILL' 0, 'wght' 300;
}

.search-input {
  flex: 1;
  padding: 0;
  border: none;
  background: transparent;
  color: var(--text);
  font-size: 15px;
  font-family: var(--font-body);
  outline: none;
  letter-spacing: 0.2px;
}

.search-input::placeholder {
  color: var(--text3);
  font-weight: 300;
}

.loading {
  color: var(--text3);
  font-size: 14px;
  text-align: center;
  padding: 80px 40px;
  font-weight: 400;
}

.empty {
  color: var(--text3);
  text-align: center;
  padding: 60px 40px;
  font-size: 14px;
}

.hero-section {
  display: flex;
  gap: 36px;
  margin-bottom: 52px;
  padding-bottom: 52px;
  border-bottom: 1px solid var(--border);
  align-items: center;
}

.hero-art {
  width: 220px;
  aspect-ratio: 1;
  border-radius: 4px;
  overflow: hidden;
  background: var(--surface2);
  cursor: pointer;
  flex-shrink: 0;
  transition: box-shadow var(--transition);
  position: relative;
}

.hero-art:hover {
  box-shadow: 0 0 0 2px var(--text3);
}

.hero-art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.hero-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text3);
}

.hero-fallback .icon {
  font-size: 60px;
  font-variation-settings: 'FILL' 0;
}

.hero-body {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.hero-label {
  font-family: var(--font-body);
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  color: var(--text3);
  margin-bottom: 6px;
}

.hero-title {
  font-family: var(--font-display);
  font-size: 38px;
  font-weight: 700;
  color: var(--text);
  letter-spacing: -1.2px;
  line-height: 1.05;
}

.hero-artist {
  font-family: var(--font-body);
  font-size: 18px;
  font-weight: 400;
  color: var(--text2);
  margin-top: 4px;
}

.hero-count {
  font-family: var(--font-body);
  font-size: 12px;
  font-weight: 400;
  color: var(--text3);
  margin-top: 8px;
}

.section-head {
  margin-bottom: 24px;
}

.section-title {
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 600;
  color: var(--text);
  letter-spacing: -0.3px;
}

.album-gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 24px;
}

.album-tile {
  display: flex;
  flex-direction: column;
  background: none;
  border: none;
  cursor: pointer;
  text-align: left;
  padding: 0;
  transition: transform 200ms ease;
  border-radius: 0;
}

.album-tile:hover {
  transform: translateY(-4px);
}

.album-tile:active {
  transform: translateY(-2px) scale(0.98);
}

.tile-art {
  width: 100%;
  aspect-ratio: 1;
  background: var(--surface2);
  overflow: hidden;
  position: relative;
  border-radius: 4px;
}

.tile-art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: filter 300ms ease;
}

.album-tile:hover .tile-art img {
  filter: brightness(0.65);
}

.tile-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text3);
}

.tile-fallback .icon {
  font-size: 40px;
  font-variation-settings: 'FILL' 0;
}

.tile-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 300ms ease;
}

.album-tile:hover .tile-overlay {
  opacity: 1;
}

.tile-play-icon {
  font-size: 44px;
  color: white;
  font-variation-settings: 'FILL' 1, 'wght' 400;
  text-shadow: 0 2px 12px rgba(0,0,0,0.5);
}

.tile-info {
  padding: 14px 0 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.tile-album {
  font-family: var(--font-body);
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  letter-spacing: -0.1px;
}

.tile-artist {
  font-family: var(--font-body);
  font-size: 12px;
  font-weight: 400;
  color: var(--text3);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

@media (max-width: 768px) {
  .v1-header {
    margin-bottom: 24px;
  }

  .hero-section {
    flex-direction: column;
    gap: 16px;
    margin-bottom: 28px;
    padding-bottom: 28px;
  }

  .hero-art {
    max-width: 140px;
    width: 100%;
  }

  .hero-title {
    font-size: 22px;
  }

  .hero-artist {
    font-size: 14px;
  }

  .hero-label {
    font-size: 10px;
    margin-bottom: 2px;
  }

  .hero-count {
    margin-top: 4px;
  }

  .section-head {
    margin-bottom: 16px;
  }

  .section-title {
    font-size: 17px;
  }

  .album-gallery {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .tile-info {
    padding: 10px 0 0;
  }

  .tile-album {
    font-size: 12px;
  }

  .tile-artist {
    font-size: 11px;
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 19px;
  }

  .hero-art {
    max-width: 120px;
  }

  .album-gallery {
    gap: 8px;
    grid-template-columns: repeat(2, 1fr);
  }

  .tile-fallback .icon {
    font-size: 28px;
  }
}
</style>
