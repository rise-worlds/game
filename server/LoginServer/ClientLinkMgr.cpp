#include "ClientLinkMgr.h"
#include "../Utility/FunctionGuard.h"

ClientLinkMgr::ClientLinkMgr()
{

}

ClientLinkMgr::~ClientLinkMgr()
{
	ENTER_FUNCTION_FOXNET

	// 断开剩下的连接
	stdext::hash_set<ClientLink*>	KickClientSet;
	FOREACH_IT(TempClientIDToPtrMap, m_TempClientIDToPtrMap, it)
	{
		ClientLink*	pClientLink = it->second;
		KickClientSet.insert(pClientLink);
	}

	FOREACH_IT(AccountIDToPtrMap, m_AccountIDToPtrMap, it)
	{
		ClientLink*	pClientLink = it->second;
		KickClientSet.insert(pClientLink);
	}

	FOREACH_IT(stdext::hash_set<ClientLink*>, KickClientSet, it)
	{
		ClientLink* pClientLink = *it;
		pClientLink->Disconnect();
	}

	LEAVE_FUNCTION_FOXNET
}

ClientLink*	ClientLinkMgr::AllocClient()
{
	ENTER_FUNCTION_FOXNET

	ClientLink*	pClientLink = SGExternNew(ClientLink);
	if (!pClientLink)
	{
		ERRMSG("分配客户端连接出错");
		return NULL;
	}

	UINT16	nTempID = m_TempClientIDAlloc.AllocID();

#ifdef _DEBUG
	// 检查分配的连接的唯一性
	if (GetClientLinkByTempID(nTempID) != NULL)
	{
		ERRMSG("临时客户端ID重复分配了 %d 可能因为分配完了", nTempID);

		SGExternDelete(pClientLink);
		m_TempClientIDAlloc.FreeID(nTempID);
		return NULL;
	}
#endif

	pClientLink->SetTempClientID(nTempID);
	m_TempClientIDToPtrMap[nTempID] = pClientLink;

	return pClientLink;

	LEAVE_FUNCTION_FOXNET

		return NULL;
}

void		ClientLinkMgr::FreeClient(ClientLink* pClientLink)
{
	ENTER_FUNCTION_FOXNET

	UINT16	nTempID = pClientLink->GetTempClientID();
	if (nTempID != 0)
	{
		m_TempClientIDAlloc.FreeID(nTempID);

#ifdef _DEBUG
		if (GetClientLinkByTempID(nTempID) != pClientLink)
		{
			ERRMSG("释放的客户端未在MAP中存在 %d", nTempID);
		}
#endif
		m_TempClientIDToPtrMap.erase(nTempID);
	}

	UINT32	nAccountID = pClientLink->GetAccountID();
	if (nAccountID != 0)
	{
		m_AccountIDToPtrMap.erase(nAccountID);
	}

	SGExternDelete(pClientLink);

	LEAVE_FUNCTION_FOXNET
}
//从临时链接队列里查找指定的玩家的链接
ClientLink*	ClientLinkMgr::GetLinkFromTempByAccountID(UINT16 nAccountID)
{
	ENTER_FUNCTION_FOXNET

	TempClientIDToPtrMap::iterator iter = m_TempClientIDToPtrMap.begin();
	for (; iter != m_TempClientIDToPtrMap.end(); iter++)
	{
		if ((iter->second)->GetAccountID() == nAccountID)
		{
			return iter->second;
		}
	}
	return NULL;

	LEAVE_FUNCTION_FOXNET

	return NULL;
}
ClientLink*	ClientLinkMgr::GetClientLinkByTempID(UINT16 nTempClientID)
{
	ENTER_FUNCTION_FOXNET

	MAP_FIND(TempClientIDToPtrMap, m_TempClientIDToPtrMap, it, nTempClientID)
	{
		return it->second;
	}

	return NULL;

	LEAVE_FUNCTION_FOXNET

	return NULL;
}

ClientLink*	ClientLinkMgr::GetClientLinkByAcctID(UINT16 nAccountID)
{
	ENTER_FUNCTION_FOXNET

	MAP_FIND(AccountIDToPtrMap, m_AccountIDToPtrMap, it, nAccountID)
	{
		return it->second;
	}

	return NULL;

	LEAVE_FUNCTION_FOXNET

	return NULL;
}

bool	ClientLinkMgr::BindAccountID(ClientLink* pClientLink)
{
	ENTER_FUNCTION_FOXNET
		m_AccountIDToPtrMap[pClientLink->GetAccountID()] = pClientLink;
	return true;
	LEAVE_FUNCTION_FOXNET
		return false;
}

void	ClientLinkMgr::UnBindAccountID(ClientLink* pClientLink)
{
	ENTER_FUNCTION_FOXNET

		m_AccountIDToPtrMap.erase(pClientLink->GetAccountID());

	LEAVE_FUNCTION_FOXNET
}

void	ClientLinkMgr::Update(UINT32	nDiffTime)
{
	ENTER_FUNCTION_FOXNET

	stdext::hash_set<ClientLink*>	KickClientSet;
	FOREACH_IT(TempClientIDToPtrMap, m_TempClientIDToPtrMap, it)
	{
		ClientLink*	pClientLink = it->second;
		if (pClientLink->GetKickTimer() <= nDiffTime)
		{
			KickClientSet.insert(pClientLink);
		}
	}

	FOREACH_IT(stdext::hash_set<ClientLink*>, KickClientSet, it)
	{
		ClientLink* pClientLink = *it;
		pClientLink->Disconnect();
	}

	LEAVE_FUNCTION_FOXNET
}

void	ClientLinkMgr::ShowPlayerInfo(int nIsShowAll)
{
	ENTER_FUNCTION_FOXNET

		if (nIsShowAll)
		{
		FOREACH_IT(AccountIDToPtrMap, m_AccountIDToPtrMap, it)
		{
			ClientLink*	pClientLink = it->second;
			printf("ID[%d] \tIP[%s]\n", it->first, pClientLink->GetIP());
		}
		}
	printf("当前登录:[%d]\n", m_AccountIDToPtrMap.size());

	if (nIsShowAll)
	{
		FOREACH_IT(TempClientIDToPtrMap, m_TempClientIDToPtrMap, it)
		{
			ClientLink*	pClientLink = it->second;
			printf("IP[%s]\n", pClientLink->GetIP());
		}
	}

	printf("当前等待登录:[%d]\n", m_TempClientIDToPtrMap.size());

	LEAVE_FUNCTION_FOXNET
}
