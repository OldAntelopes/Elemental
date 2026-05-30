// Toon.fx

sampler2D TextureSampler : register(s0);

float3 LightDirection = normalize(float3(0.5, -1.0, 0.5)); // Set from app if needed

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
    float3 Normal : TEXCOORD1;          // mm ?? need to check if this is coming in properly..
};

float4 ToonPS(VS_OUTPUT input) : COLOR
{
    // Sample base color
    float4 color = tex2D(TextureSampler, input.Tex);

    // Calculate diffuse lighting
    float NdotL = saturate(dot(normalize(input.Normal), LightDirection));

    // Quantize lighting for toon effect (3 bands)
    float toonShade;
    if (NdotL > 0.75)
        toonShade = 1.0;
    else if (NdotL > 0.5)
        toonShade = 0.7;
    else if (NdotL > 0.25)
        toonShade = 0.4;
    else
        toonShade = 0.15;

    color.rgb *= toonShade;

    // Optional: simple edge detection (darken edges)
    // If you pass edge info in alpha, you can do:
    // color.rgb = lerp(color.rgb, float3(0,0,0), 1.0 - input.Pos.w);

    return color;
}

/*

VS_OUTPUT ToonVS(float4 inPos : POSITION, float3 inNormal : NORMAL, float2 inTex : TEXCOORD0)
{
    VS_OUTPUT output;
    output.Pos = mul(inPos, WorldViewProj);
    output.Tex = inTex;
    output.Normal = mul(inNormal, (float3x3) World); // Transform normal to world space
    return output;
}

*/

technique Toon
{

//    pass V0
//    {
//        VertexShader = compile vs_2_0 ToonVS();
//    }

    pass P0
    {
        PixelShader = compile ps_2_0 ToonPS();
    }
}
