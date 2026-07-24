// Luanti
// SPDX-License-Identifier: LGPL-2.1-or-later
// Dimension support: separate per-dimension ServerMap + EmergeManager instances
// with their own SQLite databases.

#pragma once

#include <map>
#include <mutex>
#include <string>
#include <memory>
#include "network/networkprotocol.h" // session_t

class Server;
class ServerMap;
class EmergeManager;
class MetricsBackend;
struct MapgenSinglenodeParams;
struct BiomeParamsOriginal;

class DimensionManager {
public:
	DimensionManager(Server *server, MetricsBackend *mb);
	~DimensionManager();

	// Register a new dimension. savedir is the full path to a directory
	// where map.sqlite and map_meta.txt will be stored. Returns false if the
	// name is already registered or if initialisation fails.
	// Safe to call during mod loading (before node resolution); the actual
	// EmergeManager/ServerMap creation is deferred until finalizeRegistrations().
	bool registerDimension(const std::string &dim_name, const std::string &savedir);

	// Called by Server after node resolution is complete. Creates the
	// EmergeManager and ServerMap for every dimension queued during mod loading.
	void finalizeRegistrations();

	// Move a player between dimensions. dim_name="" means the main world.
	// Also clears the client's sent-block cache so it re-requests from new map.
	void setPlayerDimension(session_t peer_id,
		const std::string &player_name,
		const std::string &dim_name);

	// Returns "" for the main world.
	std::string getPlayerDimension(const std::string &player_name) const;

	// Routing helpers.  Return nullptr if the player is in the main world.
	ServerMap    *getMapForPlayer(const std::string &player_name) const;
	EmergeManager*getEmergeForPlayer(const std::string &player_name) const;

	ServerMap    *getMapForPeer(session_t peer_id) const;
	EmergeManager*getEmergeForPeer(session_t peer_id) const;

private:
	struct DimInfo {
		ServerMap             *map     = nullptr;
		EmergeManager         *emerge  = nullptr;
		MapgenSinglenodeParams *mgparams = nullptr;
		BiomeParamsOriginal   *biome_params = nullptr;
	};

	Server        *m_server;
	MetricsBackend*m_mb;

	bool m_finalized = false;
	std::map<std::string, std::string> m_pending; // queued before finalization: dim_name → savedir

	std::map<std::string, DimInfo> m_dims;        // dim_name → info
	std::map<std::string, std::string> m_player_dim; // player_name → dim_name
	std::map<session_t, std::string>   m_peer_dim;   // peer_id → dim_name

	mutable std::mutex m_mutex;

	const DimInfo *getDimInfo(const std::string &dim_name) const;
	bool doRegisterDimension(const std::string &dim_name, const std::string &savedir);
};
