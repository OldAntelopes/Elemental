// NegativeImage.fx

float gCutoff = 0.0;    // [ELEUI_FLOAT:Cutoff:0|3.0]

sampler2D TextureSampler : register(s0);

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 NegativePS(VS_OUTPUT input) : COLOR
{
    float4 color = tex2D(TextureSampler, input.Tex);
        // Invert RGB, keep alpha unchanged
    
    if ( color.r + color.g + color.b >= gCutoff )
    {
        color.rgb = 1.0 - color.rgb;
    }
    return color;
}

technique NegativeImage
{
    pass P0
    {
        PixelShader = compile ps_2_0 NegativePS();
    }
}