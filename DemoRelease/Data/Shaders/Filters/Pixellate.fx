// Pixellate.fx

sampler2D TextureSampler : register(s0);

float3 iResolution = float3(1920.0, 1080.0, 1.0); // Set from the app: (width, height, 1.0))

float PixelSize = 32.0; // [ELEUI_INT:Pixel Size:0.0|256] Size of each pixel block in texels

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 PixellatePS(VS_OUTPUT input) : COLOR
{
    float2 TexelSize = float2(1.0 / iResolution.x, 1.0 / iResolution.y);
    float2 uv = input.Tex;

    // Compute the size of a pixel block in UV space

    float2 blockSize = TexelSize * max(1.0, PixelSize);

    // Snap UV to the center of the nearest block
    float2 blockUV = floor(uv / blockSize) * blockSize + blockSize * 0.5;

    float4 color = tex2D(TextureSampler, blockUV);
    return color;
}

technique Pixellate
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixellatePS();
    }
}