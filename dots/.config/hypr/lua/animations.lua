local presets = {
    classic = {
        curves = {
            { name = "expressiveFastSpatial",    type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.90 } } },
            { name = "expressiveSlowSpatial",    type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } },
            { name = "expressiveDefaultSpatial", type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.00 } } },
            { name = "emphasizedDecel",          type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } },
            { name = "emphasizedAccel",          type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } },
            { name = "standardDecel",            type = "bezier", points = { { 0, 0 }, { 0, 1 } } },
            { name = "menu_decel",               type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } },
            { name = "menu_accel",               type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } },
            { name = "stall",                    type = "bezier", points = { { 1, -0.1 }, { 0.7, 0.85 } } }
        },
        animations = {
            { leaf = "windowsIn",           enabled = true, speed = 3,   curve = "emphasizedDecel", style = "popin 80%" },
            { leaf = "fadeIn",              enabled = true, speed = 3,   curve = "emphasizedDecel" },
            { leaf = "windowsOut",          enabled = true, speed = 2,   curve = "emphasizedDecel", style = "popin 90%" },
            { leaf = "fadeOut",             enabled = true, speed = 2,   curve = "emphasizedDecel" },
            { leaf = "windowsMove",         enabled = true, speed = 3,   curve = "emphasizedDecel", style = "slidevert" },
            { leaf = "border",              enabled = true, speed = 10,  curve = "emphasizedDecel" },
            { leaf = "layersIn",            enabled = true, speed = 2.7, curve = "emphasizedDecel", style = "popin 93%" },
            { leaf = "layersOut",           enabled = true, speed = 2.4, curve = "menu_accel",      style = "popin 94%" },
            { leaf = "fadeLayersIn",        enabled = true, speed = 0.5, curve = "menu_decel" },
            { leaf = "fadeLayersOut",       enabled = true, speed = 2.7, curve = "stall" },
            { leaf = "workspaces",          enabled = true, speed = 7,   curve = "menu_decel",      style = getAnimDirection() },
            { leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, curve = "emphasizedDecel", style = getAnimDirection() },
            { leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, curve = "emphasizedAccel", style = getAnimDirection() },
            { leaf = "zoomFactor",          enabled = true, speed = 3,   curve = "standardDecel" }
        }
    },
    springgy = {
        curves = {
            { name = "instantSpring", type = "spring", mass = 1, stiffness = 220, dampening = 19 }
        },
        animations = {
            { leaf = "windowsIn",           enabled = true, speed = 2.4, curve = "instantSpring", style = "popin 85%" },
            { leaf = "windowsOut",          enabled = true, speed = 2.0, curve = "instantSpring", style = "popin 90%" },
            { leaf = "windowsMove",         enabled = true, speed = 2.2, curve = "instantSpring" },
            { leaf = "layersIn",            enabled = true, speed = 2.2, curve = "instantSpring", style = "popin 95%" },
            { leaf = "layersOut",           enabled = true, speed = 1.8, curve = "instantSpring", style = "popin 95%" },
            { leaf = "fadeIn",              enabled = true, speed = 2.0, curve = "instantSpring" },
            { leaf = "fadeOut",             enabled = true, speed = 1.5, curve = "instantSpring" },
            { leaf = "fadeLayersIn",        enabled = true, speed = 1.5, curve = "instantSpring" },
            { leaf = "fadeLayersOut",       enabled = true, speed = 1.5, curve = "instantSpring" },
            { leaf = "workspaces",          enabled = true, speed = 2.8, curve = "instantSpring", style = getAnimDirection() },
            { leaf = "specialWorkspaceIn",  enabled = true, speed = 2.6, curve = "instantSpring", style = getAnimDirection() },
            { leaf = "specialWorkspaceOut", enabled = true, speed = 2.2, curve = "instantSpring", style = getAnimDirection() },
            { leaf = "border",              enabled = true, speed = 3.0, curve = "instantSpring" },
            { leaf = "zoomFactor",          enabled = true, speed = 2.0, curve = "instantSpring" }
        }
    },
    elegant = {
        curves = {
            { name = "sharpDecel",   type = "bezier", points = { { 0.15, 1 }, { 0.15, 1 } } },
            { name = "smoothSpring", type = "spring", mass = 1,                         stiffness = 175, dampening = 24 }
        },
        animations = {
            { leaf = "windowsIn",           enabled = true, speed = 2.8, curve = "smoothSpring", style = "popin 88%" },
            { leaf = "windowsOut",          enabled = true, speed = 1.8, curve = "sharpDecel",   style = "popin 95%" },
            { leaf = "windowsMove",         enabled = true, speed = 2.4, curve = "smoothSpring" },
            { leaf = "layersIn",            enabled = true, speed = 2.4, curve = "smoothSpring", style = "popin 95%" },
            { leaf = "layersOut",           enabled = true, speed = 1.6, curve = "sharpDecel",   style = "popin 95%" },
            { leaf = "fadeIn",              enabled = true, speed = 2.0, curve = "sharpDecel" },
            { leaf = "fadeOut",             enabled = true, speed = 1.5, curve = "sharpDecel" },
            { leaf = "fadeLayersIn",        enabled = true, speed = 1.5, curve = "sharpDecel" },
            { leaf = "fadeLayersOut",       enabled = true, speed = 1.5, curve = "sharpDecel" },
            { leaf = "workspaces",          enabled = true, speed = 3.2, curve = "smoothSpring", style = getAnimDirection() },
            { leaf = "specialWorkspaceIn",  enabled = true, speed = 3.0, curve = "smoothSpring", style = getAnimDirection() },
            { leaf = "specialWorkspaceOut", enabled = true, speed = 2.0, curve = "sharpDecel",   style = getAnimDirection() },
            { leaf = "border",              enabled = true, speed = 4.0, curve = "sharpDecel" },
            { leaf = "zoomFactor",          enabled = true, speed = 2.2, curve = "sharpDecel" }
        }
    }
}

local active_preset = presets.elegant

local curve_types = {}
for _, curve in ipairs(active_preset.curves) do
    curve_types[curve.name] = curve.type
    hl.curve(curve.name, curve)
end

for _, anim in ipairs(active_preset.animations) do
    local c_type = curve_types[anim.curve] or "bezier"
    anim[c_type] = anim.curve
    anim.curve = nil
    hl.animation(anim)
end
