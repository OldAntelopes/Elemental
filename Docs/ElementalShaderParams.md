
The Elemental shader params annotation allows parameters in the shader to be controlled by UI in the Elemental app.

To expose a shader parameter, a comment block is added after the parameter declaration, for example:

   float BlurAmount = 1.0; // [ELEUI_FLOAT:Blur Amount:0.0|64.0] Default blur radius

The section in square brackets after the comment is parsed by the app to determine the type and properties of the exposed UI.

The format for this annotation is:

// [<FIELD_TYPE>:<NAME>:<MIN_VALUE>|<MAX_VALUE>] <Description>

Valid values for the FIELD_TYPE field are:

ELEUI_FLOAT		: single float value, displayed using a slider with the min and max range
ELEUI_FLOAT2    : float2, displayed as two separate sliders each using the min and max range 
ELEUI_FLOAT4    : float4, displayed as four separate sliders each using the min and max range
ELEUI_INT		: single int value, displayed using a slider with the min and max range
ELEUI_BOOL		: boolean, displayed as a checkbox
ELEUI_TEXTURE   : a texture sampler source. The UI allows the user to choose a texture file
ELEUI_COLOUR    : a (float4) colour value. The UI allows the user to choose a colour range through a custom interface

Other examples:

sampler2D MaskSampler : register(s1);      // [ELEUI_TEXTURE:Mask:1]
bool gMaskNegative = false;     // [ELEUI_BOOL:Negative mask:0]
float2 OffsetR = (0.02, 0);   // [ELEUI_FLOAT2:R Offset:-1.0|1.0] 
