# Purpose of this API

This wielded item API is meant to provide both a unified and extensively customizable programming experience. Unifying wield3d and wielded light mechanics with event + item callbacks. Events/callbacks available for selection/deselection, wield3d entity spawn/despawn, and wielded light "alit" and "unlit". Built to provide a rich amount of resources for your developer needs.


# API

The main meat of this mod! Provides selection/deselection, modify_ago/modify_now, on_empty, joinplayer/leaveplayer, and on_step events/callbacks!

## IMPORTANT NOTES/DISCLAIMERS

`on_modify_ago` and `on_modify_now` do NOT get ran for `on_empty` - and there should be a separate callback for it if you depend on an item being modified. `on_empty` is ran specifically when the item is dropped or removed (index unchanged, item missing)

`on_modify_ago` and `on_modify_now` also will NOT be ran if an Itemstack has had its meta or count modified. The callbacks will NOT be ran if the ItemStack's count or meta is modified (debating a future `to_string_check` to utilize)

ALL current item callbacks do NOT accept any returns - and will not modify the ItemStack proper. In order to ensure the saving modification, do `player:set_wielded_item(itemstack)`


## playerdata (pdata)

A table containing stored information on the player. This will include the following:

- `obj` - the actual player object

- `name` - name of the player grabbed from `:get_player_name()`

- `itemstack` - current wielded itemstack, grabbed from the player via `:get_wielded_item()`

- `windex` - "wielded index" - selected index of the player grabbed with `:get_wield_index()`

- `itemdef` - "item definition" - grabbed definition of `pdata.itemstack` via `:get_definition()`



## Mod Variables

`features` (table)

Table showcasing what the current list of added features are. Check `init.lua` to see what version each listed feature correlate to.

`active_modules` (table)

Table of currently active modules (modules folder inside mod). Modules that were successfully loaded, indexed by file's name (excluding extension)

`unresolved_modules` (table)

Table of lua files under mod's module's folder - that could not be loaded. Indexed by file's name (excluding extension)


## Programming Settings

`mincheck` (number) - default of 0

Number that handles the speed of the `globalstep` used for running item callbacks and events. Modify it to change how slow the checks are - good to modify if the mod gets laggy on larger servers


## Events

All listed events (excluding `register_on_setting_changed`) will firstly provide:
- `player`, `itemstack` (current wielded item), `index` (current wield index)

In events such as `register_on_modify_ago`, `register_on_deselect`, and `register_on_empty` - it will have the *old* `itemstack` and `index` first

All listed events (excluding `register_on_setting_changed`) will have, at the end of their parameters:
- `dtime` (how long it took for the step to occur), `def` (current itemstack's definition) (OR) `defs` (definitions of both new and old itemstacks, noted as `defs.new` and `defs.old` respectively), `pdata` (player's data)

In the case of the `register_on_joinplayer` and `register_on_leaveplayer` events - they will NOT have `dtime` as a parameter

`register_on_select`

Example function parameters: `function(player, itemstack, index, old-itemstack, old-index, dtime, defs, pdata)`

Ran when it's detected that a player freshly selects another item in their inventory (moved selected slot). Prior selected item is returned as `oitem` (old-itemstack) and `oindex` (old-index)

`register_on_deselect`

Example function parameters: `function(player, old-itemstack, old-index, itemstack, index, dtime, defs, pdata)`

Functional inverse of `register_on_select`, ran for the itemstack that has been detected as recently being selected off of. Now-selected item and its index are returned as `itemstack` and `index`

`register_on_modify_now`

Example function parameters: `function(player, itemstack, index, old-itemstack, old-index, dtime, defs, pdata)`

A general event for when the player either selects a different item or has their item modified to be a different registered item (does NOT run for meta or count modifications). Ran alongside `register_on_select`, with similar expected parameters. Does NOT run if current wielded ItemStack was emptied.

`register_on_modify_ago`

Example function parameters: `function(player, old-itemstack, old-index, itemstack, index, dtime, defs, pdata)`

Functional inverse of `register_on_modify_now`, ran for the item that has been detected as being selected off of - or has been modified to be a different itemstack (does NOT run for meta or count modifications). Ran alongside `register_on_deselect`, with similar expected parameters. Does NOT run if current wielded ItemStack was empied.

`register_on_empty`

Example function parameters: `function(player, old-itemstack, old-index, dtime, old-def, pdata)`

Ran when the current wielded ItemStack is emptied - either dropped, count set to 0, or ItemStack was cleared. Use this event alongside `register_on_modify_now` and `register_on_modify_ago`.

`register_on_joinplayer`

Example function parameters: `function(player, itemstack, index, def, pdata)`

Ran when the player is joining. Provides formatted player's data.

`register_on_leaveplayer`

Example function parameters: `function(player, itemstack, index, def, pdata)`

Functional inverse to `register_on_joinplayer`, ran when the player is leaving or the server is shutdown. Ran prior to `pdata` being erased.

`register_on_step`

Example function parameters: `function(player, itemstack, index, dtime, def, pdata)`

Ran each time the mod's `globalstep` check is ran. Speed is dependent on server lag and `tph_wielditem.mincheck`.

`register_on_setting_changed`

Ran when a setting/value in the `tph_wielditem` global is modified. Currently this only runs for when `tph_wielditem.mincheck` is changed.


## Item Callbacks

Provided first parameters will be equal to the events above

Provided end parameters will be equal to the events above

`tph_wielditem_on_select`

Equal to its event counterpart, `register_on_select`, providing the same parameters

