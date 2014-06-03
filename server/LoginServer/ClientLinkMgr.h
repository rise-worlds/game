#ifndef __CLIENTLNKMGR_H__
#define __CLIENTLNKMGR_H__

#include "ServerMsgDef/IDAllocFactory.h"

class ClientLink;


class ClientLinkMgr : public Common::Single<ClientLinkMgr>
{
public:
	ClientLinkMgr();
	~ClientLinkMgr();
public:
	ClientLink*	AllocClient();
	void		FreeClient(ClientLink* pClientLink);
	ClientLink*	GetClientLinkByTempID(UINT16 nTempClientID);
	ClientLink*	GetLinkFromTempByAccountID(UINT16 nAccountID);
	ClientLink*	GetClientLinkByAcctID(UINT16 nAccountID);

	bool	BindAccountID(ClientLink* pClientLink);
	void	UnBindAccountID(ClientLink* pClientLink);

	UINT32	GetTempClientAmount()
	{
		return UINT32(m_TempClientIDToPtrMap.size());
	}
	UINT32	GetLoginClientAmount()
	{
		return UINT32(m_AccountIDToPtrMap.size());
	}

	void	Update(UINT32	nDiffTime);

	void	ShowPlayerInfo(int nIsShowAll);


private:
	typedef stdext::hash_map<UINT16, ClientLink*>	TempClientIDToPtrMap;
	typedef stdext::hash_map<UINT32, ClientLink*>	AccountIDToPtrMap;
	TempClientIDToPtrMap	m_TempClientIDToPtrMap;
	AccountIDToPtrMap		m_AccountIDToPtrMap;

	IDAllocFactory<UINT16, 1>	m_TempClientIDAlloc;
};

#define Df_ClientLinkMgr	ClientLinkMgr::getSingle()
#endif