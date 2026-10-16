# village_life

Gives mg_villages inhabitants a day.

## The problem this solves

mg_villages computes an enormous amount about its villages and then never reads
it back. For every plot it knows which mob sleeps in which bed, that mob's name,
gender, age, generation and profession, which plot it *works* at, which
workplace marker inside that plot is its station, and — from the schematic
analysis done at registration — a precomputed path from the front door to both
the bed and the workstation.

None of that reached the villagers. `spawn_one_mob` dropped the
(village, plot, bed) triple on the floor and returned a random string, so the
mob had no idea who it was. Behaviour came from mobs redo's default FSM, which
is "walk in a random direction for a few seconds, repeat". The results were the
three complaints this mod exists to fix:

- **Workstations for people who don't exist.** Partly nobody ever walked to
  them, partly the population only ever went down: villagers are spawned once,
  from the mapgen callback, so anything that died was gone for the life of the
  world.
- **Villagers wander off and get killed.** The random walk is unanchored, and
  `peaceful = true` with no `runaway_from` meant no reaction to a monster at
  all.
- **Everyone has the same stale trades.** `lottmobs.add_goods()` walked
  `race.items[1..15]` *in order*, so a profession's shelf was always the same
  first fifteen entries, in the same slots, in every village.

## Structure

| file | what it owns |
|---|---|
| `lua/util.lua` | deterministic RNG, geometry, per-entity scratch space, the shared pathfinder budget |
| `lua/threats.lua` | what counts as hostile, the one-scan-per-player sweep, the village alarm bus |
| `lua/home.lua` | turning (village, plot, bed) into world positions and stored paths; the roster; spawning and adoption |
| `lua/kin.lua` | who is married to, parent of, or lodging with whom — read off the bed ordering, never stored |
| `lua/navigate.lua` | the waypoint follower, doors, stuck handling |
| `lua/schedule.lua` | what a villager should be doing right now — decisions only, no movement |
| `lua/rest.lua` | getting into and out of a bed, and healing |
| `lua/brain.lua` | `do_custom` for villagers: carries out the schedule, work emotes, roles |
| `lua/defence.lua` | guards, soldiers and buff pigmen: patrol routes, alarm response, the leash |
| `lua/census.lua` | replacing villagers who died |
| `lua/economy.lua` | goods pools and per-villager stock |
| `lua/market.lua` | village speciality, seasons, demand |
| `lua/trade_ui.lua` | the shop window |
| `lua/reputation.lua` | how each player stands with each village |
| `lua/persona.lua` | who a villager is beyond their job, derived not stored |
| `lua/memory.lua` | what one villager remembers of one player, and their mood — stored, because it happened |
| `lua/events.lua` | the record of what happened, and who had line of sight to it |
| `lua/gossip.lua` | news passing between villagers, degrading as it goes; notoriety leaving the valley |
| `lua/crime.lua` | noticing theft from containers when somebody is watching |
| `lua/faith.lua` | the pantheon's domains, each village's patron, and faith earned by deeds |
| `lua/traits.lua` | what a villager does with their evenings, and making it true |
| `lua/regard.lua` | what one villager thinks of another — derived, never stored |
| `lua/land.lua` | the country the village stands in, surveyed once and cached |
| `lua/banter.lua` | small talk, jokes, and the player's own tone |
| `lua/hire.lua` | who will come with you, what it takes, and who never will |
| `lua/companion.lua` | somebody who has taken service: orders, wages, weariness — and settling into a player's town |
| `lua/settlement.lua` | a player founds their own town from a written deed and moves people in |
| `lua/remains.lua` | the body, and what is in it |
| `lua/succession.lua` | death that sticks, mourning, and who takes up the trade |
| `lua/dialogue.lua` | the conversation, and what each player has learned |
| `lua/commands.lua` | `/village_life` |

Two files outside this mod are edited, and both only to expose what they
already had:

- `zombies4test/lumberjackzombie/init.lua` gains a public faith API
  (`deities`, `get_faith`, `add_faith`, `register_deity`, `bless_wielded`). Its
  pantheon and per-player counts were file-local, so nothing could name a god or
  grant faith for anything but typing the name in chat.
- `magma_conduits/volcanoes.lua` exports `get_volcano`, which was a file-local
  that only `/findvolcano` and the `named_waypoints` HUD could reach. It already
  returns the cone's generated name, its peak and whether it is active — so
  with one line a villager living on its flank can say which mountain that is
  and whether it is awake.

Behaviour is unchanged in both.

Nothing in mg_villages, lottmobs, creaturemob or bones is edited. Villager spawning
goes through mg_villages' documented `spawn_one_mob` hook (its own
lottmobs-based implementation is left in place as the fallback if this mod is
removed), and behaviour is attached by writing `do_custom`, `do_punch`,
`on_die` and `on_rightclick` onto the already-registered entity prototypes.
`core.register_entity` sets `prototype.__index = prototype` and uses it as the
instances' metatable, so a late write reaches mobs that are already walking
around — including ones loaded out of mapblocks saved before this mod existed.

## The day

Priority order, first match wins:

1. **danger** — a hostile within 16 nodes, or an alarm raised within 28
2. **weather** — severe precipitation and no roof overhead
3. **night** — bed
4. **work** — the assigned workplace marker, with a midday break
5. **leisure** — loiter, anchored to the village centre or the home plot

Danger is deliberately measured from the *villager*, not from the village. A
guard is the exception: the whole village is its beat, so it answers the alarm
wherever in the village it was raised.

Every villager gets a stable ±45 minute offset on the hour boundaries, derived
from its identity, so a village does not empty and refill like a shift change.

Roles beyond mg_villages' own titles: it only titles the household's worker, so
wives, children, grandparents, inn guests and chateau servants all had no title
and behaved identically. `home.role()` fills that in from `generation` and
`gender`, and children and elders keep shorter hours than their parents.

### Sleep, and getting better

Villagers lie down in the bed they were assigned rather than standing beside it
all night. It is done the way `beds/functions.lua` does it to a player: the
body centred between the two halves of the bed, `+0.07` clear of the tallest
mattress nodebox, turned along the bed's facedir, playing the `lay` frames
(162–166) of `character.b3d`. That is the same mesh the player wears, so a
villager in a bed looks like a player in a bed. mobs redo picks animations out
of `self.animation` by name, so `rest.lua` writes `lay_start`/`lay_end` onto
the prototype on `mods_loaded` — with `lay_speed = 0`, because the five frames
are one pose and not a loop.

Getting in is a short teleport onto the mattress, so it is refused beyond
`BED_REACH` (3 nodes): a villager who never got into their room must not sleep
in it through the wall. A bed that has been dug out, or a plot the player
rebuilt, leaves them standing quietly beside where it was — which is all they
ever did before. Getting *out* happens in `apply_goal`, before anything tries
to walk them anywhere, and morning, a raid and a storm all arrive that way.
They are not moved off the mattress on waking: bed nodes are walkable and only
ankle high, so the morning's first path starts from somewhere a mob can stand,
whereas teleporting them to the bedside risks putting them through a wall in a
room laid out more tightly than we assume.

Injuries close over: `HEAL_UP` (1) every `HEAL_TICK` (10s) on their feet,
`HEAL_ABED` (3) asleep in their own bed, and nothing at all until `HURT_CALM`
(20s) after the last blow — so a villager being worn down in a fight cannot
heal through it. Environmental damage deliberately does not reset that timer:
somebody standing in a fire should be losing the race, not waiting out a
cooldown. Without this, one bad night left a village permanently one bite from
being wiped out, because nothing in the game healed a mob that was not a tamed
pet being fed.

The healing tick is also where `self.prop` is refreshed. creaturemob refreshes
it once a second, but it does so *after* `do_custom` — and the brain returns
`false` from `do_custom` on every step, so for a villager that refresh never
runs. `hp_max` would then read as whatever the entity activated with, and
`check_for_death` would clamp a guard promoted to 40 by `apply_role` straight
back down to 25 the first time anything hit them.

### Weather

`climate_api` computes weather presets **per player**, not per position —
`get_weather_presets(player)` has no positional equivalent. That is not a
limitation here, because a mob only steps at all inside a player's active block
range, so "the weather the nearest player is standing in" is the weather at the
villager. Only heavy precipitation clears the streets; ordinary rain and snow
make villagers grumble and keep working, and make the ones with no job go
inside.

