//=======================
// RadialBlur.fx
//

sampler2D TextureSampler : register(s0);

float BlurStrength = 0.15;   // [ELEUI_FLOAT:Blur Strength:0.0|0.5]   How far out to sample (0.0 = no blur, 0.2 = strong blur)
float2 BlurCenter = 0.5;   // [ELEUI_FLOAT2:Blur Centre:0.0|1.0]  // Center of blur in UV space (0.5,0.5 = screen center)
bool OverrideAlpha = false; // [ELEUI_BOOL:Override Alpha] 

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 RadialBlurPS(VS_OUTPUT input) : COLOR
{
    float2 uv = input.Tex;
    float2 dir = uv - BlurCenter;
    float dist = length(dir);

    float4 color = tex2D(TextureSampler, uv);
    float total = 1.0;
    int i = 1;   
    int NumSamples = 16; // Number of samples (higher = smoother, but slower)
    
    // Accumulate samples along the direction from the center
    for (i = 1; i < NumSamples; i++)
    {
        float t = (float) i / (NumSamples - 1);
        float2 sampleUV = lerp(uv, BlurCenter, t * BlurStrength);
        color += tex2D(TextureSampler, sampleUV);
        total += 1.0;
    }

    color = color / total;
    if ( OverrideAlpha )
    {
        color.a = 1.0;
    }
    return color;
}

technique RadialBlur
{
    pass P0
    {
        PixelShader = compile ps_2_0 RadialBlurPS();
    }
}