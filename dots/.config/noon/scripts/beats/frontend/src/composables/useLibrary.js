import { ref, computed } from 'vue'

const libCache = ref([])
const loaded = ref(false)

export function useLibrary() {
  async function load() {
    if (loaded.value) return
    const resp = await fetch('/api/library')
    if (resp.ok) {
      libCache.value = await resp.json()
      loaded.value = true
    }
  }

  const tracks = computed(() => libCache.value)
  const albums = computed(() => {
    const map = {}
    for (const t of libCache.value) {
      const key = t.artist + '///' + t.album
      if (!map[key]) {
        map[key] = { artist: t.artist, album: t.album, cover: t.cover, trackCount: 0 }
      }
      map[key].trackCount++
    }
    return Object.values(map)
  })
  const artists = computed(() => {
    const map = {}
    for (const t of libCache.value) {
      if (!map[t.artist]) {
        map[t.artist] = { name: t.artist, trackCount: 0 }
      }
      map[t.artist].trackCount++
    }
    return Object.values(map)
  })

  return { load, tracks, albums, artists, libCache }
}