### Movement

Mobs redo's own navigation is either a random walk or "chase this entity", with
pathfinding bolted onto the attack state via a temporary entity the mob attacks.
Neither can express "walk to that doorway, then along that corridor, and stop on
that tile", so `navigate.lua` is a plain waypoint follower.

Routes come from **`creaturemob.navigate`**, not from `core.find_path`. The
engine pathfinder solves for a *point* and runs the whole search inside one
step, so it had to be rationed — and a rationed blocking pathfinder means most
of a village gets no route at all and falls back to steering straight at the
goal, which is walking into walls. The shared service is time-sliced (so it can
be asked every step), knows how wide the mob is, string-pulls the staircase out
of the result, and caches routes the whole village reuses. On top of that the
follower probes the width of the body ahead every 0.4s and sidesteps via
`do_smart_path` when something is in the way.

It writes only yaw and forward speed, which is exactly the interface
creaturemob's motion controller expects — `set_velocity` records intent and the
controller re-derives the vector from the live yaw every step — so it inherits
the anti-rubberbanding work for free. See `creaturemob/README.md`.

Indoor destinations are walked in two stages: the engine pathfinder out to the
spot in front of the front door, then mg_villages' stored interior path. The
engine pathfinder is not reliable at threading a 0.7-wide collisionbox through a
doorway and up a staircase, and mg_villages already solved that on the schematic
when the building was registered.

### Doors

Villagers open what is in their way and shut it behind them once they are clear
of it — not the instant they step through, which either does nothing or closes
the door in the face of whoever is following.

Two kinds are handled, and more can be added with
`village_life.register_openable(name, {open = fn, close = fn})`:

- **`doors` mod doors** keep a real open/closed state in node meta, so this is
  just `doors.get(pos):open(nil)`. The nil clicker skips the protection check,
  which is correct: a villager owns its own front door and mg_villages'
  protection has no concept of a mob.
- **`cottages` half doors** have no state to read at all — opening rotates
  `param2` by a quarter turn and both states share one node name. What *can* be
  read is the orientation: the slab fills one face of its cell, so the axis it
  blocks is the node's facedir axis. "Is this in my way" is therefore decided
  geometrically, against the direction the villager is walking, and the
  remembered heading is what lets it be shut again afterwards.

`cottages` gates are name-based (`gate_closed`/`gate_open`) and need none of
that.

#### Why they used to run at walls, and leave every door open

Both complaints were one fact: **a closed door is a `walkable` node**, and
creaturemob's `world.is_blocked` treats anything walkable as impassable. So A*
*could not find a route into a house whose door was shut* — ever. It returned
"failed", `build_path` threw the path away, and `nav.tick` fell back to its
last resort of steering in a straight line at a bed on the far side of a wall.

The door-opening code could not rescue it, because it is gated on being within
`DOOR_REACH` of a **waypoint**, and a villager with no path has no waypoints.
The only thing that ever opened a front door was the stuck handler, after two
and a half seconds of grinding — and it discarded what it opened, so nothing
was ever recorded as needing shutting again. Hence doors left standing open all
night.

The two-stage approach that exists to avoid all this never fired, for two
independent reasons. The test was `dist(pos, goal.pos) > 15`, which had it
exactly backwards — it took the careful route only from a distance and sent
everyone already near their own house (every `shelter` and `indoors` goal, and
everyone whose leisure anchor is their own plot) straight at a bed through a
wall. And `approach_pos` returned `get_entrance_list()[1]`, which is the **door
node itself**, so `navigate.snap` could resolve the "outdoor" leg to a standable
tile on either side of it.

What it does now:

- the outdoor leg aims at **`home.path_in(...)[1]`** — the first waypoint of
  mg_villages' stored path, which is by construction a standable tile in the
  street, because mg_villages worked it out on the schematic;
- which stage to start on is decided by **where the villager is standing**
  (`util.inside_plot`), not by how far off the destination is. That test is
  deliberately ungenerous: a villager on their own doorstep must read as
  *outside*, or the bug goes straight back;
- the stored path is then handed to nav as a **`route`** and walked as written,
  with the pathfinder never asked about that leg at all. It is not an
  optimisation — it is the only thing that works. A route is abandoned only if
  the villager is plainly off it, and what remains of it becomes an `interior`
  suffix so A* need only solve the reconnection;
- the door is opened at the hand-over and **recorded**, as is anything the stuck
  handler opens;
- `close_door` is a **queue**, not one slot: a villager who goes through a front
  door and then a bedroom door used to lose the first record and leave the front
  door open;
- `close_door_near` takes a heading. Without one, `swing_blocks` answers
  "blocked" for an unknown direction and the close branch never fires — so it
  could never shut a `cottages:half_door` at all, which is most of the doors in
  a village;
- and an indoor goal only counts as reached **from inside the building**. The
  distance test alone counted a villager standing outside the wall, 1.5 nodes
  from their own bed on the other side of it, as having gone to bed: the goal
  completed, the door was never opened, and "go indoors" silently did nothing.

`do_custom` returns `false` whenever the brain is driving, which makes `on_step`
skip `do_states()`, `general_attack()`, `follow_flop()` and the rest. That is
deliberate and total — the random-walk state is the thing being replaced. The
exceptions are documented in the code: defenders hand the step back once they
are actually in combat, and an unbound pigman (spawn egg, no village) is left
entirely to mobs redo.

## Defence

`guard`, `soldier` and castle-bed villagers get combat stats applied per
instance (they are the same entity as the baker, so this cannot be declared in a
mob definition), a patrol route sampled from the village's road plots, and a
leash: 40 nodes from the village centre they break off, with an eight-second
cooldown so they do not re-acquire the same monster and oscillate on the
boundary.

`zombies:buffpig` was already a competent bodyguard — `attack_monsters`, and a
`group_attack` list that includes the villagers. Its problem was that it had no
idea where the village was. It now binds to whichever village it is standing in
on its first step (persisted on the entity, so it still knows after unloading),
walks the same patrol routes, answers the alarm and comes home. **Its ambient
spawn rule in `zombies-master/init.lua` is untouched.**

Threat classification is a registry plus predicates, in this order:

1. explicit `village_life.register_threat(name, hostile)` entries
2. mobs redo `type == "monster"`, or anything with `attack_npcs`
3. mobkit carnivores that have added the villager to their own `targets` list
4. a curated list of paleotest's larger carnivores

and finally, anything that actually damages a villager or a buff pigman is
registered as a threat on the spot. That is how the mod copes with mob mods it
has never heard of.

Sensing is one `get_objects_inside_radius` per **player** per second, bucketed
by village. The naive shape — every villager scanning its own radius — is 150
overlapping scans a second in a large village.

A hostile only raises a village alarm if it is inside the village radius **and**
within ten nodes of the village's build height. Both bounds are load-bearing:
without the height check, the caves under a village keep it on permanent alert,
because in this game there is always something down there.

## Talking to people

Right-clicking a villager opens a conversation, not a shop. Trading is one
thing you can ask for, once you are on terms where they will show you.

The point is that a village is **learned** rather than displayed. Someone you
have never spoken to is *Stranger* and stays that way until you ask their name;
the village has no name until somebody tells you; you find out what the place is
short of by asking a person who lives there. Everything the debug command used
to print is in here, said by somebody, and gated behind their willingness to say
it. Village-level facts are learned once for the whole settlement — the second
person to tell you where you are is not telling you anything — while names and
personal details are per villager.

### Nobody is the same person

Derived axes, from the identity mg_villages already assigned, stored nowhere, so
a villager is the same person after a restart or in a backup:

- **temperament** (gruff, warm, shy, proud, weary, sly, earnest, dreamy) — drives
  how they open, hedge and refuse. Written out per temperament rather than
  assembled from fragments, because generated small talk reads like generated
  small talk.
- **worry**, **opinion** — what keeps them up, and one fixed view about the
  village. Two villagers who disagree about the same thing is most of what makes
  a place feel inhabited.
- **openness** — how hard they are to get anything personal out of, so the same
  standing gets you further with some people than others.

