// Luanti - Mapgen v8 (first-class, stability-hardened)
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "mapgen_v8.h"
#include <cstdint>
#include <cmath>
#include <cassert>
#include "noise.h"
#include "mapnode.h"
#include "nodedef.h"
#include "emerge.h"
#include "voxel.h"
#include "settings.h"
#include "mg_biome.h"

// Flags
const FlagDesc flagdesc_mapgen_v8[] = {
	{"mountains",     MGV8_MOUNTAINS},
	{"volcanoes",     MGV8_VOLCANOES},
	{"rivers",        MGV8_RIVERS},
	{"strata_caves",  MGV8_STRATA_CAVES},
	{"no_floaters",   MGV8_NO_FLOATERS},
	{NULL,            0}
};

// ----- Params -----
MapgenV8Params::MapgenV8Params()
{
	np_height_base   = NoiseParams(0.0,  1.0,  v3f(384, 384, 384),   82341, 5, 0.6,  2.0);
	np_height_alt    = NoiseParams(0.0,  1.0,  v3f(256, 256, 256),   19387, 5, 0.55, 2.0);
	np_height_select = NoiseParams(0.0,  1.0,  v3f(512, 512, 512),   12213, 5, 0.66, 2.0);

	np_warp_u        = NoiseParams(0.0,  1.0,  v3f(768, 768, 768),   53211, 3, 0.5,  2.0);
	np_warp_v        = NoiseParams(0.0,  1.0,  v3f(1024,1024,1024),  94111, 3, 0.5,  2.0);
	np_river         = NoiseParams(0.0,  1.0,  v3f(1024,1024,1024),  77121, 3, 0.5,  2.0);

	np_cave1         = NoiseParams(0.0, 12.0,  v3f(61, 61, 61),      52534, 3, 0.5,  2.0);
	np_cave2         = NoiseParams(0.0, 12.0,  v3f(67, 67, 67),      10325, 3, 0.5,  2.0);

	np_volcano       = NoiseParams(0.0,  1.0,  v3f(4096,4096,4096),  99131, 2, 0.5,  2.0);
}

void MapgenV8Params::readParams(const Settings *settings)
{
	settings->getNoiseParams("mgv8_np_height_base",   np_height_base);
	settings->getNoiseParams("mgv8_np_height_alt",    np_height_alt);
	settings->getNoiseParams("mgv8_np_height_select", np_height_select);
	settings->getNoiseParams("mgv8_np_warp_u",        np_warp_u);
	settings->getNoiseParams("mgv8_np_warp_v",        np_warp_v);
	settings->getNoiseParams("mgv8_np_river",         np_river);
	settings->getNoiseParams("mgv8_np_cave1",         np_cave1);
	settings->getNoiseParams("mgv8_np_cave2",         np_cave2);
	settings->getNoiseParams("mgv8_np_volcano",       np_volcano);

	settings->getS16NoEx("mgv8_mount_zero_level", mount_zero_level);
	settings->getFloatNoEx("mgv8_warp_strength",  warp_strength);
	settings->getS16NoEx("mgv8_river_depth",      river_depth);
	settings->getFloatNoEx("mgv8_river_threshold", river_threshold);
	settings->getS16NoEx("mgv8_cave_ymin",        cave_ymin);
	settings->getS16NoEx("mgv8_cave_ymax",        cave_ymax);
	settings->getS16NoEx("mgv8_cave_mask_clearance", cave_mask_clearance);
	settings->getU32NoEx("mgv8_entrance_rate_ppm", entrance_rate_ppm);
	settings->getU32NoEx("mgv8_volcano_rate_ppm",  volcano_rate_ppm);
	settings->getS16NoEx("mgv8_south_ocean_span",  south_ocean_span);

	// Apply mgv8_spflags if provided (3-arg signature in this fork)
	u32 f = spflags;
	if (settings->getFlagStrNoEx("mgv8_spflags", f, flagdesc_mapgen_v8)) {
		spflags = f;
	}
}

