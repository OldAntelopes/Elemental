// OutlineEdge.fx

sampler2D TextureSampler : register(s0);

float3 iResolution = float3(1920.0, 1080.0, 1.0); // Set from the app: (width, height, 1.0))

float gEdgeThreshold = 0.2; // [ELEUI_FLOAT:Edge Threshold:0.0|2.0]  Tweak for sensitivity

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float luminance(float3 color)
{
    return dot(color, float3(0.299, 0.587, 0.114));
}

float4 OutlineEdgePS(VS_OUTPUT input) : COLOR
{
    float2 TexelSize = (1.0 / iResolution.x, 1.0 / iResolution.y);
    float2 uv = input.Tex;

    // Sample 3x3 neighborhood
    float3 c00 = tex2D(TextureSampler, uv + TexelSize * float2(-1, -1)).rgb;
    float3 c01 = tex2D(TextureSampler, uv + TexelSize * float2(-1, 0)).rgb;
    float3 c02 = tex2D(TextureSampler, uv + TexelSize * float2(-1, 1)).rgb;
    float3 c10 = tex2D(TextureSampler, uv + TexelSize * float2(0, -1)).rgb;
    float3 c11 = tex2D(TextureSampler, uv + TexelSize * float2(0, 0)).rgb;
    float3 c12 = tex2D(TextureSampler, uv + TexelSize * float2(0, 1)).rgb;
    float3 c20 = tex2D(TextureSampler, uv + TexelSize * float2(1, -1)).rgb;
    float3 c21 = tex2D(TextureSampler, uv + TexelSize * float2(1, 0)).rgb;
    float3 c22 = tex2D(TextureSampler, uv + TexelSize * float2(1, 1)).rgb;

    // Convert to luminance
    float l00 = luminance(c00);
    float l01 = luminance(c01);
    float l02 = luminance(c02);
    float l10 = luminance(c10);
    float l11 = luminance(c11);
    float l12 = luminance(c12);
    float l20 = luminance(c20);
    float l21 = luminance(c21);
    float l22 = luminance(c22);

    // Sobel operator
    float gx = -l00 - 2.0 * l01 - l02 + l20 + 2.0 * l21 + l22;
    float gy = -l00 - 2.0 * l10 - l20 + l02 + 2.0 * l12 + l22;

    float edgeStrength = sqrt(gx * gx + gy * gy);

    // If edge is strong, draw black, else show original color
    if (edgeStrength > gEdgeThreshold)
        return float4(0, 0, 0, 1); // Black outline
    else
        return float4(c11, 1.0); // Original color
}

technique OutlineEdge
{
    pass P0
    {
        PixelShader = compile ps_2_0 OutlineEdgePS();
    }
}