And stored axes, because they are records of things that happened rather than
functions of a seed (`memory.lua`): their **mood**, which drifts back towards a
baseline set by their temperament, and their **opinion of you personally**.

### Refusing to talk says why

A villager running for their door names what they are running from —
"Not now. There's a dire wolf loose." — per temperament, like every other line
they have. It used to be one shared "Not now! Get inside!", which told a player
nothing about a village they had just walked into and could not see the far
side of; the thing itself is the useful half of the sentence.

What they may name is bounded by what they know. If they can see it, they name
it. If they are only running because a neighbour shouted, they name whatever
the alarm reported — `threats.raise` carries the entity name of what was seen,
and being told is a thing you may repeat. If nobody said what it was, they say
so vaguely rather than inventing a species (`persona.alarms_vague`). A player
the village has written off is named outright: being run from by name is the
point of being an enemy of the village.

`threats.describe` turns an entity name into something speakable, with its
article: it prefers the mob's own `description`, but mobs redo defaults that
field to the entity name, so a description with a colon in it counts as the mod
having said nothing and the name is cleaned up instead
(`mobs_monster:dungeon_master` → "a dungeon master"). Anything that reads badly
with an automatic article — a swarm, a proper name, a plural — wants
`village_life.register_threat_label`, whose value is spoken exactly as written.

### Questions run out. Conversation does not.

The conversation has two levels, and the split is the difference between a
*fact* and a *conversation*.

A question is a fact to be extracted: their name, their trade, what troubles
them. `dialogue.learn` files it and the topic closes for good, which is right —
and which is why a villager used to be exhausted in about ninety seconds and
stay exhausted.

A **menu** is a way to keep talking, and never runs out. There are four:

| menu | what is in it |
|---|---|
| *Let me ask you about someone.* | everyone in their household, at their workplace, and in the houses nearby |
| *Tell me about this country.* | the biome, the lie of the land, the water, the volcano, the next settlement, what is out past the fields |
| *Never mind that. Let's just talk.* | the weather, the wind, the season, the hour, their mood, a joke — and things the **player** says |
| *I've a proposition for you.* | asking them to come with you; once they have, their orders |

Menus are ranked among themselves and allocated their own slots. Thrown into
one pool with the questions they would lose every slot for as long as any
introduction was left unasked, so the deep half of the conversation would be
unreachable until the shallow half had been used up — precisely backwards for
somebody who wants to talk for an hour.

### The topic list is ranked, not fixed

Every topic carries a weight. Eleven options are offered — five questions, up
to four menus, and the two pinned actions — and what gets cut is what matters
least, not whatever happens to be declared last. Something that actually
happened outranks anything a villager merely thinks, so a fresh murder leads;
small talk sits below the civic questions on purpose, because "what does the
village need?" is how a player finds out what a place is for.

Entries inside a menu are built fresh for each repaint and have no registered
id — they are named by their position in the list that was actually drawn, and
a click resolves against **that** list. A menu of people can lose somebody
between the painting and the clicking, and answering about whoever shuffled up
into that slot instead is worse than doing nothing at all.

Repeatable topics (what the village needs, what it sells, how you stand) drop to
a low weight once used and come back into view when there is nothing newer.
They used to write knowledge flags that nothing read back, which kept them at
full weight forever and permanently squatted three of the five slots.

The window is sized to the list rather than the list to the window. It was a
fixed `size[11,8.6]` with buttons stepping 0.68 from y=3.9, so the eighth
button started at y=9.26 — drawn past the bottom edge, where it could be
neither read nor scrolled to. Because `options_for` appends the pinned topics
last, what fell off was always "Show me your wares" and "Goodbye": the two the
player most needs. Past `VISIBLE_ROWS` (8) the list scrolls inside a
`scroll_container` instead of growing, and the scroll position is carried
across repaints so answering a question found at the bottom of a long list does
not throw the player back to the top of it. The container declares a content
padding (the sixth parameter), which is what makes the engine derive the
scrollbar's range from the buttons themselves — nothing here has to be kept in
step with the number of topics.

### Only what is true

**A villager never states as fact something the world does not model.** This is
the rule the whole conversation is built to keep, and `traits.lua` is where it
is enforced. Every pastime belongs to one of three classes:

- **simulated** — there is really an `x_farming:bee_hive` on their plot, with
  bees in it, ticking. They walk out to it on a `hobby` goal, and the honey is
  on their shelf. Stated as fact, because it is one.
- **conditional** — true only if the world supports it. Nobody fishes a river
  that is not there; the check runs against the actual map before the trait is
  ever handed out.
- **behaviour** — private conduct nothing could confirm or deny (singing badly,
  re-reading the same three books). The only ones that stay pure text, and that
  is honest.

Anything that could not be realised falls back to an **aspiration**, phrased as
a wish: *"I'd keep bees, if I had the room."* Chop the hive down and they go
back to wishing.

### What they think of each other

`kin.lua` had worked out who is married to whom, who works alongside whom and
who lives two doors down since the day it was written, and nothing ever read it
back — so the one question everybody actually wants to ask in a village, *"what
do you make of him, then?"*, had no answer.

Nothing about a regard is stored. It is a pure function of the two identities,
their relationship and their two characters, all of which are themselves
derived. That buys three things:

- the smith thinks the same of the baker after a restart, in a backup, and on
  somebody else's server;
- it can be computed for people who are **not loaded**, because
  `persona.for_identity` works off the key alone — which is what lets somebody
  have a view of the man across the village without that man being spawned;
- and asking A about B, then B about A, gives two different answers, because
  the seed is the *ordered* pair. Mutual dislike is a special case, not the
  default, and the asymmetry is free.

On top of the seed: family sits warmer at the floor without losing any of the
spread, so an unhappy marriage is perfectly possible and merely unusual;
working alongside somebody warms them; and being the **second** person in one
village with the same trade is a rivalry, because there is one forge and one set
of customers and mg_villages will happily title two people "smith". Temperaments
clash by a table that is deliberately not symmetric — the shy find the gruff
frightening while the gruff barely notice the shy.

Every specific detail in the answer is read from the same rows the subject
themselves would answer from: their trade, their age, their hobby, the one fixed
opinion they will bore you with. Ask them yourself and they say the same thing.
At friend or ally they will also let slip the subject's real **worry**, which is
true, which means you can go and do something about it — and `hire.lua` pays for
having done so.

Being told about somebody is being introduced to them: their name is filed
against *their* key, so gossiping your way round a village learns you more names
than knocking on every door does. The dead are not gossiped about but mourned,
read off the same bed rows `succession.lua` writes — and asked about somebody
you killed, they say so.

### The country they live in

Villagers could not see out of their own front door. Somebody living on the
flank of a named volcano had nothing to say about it.

The rule is the one from `traits.lua`: **a topic exists only if the thing it is
about exists.** No volcano, no volcano question. The survey is per village, not
per villager, cached, and built the first time anybody is asked:

| fact | where it comes from |
|---|---|
| biome, and what its climate means in words | `core.get_biome_data` / `get_biome_name`, `get_heat`, `get_humidity` |
| the lie of the land — plain, valley, hills, bluff | a ring of surface probes around the village |
| water, and which way | `find_node_near` for `group:water` |
| **the volcano** | `magma_conduits.get_volcano` — its own generated name, its own active/dormant/extinct state |
| the next settlements, by name and bearing | `mg_villages.all_villages`, whose keys are `"vx:vz"` |
| what is out past the fields | `sighting` events with real witnesses |

Bearings are compass words and distances are walking time, because nobody says
"eight hundred and twelve nodes". A cone more than 900 nodes off is not
mentioned at all: magma_conduits' regions are thousands of nodes across, and
without that bound every village in one would be talking about a mountain
nobody there has ever seen. If the ring of probes comes back unreadable — the
mapblocks are not loaded — the survey is **not cached**, so the next person
asked gives a real answer rather than that one forever.

Who knows what is gated too. A hunter, lumberjack or shepherd has walked the
country and will give you a bearing to the next village; a baker knows the
weather and what everyone knows. Nobody gives directions to a player the village
distrusts.

