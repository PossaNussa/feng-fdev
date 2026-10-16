// Luanti
// SPDX-License-Identifier: LGPL-2.1-or-later
// Dimension support: separate per-dimension ServerMap + EmergeManager instances

#include "dimension_manager.h"

#include "log.h"
#include "filesys.h"
#include "server.h"
#include "emerge.h"
#include "servermap.h"
#include "mapgen/mapgen_singlenode.h"
#include "mapgen/mg_biome.h"
#include "util/metricsbackend.h"

DimensionManager::DimensionManager(Server *server, MetricsBackend *mb)
	: m_server(server), m_mb(mb)
{
}

void DimensionManager::stopThreads()
{
	std::lock_guard<std::mutex> lock(m_mutex);
	for (auto &kv : m_dims) {
		if (kv.second.emerge)
			kv.second.emerge->stopThreads();
	}
}

DimensionManager::~DimensionManager()
{
	// Stop and destroy dimensions in reverse registration order.
	// ServerMap destructor calls emerge->resetMap(), so destroy map first.
	// Note: ~MapgenParams() deletes bparams, which is info.biome_params, so
	// biome_params must NOT be deleted separately here.
	for (auto &kv : m_dims) {
		DimInfo &info = kv.second;
		if (info.emerge)
			info.emerge->stopThreads();
		delete info.map;
		delete info.emerge;
		delete info.mgparams;
	}
	m_dims.clear();
}

bool DimensionManager::registerDimension(const std::string &dim_name,
	const std::string &savedir)
{
	if (dim_name.empty()) {
		errorstream << "DimensionManager: dimension name must not be empty" << std::endl;
		return false;
	}

	std::lock_guard<std::mutex> lock(m_mutex);

	if (m_dims.count(dim_name) || m_pending.count(dim_name)) {
		errorstream << "DimensionManager: dimension '" << dim_name
			<< "' already registered" << std::endl;
		return false;
	}

	if (!m_finalized) {
		// Node resolution not done yet — queue for later
		m_pending[dim_name] = savedir;
		infostream << "DimensionManager: queued dimension '" << dim_name
			<< "' (will initialize after node resolution)" << std::endl;
		return true;
	}

	return doRegisterDimension(dim_name, savedir);
}

void DimensionManager::finalizeRegistrations()
{
	m_finalized = true;
	for (auto &kv : m_pending) {
		doRegisterDimension(kv.first, kv.second);
	}
	m_pending.clear();
}

bool DimensionManager::doRegisterDimension(const std::string &dim_name,
	const std::string &savedir)
{
	// Ensure save directory exists
	if (!fs::CreateAllDirs(savedir)) {
		errorstream << "DimensionManager: failed to create save dir '"
			<< savedir << "'" << std::endl;
		return false;
	}

	DimInfo info;

	info.biome_params = new BiomeParamsOriginal();
	info.mgparams = new MapgenSinglenodeParams();
	info.mgparams->mgtype = MAPGEN_SINGLENODE;
	info.mgparams->bparams = info.biome_params;

	info.emerge = new EmergeManager(m_server, m_mb);
	info.emerge->m_dim_name = dim_name;

	info.emerge->initMapgens(info.mgparams);

	try {
		info.map = new ServerMap(savedir, m_server, info.emerge, m_mb);
	} catch (const std::exception &e) {
		errorstream << "DimensionManager: failed to create ServerMap for '"
			<< dim_name << "': " << e.what() << std::endl;
		info.emerge->stopThreads();
		delete info.emerge;
		// ~MapgenParams() deletes bparams (info.biome_params) for us.
		delete info.mgparams;
		return false;
	}

	info.emerge->setMapOverride(info.map);
	info.emerge->startThreads();

	m_dims[dim_name] = info;

	infostream << "DimensionManager: registered dimension '" << dim_name
		<< "' at " << savedir << std::endl;
	return true;
}

void DimensionManager::setPlayerDimension(session_t peer_id,
	const std::string &player_name,
	const std::string &dim_name)
{
	// Validate dimension name (allow "" for main world)
	if (!dim_name.empty()) {
		std::lock_guard<std::mutex> lock(m_mutex);
		if (!m_dims.count(dim_name)) {
			errorstream << "DimensionManager::setPlayerDimension: unknown dimension '"
				<< dim_name << "'" << std::endl;
			return;
		}
	}

	{
		std::lock_guard<std::mutex> lock(m_mutex);
		if (dim_name.empty()) {
			m_player_dim.erase(player_name);
			m_peer_dim.erase(peer_id);
		} else {
			m_player_dim[player_name] = dim_name;
			m_peer_dim[peer_id] = dim_name;
		}
	}

	// Clear the client's sent-block tracking so it re-requests everything
	// from the new dimension's map.
	m_server->clearClientSentBlocks(peer_id);
}

std::string DimensionManager::getPlayerDimension(const std::string &player_name) const
{
	std::lock_guard<std::mutex> lock(m_mutex);
	auto it = m_player_dim.find(player_name);
	return (it != m_player_dim.end()) ? it->second : "";
}

const DimensionManager::DimInfo *DimensionManager::getDimInfo(const std::string &dim_name) const
{
	auto it = m_dims.find(dim_name);
	return (it != m_dims.end()) ? &it->second : nullptr;
}

ServerMap *DimensionManager::getMapForPlayer(const std::string &player_name) const
{
	std::lock_guard<std::mutex> lock(m_mutex);
	auto pit = m_player_dim.find(player_name);
	if (pit == m_player_dim.end())
		return nullptr;
	const DimInfo *info = getDimInfo(pit->second);
	return info ? info->map : nullptr;
}

EmergeManager *DimensionManager::getEmergeForPlayer(const std::string &player_name) const
{
	std::lock_guard<std::mutex> lock(m_mutex);
	auto pit = m_player_dim.find(player_name);
	if (pit == m_player_dim.end())
		return nullptr;
	const DimInfo *info = getDimInfo(pit->second);
	return info ? info->emerge : nullptr;
}

ServerMap *DimensionManager::getMapForPeer(session_t peer_id) const
{
	std::lock_guard<std::mutex> lock(m_mutex);
	auto pit = m_peer_dim.find(peer_id);
	if (pit == m_peer_dim.end())
		return nullptr;
	const DimInfo *info = getDimInfo(pit->second);
	return info ? info->map : nullptr;
}

EmergeManager *DimensionManager::getEmergeForPeer(session_t peer_id) const
{
	std::lock_guard<std::mutex> lock(m_mutex);
	auto pit = m_peer_dim.find(peer_id);
	if (pit == m_peer_dim.end())
		return nullptr;
	const DimInfo *info = getDimInfo(pit->second);
	return info ? info->emerge : nullptr;
}