`tph_wielditem_on_deselect`

Equal to its event counterpart, `register_on_deselect`, providing the same parameters. Functional inverse of `tph_wielditem_on_select`

`tph_wielditem_on_modify_now`

Equal to its event counterpart, `register_on_modify_now`, providing the same parameters

`tph_wielditem_on_modify_ago`

Equal to its event counterpart, `register_on_modify_ago`, providing the same parameters. Functional inverse of `tph_wielditem_on_modify_now`

`tph_wielditem_on_empty`

Equal to its event counterpart, `register_on_empty`, providing the same parameters. Ran when the selected item is emptied, count is set to 0, or is dropped

`tph_wielditem_on_joinplayer`

Equal to its event counterpart, `register_on_joinplayer`, providing the same parameters

`tph_wielditem_on_leaveplayer`

Equal to its event counterpart, `register_on_leaveplayer`, providing the same parameters. Functional inverse of `tph_wielditem_on_joinplayer`

`tph_wielditem_on_step`

Equal to its event counterpart, `register_on_step`, providing the same parameters



# Modules

You will notice that there's a folder called "modules". The purpose of this is to permit removing and adding custom modules to the mod - and having them run effectively and be connected.

Currently, the mod comes prepackaged with two modules: `wield3d` and `wieldlight` - if your copy of the mod doesn't - then this is for the original `tph_wielditem` mod.

The code that runs modules expects a table return, requiring the function `main` for running loadtime code such as setup or running checks.

Here are the expected and optional parameters of a module return

* function `main(moddata, moduledata, events)`

- `moddata` is the global `tph_wielditem` prior to being metatable protected. Permitting modules to inject their own values.

- `moduledata` is the generated information of the select module which will contain:
  - `path` - filepath string
  - `name` - name of the module
  - `depends` - the listed "depends" of a module - the name of modules that it requires. Only present if specified.
  - `events` - names of the events as indexes, registration functions as values of the module. Only present if specified.
  
- `events` will be, if module data specified an `events`, a table of `events_api` (https://content.luanti.org/packages/TPH/events_api/) returns, indexed by the names provided in the module data's events table. E.g. an `events` array of  `moduledata.events = {"myevent"}` will become `events = {myevent = *events_api-data*}` when returned in the `main` function. If NO `events` was specified in module data, this will be NIL.
  
  
* table/string `events`

OPTIONAL! Does not need to be specified if you do not intend to have custom events firing.
  
Array of event names to have the API register. Will have a register function be added to the API as well, e.g. `register_on_my_event(func)`
  
WARNING: all event names will be automatically prefixed with "on_"!


* table/string `depends`

OPTIONAL! Does not need to be specified if your module is standalone.

Array of the names of modules that the select modules requires.

If cannot be fulfilled, prints an error to chat that your module could not be ran.



# Wield3D (module `wield3d.lua`)

Provides a wielded item entity that other players can see in a player's hand (in which they can too see in other camera modes)! With events and item callbacks for when it gets spawned/despawned.

Stores field `wield3d` to player's data (`pdata`). `wield3d` will be the entity's table


## Events

All below events will provide: `player`, `wield3d` (entity), `itemstack`, `index`, `itemdef` (item definition), and `playerdata`

Example function parameters: `function(plr, wield3d, itemstack, index, itemdef, pdata)`

`register_on_wield3d_spawn`

Ran when a wield3d entity is created.

`register_on_wield3d_despawn`

Example function parameters: `function(plr, wield3d, itemstack, index, itemdef, pdata)`

Ran when a wield3d entity is "deactivated" - removed. Callback runs in entity's `on_deactivate`. Assume that `itemstack`, `index`, and `pdata` parameters MAY be nil


## Item Callbacks

All below callbacks will provide: `player`, `wield3d` (entity), `itemstack`, `index` (wield index), `item definition`, `playerdata`

Example function parameters: `itemdef.function(plr, wield3d, item, index, itemdef, pdata)`

`itemdef.tph_wielditem_wield3d_spawn`

Like `register_on_wield3d_spawn`, ran when the wield3d entity is spawned with this item.

`itemdef.tph_wielditem_wield3d_despawn`

Like `register_on_wield3d_despawn`, ran when the wield3d entity is despawned after this item was previously wielded.




# Wielded Light (module `wieldlight.lua`)

Registers 14 nodes (from 1 to 14) named `tph_wielditem:light_(1-14)`. Light does checks every 20 seconds - if its position `hash` (`core.hash_node_position(pos)`) does not correlate to an active player's name - it deletes itself to prevent clutter.

Each light node has the following groups: `not_in_creative_inventory`, `internal_light`, `tph_wielditem_light`


## Events

`register_on_wield_alit`

Ran when a position (only if air) is lit up with a wielded light source.

Provides `pos`, `node`, `item definition`, `playerdata`

Example function parameters: `function(pos, node, itemdef, pdata)`

`register_on_wieldlight_unlit`

Ran when a position of light is removed by an internal function

Provides `pos`, `playerdata`

Example function parameters: `function(pos, pdata)`


## Item Callbacks

`itemdef.tph_wielditem_wieldlight_alit`

Item callback equivalent to `register_on_wield_alit` (provides same parameters). Ran for the selected item.

`itemdef.tph_wielditem_wieldlight_unlit`

Item callback near-equivalent to `register_on_wield_unlit` - except with an additional 4th parameter. Ran for the formerly selected item.

Provides `pos`, `playerdata`, `item definition`

Example function parameters: `function(pos, pdata, itemdef)`

