**Source Filters**
 The Source Filter component lets you plug fullscreen .fx/hlsl into the Elemental render pipeline. A bunch of default, basic filters/shaders are included, all of which can be added, linked and controlled through the control panel, no code required. If you are shader-literate (or know someone who is), you can add your own filters by adding .fx files to the Data/Shaders/Filters/ folder.

You can have your shader parameters appear within the standard Elemental UI using a custom comment tag in the shader. Because that becomes another component property just like the others, you can then set your shader constant to be linked to the FFT, BPM, an envelope, a midi or osc controller dial (eventually), etc etc. 

The Source Filters acts on whatever you're mixing through a Source Channel (milkdrop, vid, spout input, outputs from particle systems, or any combination of earlier sources etc); your random milkdrop + dilate or radial blur on FFT Bass is usually worth a basic set in itself. 

**Tips**
- Use F5 to refresh the shaders
- Check the log tab for compiler errors if your shader doesn't work
- Copilot/Claude etc are pretty good at generating shaders with the right prompts

**Elemental UI shader params annotation**

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


**Default Filters**

#TODO - Will add a list of filters here with their basic function and params
