#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float u_time;
    vec2 u_res;
    vec4 colPrimary;
    vec4 colSecondary;
    float baseSpeed;
    float blurSoftness;
    int count;
};

float circle(vec2 uv, vec2 center, float radius) {
    vec2 aspect = vec2(u_res.x / u_res.y, 1.0);
    vec2 d = (uv - center) * aspect;
    float dist = length(d);
    return smoothstep(radius, radius * (1.0 - blurSoftness), dist);
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec3 col = vec3(0.0);
    float alpha = 0.0;

    for (int i = 0; i < count; i++) {
        float fi = float(i);
        float sizeFactor = 0.3 + fi * 0.12;
        float sx = (baseSpeed / 1000.0) * (0.8 + sin(fi) * 0.2);
        float sy = (baseSpeed / 1000.0) * (0.8 + cos(fi) * 0.2);
        float r = sizeFactor * 0.18;

        float cx = mod(fi, 2.0) == 0.0
            ? fract(u_time * sx + fi * 0.137) : 1.0 - fract(u_time * sx + fi * 0.137);

        float cy = mod(fi, 3.0) == 0.0
            ? fract(u_time * sy + fi * 0.237) : 1.0 - fract(u_time * sy + fi * 0.237);

        float mask = circle(uv, vec2(cx, cy), r);
        vec4 tint = mod(fi, 2.0) == 0.0 ? colPrimary : colSecondary;
        col += tint.rgb * mask * tint.a;
        alpha += mask * tint.a;
    }

    fragColor = vec4(col, min(alpha, 1.0) * qt_Opacity);
}
