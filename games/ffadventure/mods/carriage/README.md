# Carriage Mod

This mod adds horse carriages to Minetest, complete with:
- **Standard Carriage**: Seating for 2 players.
- **Model-K Carriage**: A sturdy steel version with seating for 2 players.
- **Model-KT (Transport) Carriage**: An autonomous, no-seat transport carriage. Once attached to an animal, it automatically follows the player who placed it, staying 3-5 blocks away and syncing speeds. It features click-to-load conceptual storage capacity equivalent to 2 chests.
- Realistic movement mechanics: supports 3 speeds, steers with A/D, respects gravity, and stops at cliffs, lava, or walls. Speed limitations apply based on the attached animal: 3 speeds for horses, 2 speeds for donkeys, and 1 speed for cows.
- Attachable to horses (from `mob_horse` or `mobs_mc`), donkeys (from `mobs_mc`), cows (from `mobs_animal` or `mobs_mc`).

## Dependencies
Compatible with both Minetest Game and Mineclonia.
- **Minetest Game**: `default`, `mobs` (mobs_redo), `mob_horse`
- **Mineclonia**: `mcl_core`, `mcl_wool`, `mobs_mc`

## Usage
- Craft the desired carriage.
- Place it down and ride it! Requires a horse, donkey, or dog to be near the front to attach automatically.
- Press `W` to increase speed (speeds 1, 2, 3), and `S` to decrease speed (speeds 3, 2, 1, 0). Steer with `A` and `D`. (Controls do not apply to the autonomous Transport Carriage).

## Crafting Recipes

### Standard Carriage (AI generated graphic)
- 6x Wood (`default:wood` or `mcl_core:wood`) (arranged as 2 rows of 3).

### Carriage Model-K (Kenney Model)
- 6x Steel/Iron Ingot (`default:steel_ingot` or `mcl_core:iron_ingot`) (arranged as 2 rows of 3).

### Carriage Model-KT (Transport) (Kenney Transport)
- **Top Row:** 3x White Wool (`wool:white` or `mcl_wool:white`)
- **Middle Row:** 3x Steel/Iron Ingot (`default:steel_ingot` or `mcl_core:iron_ingot`)

## License
CC-BY-SA 4.0 by ronrob-lu
