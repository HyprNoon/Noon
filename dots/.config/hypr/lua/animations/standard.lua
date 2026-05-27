local anim_direction = getAnimDirection()

hl.curve("emphasized", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1.0 } } })
hl.curve("emphasizedIn", { type = "bezier", points = { { 0.35, 0.0 }, { 0.7, 0.15 } } })
hl.curve("emphasizedOut", { type = "bezier", points = { { 0.15, 0.85 }, { 0.0, 1.0 } } })
hl.curve("standard_", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = math.max(0.1, 4.8 * animation_scale),
    style = "popin 90%",
    bezier = "emphasizedOut"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = math.max(0.1, 3.2 * animation_scale),
    style = "popin 95%",
    bezier = "emphasizedIn"
})
hl.animation({ leaf = "windowsMove", enabled = true, speed = math.max(0.1, 4.0 * animation_scale), bezier = "emphasized" })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = math.max(0.1, 4.0 * animation_scale),
    style = "slide",
    bezier = "emphasizedOut"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = math.max(0.1, 2.8 * animation_scale),
    style = "fade",
    bezier = "emphasizedIn"
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = math.max(0.1, 3.2 * animation_scale), bezier = "emphasizedOut" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = math.max(0.1, 2.4 * animation_scale), bezier = "emphasizedIn" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = math.max(0.1, 2.0 * animation_scale), bezier = "standard_" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = math.max(0.1, 2.0 * animation_scale), bezier = "standard_" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = math.max(0.1, 2.8 * animation_scale), bezier = "standard_" })
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = math.max(0.1, 2.8 * animation_scale),
    bezier = "emphasizedOut"
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = math.max(0.1, 2.0 * animation_scale),
    bezier = "emphasizedIn"
})
hl.animation({ leaf = "border", enabled = true, speed = math.max(0.1, 4.0 * animation_scale), bezier = "standard_" })
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = math.max(0.1, 4.4 * animation_scale),
    style = anim_direction,
    bezier = "emphasized"
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = math.max(0.1, 4.0 * animation_scale),
    style = anim_direction,
    bezier = "emphasizedOut"
})
