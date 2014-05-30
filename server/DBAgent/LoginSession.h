#ifndef __LoginSession_H__
#define __LoginSession_H__
#include "ServerMsgDef/SvrLinkMgr.h"

class LoginSession : public CSvrSession
{
public:
	LoginSession()
	{
		SetServerType(eSvrType_Login);
		SetServerID(0);
		SetLinkState(eLinkState_Disconnect);
		SetLinkIP(0);
		SetLinkPort(0);
	}

	virtual void	OnAccept(unsigned int nNetworkIndex);
	virtual void	OnDisconnect();
	virtual	void	OnRecv(void *pMsg, short nSize);
	virtual void	OnConnect(bool bSuccess, unsigned int dwNetworkIndex);
	virtual void	OnRedirect();

};
#endif