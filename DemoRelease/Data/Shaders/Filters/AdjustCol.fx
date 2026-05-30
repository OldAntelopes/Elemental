
sampler2D TextureSampler : register(s0);

float gBrightness = 0.0; // [ELEUI_FLOAT:Brightness:-1|1]
float gContrast = 1.0; // [ELEUI_FLOAT:Contrast:0|2] 
bool gGreyscale = false; // [ELEUI_BOOL:Greyscale:0]
float gAlphaMod = 1.0; // [ELEUI_FLOAT:Alpha Mod:0|2] 
bool gNegative = false; // [ELEUI_BOOL:Negative:0]
float4 gColStrength = float4(1.0, 1.0, 1.0, 1.0); // [ELEUI_COLOUR:Colour Strength:0.0|2.0]

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 AdjustColPS(VS_OUTPUT input) : COLOR
{
    float4 color = tex2D(TextureSampler, input.Tex);
 
    color.rgb = ((color.rgb - 0.5) * gContrast) + 0.5f;
    
    color.rgb = color.rgb + gBrightness;
    color.rgb = clamp(color.rgb, 0, 1);
    
    if ( gGreyscale )
    {
        // Standard luminance weights for RGB
        float grey = dot(color.rgb, float3(0.299, 0.587, 0.114));
        color.rgb = grey;    
    }
    
    if ( gNegative )
    {
        color.rgb = 1.0 - color.rgb;
    }
    
    // Apply RGB strength modifiers
    color.rgb *= gColStrength.rgb;
    color.rgb = clamp(color.rgb, 0, 1);
    
    color.a *= gAlphaMod;
    return color;
}

technique AdjustCol
{
    pass P0
    {
        PixelShader = compile ps_2_0 AdjustColPS();
    }
}