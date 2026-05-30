---------------------------------------------------------------------------------
v0.22.0
-------
- Added 'Particle Clustered Path' component - updates a bunch of persistent particles with trails along a path
- Deprecated offset and rotation components, merging them into a single 'transform' one
- Rework of the render layering pipeline to provide consistency and fix various issues where certain output layers would get displayed incorrectly
- Various performance optimisations
- Source blender - made subtract operate as source 1 - source 2  ('subtract both' is  - (source 1 + source2) ). Added outputs to the debug texture view.
- The main/default camera position is now applied at the end of every channel render process (so that a CameraControllers on one channel does not affect the camera on a different channel)
- Added 'ignore ch alpha' for particle emitters, which is particularly relevant when chaining emitters through source channels
- Instance thumbnails fallback loading process. first priority for thumbnails is now to load from/save to the composition/thumbs folder if it exists. 
- Milkplus toolbar function now works (All active milk components that are in playlist but not-autoplay mode will be advanced to the next preset)
- Moved the performance/editor mode dropdown off the midbar and replaced it with a View menu
- Added 'Confirm quit' window with save option
- Added 'first boot' window to direct newbs to either a full comp or a blank slate
- Changed the way 'source scale' is applied to mirrors
- minor/partial refactoring of some common particle features
- Initialisation status messages on boot window
- UX: Added 'move to first column' option on channel view -> instance right click popup menu
- BUGFIXES for:
  - performance mode option sometimes leaving the window expanded
  - particle emitter render targets not getting reset when the graphics device is changed (fixes inconsistent output after changing to a different display)
  - possible crash if any shaders fail to load
  - Console log not filling the entire window
  - cases where the active composition name wasnt getting set correctly (e.g. when merging comps, creating new comp, etc)
  - mappablefunctions not being re-registered correctly after loading a composition (hence midi-mappings would get messed)
  - Various memory leaks
  - For circle path 'pitch' property initialising without appropriate range settings
  - Sourceblender and the debug renderTargets displays sometimes not working in the release build (shutting down the boot window was inadvertedly shutting down some of the main window interface)
  - the f9 debug RTs view stopped working if the main display device was changed to another monitor (font system wasnt getting correctly reset)
  - some components (e.g. clustered path, circle path) not fully functioning when first added as a new component ('OnPostInitialise' was only getting called when the component was loaded, not when it was added).

v0.21.5
-------
- added support for different value mapping modes
- added 'open data folder' option to the main menu bar
- property values without a range will default to having a midi mapping range of -1 to 1
- added extra info on the midi mapping editor window, (including the device the mapping is associated with), made the textbox editing work and tidied the UI
- Added placeholder REST api structure and preferences option to activate the http server port (more to follow)
- Added some new filters (bulge, mirror/radial mirror) and added a few extra parameters to others. Changed BrightnessContrast to AdjustCol, which does a lil more (UI needs sortin). 
- Added midi mapping editor options to map to the content instances, the bpm +/- buttons and the prev/next column buttons
- Sorted all the channel view stuff out so we can have any number of instances in a channel (well, within limits), and the view deals with appropriately. Buttons to scroll through the channels and center the view on the specified active instance (etc)
- Added Menu option to merge compositions (combine the currently loaded one with another previously saved one) and shuffle compositions (randomly mix up the position of instances within channels - cheap way of getting some new combinations and variety to a composition)
- Added multiply blend mode
- Added concepts of editor and performance mode, which can be selected from dropdown in the midbar. 'Performance mode' will turn off most of the editor display, leaving just the channel view and channel controls panel active. (Turning off some of the editor UI can save a few milliseconds on the frametime, and just makes it easier to keep your windows tidy). 
- (Full vers) Videos now display their current playback progress etc
- BUGFIXES for:
  - non-selectable textboxes in midi mapping editor
  - Q and W keys causing the rename text input dialog to exit weirdly
  - the midi mapping selection not being reset when finishing edit
  - channels using subtractive modes making particle emitters outputting to a source channel not do anything
  - a newly added instance showing as selected in the channel view but not appearing in the effect stack
  - bunch of leaky memory issues and started looking at some of the more gnarly bits left to do with async initialisation and memory consumption
 
