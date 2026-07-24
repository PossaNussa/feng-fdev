# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/).

'!' (near bottom) is for bugs in 2012 version that are fixed (as opposed
to features that were changed/added) in this fork.


## [git] - 2019-07-02
### Changed
* Rename etc to src to denote that the files are unnecessary for use.
* Move log to CHANGELOG.md (and format as per keepachangelog.com)
* Rename expertmm to poikilos to reflect my GitHub username change.
* Improve use of markdown in README.md and CHANGELOG.md.


## [git] - 2017-05-14
### Added
- ruby item, mineral, & (realistic mode) block textures


## [git] - 2017-03-23
### Added
- peridot (realistic mode) block texture


## [git] - 2017-03-21
### Changed
- improved peridot item & mineral textures


## [git] - 2017-03-20
### Added
- Add improved opal item texture (All except optional realistic mode
  opal block are finished)
### Changed
- Change garnet from Spessartine to pomegranate seed colored Rhodolite
  to reflect the original meaning of the word garnet (comes from the
  word pomegranate) -- see
  <https://www.americangemsociety.org/en/garnet-history>.


## [git] - 2017-03-18
### Added
- new textures for garnet: gem (item), mineral, block (realistic style)
### Changed
- Change tint of garnet block (classic style) to look like Spessartine
  garnet.


## [git] - 2017-03-13
### Changed
- Use settings from server's minetest.conf:
  birthstones_texture_style (can be realistic or classic)
- Change default block style to classic
- Improve opal mineral overlay, alexandrite classic block texture.


## [git] - 2017-03-11
### Changed
- Redo emerald mineral and item textures.
- Redo classic textures for gems where realistic block is not
  finished yet.


## [git] - 2017-03-10
### Changed
- Redo textures for "white diamond" mineral and item [blend file:
  octagon beveled all but top and bottom by .12 offset] and for topaz
  mineral.
- Change sun square emission from 10 to 100.


## [git] - 2017-02-16
### Added
- Rerender Alexandrite block & item; new textures for minerals:
  Alexandrite, Amethyst (collect HD versions in src/hd).
### Changed
- Completely rework gem shader (blend version 2).
- Redo textures for aquamarine: mineral, block, item.


## [git] - 2017-02-15
### Changed
- In blend file, connect ID Mask to Image output (in Compositor nodes)
  for alpha in rendered image.


## [git] - 2017-02-13
### Added
- Make Blender project for gem rendering (see Developer Notes in
  README.md for usage)
- Make multi-sided Topaz Block (WIP) made in Blender.
- Finish gem and block textures for Topaz, Alexandrite, Amethyst (in
  Blender by Poikilos)


## [git] - 2017-02-12
### Added
- (2017-02-12) Add gem hoes (using farming api).


## [git] - 2017-02-11
### Added
- (!) Make opal possible to get: added missing register_on_generated for
  changing some stone to opal (see oregen.lua).
- swords & shovels
- Add crafting recipe to convert block back into 9 gems.
- Add recipe to create `default:diamond` from `dye:blue` +
  `birthstones:diamond` for playability (for when other mods like
  technic need diamonds for things)
### Changed
- (!) Preliminary step in fixing one-chop axes: Change register_tool
  `time2` and `time3` from:
  `[1]=time1-2.0, [2]=2.0-time2, [3]=2.0-time3}`
  to
  `times={[1]=time1/2.0, [2]=time2/2.0, [3]=time3/2.0}`
- Change `* Ore` to `Stone with *` (because why copy other people when
  you can make sense instead).
- (!) Ore needs better pick to be mined: changed groups.cracky of all
  from 3 to 1
- (!) Block needs better pick to be mined: Changed groups:
```lua
	-- groups = {cracky = 3}
	groups = {cracky = 1, level = 3}
```
- (!) Change drop of ores (to match modern style from default in
  minetest_game from minetest 0.4.15-git 2017-01), where * below is
  name:
```lua
	-- drop = 'craft "birthstones:*" 1',
	drop = "birthstones:*",
```
- (!) Change drop for stone_with_topaz from stone_with_topaz to topaz
  (apparently this didn't cause an issue since craft method had been
  used).
- Componentize into separate lua files for each category of operations.


## [git] - 2017-02-10
### Changed
- Poikilos fork starts today.
- Match minetest texture & variable naming scheme:
```
    (see changes below, where ^* is capitalized mineral name and * is
    uncapitalized)
	(aliases added only for backward compatibility--see aliases.lua
	--doing aliases can be commented in init.lua)
	Files:
		^* TO birthstones_* (ITEM)
		^*_overlay TO birthstones_mineral_* (ORE OVERLAY)
		^*_block TO birthstones_*_block
		*_axe to birthstones_tool_*axe
		*_pick to birthstones_tool_*pick
		^*_block to birthstones_*_block
	Variables:
		birthstones:*ore TO birthstones:stone_with_*
		"birthstones:".. name .. "_pick" TO "birthstones:pick_"..name
		"birthstones:".. name .. "_axe" TO "birthstones:axe_"..name
```
- (!) Capitalize stone name when used within tool display name.
- (!) Fix issue where topaz ore was registered twice (didn't seem to
  cause problems)
- (!) Remove month from display names to avoid breaking immersion (draws
  too much attention to the items having a "label") if re-added, months
  would have to be corrected anyway as follows (in the original mod,
  alphabetical order instead of actual birthstone month determined
  month): see src/birthstones list.csv