`sighting` was a dead branch: `events.KINDS` declared it and `gossip.phrase`
knew how to say it, and nothing ever raised one. A village alarm is precisely
somebody having seen something, so that is where they come from now — on a
*fresh* alarm only, because one monster pacing the treeline for a minute is one
thing that happened, not twenty.

### Small talk, and saying the wrong thing

The half of the conversation with nothing to extract, and so the half that never
runs out. Remarks are grounded in what is actually happening — the weather
falling on them right now, the season the world is in, the hour, their own mood,
what the village is short of this week — and they are **walked** rather than
sampled, so eight consecutive asks are eight different remarks. Drawing
independently means repeats about one ask in five, and small talk that repeats
itself is the complaint the whole thing exists to answer.

Jokes are written per temperament, like the greetings and for the same reason.
Where one is at somebody's expense the name is a real neighbour, drawn from the
people that villager actually knows — and specifically one they are not fond of,
because a joke is a cheaper way of saying what you think than saying it.

This is also the only place the **player** says something rather than asking
something. Five tones, each a bet on who you are talking to:

- flattery works on the proud and insults the earnest — the same words, opposite
  outcomes;
- needling amuses the sly and wounds the shy;
- boasting is the one the world can call your bluff on: it works only if the
  village has actually seen you do something;
- *"nobody would miss you"* is a fair point to a lodger and an unforgivable
  thing to say to a man with three children in the house, and the check for that
  is the family, not a dice roll.

Outcomes land in `memory.DEEDS` as `amused` and `offended` — the same book every
other kindness and injury in this mod is written in, so being good company is
worth about what a small gift is worth. Both are capped per day, or standing
becomes a function of how many times somebody clicked the same button.

### Taking somebody with you

lottmobs has a hireable-follower path. It is unreachable from an mg_villages
villager, and it could not be reused if it were: `lottmobs.guard` takes payment
and then **removes the entity**, handing the player a craftitem that respawns a
*nameless* guard. That would destroy the villager's identity, their bed row,
their family, their memory of you, their mood and everything they have heard —
which is to say everything this mod is. (It also parks its callback in a global,
so with two players hiring at once the last click wins.) Nothing here goes near
it.

So the villager stays the villager. All that changes is where they are standing.

**A refusal is never a dead end without a reason.** Every "no" says which "no" it
is. Some are arithmetic and will move if you come back better: the village is on
alert, they are asleep, they are the last guard on the gate. Some never will:
they are a child, they are too old, you killed one of their family, the village
has written you off. Being told which is the difference between a system and a
slot machine.

What moves them is one legible sum, and the window shows it in words:

what the village makes of you · what *they* make of you personally · what sort
of year they have been having · their openness and temperament · whether you
have bothered to learn their name and ask what troubles them · **whether you
went and did something about it** · the children they would be leaving · whether
they are a lodger with nothing holding them · and what you have put on the
table.

Payment is priced through `economy.value_of`, so a coin is worth what the
counter says it is, and it is deliberately **not** linear: the first purse says
you are serious, the tenth says nothing new. Without that, hiring is a wallet
check and every other term in the sum is decoration.

Persuasion is a conversation. Three arguments, each offered only when it is true
of this person — there is no "appeal to their trade" for somebody with no trade,
and *"I've seen to what was troubling you"* is only offered if they really told
you and only lands if you really did it. The persuasion lives in the
conversation's scratch memory, so walking away loses it: nobody should be able
to grind somebody down over a week of two-line visits.

### Being a companion

They keep their name, their family, their memory of you, their mood, their
opinions of their neighbours, and their worry. Everything that reads a villager
still reads them.

- **Their bed is marked `away`** in the row that is the authority on who lives
  where, exactly as a death is. Without it `census.audit` sees a bed that is
  `first_name and not dead and not occupied` and refills it — so walking your
  new companion out of the village hands the village a second, identical copy of
  them. `home.adopt` refuses those beds for the mirror-image reason.
- **The schedule hands over entirely.** `companion.goal` is consulted above
  everything, including danger, because somebody who has taken service is not
  living this village's day: they do not go to the forge at nine and — the part
  that matters — they do not bolt for their own front door when something
  growls, because their own front door is half a valley behind them.
- **Orders** are follow, wait, and go home, as dialogue topics rather than a
  second window.
- **Mood is the morale bar**, and there is no second one. It already drifts back
  towards a baseline set by their temperament, already decides whether they will
  confide in you, and already colours every line they speak — so a tired, unpaid
  companion is audibly a tired, unpaid companion without a word of it being
  written twice. Nights out, storms with no roof, being badly hurt and being owed
  money all push it down; being paid and being rested push it up.
- **Wages** fall due each in-game day. Two days unpaid, or worn down far enough,
  and they say so and walk home — and the village hears about it, which is how
  word gets round that you do not pay.
- **Dying in your service** costs you with their village, heavily if you did it
  yourself, and `succession` takes the bed as it would for any other death. The
  `away` mark is cleared first, because a row carrying both marks is a row the
  census cannot read.

### Founding your own town

`settlement.lua`. A player can start their own settlement and pull people into
it — not as mercenaries, but as residents who live there.

The whole feature rests on one observation: **everything in this mod reads the
village data mg_villages keeps, and never asks how the village came to exist.**
The census fills any bed with a `first_name`; `home.resolve` turns a
`(village, plot, bed)` triple into a home and a place to sleep; sleep, hire and
lodging all key off the same rows. So a player's town is not a new system. It is
a *synthetic mg_villages village* — a record injected into
`mg_villages.all_villages` with a centre, a radius and a `to_add_data.bpos` list
the player builds up by hand. Once it is there the census spawns and keeps its
residents, the schedule walks them home to bed, and the hire machinery works on
them, all unchanged. It persists exactly like every other village, through
`mg_villages.save_data()` and the world's `mg_all_villages.data`, so there is no
storage of our own.

The tools are a written book and the player's own hands:

- **The deed** is any `default:book_written` whose first line is `Town Deed` and
  which carries a `Name:` line. It is recognised by content, not made a new item.
  The town is *not* stored on the book — the book only authorises the gesture and
  names the place — because saving a book rewrites its whole meta and would orphan
  the town. A town is tracked by its founder and where it stands.
- **Punch the ground** with the deed to found a town centred there (refused on
  ground that already belongs to a mapgen village). It drops a foundation stone —
  right-click it for the town overview; only the founder can dig it, and digging
  it unmakes the town. **One name, one town:** if you already have a settlement by
  that name standing elsewhere, punching fresh ground does not quietly start a
  second copy of it — that was almost always a misfire. Move a town by digging its
  foundation stone first. A world that founded duplicate same-name towns before
  this guard existed is cleaned up once at load (`settlement.dedup_towns`): for each
  `(founder, name)` collision the copy with the most **named** residents is kept and
  the empty ones dissolved — a town with a settled resident is never removed, only
  the "just me" copies, so it can never eat real data.
- **Punch a bed** to say who sleeps in it: keep it vacant for a newcomer, label
  it your own home (a roster note, no respawn change — this game disables bed
  respawn), mark it a public/spare bed, or settle someone currently walking with
  you into it. Beds within a few nodes of each other are taken to be one
  household, so a house with three beds is three residents of one house without
  the player having to declare the walls.
- **Punch a door** for a read-out of who lives in that house, and a toggle to
  mark it a public space. Beds are the unit that matters — sleep is per bed — so
  the door is a convenience, nothing more.

**Moving in.** "Come and live in my town" is the same persuasion as hiring — the
same arguments, the same coin, the same running total shown in words — but the
offer is a home rather than a wage, so it opens with a pull a mercenary contract
does not have, gated on the player actually having a bed set aside. It ends not
in service but in a choice of how they travel:

- **On foot.** They take service as a companion (`companion.engage`) and walk at
  your side; when you get home you settle them into a vacant bed
  (`companion.settle`) — the *same body*, keeping their memory of you and their
  opinions, now bound to the town bed with their old bed left behind for good.
- **Themselves.** They leave now: their identity is written onto a reserved town
  bed with an `arrive_day` a day to three off, their origin bed is blanked (they
  have moved away — the house simply loses a resident), and the body despawns.
  The census brings them in by their new bed once the day comes — a fresh villager
  wearing their name, which is the honest cost of a teleport. Two guards make this
  safe: `census.audit` and `home.adopt` both refuse an `arrive_day` bed exactly as
  they refuse an `away` one, so nobody is spawned early and no stray claims the
  reserved name.

