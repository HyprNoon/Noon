local anim_direction = getAnimDirection()

hl.curve("reveal", { type = "bezier", points = { { 0.0, 0.0 }, { 0.2, 1.0 } } })
hl.curve("conceal", { type = "bezier", points = { { 0.8, 0.0 }, { 1.0, 1.0 } } })
hl.curve("drift", { type = "bezier", points = { { 0.25, 0.46 }, { 0.45, 0.94 } } })

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = math.max(0.1, 2.6 * animation_scale),
    style = "popin 80%",
    bezier =
    "reveal"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = math.max(0.1, 1.9 * animation_scale),
    style = "popin 92%",
    bezier =
    "conceal"
})
hl.animation({ leaf = "windowsMove", enabled = true, speed = math.max(0.1, 2.1 * animation_scale), bezier = "drift" })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = math.max(0.1, 2.4 * animation_scale),
    style = "slide",
    bezier =
    "reveal"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = math.max(0.1, 1.6 * animation_scale),
    style = "fade",
    bezier =
    "conceal"
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = math.max(0.1, 2.0 * animation_scale), bezier = "reveal" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = math.max(0.1, 1.4 * animation_scale), bezier = "conceal" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = math.max(0.1, 1.6 * animation_scale), bezier = "drift" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = math.max(0.1, 1.6 * animation_scale), bezier = "drift" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = math.max(0.1, 1.9 * animation_scale), bezier = "drift" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = math.max(0.1, 1.9 * animation_scale), bezier = "reveal" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = math.max(0.1, 1.4 * animation_scale), bezier = "conceal" })
hl.animation({ leaf = "border", enabled = true, speed = math.max(0.1, 2.4 * animation_scale), bezier = "drift" })
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = math.max(0.1, 2.5 * animation_scale),
    style = anim_direction,
    bezier =
    "drift"
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = math.max(0.1, 2.3 * animation_scale),
    style =
        anim_direction,
    bezier = "reveal"
})
