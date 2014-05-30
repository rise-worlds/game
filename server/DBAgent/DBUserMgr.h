#ifndef __DBUserMgr_H__
#define __DBUserMgr_H__

#include <string>
#include <hash_map>

class CDBUser;

class CDBUserMgr : public Common::Single < CDBUserMgr >
{
public:
	CDBUserMgr();
	~CDBUserMgr();

	CDBUser*	AllocDBUser(UINT32 nAccountID);
	void		FreeDBUser(CDBUser*	pUser);

	CDBUser*	GetUserByAccountID(UINT32 nAccountID);

	UINT32	GetUserAmount()
	{
		return UINT32(m_AccountIDMap.size());
	}

private:
	typedef stdext::hash_map<UINT32, CDBUser*>	DBUSER_IDMAP;
	DBUSER_IDMAP	m_AccountIDMap;
};

#define Df_DBUserMgr	CDBUserMgr::getSingleton()

#endif