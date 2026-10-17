-- The starter ship's layout, as data. Edit this to rearrange the ship, then
-- /regenship (or build by hand - the generator only runs once per world).
--
-- The ship runs along X (bow = +X). Five decks, each 9 nodes tall: floor
-- slab, six nodes of room, ceiling, and a one-node crawlspace above the
-- ceiling that holds the air ducts (ducts.lua).
-- A 7-wide corridor runs down the middle of every deck. The hull is cut into
-- bands along X; in each band a deck has either a North room, a South room
-- (either side may be split into several rooms) or one Full-width room.
-- Narrow "lift" bands hold the gravity lift shafts, at the same X on every
-- deck so they line up.

local S = csd_ship.S

local L = {}
csd_ship.layout = L

L.name = "CSV Meridian"
L.origin = vector.new(0, 1000, 0)  -- far from 0,0,0 so nothing else collides
L.half_width = 36                  -- hull walls at z = +-36
L.corridor = 3                     -- corridor is z = -3..3
L.deck_height = 9
L.decks = 5                        -- deck 1 is the top; deck 5 is the zoo
L.lift_width = 7

-- deck number -> floor surface y (relative to origin)
function L.floor_y(deck)
	return (L.decks - deck) * L.deck_height
end

-- Bands, aft to fore: {name, x0, x1, kind}. Lift bands hold a shaft on the
-- north side and a maintenance closet on the south side.
L.bands = {
	{"A",  -200, -161},
	{"L1", -160, -154, "lift"},
	{"B",  -153,  -90},
	{"L2",  -89,  -83, "lift"},
	{"C",   -82,  -19},
	{"L3",  -18,  -12, "lift"},
	{"D",   -11,   52},
	{"L4",   53,   59, "lift"},
	{"E",    60,  123},
	{"L5",  124,  130, "lift"},
	{"F",   131,  170},
}
L.bow = {x0 = 171, x1 = 205, decks = {1, 2}}  -- tapered bow, upper two decks
L.engines_x = {-226, -201}

