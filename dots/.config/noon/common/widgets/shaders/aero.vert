#version 440

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;
layout(location = 0) out vec2 uv;

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

void main() {
    uv = qt_MultiTexCoord0;
    gl_Position = qt_Matrix * qt_Vertex;
}