MapgenV8::MapgenV8(MapgenV8Params *p, EmergeParams *emerge) :
	// Use an existing enum constant for MapgenBasic base; selection is via factory registration.
	MapgenBasic(MAPGEN_V7, p, emerge)
{
	// Pull feature flags from params
	spflags_v8          = p->spflags;
	mount_zero_level    = p->mount_zero_level;
	warp_strength       = p->warp_strength;
	river_depth         = p->river_depth;
	river_threshold     = p->river_threshold;
	cave_ymin           = p->cave_ymin;
	cave_ymax           = p->cave_ymax;
	cave_mask_clearance = p->cave_mask_clearance;
	entrance_rate_ppm   = p->entrance_rate_ppm;
	volcano_rate_ppm    = p->volcano_rate_ppm;
	south_ocean_span    = p->south_ocean_span;

	// Allocate per-instance noise generators
	n_height_base   = new Noise(&p->np_height_base,   seed, csize.X, csize.Z);
	n_height_alt    = new Noise(&p->np_height_alt,    seed, csize.X, csize.Z);
	n_height_select = new Noise(&p->np_height_select, seed, csize.X, csize.Z);
	n_warp_u        = new Noise(&p->np_warp_u,        seed, csize.X, csize.Z);
	n_warp_v        = new Noise(&p->np_warp_v,        seed, csize.X, csize.Z);
	n_river         = new Noise(&p->np_river,         seed, csize.X, csize.Z);
	n_cave1         = new Noise(&p->np_cave1,         seed, csize.X, csize.Y + 2, csize.Z);
	n_cave2         = new Noise(&p->np_cave2,         seed, csize.X, csize.Y + 2, csize.Z);
	n_volcano       = new Noise(&p->np_volcano,       seed, csize.X, csize.Z);
}

MapgenV8::~MapgenV8()
{
	delete n_height_base;
	delete n_height_alt;
	delete n_height_select;
	delete n_warp_u;
	delete n_warp_v;
	delete n_river;
	delete n_cave1;
	delete n_cave2;
	delete n_volcano;
}

static inline float clampf(float v, float lo, float hi)
{ return v < lo ? lo : (v > hi ? hi : v); }

void MapgenV8::calcHeightmap()
{
	const int sx = csize.X;
	const int sz = csize.Z;
	for (int z = 0; z < sz; z++) {
		for (int x = 0; x < sx; x++) {
			const int i2d = z * sx + x;
			float hsel = clampf(n_height_select->result[i2d], 0.0f, 1.0f);
			float u = n_warp_u->result[i2d] * warp_strength;
			float v = n_warp_v->result[i2d] * warp_strength;
			float hb = n_height_base->result[i2d] + u * 0.05f;
			float ha = n_height_alt ->result[i2d] + v * 0.05f;
			float h = hb + (ha - hb) * hsel;

			if (h > mount_zero_level)
				h += (h - mount_zero_level) * 0.2f;

			heightmap[i2d] = (s16) floorf(h);
		}
	}
}

void MapgenV8::placeVolcanoes()
{
	if (!(spflags_v8 & MGV8_VOLCANOES))
		return;

	const int sx = csize.X;
	const int sz = csize.Z;
	const int CELL = 2048;

	for (int z = 0; z < sz; z++) {
		for (int x = 0; x < sx; x++) {
			int X = node_min.X + x;
			int Z = node_min.Z + z;
			int cx = (X >= 0 ? X : X - (CELL-1)) / CELL;
			int cz = (Z >= 0 ? Z : Z - (CELL-1)) / CELL;

			uint64_t hcalc = (uint64_t)cx * 374761393ULL + (uint64_t)cz * 668265263ULL + (uint64_t)seed * 2654435761ULL;
			if (((hcalc >> 1) % 1000000ULL) >= (uint64_t)volcano_rate_ppm)
				continue;

			hcalc ^= (hcalc << 13);
			float ox = (float)((hcalc & 0x3FF)) / 1023.0f; hcalc >>= 10;
			float oz = (float)((hcalc & 0x3FF)) / 1023.0f; hcalc >>= 10;
			float center_x = cx * CELL + ox * CELL;
			float center_z = cz * CELL + oz * CELL;

			float dx = (float)X - center_x;
			float dz = (float)Z - center_z;
			float r = sqrtf(dx*dx + dz*dz);
			const float R = 220.0f;
			if (r > R) continue;

			float cone = powf(1.0f - (r / R), 1.2f) * 120.0f;
			int idx = z * sx + x;
			heightmap[idx] += (s16) cone;
		}
	}
}

