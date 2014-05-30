#include "stdafx.h"
#include "DBUserMgr.h"

CDBUserMgr::CDBUserMgr()
{

}

CDBUserMgr::~CDBUserMgr()
{

}

CDBUser*	CDBUserMgr::AllocDBUser(UINT32 nAccountID)
{
	ENTER_FUNCTION_FOXNET
		CDBUser* pUser = GetUserByAccountID(nAccountID);
	if (pUser)
	{
		return pUser;
	}

	pUser = new CDBUser;
	pUser->SetAccountID(nAccountID);
	pUser->SetWorldSvrID(MakeSvrID(nAccountID, Df_Master.GetWorldAmount()));
	m_AccountIDMap[nAccountID] = pUser;

	return pUser;
	LEAVE_FUNCTION_RETURN_NULL
}

void		CDBUserMgr::FreeDBUser(CDBUser*	pUser)
{
	ENTER_FUNCTION_FOXNET
		CHECK(pUser);
	if (GetUserByAccountID(pUser->GetAccountID()))
	{
		m_AccountIDMap.erase(pUser->GetAccountID());
	}
	pUser->Release();
	LEAVE_FUNCTION_FOXNET
}

CDBUser*	CDBUserMgr::GetUserByAccountID(UINT32 nAccountID)
{
	ENTER_FUNCTION_FOXNET
		MAP_FIND(DBUSER_IDMAP, m_AccountIDMap, it, nAccountID)
	{
		return it->second;
	}

	return NULL;
	LEAVE_FUNCTION_RETURN_NULL
}