# birthstones
(minetest mod)

* Code is based on birthstones Minetest mod by Doc22.
* Default (pixel art) textures are based on CC-BY-SA work by various
  authors (see LICENSE for full credits).

## Primary differences from original
(see also CHANGELOG.md)

### Main reasons for fork
* Add more tools.
* Make changes to code to make use of modern Minetest (such as ore drop
  string).
* Make 3D prerendered textures of gem (item) and mineral (and optional
  block textures); improve other textures.

### Notable Issues Found in Original
(see also exclamation points in **CHANGELOG.md**)
* I removed incorrect birth stone months (see "birthstones list.csv" in
  src. folder for corrections, though month names are removed in this
  fork).
* Now stone_with_opal is generated (it was impossible to get by mining
  before, apparently).
* Crafting a block back into 9 gemstones is now possible.

### Other Major Differences from Original
I made some major changes to make the mod easier to maintain:
* I changed to minetest_game's naming scheme for filenames and node/tool
  names (adding aliases for backward compatibility).
* Componentize into separate Lua files by operation.


## Known Issues
* Improve remaining block textures
* Make a trm for treasurer (separate mod)
* Make variables based on real hardness values (but allow all birthstones to break the same types of blocks, for playability):
  * #of uses, dig times, and fleshy damage group value now all based on real-life hardness values (see xlsx spreadsheet for details and sources and extrapolation formulas)
  * Formulas were determined using Excel:
    * Diamond theoretical Brinell explanation: Excel says the curve on 18carat.co.uk, if a power curve, is Brinell = 2.9592*(ans^2.2856) where ans is Moh value
    * Other extrapolated Brinell values (rounded to nearest whole number) explanation: Excel says power function for predicting from density is Brinell = 9.0954*(ans^2.9757) where ans is metric density value
    * Extrapolated Moh values explanation: Excel says power curve from 18carat.co.uk materials is: Moh = 0.6514*(ans^0.4269) where ans is Brinell value
