// Sharpen.fx

sampler2D TextureSampler : register(s0);

//TODO float2 TexelSize; // Set from your app: (1.0/textureWidth, 1.0/textureHeight)
float2 TexelSize = (1.0 / 1920, 1.0 / 1080); // Set from your app: (1.0/textureWidth, 1.0/textureHeight)
float SharpenStrength = 1.0; // You can tweak this value for more/less sharpening

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 SharpenPS(VS_OUTPUT input) : COLOR
{
    float2 uv = input.Tex;

    // Sharpen kernel (center pixel weighted, neighbors subtracted)
    float4 color = tex2D(TextureSampler, uv) * (5.0 * SharpenStrength);

    color -= tex2D(TextureSampler, uv + float2(-TexelSize.x, 0));
    color -= tex2D(TextureSampler, uv + float2(TexelSize.x, 0));
    color -= tex2D(TextureSampler, uv + float2(0, -TexelSize.y));
    color -= tex2D(TextureSampler, uv + float2(0, TexelSize.y));

    // Clamp to valid color range
    color = saturate(color);

    return color;
}

technique Sharpen
{
    pass P0
    {
        PixelShader = compile ps_2_0 SharpenPS();
    }
}
