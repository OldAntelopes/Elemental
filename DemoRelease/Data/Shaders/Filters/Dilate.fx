//---------------
// Dilate.fx


sampler2D TextureSampler : register(s0);

float3 iResolution = float3(1920.0, 1080.0, 1.0); // Set from the app: (width, height, 1.0))

// --- Exposed params
float gDilateRadius = 8.0; // [ELEUI_FLOAT:Dilate Radius:0.0|64.0] // How far to search (in texels)
static const int gNumSamples = 8; 

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 DilatePS(VS_OUTPUT input) : COLOR 
{
    float2 TexelSize = float2(1.0 / iResolution.x, 1.0 / iResolution.y);

    float2 uv = input.Tex;
    float4 maxColor = tex2D(TextureSampler, uv);

    // Sample in a circle around the center pixel
    for (int i = 0; i < gNumSamples; ++i)
    {
        float angle = 6.2831853 * (float) i / gNumSamples;
        float2 offset = float2(cos(angle), sin(angle)) * gDilateRadius * TexelSize;
        float4 sampleColor = tex2D(TextureSampler, uv + offset);
        maxColor = max(maxColor, sampleColor);
    }

    return maxColor;
}

technique Dilate
{
    pass P0
    {
        PixelShader = compile ps_2_0 DilatePS();
    }
}