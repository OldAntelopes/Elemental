// ChromaKey.fx

sampler2D TextureSampler : register(s0);

float4 KeyColor = float4(0.0,1.0,0.0,0.0); // [ELEUI_COLOUR:Key Colour:0.0|1.0] Default: green
float Tolerance = 0.4; // [ELEUI_FLOAT:Tolerance:0.0|1.0] How close to key color (0.0-1.0)
float Feather = 0.05; // [ELEUI_FLOAT:Feather:0.0|1.0] Soft edge width
bool gInvert = false; // [ELEUI_BOOL:Invert:0]
bool gIgnoreSourceAlpha = false; // [ELEUI_BOOL:Ignore Source Alpha:0]

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 ChromaKeyPS(VS_OUTPUT input) : COLOR
{
    float4 color = tex2D(TextureSampler, input.Tex);

    // Compute color distance
    float dist = distance(color.rgb, KeyColor);
    
    // Alpha: 0 if within tolerance, 1 if outside, feathered in between
    float alpha = smoothstep(Tolerance, Tolerance + Feather, dist);

    if (gInvert)
    {
        alpha = 1.0f - alpha;
    }
            
    if (gIgnoreSourceAlpha )
    {
        return float4(color.rgb, 1.0f * alpha);
    }
    else
    {
        return float4(color.rgb, color.a * alpha);        
    }
}

technique ChromaKey
{
    pass P0
    {
        PixelShader = compile ps_2_0 ChromaKeyPS();
    }
}