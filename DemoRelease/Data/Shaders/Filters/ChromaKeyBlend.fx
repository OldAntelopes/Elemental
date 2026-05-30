// ChromaKeyBlend.fx

sampler2D TextureSampler : register(s0);
sampler2D SecondChannelSampler : register(s1); // [ELEUI_TEXTURE:Blend:1]

float4 KeyColor = float4(0.0,1.0,0.0,0.0); // [ELEUI_COLOUR:Key Colour:0.0|1.0] Default: green
float Tolerance = 0.4; // [ELEUI_FLOAT:Tolerance:0.0|1.0] How close to key color (0.0-1.0)
float Feather = 0.05; // [ELEUI_FLOAT:Feather:0.0|1.0] Soft edge width

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 ChromaKeyBlendPS(VS_OUTPUT input) : COLOR
{
    float4 color = tex2D(TextureSampler, input.Tex);

    // Compute color distance
    float dist = distance(color.rgb, KeyColor);

    // Alpha: 0 if within tolerance, 1 if outside, feathered in between
    float blend = smoothstep(Tolerance, Tolerance + Feather, dist);
    
//    blend = 0.0;
    color.rgba = (color.rgba * blend) + ( tex2D(SecondChannelSampler, input.Tex) * (1.0 - blend));  
//    color.rgba = (color.rgba * blend) + (float4(0.0f, 0.0f, 0.0f, 1.0f) * (1.0 - blend));
//    color.r = 1.0;
    return color;
}

technique ChromaKeyBlend
{
    pass P0
    {
        PixelShader = compile ps_2_0 ChromaKeyBlendPS();
    }
}