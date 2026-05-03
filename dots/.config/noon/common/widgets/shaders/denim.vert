#version 440

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;
layout(location = 0) out vec2 uv;

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

void main() {
    uv = qt_MultiTexCoord0;
    gl_Position = qt_Matrix * qt_Vertex;
}
