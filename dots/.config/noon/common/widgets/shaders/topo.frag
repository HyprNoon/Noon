#version 440

layout(location = 0) in vec2 uv;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float time;

    vec4 bgColor;
    vec4 lineColor;

    float speed;
    float scale;
    float complexity;
    float lineCount;
    float lineWidth;
    float lineSharpness;

    float aspect;

    float alphaBase;
    float alphaMin;
    float alphaMax;
};

float hash(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    p += dot(p, p + 19.19);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
        mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
}

float fbm(vec2 p, int octaves) {
    float v = 0.0;
    float a = 0.5;
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
    for (int i = 0; i < 6; i++) {
        if (i >= octaves) break;
        v += a * noise(p);
        p = rot * p * 2.0 + vec2(100.0);
        a *= 0.5;
    }
    return v;
}

void main()
{
    vec2 c = uv - 0.5;
    c.x *= aspect;

    vec2 halfSize = vec2(aspect * 0.5, 0.5);
    vec2 d = abs(c) - halfSize;
    float rectSDF = length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
    float inside = step(rectSDF, 0.0);

    vec2 p = c * scale;
    float t = time * speed;

    vec2 q = vec2(
            fbm(p, int(complexity)),
            fbm(p + vec2(5.2, 1.3), int(complexity))
        );
    vec2 r = vec2(
            fbm(p + 4.0 * q + vec2(1.7, 9.2) + 0.15 * t, int(complexity)),
            fbm(p + 4.0 * q + vec2(8.3, 2.8) + 0.126 * t, int(complexity))
        );

    float f = fbm(p + 4.0 * r, int(complexity));

    float bands = fract(f * lineCount);
    float line = pow(
            smoothstep(lineWidth, 0.0, abs(bands - 0.5) - (0.5 - lineWidth)),
            lineSharpness
        );

    vec3 color = mix(bgColor.rgb, lineColor.rgb, line);

    float alpha = alphaBase * inside;
    alpha = clamp(alpha, alphaMin * inside, alphaMax);

    fragColor = vec4(color * alpha, alpha) * qt_Opacity;
}
