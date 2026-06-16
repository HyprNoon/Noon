-- Workspaces Switch
for i = 1, 10 do
    hl.bind(mainMod .. "+" .. i % 10, hl.dsp.focus({ workspace = i }))
end

-- Move active window to workspace
for i = 1, 10 do
    hl.bind(mainMod .. "+ALT+" .. tostring(i % 10), hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mainMod .. "+S", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. "+ALT+S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. "+mouse:275", hl.dsp.workspace.toggle_special(), { mouse = true })

hl.bind("CTRL+" .. mainMod .. "+bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL+" .. mainMod .. "+bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL+" .. mainMod .. "+up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL+" .. mainMod .. "+down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. "+Page_Up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. "+Page_Down", hl.dsp.focus({ workspace = "r+1" }))

hl.bind("CTRL+" .. mainMod .. "+ALT+right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL+" .. mainMod .. "+ALT+left", hl.dsp.focus({ workspace = "m-1" }))

hl.bind("CTRL+" .. mainMod .. "+Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL+" .. mainMod .. "+Page_Up", hl.dsp.focus({ workspace = "r-1" }))

hl.bind(mainMod .. "+mouse_up", hl.dsp.focus({ workspace = "+1" }), { mouse = true })
hl.bind(mainMod .. "+mouse_down", hl.dsp.focus({ workspace = "-1" }), { mouse = true })

hl.bind("CTRL+" .. mainMod .. "+mouse_up", hl.dsp.focus({ workspace = "r+1" }), { mouse = true })
hl.bind("CTRL+" .. mainMod .. "+mouse_down", hl.dsp.focus({ workspace = "r-1" }), { mouse = true })

---

hl.bind(mainMod .. "+SHIFT+mouse_down", hl.dsp.window.move({ workspace = "r-1" }), { mouse = true })
hl.bind(mainMod .. "+SHIFT+mouse_up", hl.dsp.window.move({ workspace = "r+1" }), { mouse = true })
hl.bind(mainMod .. "+ALT+mouse_down", hl.dsp.window.move({ workspace = "-1" }), { mouse = true })
hl.bind(mainMod .. "+ALT+mouse_up", hl.dsp.window.move({ workspace = "+1" }), { mouse = true })

hl.bind(mainMod .. "+ALT+Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. "+ALT+Page_Up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. "+SHIFT+Page_Down", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. "+SHIFT+Page_Up", hl.dsp.window.move({ workspace = "r-1" }))

hl.bind(mainMod .. "+ALT+S", hl.dsp.window.move({ workspace = "special" }))

-- Windows
hl.bind(mainMod .. "+G", hl.dsp.group.toggle())
hl.bind(mainMod .. "+CTRL+TAB", hl.dsp.group.next())

hl.bind(mainMod .. "+Q", hl.dsp.window.close())
hl.bind(mainMod .. "+ALT+SPACE", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({ x = 1280, y = 800 }))
end)
-- Movement
hl.bind(mainMod .. "+SHIFT+Right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. "+SHIFT+Left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+SHIFT+Up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+SHIFT+Down", hl.dsp.window.move({ direction = "down" }))

-- Fullscreen / window state
hl.bind(mainMod .. "+D", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. "+F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. "+ALT+F", hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 0 3"))

-- Focus
hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. "+left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. "+up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. "+down", hl.dsp.focus({ direction = "d" }))

-- Mouse move/resize
hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+mouse:274", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+CTRL+mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Layout: fine pixel scroll
hl.bind(mainMod .. "+P", hl.dsp.window.pin())