Nothing here edits mg_villages or the beds mod. The deed hooks the written book's
`on_use` (which overrides digging and is handed what was punched); the rest is
new bed-row marks — `vacant`, `arrive_day`, `player_owner`, `public` — on rows
mg_villages already serialises.

### Recruiting the wandering traders

`wanderer.lua`. The world spawns four peaceful lottmobs traders on the same
creaturemob framework as the pigman villager — `lottmobs:dwarf_trader`,
`lottmobs:mung_trader`, `lottmobs:human_trader`, `lottmobs:elf_trader`. They used
to be shops on legs, nothing more. Now you can talk to one, convince it to join
your town, and settle it beside a bed like anyone else.

They are **bedless recruits**, the same shape the passing adventurers are:
`home.resolve` returns nil for a loose trader, so the bedless hire/follow paths
already built for adventurers carry them without change. `wanderer.is(self)` is
true for any recruitable species (the four traders, plus the wandering guards
below) that has not settled yet;
`village_life.is_bedless_recruit(self)` is the union of that and `_adventurer`,
and it is what the shared sites test — `home.adopt` (so a trader never claims a
random village bed), `companion.engage`, and `hire.refusal`/`inclination` (so a
trader is hireable and amenable, defaulting to a wayfarer's leaning since it has
no adventurer subtype). Adventurer *flavour* — pirate crews, world tales,
subtypes, the pigman career skins — stays gated on the narrow `_adventurer`, so a
dwarf never talks like a pirate or gets repainted as a pig.

Two things had to be taught the difference between a pigman and a dwarf:

- **The right-click.** Each trader ships its own native lottmobs shop on
  `on_rightclick`. Dialogue takes the click over (talk first), capturing that
  closure into `wanderer.SPECIES[name].native_trade`; a **"Show me your wares"**
  option reopens the very window the plain click used to. The pigman's own
  village_life trade UI is untouched and stays pigman-only — a settled trader
  trades through the ordinary village shop like any resident.
- **The respawn.** The census revives a bed's occupant through `home.spawn`,
  which was hard-wired to `lottmobs.spawn_pigman_trader`. A recruited trader who
  *makes their own way* (despawn now, turn up by the reserved bed in a day or
  three) would have arrived **as a pigman**. So the bed row now carries
  `species`, written by both arrival paths (`settlement.take_resident` for travel,
  `companion.settle` for follow-on-foot), and `home.spawn` branches on it:
  `minetest.add_entity(pos, species)` for a trader, keeping the mob's own
  textures. `apply_role`'s career-skin block is guarded to the pigman for the same
  reason. `clear_bed` wipes `species` (and any lent kit) when a bed is vacated, so
  a re-used bed never revives the next occupant as the last one's mob.

The follow-on-foot path never respawns anything — the *same body* rebinds via
`home.bind`, so a dwarf who walks home with you is still a dwarf, trivially. The
species field only matters for the teleport half.

**They settle as a trade, not as "trader".** Until now every recruited wanderer
took the flat placeholder title `trader` its species carried, so a mung talked
into a town became a shopkeeper whether or not it ever kept a shop. That is not
what these folk are. `wanderer.ensure_role(self)` rolls a town role *once*, the
first time it matters (either settle path calls it before reading
`self.profession`), and stamps it on the entity, where both arrival paths already
copy it onto the bed row — so the role rides a settle and every later respawn, and
the mung you walk up to is already a hunter when you convince it, not a
shopkeeper. The roll is weighted per race, from `wanderer.ROLE_POOLS`:

- **Mung traders** are warlike but keep to what a mung behind a counter would be:
  a **hunter** who took up selling, or a plain **trader** — never a barbarian.
  Their pool is `mung_trader`.
- **Dwarves** lean to the forge and the quarry — **blacksmith**, **stonemason**,
  **carpenter** — with a guard or a shopkeeper among them.
- **Humans** spread across the ordinary village trades (farmer, baker, carpenter,
  butcher, innkeeper, shopkeeper) with a guard or hunter now and then.
- **Elves** keep to growing and glasswork (farmer, glassmaker, shopkeeper, dyer).

These are the same profession titles a home-grown villager can hold: `home.role`
maps the fighting roles (hunter/barbarian) to **guard** and arms them, and the
trade titles to **worker** — who will spend their day at a workstation if you give
them one (below). Redeemed beastmen, trolls and champions pick their own role in
`redeem.lua`; `ensure_role` skips any species `redeem` owns and never overwrites a
role already set.

**Guards are people too.** lottmobs spawns armed guards of every one of those
races (`lottmobs:mung_guard`, `lottmobs:nune_guard`, and the `lottmobs:elf*` /
`lottmobs:dwarf*` warriors from `elves.lua`/`dwarves.lua`). They shipped only
lottmobs' hire-for-a-gem right-click — the one-liner a player saw on click — and
no path into a town, because they were never in `wanderer.SPECIES`. They are now,
flagged `guard = true` and with their lottmobs race tag (`GAMEman`/`GAMEelf`/
`GAMEdwarf`) mapped to the canonical `human`/`elf`/`dwarf` the pools key on. A
guard is a peaceful npc that already fights monsters, so it recruits exactly like
a trader — no calming step — and rolls its race's **full** trade spread, the same
as a home-grown villager: a **mung guard** takes the warlike `mung` pool (hunter,
barbarian, the odd watchman or trader), the others their race's ordinary trades.
Two differences from a trader, both flagged on the species entry:

- Their native right-click is a **mercenary hire**, not a shop, so dialogue drops
  it rather than capturing it as `native_trade` — there is no "Show me your wares"
  for a guard, and recruiting it into a town replaces the old hire outright.
- They greet and introduce themselves in a **watchman's voice** (`GUARD_GREETINGS`
  / `GUARD_INTRODUCE` / `GUARD_WHY_SETTLE`), not a pedlar's, so a mung guard no
  longer offers to sell you what the towns can't make.

`mung_guard` uses the mung mesh (`mobs_mc_villager.b3d`), so like the mung trader
it shows no held weapon or worn armour; the elf/dwarf/nune guards use
`lottarmor_character.b3d` and show their gear like any villager.

For a player town the resident spawns **right beside their bed**: a hand-built
`player_house` plot has no schematic, no entrance list and no front-of-house path,
so `home.spawn_pos` now goes straight to `find_standing_near` of the bed for a
player town rather than through the village heuristics (which resolved a
player_house only to the plot corner, and only by luck).

### Arming your townsfolk

The equipment machinery hired companions use — hand them a blade or a piece of
armour, it lifts their damage and hit points — now works on your own **settled
residents** too. A hired follower keeps their kit on the hire record; a
townsperson keeps it on their **bed row**, which mg_villages serialises, so it
survives a restart and a respawn. `companion.gearstore(self)` is the one chokepoint
that picks the right store (hire record if in service, else the bed row), and
`equip`/`return_gear`/`gear` all read it.

**A whole set, not one piece.** The store holds one **weapon** and a **set of
armour** — a helm *and* a breastplate *and* greaves *and* boots, one per body
slot, read from 3d_armor's own `armor_head`/`armor_torso`/… groups. Handing over a
second helm displaces the first helm, not the boots; each worn piece adds its own
hide, summed. (Worlds saved before the set existed stored a single armour string;
`companion.armor_names` migrates that shape on read, so no separate migration pass
is needed.) Their hit points are the base plus the whole suit; `return_gear` hands
back the lot.

**They actually use it now.** Arming a plain townsperson used to do nothing,
because `apply_role` pacified everyone who was not already a guard — the sword sat
in the store unused. Now a resident **handed a weapon becomes town militia**
(`village_life.arm(self, "militia")`): a light combat tier that folds in the blade
and any armour, so they stand watch and wade into a fight of their own accord — a
baker with a blade, not a trained guard. Given only armour, they stay peaceful but
wear it (the hit points, anchored to the prototype's own `hp_max` so re-applying it
every reload never stacks), and still rouse harder when struck. Fighting roles
(hunter/barbarian) and guards fold their kit into their heavier tier as before.

