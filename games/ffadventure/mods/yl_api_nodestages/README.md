
# yl_api_nodestages

## Purpose

This mod is a library which brings various nodestage-related functions.

## Download

Get it from https://gitea.your-land.de/your-land/yl_api_nodestages

## Installation

1. Copy the "yl_api_nodestages" folder to your mod directory.
2. Enable the mod in your world.mt file.

## Configuration

```
yl_api_nodestages.debug = false
```
Set to true to enable debug mode

```
yl_api_nodestages.run_lbm = true
```

Set to true to enable the timer restart lbm, set to false to disable it

## Usage

This mod can be used in singleplayer and multiplayer. It comes with no direct content but exposes functions you can use in your mod.

### Data structure

One stage consists of at least the stage_name, next_stages and duration. 

```lua
local stage = {
    {
        stage_name = "modname:nodename", -- required, string, nodename to attach this stage to, must not exist previously
        next_stages = "modname:same_or_other_nodename", -- required, string or table (see below), if missing last stage is assumed
        --    OR 
        next_stages = { -- required if not last stage, table format
            {
                "modname:same_or_other_nodename", -- required, string, target nodename must exist
                50,  -- optional, number, chance for the node to switch to this target, defaults to 1
                { can_set = mymod.optional_can_set_function, more_functions = ... }, -- optional, table, callback table of known keys and function values
                { param1 = 90, param2 = 107, ... } -- optional, table, metadata table of known keys and whatever values they want
            },
            { "modname:same_or_other_nodename"}, -- as above, but without any optional fields
            { "other_modname:their_nodename"} -- as above, but targets a node from different mod
        },
        duration = 120, -- required, number, fixed duration of stage in seconds, if missing last stage is assumed
        tiles = {"modname_nodename_texturename.png", ... }, -- required, table, table of tiles
        description = "Node description", -- required, string, node description
        -- Optional "Node definition" aka "Used by minetest.register_node"
        node_definition = {
            drawtype = "normal",
            ...
        },
        overwrite = false, -- optional, boolean, false breaks during registration if the node has on_timer or on_construct. true overwrites regardless
        restart = true, -- optional, boolean, true restarts the nodetimer via lbm, false does not
        _previous = {}, -- DO NOT USE, this holds the history to be accessed by delete_stage only
        _version = 1, -- DO NOT USE, this holds the version of the datastructure, will increase when datastructure changes
    }
}
```

A list of `{stage}` sit in a table `stages`:

```lua
local stages = {
    {stage},
    {stage},
    ...
}
```

### Modmakers

Use the following public functions related to nodestages.

```lua
yl_api_nodestages.get_stage(modname, nodename)
```

Gets a table with the values of the stage attached to the given `modname:nodename`. Returns `true, {stage}` or `false, errormessage` if an error occurred.

```lua
yl_api_nodestages.create_stagenode(stage)
```

Creates the node without attaching the stage. Returns `true` if the node was successfully created. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.add_stage(stage)
```

Attaches a stage to an existing node. Returns `true` if the stage was successfully attached. Only successful if the stage does not yet exist. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.overwrite_stage(stage)
```

Attaches a stage to an existing node. Returns `true` if the stage was successfully attached, regardless whether the stage already exist. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.rollback_stage(modname, nodename)
```

Rolls a stage of an existing node back to the stage before the last overwrite. Returns `true` if the stage was successfully rolled back. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.delete_stage(modname, nodename)
```

Deletes the stage (including cached previous stages) from an existing node. Returns `true` if the stage was successfully removed. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.register_stage(stage)
```

Registers a single `stage`, calls create_stage and add_stage. Returns `true` if the stage was successfully registered. Returns `false, "errormessage"` if not.

```lua
yl_api_nodestages.register_stages(stages)
```

Registers all given `stages`, calls create_stage and add_stage. Returns `true, good, bad, total, {}` if all stages were registered successfully. Returns `false, good, bad, total, {reasons}` if at least one stage was not successfully registered.

```lua
yl_api_nodestages.validate_all_stages()
```

Validates all stages currently attached to any node. Returns `true, good, bad, total, {}` if all stages were validated successfully. Returns `false, good, bad, total, {reasons}` if at least one stage was not successfully validated.

## Limitations

* No randomized duration except by registering the same stage as a next_stage again
* Core nodes cannot have stages, examples are `air` and `ignore`
* Unclear: About 1 Million active stages may cause `Server::ActiveObjectMgr::addActiveObjectRaw(): no free id available`

## Alternatives

* Implement nodetimers, ABMs or LBMs

## Supported versions

If you use yl_api_nodestages, but something is wrong, please [file a bug](https://gitea.your-land.de/your-land/yl_api_nodestages/issues/new). PRs also welcome.

There is no reason to believe it doesn't work anywhere, but you never know.

## Allied projects

* [yl_canned_food](https://gitea.your-land.de/your-land/yl_canned_food/)

## Uninstall

Remove it from your mod folder or deactivate it in your world.mt

Mods that depend on it will cease to work, if the mod is removed without proper replacement.

## License

See [LICENSE.md](https://gitea.your-land.de/your-land/yl_api_nodestages/src/LICENSE.md)

* Code MIT Developername
* Screenshot CC0 Styxcolor

## Thank you

* Original canned_food author: https://github.com/h-v-smacker
* AspireMint
* Styxcolor