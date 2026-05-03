#version 440

layout(location = 0) in vec2 uv;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float time;

    vec4 topColor;
    vec4 midColor;
    vec4 bottomColor;

    float topSplit;

    float bloomIntensity;
    float bloomHeight;

    float stripeAngle;
    float stripeSpeed;
    float stripeCount;
    float stripeSpread;
    float stripeWidth;
    float stripeIntensity;
    float stripeSharpness;

    float cyanDepthIntensity;
    float edgeGlowIntensity;
    float edgeGlowPower;

    float glassTopDensity;
    float glassBottomDensity;

    float saturation;

    float alphaBase;
    float alphaBloomBoost;
    float alphaStripeBoost;
    float alphaMin;
    float alphaMax;
};

float singleStripe(float t, float center, float halfW) {
    float d = abs(t - center);
    return pow(
        smoothstep(halfW, halfW * 0.1, d),
        stripeSharpness
    );
}

void main()
{
    vec3 color;

    if (uv.y < topSplit)
    {
        color = mix(topColor.rgb, midColor.rgb, uv.y / topSplit);
    }
    else
    {
        color = mix(
                midColor.rgb,
                bottomColor.rgb,
                (uv.y - topSplit) / (1.0 - topSplit)
            );
    }

    float bloom = smoothstep(bloomHeight, 0.0, uv.y);
    color += vec3(1.0) * bloom * bloomIntensity;

    vec2 dir = normalize(vec2(1.0, -tan(radians(stripeAngle))));
    float proj = dot(uv, dir);

    float phase = time * stripeSpeed;
    float n = stripeCount;
    float spacing = stripeSpread / n;

    float totalStripe = 0.0;
    float halfW = stripeWidth * 0.5;

    for (int i = 0; i < 8; i++)
    {
        if (float(i) >= n) break;

        float base = (float(i) / n) * stripeSpread;
        float center = mod(base + phase, stripeSpread + stripeWidth) - halfW;

        float s = singleStripe(proj, center, halfW);

        float fade = 1.0 - abs(float(i) - (n - 1.0) * 0.5) / (n * 0.5);
        totalStripe += s * mix(0.5, 1.0, fade);
    }

    totalStripe = clamp(totalStripe, 0.0, 1.0);
    color += vec3(1.0) * totalStripe * stripeIntensity;

    float glass = smoothstep(1.2, 0.1, uv.y);
    color *= mix(glassTopDensity, glassBottomDensity, uv.y);
    color += vec3(0.0, 0.12, 0.22) * glass * cyanDepthIntensity;

    float edge = 1.0 - min(
                min(uv.x, 1.0 - uv.x),
                min(uv.y, 1.0 - uv.y)
            );
    edge = pow(edge, edgeGlowPower);
    color += vec3(0.7, 0.9, 1.0) * edge * edgeGlowIntensity;

    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(luma), color, saturation);

    float alpha = alphaBase;
    alpha += bloom * alphaBloomBoost;
    alpha += totalStripe * alphaStripeBoost;
    alpha = clamp(alpha, alphaMin, alphaMax);

    fragColor = vec4(color * alpha, alpha) * qt_Opacity;
}
