// Blur.fx

sampler2D TextureSampler : register(s0);

float3 iResolution = float3(1920.0, 1080.0, 1.0); // Set from the app: (width, height, 1.0))

float BlurAmount = 1.0; // [ELEUI_FLOAT:Blur Amount:0.0|64.0] Default blur radius

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 BlurPS(VS_OUTPUT input) : COLOR
{
    float2 TexelSize = float2(1.0 / iResolution.x, 1.0 / iResolution.y);

    float2 uv = input.Tex;
    float2 offset = TexelSize * BlurAmount;

    float4 sum = float4(0, 0, 0, 0);

    // 3x3 box blur
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            sum += tex2D(TextureSampler, uv + float2(x, y) * offset);
        }
    }

    return sum / 9.0;
}

technique Blur
{
    pass P0
    {
        PixelShader = compile ps_2_0 BlurPS();
    }
}
