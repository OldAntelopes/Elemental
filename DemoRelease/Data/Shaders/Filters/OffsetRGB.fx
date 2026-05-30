sampler2D TextureSampler : register(s0);

// TODO - Need to sort out parsing the default values properly 
float2 OffsetR = (0.02, 0);   // [ELEUI_FLOAT2:R Offset:-1.0|1.0] 
float2 OffsetG = (0.0, 0.02); // [ELEUI_FLOAT2:G Offset:-1.0|1.0] 
float2 OffsetB = (-0.002, 0); // [ELEUI_FLOAT2:B Offset:-1.0|1.0] 

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 DelayRGB_PS(VS_OUTPUT input) : COLOR
{
    float2 uv = input.Tex;

    // Sample each channel with its own delay
    float3 colorR = tex2D(TextureSampler, uv + OffsetR).rgb;
    float3 colorG = tex2D(TextureSampler, uv + OffsetG).rgb;
    float3 colorB = tex2D(TextureSampler, uv + OffsetB).rgb;

    // Combine channels: take R from colorR, G from colorG, B from colorB
    float3 outColor = float3(colorR.r, colorG.g, colorB.b);

    // Optionally, use alpha from the center sample
    float alpha = tex2D(TextureSampler, uv).a;

    return float4(outColor, alpha);
}

technique DelayRGB
{
    pass P0
    {
        PixelShader = compile ps_2_0 DelayRGB_PS();
    }
}