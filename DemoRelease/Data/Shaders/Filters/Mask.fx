//----------------
// Mask.fx

sampler2D TextureSampler : register(s0);
sampler2D MaskSampler : register(s1);      // [ELEUI_TEXTURE:Mask:1]

float gMaskScale = 1.0f;         // [ELEUI_FLOAT:Mask Scale:0.0|2.0]  
bool gMaskNegative = false;     // [ELEUI_BOOL:Negative mask:0]
bool gMaskCutoff = false; // [ELEUI_BOOL:Mask Cutoff:0]
float gMaskThreshold = 0.5f; // [ELEUI_FLOAT:Mask Threshold:0.0|1.0]  

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 MaskPS(VS_OUTPUT input) : COLOR
{
    float4 mask;
    
    if ( gMaskScale == 1.0f )
    {
        mask = tex2D(MaskSampler, input.Tex );
    }
    else
    {
        float2 originScale = clamp(0.5 + (input.Tex - 0.5) / gMaskScale, 0.0, 1.0);

        mask = tex2D(MaskSampler, originScale);        
    }
    float maskLuminance = dot(mask.rgb, float3(0.299, 0.587, 0.114));

    if (gMaskNegative)
    {
        maskLuminance = 1.0 - maskLuminance;
    }

    if ( gMaskCutoff )
    {
        if (maskLuminance < gMaskThreshold)
        {
            return tex2D(TextureSampler, input.Tex);           
        }
        else
        {
            return float4(0.0f,0.0f,0.0f,0.0f);
        }
    }   
    return tex2D(TextureSampler, input.Tex) * maskLuminance;
}

technique Mask
{
    pass P0
    {
        PixelShader = compile ps_2_0 MaskPS();
    }
}
