# DynamicSounds

Adds basic sound occlusion and simple reflections to Luanti (Minetest) by adjusting per-player playback.

Features:
- Occlusion (muffling/attenuation) when sound source is behind nodes relative to listener
- Simple early reflections (echo) off nearby surfaces
- Enclosure-aware boosts: caves and closed rooms sound more enclosed and echo more
- Room-aware reverberation: estimates room size and adds an RT60-based tail for more natural decay
- Configurable strength and behavior via settings
- Non-invasive: call the API directly, or opt-in to globally wrap `minetest.sound_play`
 - Affects ambient/non-positional sounds (rain, UI, targeted player sounds) when wrapper is enabled, with cover-based muffling

## Usage

Two ways to use:

1) Call the API directly from your mod:

```lua
-- within another mod
local ds = rawget(_G, "dynamicsounds")
if ds and ds.play then
  ds.play({ name = "default_place_node_hard" }, {
    pos = {x=0,y=10,z=0},
    gain = 1.0,
    max_hear_distance = 32,
  })
else
  -- fallback
  minetest.sound_play({ name = "default_place_node_hard" }, { pos = {x=0,y=10,z=0} })
end
```

2) Wrapper (default ON): transparently process nearly all sounds, including positional sounds targeting a specific player and sounds attached to objects.

## Settings

All settings are under `dynamicsounds.*`.

- `dynamicsounds.enable_wrapper` (bool, default true): Wrap `minetest.sound_play` to apply occlusion/reflections.
- `dynamicsounds.occlusion_strength` (float, default 0.7): How strongly occlusion reduces gain (0-1).
- `dynamicsounds.raycast_step` (float nodes, default 0.5): Resolution of occlusion ray.
- `dynamicsounds.max_trace_nodes` (int, default 64): Max nodes checked when tracing to listener.
- `dynamicsounds.speed_of_sound` (float m/s, default 340): Used to time reflection delays.
- `dynamicsounds.max_reflections` (int, default 4): Number of simple echoes to spawn.
- `dynamicsounds.echo_decay` (float, default 0.65): Multiplicative gain per reflection.
- `dynamicsounds.material_muffle_factor` (key=value CSV): Per-group factor; e.g. `stone:0.9,wood:0.6,leaves:0.2,glass:0.3`.

Enclosure and Reverb:
- `dynamicsounds.enclosure_probe_steps` (int, default 6): How far to look for surrounding occluders.
- `dynamicsounds.enclosure_occlusion_boost` (float, default 0.5): Extra muffling when enclosed.
- `dynamicsounds.enclosure_reflection_boost` (float, default 1.0): Extra echo loudness inside enclosed spaces.
- `dynamicsounds.late_reverb_taps` (int, default 6): Number of late reverb tail copies.
- `dynamicsounds.late_reverb_decay` (float, default 0.7): Decay per tap.
- `dynamicsounds.late_reverb_min_ms`/`max_ms`: Time window for late reverb taps.

Room and Echo Realism:
- `dynamicsounds.room_probe_maxdist` (int, default 40): How far to probe along axes to estimate room size.
- `dynamicsounds.rt60_scale` (float, default 0.15): Scales overall reverb length; raise for longer tails.
- `dynamicsounds.reflection_absorb` (float, default 0.25): Higher absorbs more each bounce (shorter/softer).
- `dynamicsounds.reverb_tap_density` (int/sec, default 60): How dense the late tail is.
- `dynamicsounds.pitch_muffle_amount` (float, default 0.02): Reduces pitch shift so muffling isn’t “underwater”.

