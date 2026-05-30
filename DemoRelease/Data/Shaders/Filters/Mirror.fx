// Mirror.fx

float   gMirrorCount = 2.0;    // [ELEUI_FLOAT:Mirror Count:0|8.0]
bool    gRadial = false;       // [ELEUI_BOOL:Radial:0]
bool    gVertical = true; // [ELEUI_BOOL:Vertical:1]
float2   gSourceScale = 1.0; // [ELEUI_FLOAT2:Source Scale:0|4.0]

sampler2D TextureSampler : register(s0);

static const float PI = 3.14159265359;
static const float TWO_PI = 6.28318530718;

struct VS_OUTPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

float4 FlatMirrorPS(VS_OUTPUT input) : COLOR
{   
    float2 uv = input.Tex.xy * gSourceScale;
    
    // Calculate which mirror segment we're in
    int mirrorCount = max(1, (int) gMirrorCount);
    float segmentWidth = 1.0 / (float) mirrorCount;
    
    float2 mirroredUV;
    
    if ( gVertical )
    {
    // Find which segment this pixel belongs to
        float segment = floor(uv.x / segmentWidth);  
    // Get position within the segment (0 to 1)
        float posInSegment = fmod(uv.x, segmentWidth) / segmentWidth;            
    
        // Mirror odd segments
        int segmentIndex = (int) segment;
        if (segmentIndex % 2 == 1)
        {
            posInSegment = 1.0 - posInSegment;
        }
    
    // Calculate final UV coordinates
        mirroredUV = float2(uv.y, posInSegment * segmentWidth );
    }
    else
    {
    // Find which segment this pixel belongs to
        float segment = floor(uv.y / segmentWidth);
    // Get position within the segment (0 to 1)
        float posInSegment = fmod(uv.y, segmentWidth) / segmentWidth;
    
        // Mirror odd segments
        int segmentIndex = (int) segment;
        if (segmentIndex % 2 == 1)
        {
            posInSegment = 1.0 - posInSegment;
        }
    
    // Calculate final UV coordinates
        mirroredUV = float2(posInSegment * segmentWidth, uv.x);            
    }
    
    // Sample the texture
    float4 color = tex2D(TextureSampler, mirroredUV * gSourceScale);   
    return color;
}


float4 MirrorPS(VS_OUTPUT input) : COLOR
{
    if (gRadial == false)
    {
        return FlatMirrorPS(input);
    }
    
    // Radial mirror
//    float2 scale = float2(1.0, 1.0);
//    scale = gSourceScale;
    float2 centered = (input.Tex.xy ) -0.5;
    
    centered /= gSourceScale;

    float radius = length(centered);
    float angle = atan2(centered.y, centered.x);

    // Remap -PI..PI to 0..2PI - avoid branch with step
    angle += TWO_PI * step(angle, 0.0);

    // Use float throughout - avoids expensive int cast and int % operator
    float mirrorCount = max(1.0, gMirrorCount);
    float segmentAngle = TWO_PI / mirrorCount;

    float segment = floor(angle / segmentAngle);
    float posInSegment = fmod(angle, segmentAngle);

    // Mirror odd segments - replace int branch with float lerp+step
    float isOdd = fmod(segment, 2.0);
    posInSegment = lerp(posInSegment, segmentAngle - posInSegment, step(0.5, isOdd));

    // sincos computes both sin and cos in a single instruction slot
    float sinA, cosA;
    sincos(posInSegment, sinA, cosA);

    float2 mirroredUV = ( (  float2(cosA, sinA) * radius) / gSourceScale) + 0.5;

    return tex2D(TextureSampler, mirroredUV);
}

technique Mirror
{
    pass P0
    {
        PixelShader = compile ps_2_a MirrorPS();
    }
}