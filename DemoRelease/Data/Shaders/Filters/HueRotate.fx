// HueRotate.fx

sampler2D TextureSampler : register(s0);

float HueShift = 0.0; // [ELEUI_FLOAT:Hue Shift:-3.14159|3.14159] (radians, -PI to PI)

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

// Helper: RGB to YIQ
float3 rgb2yiq(float3 rgb)
{
    float Y = dot(rgb, float3(0.299, 0.587, 0.114));
    float I = dot(rgb, float3(0.596, -0.274, -0.322));
    float Q = dot(rgb, float3(0.211, -0.523, 0.312));
    return float3(Y, I, Q);
}

// Helper: YIQ to RGB
float3 yiq2rgb(float3 yiq) 
{
    float3 rgb;
    rgb.r = dot(yiq, float3(1.0, 0.956, 0.621));
    rgb.g = dot(yiq, float3(1.0, -0.272, -0.647));
    rgb.b = dot(yiq, float3(1.0, -1.106, 1.703));
    return rgb;
}

float4 HueRotatePS(VS_OUTPUT input) : COLOR
{
    float4 color = tex2D(TextureSampler, input.Tex);

    // Convert to YIQ
    float3 yiq = rgb2yiq(color.rgb);

    // Rotate hue in the I/Q plane
    float angle = HueShift;
    float cosA = cos(angle);
    float sinA = sin(angle);
    float I = yiq.y * cosA - yiq.z * sinA;
    float Q = yiq.y * sinA + yiq.z * cosA;

    // Convert back to RGB
    float3 rgb = yiq2rgb(float3(yiq.x, I, Q));

    // Clamp to [0,1] to avoid out-of-gamut colors
    rgb = saturate(rgb);

    return float4(rgb, color.a);
}

technique HueRotate
{
    pass P0
    {
        PixelShader = compile ps_2_0 HueRotatePS();
    }
}