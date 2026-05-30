// Soften shader - smooths the image while preserving more detail than a simple blur
// Uses a weighted kernel to blend neighboring pixels

// Soften.fx

sampler2D TextureSampler : register(s0);

float3 iResolution = float3(1920.0, 1080.0, 1.0); // Set from the app: (width, height, 1.0))

float SoftenAmount = 1.0; // [ELEUI_FLOAT:Soften Amount:0.0|1.0] Default blur radius

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 SoftenPS(VS_OUTPUT input) : COLOR
{
    float2 uv = input.Tex;
    
    // Get texture dimensions for proper pixel offset
    float2 texelSize = float2(1.0 / 1920.0, 1.0 / 1080.0); // Adjust based on your resolution
    
    // Sample center pixel
    float4 center = tex2D(TextureSampler, uv);
    
    // 3x3 weighted kernel for soften effect
    // Center pixel gets higher weight to preserve detail
    float4 result = center * 0.5; // Center weight
    
    // Sample surrounding pixels with lower weights
    result += tex2D(TextureSampler, uv + float2(-texelSize.x, -texelSize.y)) * 0.0625;
    result += tex2D(TextureSampler, uv + float2(0, -texelSize.y)) * 0.125;
    result += tex2D(TextureSampler, uv + float2(texelSize.x, -texelSize.y)) * 0.0625;
    
    result += tex2D(TextureSampler, uv + float2(-texelSize.x, 0)) * 0.125;
    result += tex2D(TextureSampler, uv + float2(texelSize.x, 0)) * 0.125;
    
    result += tex2D(TextureSampler, uv + float2(-texelSize.x, texelSize.y)) * 0.0625;
    result += tex2D(TextureSampler, uv + float2(0, texelSize.y)) * 0.125;
    result += tex2D(TextureSampler, uv + float2(texelSize.x, texelSize.y)) * 0.0625;
    
    // Blend between original and softened based on SoftenAmount parameter
    float4 finalColor = lerp(center, result, SoftenAmount);
    
    return finalColor;
}

technique Soften
{
    pass P0
    {
        PixelShader = compile ps_2_0 SoftenPS();
    }
}