More controls:
- `dynamicsounds.nonpos_profile` (smart/ui/ambient, default smart): Heuristic for non-positional sounds.
- `dynamicsounds.ambient_name_patterns` (CSV): Names treated as ambient (e.g., rain, wind) when using smart profile.
- `dynamicsounds.ui_name_patterns` (CSV): Names treated as UI/feedback and kept crisp.
- `dynamicsounds.footstep_name_patterns` (CSV): Names treated as footsteps; get subtle extra room feel.
- `dynamicsounds.material_reflectivity` (CSV): Material reflectivity for reflections (e.g., stone:0.95, wool:0.15).
- `dynamicsounds.secondary_reflections` (bool): Enable secondary bounces for richer echo.
- `dynamicsounds.max_secondary_reflections` (int): Cap secondary bounces per first hit.
- `dynamicsounds.near_distance` (float): Within this distance, keep a minimum direct gain to avoid cutouts.
- `dynamicsounds.near_min_direct_gain` (float): Direct gain floor factor when near.
- `dynamicsounds.near_occlusion_relax` (0..1): When near, relax occlusion by this amount to reduce “underwater” feel.
- `dynamicsounds.near_occlusion_distance` (float): Range considered “near” for occlusion relaxation.
- `dynamicsounds.occlusion_start_offset` (float): Skip the very start of the ray to avoid self-occlusion.
- `dynamicsounds.min_reflection_delay_ms` (int): Skip too-early reflections (Haas-safe window) to prevent double hits.
- `dynamicsounds.late_reverb_predelay_ms` (int): Small delay before the late tail starts.
- `dynamicsounds.handle_ttl` (int): Auto-cleanup seconds for grouped handles; 0 disables. Long-lived looped sounds are marked persistent and not auto-cleaned.

## Tuning tips

- Make caves boom more (natural echo):
  - `dynamicsounds.enclosure_reflection_boost`: raise to 2.0–2.5
  - `dynamicsounds.echo_decay`: raise toward 0.85–0.95
  - `dynamicsounds.rt60_scale`: raise (e.g., 0.25–0.35) for longer natural decay
  - `dynamicsounds.reverb_tap_density`: raise (e.g., 90–120) for thicker tails
  - `dynamicsounds.room_probe_maxdist`: raise for very large caverns

- Make rooms feel more closed:
  - `dynamicsounds.enclosure_occlusion_boost`: raise to 1.0–1.5
  - `dynamicsounds.ambient_cover_muffle`: raise toward 0.8–0.95 for rain under roofs

Ambient and Realism:
- `dynamicsounds.process_non_positional` (bool, default true): Apply enclosure/cover effects to non-positional sounds (e.g., rain).
- `dynamicsounds.ambient_cover_muffle` (float, default 0.6): How much to reduce ambient sounds when under cover/indoors.
- `dynamicsounds.reflection_raycast` (bool, default true): Use raycasts for more realistic early reflections (slightly higher cost).

Occlusion-aware echo boosts:
- `dynamicsounds.occluded_reflection_boost` (float): Extra early-echo boost when the direct path is blocked (sound around corners).
- `dynamicsounds.occluded_min_reflection_delay_ms` (int): Allow earlier reflections when occluded, for a more immediate wrap-around feel.
- `dynamicsounds.occluded_diffuse_spill` (bool): Adds a couple short, quiet diffuse taps near the ear when heavily occluded indoors.
- `dynamicsounds.occluded_direct_gain_floor` (float): Keeps a subtle direct presence even when blocked.
- `dynamicsounds.reverb_tail_min_gain` (float): Ensures the late tail has some presence when occluded.

Outdoor-to-indoor control:
- `dynamicsounds.indoor_outdoor_reflection_mult` (float): Damp early reflections when the source is outdoors and the listener is indoors.
- `dynamicsounds.indoor_outdoor_skip_tail` (bool): Skip late tail for outdoor->indoor case.
- `dynamicsounds.indoor_outdoor_disable_spill` (bool): Disable diffuse spill for outdoor->indoor case.
- `dynamicsounds.indoor_outdoor_extra_occlusion` (float): Extra direct attenuation for outdoor->indoor.

## Limitations

- Luanti's sound API doesn't expose lowpass filters; "muffle" is simulated by lowering gain and slightly reducing pitch.
- Per-player sound parameters require playing separate sounds for each listener.
- Reflections are a simple heuristic, not a full reverb; tune counts/decay accordingly.

## Test

Use the chat command to try it out:

```
/ds_test default_dig_metal
```

It will play the given sound at your position with occlusion/reflections.

## Compatibility

- The wrapper returns a single numeric handle that represents a group of sub-sounds (direct + reflections + reverb). Calls to `minetest.sound_stop` and `minetest.sound_fade` work transparently on that handle.
- Designed to work with base game and MineClone; if a mod expects a numeric sound handle (most do), it will continue to work.

## License

This project is released under the MIT License. See `LICENSE` for details.
