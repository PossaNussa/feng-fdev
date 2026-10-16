# sapling_autoplant

Saplings plant themselves instead of lying around as items. A chopped tree
reseeds the ground it stood on, and a sapling that would land where one already
stands shifts to the nearest free patch of soil.

Works with every tree mod in the game — `dtrees` (dynamic_trees), `moretrees`,
`aotearoa`, `Variety`, `naturalbiomes`, `default` and the rest — without a
per-mod support table.

## The rule

Anything that would put a sapling item into the world plants it instead:

- leaf decay after a tree is chopped
- a sapling whose ground was removed under it (`attached_node`)
- digging leaves with a full inventory
- mob drops, `tree_felling` / `falling_item` drops
- saplings thrown by hand, once they have landed

**The one exception:** a sapling a player breaks goes to that player. Punch a
sapling and it lands in your inventory as normal; if your inventory is full it
drops at your feet where you can pick it up, rather than replanting itself out
of reach.

## How it decides where to plant

The drop position is usually up inside a canopy, so the search looks straight
down for the first soil or sand it can root in, passing through leaves, trunks,
grass and snow on the way. It will not plant in water, under a roof, inside
protection, or within `spacing` nodes of another sapling — the last one is what
makes a blocked sapling shift sideways instead of stacking.

If no spot works within the search radius the sapling drops as an item, so
nothing is ever lost.

## Settings

See `settingtypes.txt`. The two worth tuning:

- `sapling_autoplant_spacing` (2) — gap kept clear around each sapling. Raise it
  if forests come out too crowded.
- `sapling_autoplant_radius` (5) — how far sideways to look for free ground.
  Must stay larger than the spacing, or a blocked sapling has nowhere to go.

## For other mods

```lua
-- treat a node as a sapling (or never): for saplings not named "sapling"
sapling_autoplant.set_sapling("mymod:weird_seed", true)

-- plant up to `count` saplings at or near pos, returns how many went in
sapling_autoplant.plant(pos, "default:sapling", 1)

-- run something with autoplanting switched off
sapling_autoplant.without_planting(my_function, arg1, arg2)
```

A node is detected as a sapling when it is in `group:sapling` *and* its name
contains `sapling`, `seedling`, `sprout` or `shoot`. The group alone is not
enough: a few mods tag ground cover with `sapling = 1` (`awuuwa_biomes` does for
its grasses and flowers), and those have to keep dropping as items.

## Implementation note

Everything hooks `core.add_item`, which every source of ground drops funnels
through, including `drop_attached_node` in `builtin/game/falling.lua`. Thrown
saplings are the exception: `core.item_drop` only clears the thrown stack from
the inventory once the item entity exists, so planting from inside `add_item`
there would plant the sapling *and* leave a copy in the inventory. Those are
planted from the entity a moment after it lands.
