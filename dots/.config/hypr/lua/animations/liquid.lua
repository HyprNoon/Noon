local anim_direction = getAnimDirection()

hl.curve("fluid", { type = "spring", mass = 4.0, stiffness = 100, dampening = 38 })
hl.curve("ripple", { type = "spring", mass = 3.0, stiffness = 140, dampening = 34 })
hl.curve("flow", { type = "bezier", points = { { 0.0, 0.95 }, { 0.0, 1.0 } } })
hl.curve("drain", { type = "bezier", points = { { 0.95, 0.0 }, { 1.0, 1.0 } } })

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = math.max(0.1, 0.8 * animation_scale),
    style = "popin 85%",
    spring = "fluid"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = math.max(0.1, 0.6 * animation_scale),
    style = "popin 92%",
    spring = "ripple"
})
hl.animation({ leaf = "windowsMove", enabled = true, speed = math.max(0.1, 0.8 * animation_scale), spring = "fluid" })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = math.max(0.1, 0.7 * animation_scale),
    style = "slide",
    spring = "fluid"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = math.max(0.1, 0.6 * animation_scale),
    style = "slide",
    spring = "ripple"
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = math.max(0.1, 0.8 * animation_scale), bezier = "flow" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = math.max(0.1, 0.6 * animation_scale), bezier = "drain" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = math.max(0.1, 0.5 * animation_scale), spring = "ripple" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = math.max(0.1, 0.5 * animation_scale), spring = "ripple" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = math.max(0.1, 0.6 * animation_scale), spring = "ripple" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = math.max(0.1, 0.7 * animation_scale), bezier = "flow" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = math.max(0.1, 0.5 * animation_scale), bezier = "drain" })
hl.animation({ leaf = "border", enabled = true, speed = math.max(0.1, 1.0 * animation_scale), spring = "ripple" })
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = math.max(0.1, 1.0 * animation_scale),
    style = anim_direction,
    spring = "fluid"
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = math.max(0.1, 0.8 * animation_scale),
    style = anim_direction,
    spring = "fluid"
})
