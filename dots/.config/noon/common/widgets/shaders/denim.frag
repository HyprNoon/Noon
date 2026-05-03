#version 440

layout(location = 0) in vec2 uv;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    vec4 colorA;
    vec4 colorB;

    float scale;
    float threadSharpness;
    float twillShift;
    float fuzzAmount;
    float fuzzScale;
    float fadeScale;
    float fadeStrength;

    float edgeWidth;
    float edgeIntensity;
    float edgePower;

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

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 3; i++) {
        v += a * noise(p);
        p = p * 2.0 + vec2(31.4, 17.9);
        a *= 0.5;
    }
    return v;
}

float cylinder(float t, float sharpness) {
    float x = fract(t) * 2.0 - 1.0;
    return pow(max(0.0, 1.0 - x * x), sharpness);
}

void main()
{
    vec2 c = uv - 0.5;
    c.x *= aspect;

    vec2 halfSize = vec2(aspect * 0.5, 0.5);
    vec2 d = abs(c) - halfSize;
    float rectSDF = length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
    float inside = step(rectSDF, 0.0);

    float edgeBrighten =
        (1.0 - pow(
                smoothstep(0.0, -edgeWidth, rectSDF),
                edgePower
            )) * edgeIntensity;

    vec2 p = c * scale;

    float fuzz = (noise(p * fuzzScale) - 0.5) * fuzzAmount;

    vec2 warp = vec2(
            noise(p * 0.2 + vec2(3.1, 7.4)),
            noise(p * 0.2 + vec2(9.2, 2.6))
        ) * fuzzAmount * 0.3;

    vec2 pw = p + warp + fuzz;

    float along = (pw.x + pw.y) * 0.7071;
    float across = (pw.x - pw.y) * 0.7071;

    float row = floor(along);
    float shift = fract(row * twillShift) * 1.0;
    float threadT = across + shift;

    float threadProfile = cylinder(threadT, threadSharpness);

    float weftAlong = across;
    float weftRow = floor(weftAlong);
    float weftShift = fract(weftRow * twillShift * 0.5);
    float weftT = along + weftShift;
    float weftProfile = cylinder(weftT, threadSharpness * 0.5) * 0.25;

    float weave = max(threadProfile, weftProfile);

    float fade = fbm(c * fadeScale);
    fade = mix(1.0, fade, fadeStrength);

    float microFiber = noise(pw * fuzzScale * 3.0) * 0.04;

    vec3 base = colorA.rgb * mix(0.7, 1.0, fade);
    vec3 color = mix(base, colorB.rgb, weave * fade);
    color += microFiber;
    color = clamp(color, 0.0, 1.0);

    color *= 1.0 + edgeBrighten;

    float alpha = alphaBase * inside;
    alpha = clamp(alpha, alphaMin * inside, alphaMax);

    fragColor = vec4(color * alpha, alpha) * qt_Opacity;
}
