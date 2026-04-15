<h1 align="center"> Plugins </h1>
# This is very "Ambitious" yet very early stage plugins system and a very new concept for me ^^

## Roadmap
- [-] Docs
- [x] Color Palettes
- [x] Sidebar Modules (adds new sidebar contents)
- [ ] Plugins gui easy installer
- [ ] Desktop Widgets --- KDE API Workarounds
- [ ] Bars
- [ ] Bar Modules
- [ ] Dialog Components
- [ ] Routines
- [ ] Ambient Sounds
- [ ] AI Skills - Functions
- [ ] Complete Panels Alterations

## Directories Integrity
All plugins are inside `~/.noon_plugins/`.
- every panel has different sub directory eg, ../sidebar, ../palettes, etc

### Color Palettes
those are files inside the "palettes" in format `${PALETTE_NAME}.json` 
- each file name is the same name of palette in UI
- adds are reactive and NO RELOAD NEEDED.
- json keys are material3 colors with m3prefixed camel case check plugins/palettes/example.json

### Sidebar Plugins
- each plugin has to be in a different folder with explicitly named manifest.json
- check the plugins/sidebar/manifest.json
- for the path u need to add prefix `@plugins` for the shell imports to work and use normal qs imports
- hot reload isn't implemented yet for this WIP
