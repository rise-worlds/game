#include "stdafx.h"
#include "DBUser.h"

CDBUser::CDBUser()
{
	SetAccountID(0);
	m_nFriendAmount = 0;
	SetSceneSvrID(0);
}

CDBUser::~CDBUser()
{
}

//==============================lw=================================
MAP_ITEM_INFO* CDBUser::GetItemInfoset()
{
	return &m_mapItemInfoset;
}
//==============================lw=================================
void CDBUser::Release()
{
	this->ResetItemInfoMap();
	delete(this);
}

void CDBUser::ResetItemInfoMap()
{
	MAP_ITEM_INFO::iterator iter = m_mapItemInfoset.begin();
	for (; iter != m_mapItemInfoset.end(); iter++)
	{
		SAFE_DELETE((*iter).second);
	}
	m_mapItemInfoset.clear();
}

VEC_ATTACK_INFO* CDBUser::GetAttackInfoVec()
{
	return &m_vecAttackInfo;
}