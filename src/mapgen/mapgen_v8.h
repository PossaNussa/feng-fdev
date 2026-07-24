// Luanti - Mapgen v8 (first-class, stability-hardened)
// SPDX-License-Identifier: LGPL-2.1-or-later
#pragma once

#include <vector>
#include "mapgen.h"
#include "noise.h"

class VoxelManipulator;
class NodeDefManager;

// v8 feature flags
#define MGV8_MOUNTAINS     0x01
#define MGV8_VOLCANOES     0x02
#define MGV8_RIVERS        0x04
#define MGV8_STRATA_CAVES  0x08
#define MGV8_NO_FLOATERS   0x10

struct MapgenV8Params : public MapgenParams {
	NoiseParams np_height_base;
	NoiseParams np_height_alt;
	NoiseParams np_height_select;
	NoiseParams np_warp_u;
	NoiseParams np_warp_v;
	NoiseParams np_river;
	NoiseParams np_cave1;
	NoiseParams np_cave2;
	NoiseParams np_volcano;

	// Controls (configurable)
	s16   mount_zero_level     = 32;
	float warp_strength        = 40.0f;
	s16   river_depth          = 6;
	float river_threshold      = 0.55f;
	s16   cave_ymin            = -31000;
	s16   cave_ymax            =  31000;
	s16   cave_mask_clearance  = 4;     // minimum roof thickness under surface
	u32   entrance_rate_ppm    = 120;   // entrances per million nodes
	u32   volcano_rate_ppm     = 3;     // volcano cells per million
	s16   south_ocean_span     = 8000;  // span of southern ocean end

	// v8 feature toggle string (mgv8_spflags)
	u32   spflags = (MGV8_MOUNTAINS | MGV8_RIVERS | MGV8_NO_FLOATERS);

	MapgenV8Params();
	~MapgenV8Params() = default;

	void readParams(const Settings *settings) override;
	void writeParams(Settings *settings) const override {} // not required
};

// Derive from MapgenBasic to reuse biome/topsoil utilities and content IDs.
class MapgenV8 : public MapgenBasic {
public:
	MapgenV8(MapgenV8Params *params, EmergeParams *emerge);
	~MapgenV8() override;

	void makeChunk(BlockMakeData *data) override;

protected:
	u32   spflags_v8 = 0;   // Mapgen v8 specific feature flags (from params)

	// Tunables copied from params
	s16   mount_zero_level    = 32;
	float warp_strength       = 40.0f;
	s16   river_depth         = 6;
	float river_threshold     = 0.55f;
	s16   cave_ymin           = -31000;
	s16   cave_ymax           =  31000;
	s16   cave_mask_clearance = 4;
	u32   entrance_rate_ppm   = 120;
	u32   volcano_rate_ppm    = 3;
	s16   south_ocean_span    = 8000;

	// 2D/3D noise generators
	Noise *n_height_base   = nullptr;
	Noise *n_height_alt    = nullptr;
	Noise *n_height_select = nullptr;
	Noise *n_warp_u        = nullptr;
	Noise *n_warp_v        = nullptr;
	Noise *n_river         = nullptr;
	Noise *n_cave1         = nullptr;
	Noise *n_cave2         = nullptr;
	Noise *n_volcano       = nullptr;

	// Working pointers (do not shadow MapgenBasic members)
	VoxelManipulator *m_vm   = nullptr;
	const NodeDefManager *m_ndef = nullptr;

	// Chunk extents for quick access
	v3s16 node_min, node_max;

	// Heightfield for this chunk
	std::vector<s16> heightmap; // size: csize.X * csize.Z

	// Core terrain generation steps
	void calcHeightmap();
	void placeVolcanoes();
	void fillTerrain();
	void carveRivers();
	void carveCaves();
	void carveEntrances();
};

extern const FlagDesc flagdesc_mapgen_v8[];
