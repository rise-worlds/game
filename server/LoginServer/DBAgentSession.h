#ifndef __LoginSession_H__
#define __LoginSession_H__
#include "ServerMsgDef/SvrLinkMgr.h"

class DBAgentSession : public CSvrSession
{
public:
	DBAgentSession()
	{
		SetServerType(eSvrType_DBAgent);
		SetServerID(0);
		SetLinkState(eLinkState_Disconnect);
		SetLinkIP(0);
		SetLinkPort(0);
	}

	virtual void	OnAccept(UINT32 nNetworkIndex);
	virtual void	OnDisconnect();
	virtual	void	OnRecv(void *pMsg, INT16 nSize);
	virtual void	OnConnect(bool bSuccess, UINT32 dwNetworkIndex);
	virtual void	OnRedirect();

};
#endif