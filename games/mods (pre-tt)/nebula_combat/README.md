# Nebula Combat

A combat customizer for [Luanti](https://www.luanti.org/), intended for competitive servers.

Features:

- Customize knockback
- Modify how far away players can be hit from
- Change the attack interval (constant rate or multiplier)
- Apply a damage multiplier

## Optional Dependencies

You can optionally affect the knockback based on if the attacker is sprinting. The mods below can be used for sprint detection:

[Stamina](https://content.luanti.org/packages/sofar/stamina/)  
[Stamina (Fork)](https://content.luanti.org/packages/TenPlus1/stamina/)  
[Hbsprint](https://content.luanti.org/packages/texmex/hbsprint/) with [Player Monoids](https://content.luanti.org/packages/Byakuren/player_monoids/)  
[Wadsprint](https://content.luanti.org/packages/drkwv/minetest_wadsprint/)  
[Stamina++](https://content.luanti.org/packages/swagtoy/real_stamina/)  
[Sprint Lite](https://content.luanti.org/packages/mt-mods/sprint_lite/)

**IMPORTANT:** Physics multipliers may not be reliable unless one of the mods below are used. The recommended setup is to use both [Player Monoids](https://content.luanti.org/packages/Byakuren/player_monoids/) and [Player Physics API with Monoid Support](https://content.luanti.org/packages/TestificateMods/playerphysics/). The reason is that some mods, like Stamina, do not work with a speed or gravity multiplier without Player Monoids, but Player Monoids does not support changing air acceleration, while Player Physics API does.

[Player Monoids](https://content.luanti.org/packages/Byakuren/player_monoids/)\*  
[Player Physics API](https://content.luanti.org/packages/Wuzzy/playerphysics/)  
[Player Physics API with Monoid Support](https://content.luanti.org/packages/TestificateMods/playerphysics/)

**INCOMPATIBLE:** Despite using [Pova](https://content.luanti.org/packages/TenPlus1/pova/)*'s API when available, multipliers don't work at all with support enabled, and gravity and speed don't work with support disabled

\* Items marked with a star require a config change due to not supporting a change in air acceleration (not needed if you use Player Physics API)

## Developer API

```lua
nebula_combat.register_on_knockback(function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
    -- Values that are not provided, like the vertical values in this example, will be the default from the config (or what another mod gives)
    return {
        horizontal_momentum = 0.0,
        horizontal_force = 15.0,
        physics_duration = 3.0 -- How long (in seconds) to apply physics multipliers like speed, gravity, and air accel
        gravity_mult = 0.2
    }
end)
```

```lua
-- This API exists so sprint mods can add support if it isn't built-in
-- This API does not affect the player in any way, it simply marks them as sprinting for our detections
-- The id should be your mod id
nebula_combat.set_sprinting(player, sprinting, id)
```

```lua
nebula_combat.is_sprinting(player)
```
