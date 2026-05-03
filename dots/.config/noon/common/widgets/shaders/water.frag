#version 440

layout(location = 0) in vec2 uv;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float time;

    vec4 colorA;
    vec4 colorB;
    vec4 colorC;

    float speed;
    float scale;
    float waveHeight;
    float causticSharpness;
    float layers;

    float edgeWidth;
    float edgeIntensity;
    float edgePower;

    float aspect;

    float alphaBase;
    float alphaMin;
    float alphaMax;
};

float caustic(vec2 p, float t, float seed) {
    vec2 a = vec2(sin(t * 0.7 + seed), cos(t * 0.5 + seed));
    vec2 b = vec2(cos(t * 0.4 + seed * 1.3), sin(t * 0.6 + seed * 0.7));
    vec2 c = vec2(sin(t * 0.9 + seed * 2.1), cos(t * 0.3 + seed * 1.7));

    float d = length(p - a * waveHeight);
    float e = length(p - b * waveHeight);
    float f = length(p - c * waveHeight);

    return pow(
        abs(sin(d * 6.0 - t) * sin(e * 6.0 - t) * sin(f * 6.0 - t)),
        causticSharpness
    );
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
    float t = time * speed;

    float light = 0.0;
    float n = max(1.0, layers);
    for (int i = 0; i < 4; i++) {
        if (float(i) >= n) break;
        float seed = float(i) * 2.39996;
        float depth = 1.0 - float(i) / n;
        light += caustic(p, t + float(i) * 1.3, seed) * depth;
    }
    light /= n;

    vec3 color = mix(
            mix(colorA.rgb, colorB.rgb, clamp(light * 2.5, 0.0, 1.0)),
            colorC.rgb,
            clamp(light * light * 6.0, 0.0, 1.0)
        );

    color *= 1.0 + edgeBrighten;

    float alpha = alphaBase * inside;
    alpha = clamp(alpha, alphaMin * inside, alphaMax);

    fragColor = vec4(color * alpha, alpha) * qt_Opacity;
}
