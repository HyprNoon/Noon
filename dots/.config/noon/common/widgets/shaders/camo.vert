#version 440

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;
layout(location = 0) out vec2 uv;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float time;

    vec4 colorA;
    vec4 colorB;
    vec4 colorC;

    float speed;
    float scale;
    float complexity;
    float flowSharpness;

    float aspect;

    float alphaBase;
    float alphaFlowBoost;
    float alphaMin;
    float alphaMax;

    float edgeWidth;
    float edgeIntensity;
    float edgePower;
};

void main() {
    uv = qt_MultiTexCoord0;
    gl_Position = qt_Matrix * qt_Vertex;
}