(to use Speedcrunch to get values not listed, enter the number without any equation, then paste the formulas above exactly to use that "answer" as a variable--see spreadsheet's "Hardness - Extrapolated" sheet for spreadsheet version of formulas)

### Things that will be kept the same:
* You must manually delete the src folder (source material) from your mods/birthtones folder to reduce download times of the mod when using a server
* birthstones:diamond will still be present for now (as opposed to becoming an alias for default:diamond), since the birthstones diamond texture looks cool. The display names for all of the items will say "White Diamond". (planned: recipe to make it into regular diamond)
* No shields & armor (planned as separate mod: birthstones_3d_armor)
* No arrows (planned as separate mod: birthstones_throwing)

### Future plans
* Add option in server minetest.conf to use 8-bit style block textures (based on minetest default diamond block)
* Look into changes in "birthstones fixed" at https://forum.minetest.net/viewtopic.php?f=9&t=11497&hilit=birthstones
* Look into overlap in stone list found in Glooptest
* Make compatible with glooptest
```Lua
  local glooptest = minetest.get_modpath("glooptest")
  if glooptest then
    register_alias("birthstones:amethyst","glooptest:amethyst_gem")
    register_alias("birthstones:emerald","glooptest:emerald_gem")
    register_alias("birthstones:ruby","glooptest:ruby_gem")
    register_alias("birthstones:sapphire","glooptest:sapphire_gem")
    register_alias("birthstones:topaz","glooptest:topaz_gem")
    -- (and glooptest:*_block for all of those)
  else
    -- create those ores
    -- register those ore nodes
    -- register those block nodes
  end
  -- If neeeded, can also do things like drop = glooptest and "glooptest:topaz_gem" or "birthstones:topaz"
```


## Minerals of note not in birthstones (for reference only) with density values from website above:
(NOTE: More, but with only Mohs hardness values, available from 18carat.co.uk link in spreadsheet)
* Name,Density,Moh,Brinell
* Apatite,3.16-3.23,5,137
* Calcite,2.69-2.71,3,53

### Developer Notes
xcf file has colors used for manual tinting
Reference photos: Wikipedia entries for each Gem, and http://geologynerd.tumblr.com/

(If you rotate the gems, rotation must be applied, since absorption is manually done along object z axis--see "Blender gem tutorial" link below for why)
Do the following steps to re-render a block:
* Install filmic blender (recommended: install Cycles Denoising build of Blender, and place filmic blender in there)
* IF you make a new object that should be the gem, add the Gem3 material to your object (this is recommended for consistency--with previous versions, you must hide ground and show Ground sky reflection in order for top view to look shiny--this may be since both clamping settings were above 0).
* Open the included Blend file in Blender and set the input nodes as follows (if there are two, set one as the input for absorption and turn that up--or experiment; ~ means wasn't plugged into any nodes):
(v1L you can also tweak whether fresnel, facing, or IsTransmissionRay is Factor for "Glow Mix" node (you can also flip the inputs)
(v2 you can also tweak whether Tangent, which Light Path output [and whether passes through Reduction node], or nothing [0.00] is used for Glare Mix's Factor; warped block shards can be fitted together then scaled by 1.01 on the x&z [s, shift z, 1.01])
```
Name,		GemColor,			IOR**,		Frost,	Gloss,	Clarity,Absorption,	AbspSat,	Glare Mix, 						GlareSat (Glare Saturation)
***Alexandrite,567274 to 63152c,1.75,		~,		~,		.95,	1,			1.0,		Gem:Tangent ; Block: Tangent*Reduction; Block east: 0.00, ~
***Amethyst,	ad87a6,			1.55,		.5,		0,		0,		1,			.5,			~,								~
***Aquamarine,	8bdcdf,		1.564-1.596,	~,		~,		.95,	1,			0,			Gem:PatchyNoise;,				.5
Aquamarine,	(!8bdcdf)04A752,1.564-1.596,	.1,		0,		.5,		0,			0,			~,								~
Diamond,	ced7da,				2.418,		0{.1}[.01],		0[.1],	1,			0,			,
Emerald,	(!02552a)04A752,1.5775-1.5835,	0,		.1,		.99,	.5,			0,			,
[Spessartine]Garnet,b5622c,1.73-1.75,		0,		0,		.9,		0,			,			,
[pom-colored]Garnet,910516,1.73-1.75,		0,		0.05,	1.0,	0,			,			,
Opal,		(texture),			1.52,		,		,		,		,(see blend file version 2's 'Stone' material),
Peridot,	85b116,			1.658-1.695,	0.001,	0.05,	0.99,	0,			0,			,
Ruby,		832935,			1.766-1.774,	,		,		,		,			,			,
Sapphire,	163f7d,				,		,		,		,		,			,			,
***Topaz, 	E5A55F,				1.62,		.5,		.5,		1.0, 	0.0,		0.0,		,
Zircon,		255f75,				,	,	,		,		,
****LampSky changed from ~1 to 3, LampSunSquareYellow changed from .3 to 30, clouds from 1 to 4, starting from only item version of this to all future renders
```
Symbols:
- `[]` if in brackets, value is for block version
- `!` means not that value: though that value is apparent from a reference photo, it is apparently not the true albedo
- `{}` if in bracurly braces, value is for mineral (ore) version
- `**` Complete IOR Lists (values averaged or used from)
  http://forums.cgsociety.org/archive/index.php?t-513458.html
  http://www.gemselect.com/gem-info/refractive-index.php (use this one--has double refraction info)
- `***` old shader (usually Gem2, or sometimes Gem) was used as opposed to Gem3 (Frost was called Scatter, but it wasn't actually volumetric scatter in Gem shaders 1-2)
- where '-' appears in IOR column, double refraction is used [different values in each IOR value input node])
- Starting with **Emerald**, block is rotated by 90 on z
- pom-colored means pomegranate-seed-colored

Take note that this list is in alphabetical order (like birthstones-mod git 2012) for convenience, not in actual birthstone month order.
* Keep default resolution of 32x32 (must be full bleed then cropped to 16x16 manually to avoid edge issues with cycles)
* Render the following cameras (or experiment): North, East, Top
* In your favorite image editor, finish making them usable in-game:
  * Crop all textures to 16x16
  * Make the textures seemless such as by using these steps:
    * Copy the bottom row of pixels of top, then Paste onto top row of pixels of north
    * Rotate top to the right temporarilty (don't save top after this)
    * Copy the new bottom row of pixels of top, then Paste onto top row of pixels of east
To make a Gem:
* If you are making a new gem, I recommend making surface imperfect as follows (avoid Edge Split since it breaks edges into two lines, leading to problems with further modifiers and possibly with refraction or other light paths):
  * Make a gem
  * Tools, Smooth
  * Add Modifier, Subdivision Surface, simple, View: 3 (that will be applied), Apply
  * Go to edit mode, and select any edges that should be sharp, and click Mesh, Edges, Mark Sharp
  * Object Data, check Autosmooth
  * Change angle (can be all the way up, such as 90, if you did mark sharp on all edges above)
  * Add Modifier, Displace, Add New, click "Show texture in texture tab" button to the right of it, change it from "Image or Movie" to Musgrave Multifractal, Intensity around .3, Size 2.0 or a little more than the size of the gem, then go back to Displace modifier and change Strength as needed (may have to be negative especially for some Musgrave patterns).
* To make 8-bit version, convert to 8-bit before scaling down from 128x128 to 16x16.
* To use existing Block Shards, keep in mind that for Block Shard Hex Pointed, Object data, mesh name can be changed between "BlockShardHexFlatSide" and "BlockShardHexPointed"

### Special Thanks
- [How to Create a Rock in Blender Using Built-In
  Textures](https://www.youtube.com/watch?v=5v8pzsYImc8)
  by Blender Smoothie

- [Blender - shiny glass sculpture - Cycles render -
  Zeitfreund](https://www.youtube.com/watch?v=jDHYQUj3N90)
  by Zeitfreund

- [Cycles' Volume
  Materials](https://www.youtube.com/watch?v=CU_igW_1ZXs)
  by EnigmaToots

### Possibly helpful other tutorials
- (basis for Gem1 material)
  [Blender gem tutorial](https://www.youtube.com/watch?v=3EN6mAFDqaI)
  by Marijus Jacevičius

- (additional influence on Gem2 material):
  [Creating advanced shaders in Blender / cycles -
  Flat](https://www.youtube.com/watch?v=nnpvFbvRSyM&t=1344s)
  by Thornton Strolia

- (unused, but can be used for color diffraction)
  [Blender Quick Tip #4 | Diamonds in
  Blender](https://www.youtube.com/watch?v=4sk6RFcORd0)
  by The Digital M

- [Gemstone
  (Tutorial)](https://www.youtube.com/watch?v=I4PmptWMA08&t=8s)
  by toki FX


## Minetest 2017 API notes
(see <http://wiki.minetest.net/Groups> and
<https://github.com/minetest/minetest/blob/142e2d3b74ad886eed83b0fc9d6cfea100dae10a/doc/lua_api.txt#L736>)
### groupcaps (in tool_capabilities dict in register_tool 2nd param dict): a dictionary of groupcap dictionaries such as:
- choppy: chops wood
- snappy: leaves and other thin materials -- possible with sword, but wears sword out quickly
- fleshy: damage mobs/players
- crumbly: shovels etc.
- cracky: picks etc.
- (and more unrelated to this mod)

### register_node:
<http://dev.minetest.net/minetest.register_node>
<http://dev.minetest.net/Groups>
- groups.cracky: like other dig types, the value is normally 1 to 3, and 1 requires the best pick to mine.
- groups.level: prevents being mined by lower level stuff