-- Scrolling Layout Controls
if layout == "scrolling" then
    hl.bind(mainMod .. "+BracketRight", hl.dsp.layout("move +col"))
    hl.bind(mainMod .. "+BracketLeft", hl.dsp.layout("move -col"))
    hl.bind(mainMod .. "+ALT+right", hl.dsp.layout("move +200"))
    hl.bind(mainMod .. "+ALT+left", hl.dsp.layout("move -200"))
    hl.bind("CTRL+" .. mainMod .. "+right", hl.dsp.layout("swapcol r"))
    hl.bind("CTRL+" .. mainMod .. "+left", hl.dsp.layout("swapcol l"))
    hl.bind(mainMod .. "+SHIFT+right", hl.dsp.layout("colresize +conf"))
    hl.bind(mainMod .. "+SHIFT+left", hl.dsp.layout("colresize -conf"))
    hl.bind(mainMod .. "+SHIFT+up", hl.dsp.layout("colresize +0.1"))
    hl.bind(mainMod .. "+SHIFT+down", hl.dsp.layout("colresize -0.1"))
    hl.bind("CTRL+ALT+" .. mainMod .. "+equal", hl.dsp.layout("colresize all 0.5"))
    -- Layout: fit / scroll to position
    hl.bind(mainMod .. "+Home", hl.dsp.layout("fit tobeg"))
    hl.bind(mainMod .. "+End", hl.dsp.layout("fit toend"))
    hl.bind(mainMod .. "+A", hl.dsp.layout("fit active"))
    hl.bind(mainMod .. "+SHIFT+A", hl.dsp.layout("fit all"))
    hl.bind("CTRL+" .. mainMod .. "+A", hl.dsp.layout("fit visible"))
end

hl.bind("CTRL+SHIFT+" .. mainMod .. "+right", hl.dsp.layout("movecoltoworkspace +1"))
hl.bind("CTRL+SHIFT+" .. mainMod .. "+left", hl.dsp.layout("movecoltoworkspace -1"))

-- Screenshot area
hl.bind(mainMod .. "+SHIFT+S", hl.dsp.exec_cmd(ipc .. " global toggle_screenshot"))

-- OCR
hl.bind(
    mainMod .. "+SHIFT+T",
    hl.dsp.exec_cmd('grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"')
)

-- Color picker
hl.bind(mainMod .. "+SHIFT+C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Fullscreen screenshot
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"), { locked = true })
hl.bind(
    "CTRL+Print",
    hl.dsp.exec_cmd(
        "mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"
    ),
    { locked = true }
)

-- Recording
hl.bind(mainMod .. "+ALT+R", hl.dsp.exec_cmd(scriptsDir .. "/record_service.sh"))
hl.bind("CTRL+ALT+R", hl.dsp.exec_cmd(scriptsDir .. "/record_service.sh --fullscreen"))
hl.bind(mainMod .. "+SHIFT+ALT+R", hl.dsp.exec_cmd(scriptsDir .. "/record_service.sh --fullscreen-sound"))

-- AI primary buffer query
hl.bind(
    mainMod .. "+SHIFT+ALT+mouse:273",
    hl.dsp.exec_cmd("~/.config/ags/scripts/ai/primary-buffer-query.sh"),
    { mouse = true }
)

-- Zoom
hl.bind(mainMod .. "+minus", hl.dsp.exec_cmd(scriptsDir .. "/hypr_zoom.sh decrease 0.1"), { repeating = true })
hl.bind(mainMod .. "+equal", hl.dsp.exec_cmd(scriptsDir .. "/hypr_zoom.sh increase 0.1"), { repeating = true })

-- Apps
hl.bind(mainMod .. "+T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd(terminal_alt))
hl.bind(mainMod .. "+E", hl.dsp.exec_cmd(file_manager))
hl.bind(mainMod .. "+B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+SHIFT+B", hl.dsp.exec_cmd(browser_alt))
hl.bind(mainMod .. "+C", hl.dsp.exec_cmd(editor))
hl.bind("CTRL+" .. mainMod .. "+V", hl.dsp.exec_cmd("pavucontrol-qt"))
hl.bind("CTRL+SHIFT+Escape", hl.dsp.exec_cmd(task_manager))
hl.bind("CTRL+" .. mainMod .. "+SHIFT+Escape", hl.dsp.exec_cmd(task_manager_alt))

hl.bind(mainMod .. "+SHIFT+L", hl.dsp.exec_cmd("sleep 0.1 && systemctl suspend || loginctl suspend"), { locked = true })

hl.bind("CTRL+SHIFT+ALT+" .. mainMod .. "+Delete", hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"))
