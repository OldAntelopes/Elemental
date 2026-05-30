// Bulge.fx

float gBulgeStrength = 1.0; // [ELEUI_FLOAT:Bulge Strength:0|8.0]

sampler2D TextureSampler : register(s0);

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 BulgePS(VS_OUTPUT input) : COLOR
{
        // Center point of the image
    float2 center = float2(0.5, 0.5);
    
    // Vector from center to current pixel
    float2 offset = input.Tex - center;
    
    // Calculate distance from center
    float distance = length(offset);
    
    // Maximum radius (distance to corner)
    float maxRadius = 0.707; // sqrt(0.5^2 + 0.5^2)
    
    // Normalize distance (0 at center, 1 at edges)
    float normalizedDist = distance / maxRadius;
    
    // Calculate bulge factor using a smooth curve
    // At center (dist=0), bulge is maximum
    // At edges (dist=1), bulge is zero
    float bulgeFactor = 1.0 - normalizedDist * normalizedDist;
    
    // Apply bulge strength
    float bulge = bulgeFactor * -gBulgeStrength;
    
    // Calculate distorted UV coordinates
    // Positive bulge pushes pixels outward (bulge out)
    // Negative bulge pulls pixels inward (pinch/bulge in)
    float2 distortedUV = input.Tex + (offset * bulge);
    
    // Clamp UV to valid range
    distortedUV = saturate(distortedUV);
    
    // Sample the texture at the distorted position
    float4 color = tex2D(TextureSampler, distortedUV);
    
    return color;
    
}

technique Bulge
{
    pass P0
    {
        PixelShader = compile ps_2_0 BulgePS();
    }
}