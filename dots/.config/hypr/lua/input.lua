hl.device({
    name        = "epic-mouse-v1",
    sensitivity = 0,
})
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace"
})
hl.gesture({
    fingers = 2,
    direction = "pinch",
    action = "cursorZoom",
    zoom_level = "1",
    mods = "SHIFT",
    mode = "live"
})
hl.gesture({
    fingers = 3,
    mods = "CTRL",
    direction = "down",
    action = toggle_float
})
hl.gesture({
    fingers = 4,
    direction = "down",
    action = "special",
    workspace_name = "scratchpad",
    disable_inhibit = true
})
hl.gesture({
    fingers = 4,
    direction = "up",
    action = mission_control,
    workspace_name = "scratchpad",
    disable_inhibit = true
})