v0.21
-------
- Midi Mapping Editor
- Added better support for multiple midi devices. Active midi devices are shown on the preferences panel.
- Added F9: Debug texture view, which shows the various renderTargets being created during the output pipeline (useful for debugging mask and filter outputs etc)
- Improved the display of folder names in the preset browser
- Various default filter additions/improvements:
- - Added 'Absolute' flag to rotation component (Rotation then is set directly by the component, rather than being additional to whatever the current rotation is). Same for the offset component
- - Added greyscale flag to the brightness contrast filter so we don't need to have a separate greyscale filter. Added game the BrightnessContrast filter an AlphaMod prop
- - Added invert and 'Ignore source alpha' to the default ChromaKey filter (for various reasons)
- - Default pixellate filter treats a 0 pixel-size as the same as 1 (rather than just drawing nothing, which is strictly correct but pointless)
- - Added cutoff and threshold options to the default mask filter
- - Added a mirror filter and a radial mirror filter 
- Whole bunch of optimisations, fixes and improvements for the video player (so it can properly handle varying playback speeds without just throwing its toys out of the pram)
- Added tooltips to the milk playlist view to show the full paths of the presets in the playlist
- UX: Collapse all components button on the element header bar
- UX: file select dialog on video component shows correct current folder if theres a video already in place
- UX: Make the BrightnessContrast filter default when adding a new Source Filter
- Improved ui display of ELEUI_INT shader/filter props
- Added (mappable) 'prev instance' button on channels. Fixed behaviours when using the next/prev instance buttons so that it loops back to the start of the list as needed.
- Added (dev) menu option for regenerating UIDs (hopefully won't be needed if nothings broken..)
- Added import/export options for the midi mapping
- Every time a new instance is activated, older instances that are still in their fadeout transition phase speed up the fade out transition (to help reduce the amount of lingering instances when moving rapidly between em)
- BUGFIXES for:
  - milk preset browser missing one file from every folder
  - certain milkdrop presets leaving the renderer in an invalid state and hence subsequent SourceFilters not always working
  - deletion of milk component not cleaning up properly (possible crash)
  - using f11 to set display back to the preview window not saving that in settings
  - initial shader parameters for the default source filter not being shown when the component is first added.
  - transition time weirdness when rapidly switching between instances in a channel
  - crash if selecting 'next instance' on a channel with no instances
  - Q and W keys causing the rename text input dialog to exit weirdly

v0.20
-----
- Import & export options for milk playlists
- Particle Emitters can now be set to output to a source channel rather than just directly to the display
- Demo version now has 3 channels available
- New boot screen
- Preferences option to modify the default particle type (Blurry or clean), adjusted a few default settings slightly (including default particle scale)
- FIX: for 'dynamic' properties (e.g. ones that are part of a shader set within a source filter) not loading up correctly, (e.g. losing their envelope settings on load).
- FIX: for preferences checkboxes not being selectable
- UX: Various minor improvements : Milk playlists autoplay by default, Video component alpha mod defaults to 1.0, Added a 'negative' flag to the mask filter
- Various UI tidyups


v0.19
-----

- Instance transitions (Set a per-channel blend time applied when switching between instances)
- UX: Clicking on a milk preset in the preset browser now checks to find an appropriate milk component to add it to (e.g. the selected milk component if its there, or the first milk component on the instance you're looking at etc) and then play the preset immediately.
- UX: Composition is now autosaved on exit and the last autosave is reloaded on startup (option to disable this behaviour on preferences)
- Placeholder Settings/Preferences screen + initial options: Preserve alpha when switching between instances, Set minimum spout output resolution  (If fulscreen resolution is larger, itll use that).
- Tooltip when hovering over milk presets in the preset browser shows the full path of the .milk file
- Added option for param linkage to circle path and offset, added 'pitch' to the circle path component (rotate around right axis), added playback speed control to videos.
- Support using drag n drop a .milk file from explorer to playlist or milk component ui
- Bit of (WIP) foundational work on steamdeck (and relatedly auto-vj) mode - turning off control panel etc. Linked in steam api & input
- BUGFIXES for:
  - issues where the backbuffer size or the milk playback size wasnt getting the correct value for the monitor the output is on. Similarly, fixes so the spout output is set correctly. (There remains an issue where spout doesnt always update when switching between displays ; workaround that by restarting app once the display is chosen, until proper fix)
  - the pixellate filter not showing the control option in the UI
  - mouse cursor frequently not getting set properly
  - custom aspect applied properly to cam orientated sprites
  - various properties sometimes not showing their correct values on load (e.g. some source filter properties, envelope phase, etc)
  - crash when selecting and deleting keyframes
  - the SrcChan property of any shaders making use of [ELEUI_TEXTURE:..] not loading or displaying properly

v0.18
-----
Added source filter component:
- F5 reloads filter/shaders. 
- Added a bunch of initial filters including Radial Blur, offsetRGB, edgeOutline, chromakey etc
- All the trimmings that allow shader constants to be exposed to the elemental control panel
- (Filter list is populated by scanning the Data/Shaders/Filters (and Data/Shaders/Filters/User) folder for .fx files)
Envelope presets

Minor things:
- Tint colours can now be param linked
- FIX: changed graphic selection dropdown so it doesnt refresh UI when the dropdown selection changes (as it doesnt need to, and refreshing was causing the dropdown to lose focus and make up/down arrows unusable)
- Added placeholder preferences & about screens
- Thumbnails reset when an instance is copy/pasted
- (Non-demo) Video playback improvements:
- - Video component preserves last browse directory. 
- - Video starts playing on load. 
- - Videos now playback at correct speed (when they can) rather than whizzing through as quickly as possible. 
- - FIX: For Video component not respecting the output channel selection
- - Added an alpha mod to the video component
- Alpha and tint is now applied to 3d models. Fix for lack of serialisation of 3d model type
- Created a separate post-sprite-flush render layer so semi-trans models can be displayed on top of everything. (May revisit this as the arbitrary extra layer is a tad unpleasant)
- Updated the atm shaders to match what the engine is doing (so, i dunno, maybe we'll want to use the shadow rendering at some point)
- Did a bit of optimising on the serialised prop names just to keep the size of the saves down to a minimum
- Added some internal options to allow the ordering of property fields in components ; arranged things so the Output channel is always at the bottom of the component
- FIX: When switching milk from 'random in folder' to 'single preset', the active preset wasn't getting stored (and so when it was reloaded it'd be playing something different)


v0.17
-----
- Envelope editing ; add, delete (right-click) and move keyframes. Alongside, changed the data & calcs for the curve methods so they're applied at the end keyframe point (which will be familiar to anyone used to envelopes in any other Proper A/V software)
- Copy & paste instances
Minor things:
- Only serialise behaviour mode & invert values when they're not defaults (to reduce save file size)
- Default particle fade-in value
- Angle offset is applied to the circle path position on init so its still at least set when a path using variable speeds is started (this has good use case for when you want reactive speed circle paths that are synced and remain offset..)
- Particle fields now respect the particle fade-in time setting
- UX: property settings popup closes when select 'envelope'
- BUGFIXES for:
  - FFT Custom -> sensitivity value showing incorrectly when loaded
  - instance filename is set correctly when doing preset 'save as..'
  - crash if referencing an empty milk presets folder (e.g if loading a comp from somewhere else that refers to a folder that doesnt exist locally)
  - crash if video component refers to a file that doesnt exist locally
  - potential crash if midi device state gets out of whack

v0.16
-----
- Resizable control panel
- Custom FFT ranges
- Added copy & paste elements
- Added fade-in time and 'align to origin' options on particles
- Right click on the '+ new' instance in a channel to bring up the load preset dialog
- The output display, control panel window position and size are now saved into settings and restored on boot. 
- When selecting playlist autoplay and no preset is currently selected, one will now be selected
- Added axis option to Circle Path
- Change to the circle path calc so that it recognises when the speed is variable (e.g. when a speed range is set to an fft or envelope) and detaches the circle from the global angle. This makes attaching the speed to a variable source viable, but makes the angle offset irrelevant
- Added right click option on milk playlist to remove a preset from the playlist.
- Changed the orientation by which offsets are applied so it makes sense (some older presets with offsets may need inverting)
- Drag folder names/thumbnails from preset browser on to milk component folder
- UX: Playlist UI can now be collapsed (collapsed version still accepts dragged in presets)
- UX: FFT Popup closes appropriately when an FFT option is selected
- UX: Can drag a milk preset from the preset browser on to an element; it will add a milk component if necc and set it to play 'single preset' mode.  Similarly can drag a preset onto the preset name of an existing milk component to change it immediately.
- UX: Can drag n drop the folder path of the milk preset browser onto a milk component folder name, to set it (and set the milk component to 'random in folder' mode
- If boot fails for some reason, you're given the option to reset the settings.
- Don't display the white squares that were showing for thumbnails that were mid-load or had failed to load.
- Presets: Updated the default Standard Spout Blender .elemental so it has less kaleido and effects, rearranged the startup presets a bit, Updated some presets to fix offset change
- UI Icons: Legit Tick icon for menus, added nicer folder icon for the preset browser, Indicator on properties that are FFT linked
- BUGFIXES for:
  - camera controller ; focus on origin now works, camera-aligned sprites (mostly) work
  - occasional crash when scanning folders and shifting around the browser UI
  - the drag n drop highlight window for the milk playlist UI being the wrong size
  - source blender getting inputs offset if they werent the same size as the main output backbuffer
  - the midi mapping being broken
  - the milk preset browser path reverting whenever a path is dragged somewhere
  - occasional threaded shutdown crash if folder browser active when quitting app

Moved all the milkdrop stuff to the public github
(Not in demo): (messing about with dmx -DMX raw component for sending DMX512 channel signals out via ftdi (which according to Resolume is (probably rightly) frowned upon coz its niche and awkward, but whatever.. works for me for now.. i have lights i can dick about with and it didnt cost too much))
- (added (/hacked in) bypass option for properties (used by DMX raw))

v0.15
------
- Milk Playlist UI
- Loads of work on the milk preset browser: now recurses & shows folders, (mostly) auto caches and expires preset thumbnails to keep things performant and generally allows ya to explore all those presets nice n easy, lovely jubbly
- Various fixes and additions for multiple monitor support, Added (basic, 1st pass) fullscreen display options to the main menu based on connected output/monitors
- Added camera controller to the demo release
- Rotation affects the instance direction
- Added BPM indicator to midbar
- BUGFIXES for
  - Particle Field now clears itself up when an instance is deactivated
  - Change the UI reload so it happens only after a full render loop has completed (to avoid cases where a callback would trigger a UI reload immediately, invalidating the objects that were in the process of handling the callback and producing weird issues like dropdowns randomly expanding etc)
  - bug where an empty spout input name would cause endless attempts to create new blank spout input sources (until it ran out of texture space and exploded)
  - crash if moving components between elements and then deleting em
  - spout output getting interrupted when changing displays

v0.14
-----
- Added Particle Field component
- Added concept of direction in the effect stack
- Rotation component now has option to align to direction
- BUGFIXES for:
  - Clicking anywhere outside a modal popup closes the modal popup
  - Made it so the property popup doesnt close immediately when you select things like envelope/fft etc
  - Particle Field updates itself if graphic property is changed

v0.13
-----
Can collapse envelope UI display
Added behaviour invert flag
FIX: behaviour mode not getting saved
Inverted the camera position/orientation so that sprites appear in their normal orientation by default

v0.12
-----
added basic OSC mapping support
Added FFT Gain
Various UI tweaks n fixes : slider updates, source channel output selection, added movable constraints to source blend mix slider
some fixes for non-thread-safe milk playback issues
source blender channel setting

v0.11
-----
Improvements to trail rendering and added separate controls for fade hold and fade out time
Fixed fft audio buffer parsing
Added FFT Vol, FFT Bass, etc property behaviours
Refactored thumbnail handling, ensuring all thumbnail loading is async
Added model list (with a (temporary) option similar to sprites of having Models\User folder for adding custom content)
Improved some bits of the model component

v0.10
-----
Big reworking of the UIX stacking and child rendering logic so that it actually works and makes sense :)
Envelope phase offset
Fix for menu bar creating & leaking multiple uix pages
SpriteList scans for additional sprites in Data\Sprites\User
Improvements to the Envelope UI, added editable textbox for the speed setting

v0.09
-----
fix for milk folder and preset mode not getting serialised
refactored milk component so each has its own milkdrop plugin instance
changed circle path so all its props are ranges rather than just values
Basic midi mapping support : Midi-input refactored and driven from Json, added some default apc40 midi mapping options (active and deactivate instances on the colour buttons)
source channels
refactored milk audio/fft/loopback stuff so we can manage it separately
added a special-case rule so that if you add a milk component to an element that consists only of a particle emitter, it automatically sets the particle emitter graphic to the source channel for the milk. Its newb friendly but cheating and JUST NOT RIGHT,so i dont like it and i'll probably remove that at some point.
added log tab and various status messages from milk initialisation etc
milk component UI to allow setting of a specific milk preset
added an FFT/spectrum display to the midbar