**You can see it.** The weapon shows as a small `wielditem` entity attached to the
`Arm_Right` bone — the same trick tph_wielditem plays for the player — on every
mesh that carries that bone: the pigman villager (`character.b3d`), the settled
dwarf/human/elf traders (`lottarmor_character.b3d`), and the beastmen (built on
`zombie_normal.b3d` / `Zombielion.b3d`, both verified to have it). The gate is a
strict mesh allowlist, because attaching to a bone a mesh *lacks* would hang the
weapon at the mob's feet — so the mung (`mobs_mc_villager.b3d`), the trolls
(`troll_model.x`), and anything on `creatures_mob.x` (whose bone is
`Armature_Arm_Right`) carry their kit in their stats, not their hands. The ObjectRef
lives in a runtime table keyed by the entity (never on `self`, which creaturemob
serialises to disk), is rebuilt from the stored weapon on every reload, and removes
itself if its owner dies or unloads and it is left hanging.

**Worn armour** is drawn the way a player wears theirs: `companion.update_worn`
composites 3d_armor's own on-body textures (`def.texture` / the item name, exactly
as `armor:set_player_armor` derives them) over the mob's skin. This works on every
mesh that shares the `character.b3d` UV the armour textures were cut for — the
pigman villagers, the settled traders, **and the beastmen**, which are built on the
same humanoid model and take the same skins, so the armour lands right on them.
Only the mung and trolls, on their own skeletons, wear their armour in their stats
rather than on their skin. The clean skin is read fresh each time and the composite
is never written back into `base_texture`, so re-applying it every reload never
doubles the armour on.

**The kit window.** You dress a townsperson through a **"Let me sort your gear"**
dialogue option (gated by `settlement.founder_of`, so only in a town you founded)
that opens an **inventory grid** — a weapon slot, six armour slots
(head/torso/legs/feet/hands/shield, the hands slot taking 3d_armor's gauntlets and
gloves), and your own pack below — and you drag gear straight onto them, exactly
like a chest or an armour stand. Give one piece or a whole suit,
take a piece back, in any order. Each slot only accepts its own kind (no stacking
three helmets), enforced by the detached inventory's `allow_put`/`allow_move`
callbacks. The grid is a per-player detached inventory that is only ever a live view
of the villager's real store (bed row or hire record, which holds item names and is
the persistent truth); every drag calls `companion.kit_sync` to read the grid back
into the store and re-assert stats and visuals at once. A **"give it all back"**
option remains for a one-click strip.

### Workstations for player-town residents

A mapgen village builds its workstations into its schematics as invisible markers
a mob stands on; `home.resolve` turns `bed.works_at`/`bed.workplace` into a world
position, and the schedule walks the worker there. A player town has no
schematics, so a settled worker (a recruited dwarf smith, say) had nowhere to
spend their day and simply loitered. Now the founder plants workstations by hand.

- **Punch the ground** with the deed (the town overview) lists every resident and
  whether they have a workstation — *"Trader Throg has no workstation!"* — with a
  button that hands you a `village_life:workstation` node.
- **Place it** wherever the work should happen, then **punch it with the deed** (or
  right-click it holding the deed) to open a short menu of the town's residents;
  pick one and the station is theirs. Punch it again to reassign or clear it.

The assignment is a plain world position on the bed row: `bed.work_pos` and
`bed.work_facing` (the node's `param2`). `home.resolve` takes it as `r.work_pos`
when the schematic path found nothing, flags it `work_hand_placed`, and
`schedule.goal_work` treats a hand-placed station as an **open-air** destination
the pathfinder walks straight to — not an indoor one that needs threading through a
front door it hasn't got. The node stamps the bed it serves into its own meta, so
digging it releases that worker (and only if the bed still points at that tile, so
reassigning to a new node never has the old one strip the job when dug). Assigning
under a living resident calls `home.reresolve` to drop their cached resolution, so
the workstation takes effect on their next think rather than at the next reload.
`clear_bed` wipes the station with its occupant, so a re-used bed never inherits a
job at a node that no longer names it.

### Redeeming monsters

`redeem.lua`. The zombies mod ships sentient beastmen — lionmen, cheetahmen,
frog-folk, gnolls — as ordinary hostile monsters. This lets you turn one into a
person, and then into a townsman.

**Yell it down.** Shout a calming word near a raging beastman — `wait`, `stop`,
`easy`, `peace`, `friend` — and the louder you call it (ALL-CAPS, and `!`), the
better the odds. It reads loudness off proxchat's own rule (a mostly-capitals line
carries twice as far; each `!` adds), so `STOP!!` is far likelier than `stop`. On
a hit (base 15%, scaled by loudness) the beast **stands down and idles for 30
seconds** — it clears its target, stops, and refuses to re-acquire you. redeem
registers its own `register_on_chat_message` handler that never consumes the
message, so the same shout still reaches proxchat and chat.

**Talk it round.** Right-click the beast while it idles and a **calm menu** opens
(dialogue.lua) — structurally the settle menu's twin, a running persuasion of
appeals and a bribe against a bar, but it starts far below zero (fear and
bloodlust, scaled by how fierce the creature is) so it is genuinely hard. A loud
yell gives a small head start. Win it and `redeem.calm` flips the creature to a
peaceful `npc`: it loses monster status **for good**, is given a name, and takes a
town role. A raging beast will not open the calm menu at all — right-clicking one
just tells you it is in no state to talk.

**Then it is a wanderer.** A calmed beast is a bedless recruit exactly like a
trader (see above): it wanders, you can talk to it to gain standing, and you can
recruit it into your town — on foot or travelling in — where it is revived as its
own species beside its bed. Its town role is one of three, weighted, assigned when
it calms and kept as its profession so it survives the move:

- **Hunter** (much the most common) — fights animals and monsters for the town.
- **Barbarian** — a heavier fighter.
- **Monster** (rare) — a fearsome town guard the other residents are a little
  wary of (it says as much when you ask its trade), but loyal.

All three route through the guard step and are armed at their own combat tier
(`brain.lua` `DEFENDER_TIERS`), so a redeemed lionman is worth the trouble it took
to tame. It dies like any villager — bones, and its bed released to the ordinary
refill — and it is made **persistent** so a calmed one is never lost to a despawn.

**Betrayal.** Strike a calmed beast that has not yet settled and it turns on you
again (`redeem.revert`); kill one in front of calmed kin and their trust breaks
too. A *settled* one is a resident: it defends itself through the ordinary rouse
and never relapses on the town it belongs to.

**Trolls** (`lottmobs:troll`, `battle_troll`) are already peaceful npc guards, so
they skip the calming entirely and recruit directly, like a trader — redeem still
owns their wiring so their native `do_custom_guard` is chained, not clobbered.
Master switch: `village_life_redeem` (default true) gates the yell trigger and the
calm menu.

**Trolls flee the sun.** A troll takes 60 damage a tick in daylight and, left to
the native AI, walks into it and dies. `redeem.flee_sun` (called at the top of the
troll's `do_custom`, ahead of everything — its schedule, its guard duty, its
native AI) checks `get_node_light` and, when it is lit, runs the troll to the
darkest reachable spot nearby. So a wild or recruited troll keeps to shade and
indoors by day and is out and about by night, as a troll should be — and if there
is genuinely no cover, it still burns.