void MapgenV8::fillTerrain()
{
	const int sx = csize.X;
	const int sz = csize.Z;

	for (int z = 0; z < sz; z++) {
		for (int y = node_min.Y; y <= node_max.Y; y++) {
			for (int x = 0; x < sx; x++) {
				const int i2d = z * sx + x;
				const s16 h = heightmap[i2d];

				const s16 wx = node_min.X + x;
				const s16 wy = y;
				const s16 wz = node_min.Z + z;

				if (!m_vm->m_area.contains(v3s16(wx, wy, wz)))
					continue;
				u32 vi = m_vm->m_area.index(wx, wy, wz);
				MapNode &n = m_vm->m_data[vi];

				if (wy <= h) {
					n.setContent(c_stone);
				} else if (wy <= water_level) {
					n.setContent(c_water_source);
				}
			}
		}
	}
}

void MapgenV8::carveRivers()
{
	if (!(spflags_v8 & MGV8_RIVERS))
		return;

	const int sx = csize.X;
	const int sz = csize.Z;
	const v3s16 &emin = node_min;
	const v3s16 &emax = node_max;

	const content_t river_liquid = (c_river_water_source != CONTENT_IGNORE) ? c_river_water_source : c_water_source;

	for (int z = 0; z < sz; z++) {
		for (int x = 0; x < sx; x++) {
			const int i2d = z * sx + x;
			float r = n_river->result[i2d];
			if (r < river_threshold)
				continue;
			s16 h = heightmap[i2d];

			int hxp = (x+1 < sx) ? heightmap[z*sx + (x+1)] : h;
			int hxm = (x-1 >= 0) ? heightmap[z*sx + (x-1)] : h;
			int hzp = (z+1 < sz) ? heightmap[(z+1)*sx + x] : h;
			int hzm = (z-1 >= 0) ? heightmap[(z-1)*sx + x] : h;
			float gx = 0.5f * (hxp - hxm);
			float gz = 0.5f * (hzp - hzm);
			float slope = sqrtf(gx*gx + gz*gz);

			int depth = river_depth + (int) floor(slope * 2.0f);
			int half  = 2 + (int) floor(slope * 1.0f);
			int ds    = (node_min.Z + z) / 64;

			for (int dx = -half; dx <= half; ++dx) {
				int xx = x + dx;
				if (xx < 0 || xx >= sx) continue;
				float cross_factor = 1.0f - (fabs(dx) / (float)(half + 1));

				for (int dy = 0; dy < depth; dy++) {
					s16 bed = h - dy - ds - (int) floor((1.0f - cross_factor) * 2.0f);
					if (bed < emin.Y || bed > emax.Y) continue;
					const s16 wx = node_min.X + xx;
					const s16 wz = node_min.Z + z;
					if (!m_vm->m_area.contains(v3s16(wx, bed, wz)))
						continue;
					u32 vi = m_vm->m_area.index(wx, bed, wz);
					MapNode &node = m_vm->m_data[vi];
					content_t c = node.getContent();
					if (c == c_stone) {
						node.setContent(bed <= water_level ? river_liquid : CONTENT_AIR);
					}
				}
			}
		}
	}
}

void MapgenV8::carveCaves()
{
	const int sx = csize.X;
	const int sy = csize.Y + 2;
	const int sz = csize.Z;

	// Respect global caves flag from MapgenBasic::flags
	if (!(flags & MG_CAVES))
		return;

	for (int z = 0; z < sz; z++) {
		for (int y = 1; y < sy - 1; y++) {
			for (int x = 0; x < sx; x++) {
				const int i3d = (z * sy + y) * sx + x;
				float c1 = n_cave1->result[i3d] * 0.5f;
				float c2 = n_cave2->result[i3d] * 0.5f;
				float c = c1 * 0.6f + c2 * 0.4f;

				const s16 wx = node_min.X + x;
				const s16 wy = node_min.Y + (y - 1);
				const s16 wz = node_min.Z + z;

				if (wy < cave_ymin || wy > cave_ymax)
					continue;
				const int i2d = z * sx + x;
				s16 surf = heightmap[i2d];
				int D = surf - wy;
				if (D >= 0 && D < cave_mask_clearance)
					continue;

				if (!m_vm->m_area.contains(v3s16(wx, wy, wz)))
					continue;
				u32 vi = m_vm->m_area.index(wx, wy, wz);
				content_t curr = m_vm->m_data[vi].getContent();
				if (c > 0.0f && curr != CONTENT_AIR && curr != c_water_source && curr != c_river_water_source && curr != c_lava_source) {
					m_vm->m_data[vi].setContent(CONTENT_AIR);
				}
			}
		}
	}
}