-- Rooms. Each entry: band = {N = {rooms}, S = {rooms}} or band = {full = room}.
-- A room is {"Name", kind, [length]} - lengths split a side; omitted = share the rest.
-- `kind` picks the decorator in decor.lua. Optional keys: sealed = true (no
-- doorway - zoo habitats are glass on the corridor side), zoo = habitat spec
-- (see csd_zoo: biome and animals = {{entity, count}, ...}).
L.decks_rooms = {
	[1] = {
		A = {N = {{S("Comms Array"), "comms"}}, S = {{S("Officers' Quarters"), "cabins"}}},
		B = {N = {{S("Navigation"), "navigation"}}, S = {{S("Shield Control"), "shields"}}},
		C = {N = {{S("Weapons Bay"), "weapons"}}, S = {{S("Security"), "security"}}},
		D = {N = {{S("Observation Deck"), "observation"}}, S = {{S("Science Lab"), "science"}}},
		E = {N = {{S("Officers' Lounge"), "lounge"}}, S = {{S("Records Office"), "office", 24}, {S("Vacant Suite 1-E1"), "vacant", 20}, {S("Vacant Suite 1-E2"), "vacant"}}},
		F = {full = {S("Briefing Hall"), "briefing"}},
		bow = {S("Bridge"), "bridge"},
	},
	[2] = {
		A = {N = {{S("Crew Cabins (Aft)"), "cabins"}}, S = {{S("Crew Cabins (Aft)"), "cabins"}}},
		B = {N = {{S("Medbay"), "medbay"}}, S = {{S("Arrivals Lounge"), "arrivals"}}},
		C = {N = {{S("Mess Hall"), "mess"}}, S = {{S("Galley"), "galley", 32}, {S("Pantry"), "storage"}}},
		D = {N = {{S("Recreation Room"), "recreation"}}, S = {{S("Gym"), "gym", 32}, {S("Vacant Suite 2-D1"), "vacant", 16}, {S("Vacant Suite 2-D2"), "vacant"}}},
		E = {N = {{S("Crew Cabins (Fore)"), "cabins"}}, S = {{S("Crew Cabins (Fore)"), "cabins"}}},
		F = {full = {S("Holo Theatre"), "theatre"}},
		bow = {S("Forward Lounge"), "lounge"},
	},
	[3] = {
		A = {full = {S("Reactor Room"), "reactor", tall = true}},
		B = {N = {{S("Electrical"), "electrical"}}, S = {{S("Life Support"), "life_support"}}},
		C = {N = {{S("Hydroponics"), "hydroponics"}}, S = {{S("Water Reclamation"), "water"}}},
		D = {N = {{S("Cryo Bay North"), "cryo"}}, S = {{S("Cryo Bay South"), "cryo"}}},
		E = {N = {{S("Cryo Bay Fore"), "cryo"}}, S = {{S("Vacant Suite 3-E1"), "vacant", 16}, {S("Vacant Suite 3-E2"), "vacant", 16}, {S("Vacant Suite 3-E3"), "vacant", 16}, {S("Vacant Suite 3-E4"), "vacant"}}},
		F = {full = {S("Shuttle Bay"), "shuttle"}},
	},
	[4] = {
		-- A is the lower half of the two-deck Reactor Room.
		B = {N = {{S("Engine Control"), "engine_control"}}, S = {{S("Fuel Storage"), "fuel"}}},
		C = {full = {S("Cargo Bay"), "cargo"}},
		D = {N = {{S("Waste Processing"), "waste"}}, S = {{S("Machine Shop"), "workshop"}}},
		E = {N = {{S("Vacant Hold 4-E1"), "vacant", 32}, {S("Vacant Hold 4-E2"), "vacant"}}, S = {{S("Storage"), "storage"}}},
		F = {full = {S("Lower Cargo Hold"), "cargo"}},
	},
	[5] = {
		A = {N = {{S("Animal Feed Store"), "zoo_feed"}}, S = {{S("Vacant Hold 5-A"), "vacant"}}},
		B = {
			N = {{S("Big Cat Habitat"), "habitat", sealed = true, zoo = {biome = "jungle",
				animals = {{"pixel_animals:tiger", 3}}}}},
			S = {{S("Elephant Habitat"), "habitat", sealed = true, zoo = {biome = "savanna", pond = true,
				animals = {{"animalworld:elephant", 2}, {"animalworld:hippo", 1}}}}},
		},
		C = {
			N = {{S("Aviary"), "habitat", sealed = true, zoo = {biome = "forest", birds = true,
				animals = {{"animalia:song_bird", 4}, {"pixel_animals:hummingbird", 3}, {"animalworld:toucan", 2},
					{"animalworld:parrot", 2}, {"animalworld:robin", 2}, {"pixel_animals:crow", 1}, {"pixel_animals:seagull", 2}}}}},
			S = {{S("Aquarium"), "aquarium", sealed = true, zoo = {water = true,
				animals = {{"animalworld:carp", 3}, {"csd_zoo:salmon", 4}, {"animalia:tropical_fish", 5},
					{"animalworld:seahorse", 2}, {"pixel_animals:catfish", 2}, {"animalworld:stingray", 1}}}}},
		},
		D = {
			N = {{S("Petting Zoo"), "habitat", zoo = {biome = "farm", doors = true,
				animals = {{"animalia:sheep", 3}, {"animalia:chicken", 4}, {"animalia:pig", 2}, {"animalworld:hare", 2},
					{"pixel_animals:marmot", 2}, {"pixel_animals:capybara", 2}}}}},
			S = {{S("Grasslands Habitat"), "habitat", sealed = true, zoo = {biome = "savanna",
				animals = {{"animalworld:zebra", 3}, {"pixel_animals:ostrich", 2}, {"animalworld:giraffe", 1},
					{"animalworld:kangaroo", 2}, {"animalworld:monkey", 2}}}}},
		},
		E = {N = {{S("Vacant Suite 5-E1"), "vacant", 16}, {S("Vacant Suite 5-E2"), "vacant", 16}, {S("Vacant Suite 5-E3"), "vacant", 16}, {S("Vacant Suite 5-E4"), "vacant"}},
			S = {{S("Vacant Suite 5-E5"), "vacant", 16}, {S("Vacant Suite 5-E6"), "vacant", 16}, {S("Vacant Suite 5-E7"), "vacant", 16}, {S("Vacant Suite 5-E8"), "vacant"}}},
		F = {N = {{S("Vacant Suite 5-F1"), "vacant", 20}, {S("Vacant Suite 5-F2"), "vacant"}},
			S = {{S("Vacant Suite 5-F3"), "vacant", 20}, {S("Vacant Suite 5-F4"), "vacant"}}},
	},
}

-- Where new crew appear.
L.spawn_room = S("Arrivals Lounge")