**Champions.** `zombies:buffpig` — the big pigman a village calls its champion —
is already peaceful to players, so it too recruits directly. Right-clicking one
now opens the full recruit conversation (its gruff voice survives as the champion
race's lines in `wanderer.lua`); `defence.buffpig_step` hands a settled or hired
champion to the villager brain instead of the village patrol, and `defence`'s
punch/death handlers give a settled one the ordinary villager reactions (it rouses
to defend, and leaves a body that frees its bed). A recruited champion settles as
a `champion`-role guard armed at its own tier — the one combat tier that *raises*
hit points (to 250) rather than settling them, so arming a buff pigman never nerfs
it.

**Persistence.** The pigman villagers, all four wandering traders, the trolls and
the buff pigmen are all marked `persistent`, so none of them despawns when its
block unloads far from a player — a villager the census counts on, or a companion
you calmed and recruited, is still there when you come back. (They are a bounded,
non-breeding set, so this stays clear of the mapblock object cap.)

### News, and where it comes from

Villagers only know what they saw or were told. `events.lua` records what
happens and sweeps for witnesses with line of sight; `gossip.lua` passes it
between villagers standing near each other on idle goals. Each retelling loses a
detail and gains an attribution, so a fourth-hand rumour is recognisably a
rumour — which is what lets you go and find out whether it is true.

### Religion

Every village keeps a patron, chosen deterministically from its id but weighted
by what the village actually is, so a village with a forge usually keeps the god
of the forge. Priests preach, name their god's one tenet, know how often you
have invoked it, and will bless water for you in person. The pantheon and its
domains live in `faith.lua` and are **written to be rewritten** — the code
depends on the shape of those entries, never on the words.

### Standing changes the conversation

Seven bands, read straight off the reputation ladder: **ally, friend,
acquaintance, neutral, critic, unwelcome, enemy**. An enemy will not speak to
you — one line, no window. The unwelcome will talk but will not trade. A critic
will not discuss what the village needs. A friend volunteers extra and will tell
you their worries; an ally is greeted by name.

## Reputation

Three tiers, all the same mechanism at different ranges.

**The person.** What one villager saw and remembers, in `memory.lua`. Bounded to
±40 and added on top of the village's verdict, so the woman whose life you saved
is warmer than her neighbours and the man you robbed is colder — in the same
village, on the same day — without either of them outvoting the village.

**The village.** A number per (player, village), −100 to +100.

**The world.** Notoriety, fed only by gossip that travels. It is not a third
opinion sitting alongside the others: it is the mark a village that has never
met you *starts* from, at 45% weight. Your name arrives before you do, and then
you are judged on your own conduct.

### One ladder

`rep.tiers` is the only ladder. It carries the band name, the colour, and flags
for `favoured` / `shun` / `hostile` / `silent`, and every consumer asks it.
There are deliberately no `SHUN` / `HOSTILE` / `FAVOURED` constants any more:
three loose numbers beside a tier table is how the ladders drifted apart in the
first place, and the symptom was a "Show me your wares" button offered by a shop
that would then refuse to open. The dialogue bands used to be a second,
disagreeing set of cut-points; they are gone too.

| moves it | by |
|---|---|
| completing a trade | +1, capped at +6 per in-game day |
| selling them what they are short of | +2 (same cap) |
| killing a hostile inside the village | +3 |
| striking a villager | −10, rate-limited to once every 2s |
| killing a guard or buff pigman | −25 |
| killing a villager | −50 |

What it changes: prices (up to 25% off, up to a third on), what they pay you
for your goods, the greeting, whether the shopkeeper shows you the small
**reserve** of rare stock kept under the counter (at +40), whether anyone will
trade with you at all (below −45), and whether the guards and buff pigmen treat
you as a target (below −75). Below −75 ordinary villagers also flee from you
exactly as they flee from a monster — the one place standing becomes physical
rather than numeric.

The violence values are tuned against those thresholds, because the thresholds
are what the player actually experiences: one murder closes the shops, a second
turns the village against you; a guard costs less, so it takes two to be
refused service and three to be hunted.

Standing drifts back towards indifference — grudges at 1 point per in-game day,
goodwill at 0.35. Villages forgive a bad first impression faster than they
remember a good one, so a reputation worth having needs maintaining and a
village is always recoverable. `/village_life rep` shows where you stand;
`/village_life talk` shows what the villagers around you personally think of
you and what news they are carrying.

### Crime

Taking things out of a container is an offence **only if a villager with line of
sight watched you do it**. Nothing is protected and nothing is blocked; an empty
street costs nothing. That is the only version of this worth playing around, and
it is what makes a guard patrol mean something. Cost scales with what was taken
and how many saw, capped at four witnesses.

**Corpses are always exempt**, by node name and by pattern. Burying the dead
means digging that node, so a village that read its own funerals as theft would
be unplayable.

**Your own town is exempt for you.** The founder of a player-settled town owns its
ground and its stores, so taking from a chest there is never theft and sleeping in
any of its beds is never trespass — the same `is_player_town and founder == pname`
guard sits at the top of both `crime.on_take` and `lodging.on_sleep`. Another
player doing the same in your town still answers for it.

## Death

A killed villager stays dead. The death is written into the bed row in
`mg_all_villages.data` — that row is the authority on who lives where, and
everything else derives from it, so marking it is what makes the death real to
the census, to kin, to the market and to anyone who asks.

They leave a body: a public `bones:bones` node with their name on it, holding
what they were carrying — their trade's tools, a day's takings, something off
their own shelf, whatever their hobby makes. Owner is deliberately blank, which
`is_owner` (`bones/init.lua:11`) reads as public, so anyone may open it and
anyone may dig it. No edit to the `bones` mod was needed.

Then the household mourns, the village mourns lightly, the workstation stands
empty and the trade goes out of the market. After a few days a child of the
house who is old enough comes up into it, keeping their own name and character
and inheriting the title. Failing that, after much longer, an incomer arrives —
and the previous occupant's memories, gossip and traits are cleared first,
because the identity key is the bed and a stranger must not inherit them.

Two things had to be stopped from quietly undoing this: the census now skips
dead beds instead of refilling them after four minutes, and `home.adopt` will
not put a stray pigman into a dead person's name.

## Economy

A shop's *catalogue* — which wares it keeps — is a sample from a much larger
pool, drawn with a generator seeded on the villager's identity alone. A merchant
therefore sells the same goods day to day, which is both more believable than a
shelf that reshuffles overnight and what lets a depleted shelf be tracked ware by
ware (below). Identity is `village/plot/bed`, stable across restarts, so the
smith in Testholm is recognisably the same shop tomorrow and is not the smith in
the next valley. Only the prices drift, with the day, the season and demand.

**Stock is finite and refills slowly.** Each ware has a full-shelf maximum; the
live count is depleted by purchases and kept on the shop's **bed row**, so it
survives the villager unloading and the change of day (the bed rows sit in
mg_villages' persistent village table, not the scratch table, and reach disk
through mg_villages' own save; a shutdown flush covers a server restart). A
merchant refills each ware by about a third of its full shelf per in-game day, so
buying someone out means a thin shelf for a few days rather than a full one by
morning — the fix for "he has infinite apples". Demand still moves the *price* on
top of that; the two are independent.

Three things move a price off its base, multiplicatively, clamped to
0.45×–2.6× together:

- **speciality** — every village is good at one trade and short of another,
  derived from its id. Nothing is stored; the same village always has the same
  character. Speciality goods are 25% cheaper and stocked deeper; scarce goods
  are 45% dearer and thinner on the shelf.
- **season** — from the `seasons` mod. Fresh food is cheap at harvest and dear
  in February, seed is cheap in spring, wool and coal are dear in winter, and
  some goods (berries, melons) simply are not for sale out of season.
- **demand** — buying moves the price, up to +90%, decaying by half per in-game
  day. Persisted in mod storage; village character is derived and is not.
- **the land** — fresh produce (fruit, veg, berries, grain) stocks thin where
  the ground cannot grow it: a cold, a parched-desert or a waterlogged-swamp
  village keeps few apples, whatever else it is known for, because what fresh
  food there is has been carried in. Read once off the biome at the village
  centre (`market.climate`, heat/humidity — the same axes as the biome grid) and
  cached. This only touches shelf depth, not price.

Villagers also *buy*, at half price, and pay noticeably more (0.72×) for
whatever their village is short of and less (0.35×) for what it already has
plenty of. That is the one place the speciality system pays the player rather
than charging them.

Valuing only what somebody's shelf happens to stock was far too narrow: nobody
sells leather, hides, raw meat or feathers, so a player back from a hunt found
there was nobody to sell to — exactly backwards, since those are things a
village wants. Worth is now taken from pool prices where they exist, an explicit
table for the obvious gaps, and item-group heuristics underneath that. **Who** you
sell to matters too: a smith pays properly for metal and hides and offers scrap
for a sack of wheat.

Goods pools name items from a dozen optional mods; anything not registered is
pruned once at load rather than handed to `ItemStack` on every shop opening.

### The counter

A detached inventory is global and outlives the window, so anything the
customer leaves in it has to be given back deliberately. `payment` and
`selling` hold the player's own property and are returned — on **Clear**, on
closing the window, on disconnect, when a second customer opens the same
trader, and when the trader dies before its inventory is destroyed. If the
owner has gone offline it is dropped at the shop rather than deleted.
`selection`, `price`, `takeaway` and `sellprice` are shop stock or previews of
an uncompleted trade and are simply cleared; handing those over would be
handing out free goods.

Shift-click routing is set by the `listring` order. The client quick-moves to
whatever list follows the clicked one, locating it by its **first** occurrence
(`guiFormSpecMenu::getNextInventoryRing`), so repeating `current_player;main`
gives every shop slot the player's inventory as its destination without
changing where the player's own inventory sends things:

```
goods     -> selection     selection -> goods      main -> selling
selling, payment, takeaway, sellprice -> main
```

A list in no ring at all cannot be shift-clicked. Note also that a move between
two *different* inventories is gated by `allow_take` on the source, not by
`allow_move` — `allow_move` only governs moves within one inventory.

### Known limitation

Depletion is kept on the bed row and reaches disk only through mg_villages' save,
which happens on various village events and at shutdown rather than on every
purchase — so a hard crash (not a clean stop) can lose the last few minutes of a
shelf being sold down. Within a session, and across a clean restart, a
cleaned-out merchant stays cleaned out.

## Migration

Worlds that already have villages are handled by **adoption**: a pigman trader
with no `vl` identity, standing in a village, claims a vacant bed — preferring
one whose recorded occupant shares its name, which is usually its own. Without
that, old villagers would keep the random walk *and* the census would read their
beds as empty and spawn a second copy of everybody.

## Two traps in mg_villages worth knowing about

Both of these cost a round of debugging and neither is obvious from the code:

- **`all_villages` is written after the mob spawn hook.** In
  `mapgen.lua`, the loop that calls `part_of_village_spawned` runs at ~1074 and
  `mg_villages.all_villages[village_id] = ...` at ~1101. During the chunk that
  first creates a village, every lookup through `all_villages` returns nil.
  Anything hooking `spawn_one_mob` must use the `bed` and `bpos` arguments it is
  handed — which is exactly what mg_villages' own implementation did — or the
  village generates empty. Correspondingly, nothing may cache a failed lookup
  permanently, because the data appears moments later.
- **The stored village is a deep copy.** `all_villages[id]` is set from
  `deserialize(serialize(village))`, so the `bpos`/`bed` tables passed to the
  hook are not the same objects that end up in the table. Fine for reads;
  do not expect a write through one to be visible in the other.

## Testing

Per the project's standing rule, this was not tested by booting a server.

```
cd games/ffadventure/mods/village_life
luajit test/harness.lua
```

The harness stubs the engine and the mods this one sits on, loads `init.lua`,
and asserts the public surface exists plus the behaviour that is pure enough to
check offline: identity hashing, bed and cross-plot workplace resolution,
interior path lookup, every branch of the schedule, adoption, stock determinism
and variety, seasonal availability and pricing, demand decay, the reputation
ladder's internal consistency, personal memory and its bounds, the family
structure, gossip propagation and its degradation, faith and patron selection,
trait realisation, death with succession, where a sleeper lies in a bed and how
fast they heal there, what a fleeing villager is allowed to name and how it is
spoken, the determinism and asymmetry of what one villager thinks of another,
that the country questions are **absent** when the thing they are about is not
there, that persuasion is monotonic in standing and in payment while the hard
refusals are unmovable at any price, the wage-to-quitting state machine, the
founding of a player town and the bed clustering, bed dedication, a resident
resolving with no schematic data, the travel-in reservation and its census
gating by arrival day, and settling a companion by foot — and the geometry of
the conversation window: every button it emits, at every level of every menu,
has to land inside the window it declares. It also catches Lua 5.3-only syntax,
which LuaJIT would reject at load in the real game.

Regression tests are written so that reverting their fix makes them fail, and
were checked that way. The ones worth naming: the unemployed villager's job
line; the frozen conversation when a villager falls asleep mid-sentence; the
conversation window, which against the old fixed `size[11,8.6]` reports the live
topic list overflowing it by 0.66 — the two buttons the player could not reach;
and five for getting indoors, of which the sharpest is simply *"the villager has
a path while the pathfinder can find none"*. That one is nil against the old
code, and nil is the wall-grinding.

Everything involving actual movement — pathing through a real doorway, whether
a villager fits up a particular staircase, how a patrol looks, whether a
companion keeps up — needs a running server and a player watching. The harness
can prove a route exists; it cannot prove a 0.7-wide body fits up the stairs at
the end of it. The same goes for anything depending on real node placement:
whether a hive ends up somewhere sensible on a real plot is not something the
stub map can answer, and nor is whether the mountain a villager names is the one
you can see from the square.

## Commands

```
/village_life status     population, economy, alert state, who has died, and
                         every hostile in range with its height above the
                         village floor
/village_life rep        where you stand with the nearest village, and anywhere
                         else you have made an impression. In play, ask a
                         villager instead -- "What do people here make of me?"
/village_life talk       what the villagers around you personally think of you,
                         what mood they are in, what news they are carrying and
                         how many times it has been retold, and what your name
                         is worth in the world at large
/village_life goals      what the villagers around you are actually doing, and
                         how many have no village identity or failed to resolve
/village_life census     fill every vacant bed in the loaded part of the
                         village, now                        (server priv)
/village_life restock    clear nearby traders' shelves        (server priv)
/village_life threats    what the classifier currently believes is hostile
/village_life calm       clear a stuck alarm by hand
```

`status` and `goals` are the two to reach for. A village where everyone is
standing indoors will show its alarm as `RAISED`, and `status` lists what
raised it; if the culprit is forty nodes below the village floor, that is a
classifier problem, and `village_life.register_threat("name", false)` will
excuse it.

## Repairing a village generated before the fixes

Villages that generated while the mapgen spawn bug was live are underpopulated
and cannot fix themselves quickly — the periodic census waits out a respawn
delay per bed. Walk the town so its mapblocks are loaded and run
`/village_life census`, which fills every vacant bed in the loaded area at once.
Repeat from the other end for a large village.

## Tuning

All settings are in `settingtypes.txt`. The three worth knowing about:

- `creaturemob_path_budget_us` (default 1500) is the pathfinding allowance per
  server step, shared by **every mob in the world**, in microseconds. Searches
  are time-sliced and resume next step, so lowering it makes mobs slower to
  work out a route rather than worse at following one.
- `village_life_respawn_delay` (default 240s) is how long a bed stays empty
  before the census replaces its occupant. The census also refuses to spawn
  while the village is on alert or a hostile is within 20 nodes — replacing the
  baker into the jaws of the thing that ate the last one is worse than an empty
  bakery.
- `village_life_hiring` (default on) is the whole companion system. With it off
  nobody can be recruited, the proposition is never offered, and no bed is ever
  marked `away`.

## Extending

```lua
-- Anything a villager might have taken up. `class` decides what they may claim:
-- "simulated" builds it and states it as fact, "conditional" is checked against
-- the map first, "behaviour" is private conduct nothing could verify.
village_life.traits.defs[#... + 1] = {id = ..., class = ..., fact = ..., wish = ...}

-- Another thing to say when there is nothing to extract. Return nil when the
-- world has given you nothing to say about -- that is the normal case.
village_life.banter.tones[#... + 1] = {id = ..., label = ..., lands = fn, good = {}, bad = {}}

-- Another argument for taking somebody with you. `gate` is when it may be
-- offered at all; `lands` is whether it works on this person. Both must be
-- about something real, or it is a button that means "roll again".
village_life.hire.arguments[#... + 1] = {id = ..., label = ..., gate = fn, lands = fn, weight = n}
```

```lua
village_life.register_threat("mymod:horror")           -- or (name, false) to clear
village_life.register_threat_predicate(function(ent, villager_name) ... end)
village_life.register_threat_label("mymod:horror", "the horror")  -- spoken as written
village_life.schedule.register_shelter_weather("mymod:acid_rain", false)
village_life.economy.pools.smith[#... + 1] = {item, count, price, rarity, tags}
```
