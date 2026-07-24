// Core registration for Mapgen v8
// Compile this file as part of src/mapgen to make "v8" a first-class mapgen.
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "mapgen.h"
#include "mapgen_v8.h"

class MapgenFactoryV8 : public MapgenFactory {
public:
	Mapgen *createMapgen(MapgenParams *params, EmergeParams *emerge) override {
		return new MapgenV8(static_cast<MapgenV8Params*>(params), emerge);
	}
	MapgenParams *createMapgenParams() override {
		return new MapgenV8Params();
	}
};

static MapgenFactoryV8 g_mapgen_factory_v8;

__attribute__((constructor))
static void register_mapgen_v8()
{
	Mapgen::addMapgen("v8",   &g_mapgen_factory_v8);
	Mapgen::addMapgen("mgv8", &g_mapgen_factory_v8);
}