void MapgenV8::carveEntrances()
{
	const int sx = csize.X;
	const int sz = csize.Z;
	for (int z = 0; z < sz; z++) {
		for (int x = 0; x < sx; x++) {
			const int i2d = z * sx + x;
			s16 surf = heightmap[i2d];
			if (surf < node_min.Y || surf > node_max.Y)
				continue;
			if (surf <= water_level)
				continue;

			s16 cave_top = node_min.Y - 1;
			for (s16 y = surf - 1; y >= surf - cave_mask_clearance; --y) {
				if (y < node_min.Y) break;
				u32 vi = m_vm->m_area.index(node_min.X + x, y, node_min.Z + z);
				content_t c = m_vm->m_data[vi].getContent();
				if (c == CONTENT_AIR) { cave_top = y; break; }
			}
			if (cave_top >= node_min.Y) {
				uint64_t h = (uint64_t)(node_min.X + x) * 341873128712ULL + (uint64_t)(node_min.Z + z) * 132897987541ULL + (uint64_t)seed;
				if ((h % 1000000ULL) < (uint64_t)entrance_rate_ppm) {
					for (s16 y = cave_top; y <= surf; ++y) {
						if (y < node_min.Y || y > node_max.Y) continue;
						u32 vi = m_vm->m_area.index(node_min.X + x, y, node_min.Z + z);
						content_t c = m_vm->m_data[vi].getContent();
						if (c != CONTENT_AIR && c != c_water_source && c != c_river_water_source && c != c_lava_source) {
							m_vm->m_data[vi].setContent(CONTENT_AIR);
						}
					}
				}
			}
		}
	}
}

void MapgenV8::makeChunk(BlockMakeData *data)
{
	assert(data && data->vmanip && data->nodedef);
	// assign both base-class and local pointers
	vm    = data->vmanip;
	ndef  = data->nodedef;
	m_vm  = data->vmanip;
	m_ndef = data->nodedef;

	v3s16 blockpos_min = data->blockpos_min;
	v3s16 blockpos_max = data->blockpos_max;
	node_min = blockpos_min * MAP_BLOCKSIZE;
	node_max = (blockpos_max + v3s16(1,1,1)) * MAP_BLOCKSIZE - v3s16(1,1,1);

	// Prepare heightmap
	heightmap.assign(csize.X * csize.Z, 0);

	// Generate noise maps
	n_height_base->noiseMap2D(node_min.X, node_min.Z);
	n_height_alt->noiseMap2D(node_min.X, node_min.Z);
	n_height_select->noiseMap2D(node_min.X, node_min.Z);
	n_warp_u->noiseMap2D(node_min.X, node_min.Z);
	n_warp_v->noiseMap2D(node_min.X, node_min.Z);
	n_river->noiseMap2D(node_min.X, node_min.Z);
	n_volcano->noiseMap2D(node_min.X, node_min.Z);
	n_cave1->noiseMap3D(node_min.X, node_min.Y - MAP_BLOCKSIZE, node_min.Z);
	n_cave2->noiseMap3D(node_min.X, node_min.Y - MAP_BLOCKSIZE, node_min.Z);

	// Biome noise first if biomes are enabled
	if ((flags & MG_BIOMES) && biomegen) {
		biomegen->calcBiomeNoise(node_min);
	}

	// Core pipeline
	calcHeightmap();
	placeVolcanoes();
	fillTerrain();
	carveRivers();
	carveCaves();
	carveEntrances();

	// Place topsoil and surfaces using MapgenBasic helper
	if ((flags & MG_BIOMES) && biomegen) {
		generateBiomes();
	}
}
