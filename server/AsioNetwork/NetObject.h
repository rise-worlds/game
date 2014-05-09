#ifndef __NetObject_H__
#define __NetObject_H__

#include "AsioNetwork.h"

class Session;

class ASIONETWORK_API NetObject
{
public: 
	NetObject();
	virtual ~NetObject();

	void			Disconnect(bool bForceDisconnect = false);
	bool			Send(void *pMsg, unsigned short nSize, int nPackLevel = 0);
	bool			SendEx(unsigned int nNumberOfMessages, void **ppMsg, unsigned short *pnSize, int nPackLevel = 0);
	void			Redirect(NetObject *pNetworkObject);
	char*			GetIP();
	unsigned short  GetPort();
	void			GetSendBuffPtr(char** ptr, int& nSize);
	bool			CompleteSend(int nSize, int nMsgType);
    float           GetSendBufferRatio();

	inline	void	SetSession(Session *pSession)
	{
		m_pSession = pSession;
	}

	virtual void	OnAccept(unsigned int nNetworkIndex) {}
	virtual void	OnDisconnect() {}
	virtual	void	OnRecv(void *pMsg, short nSize) = 0;
	virtual void	OnConnect(bool bSuccess, unsigned int dwNetworkIndex) {}
	virtual void	OnRedirect() {}
    virtual bool    OnPreSendPack(void* pMsg, int nSize, float fBufferRation, int nMsgLevel);

	Session			*m_pSession;

};

#endif // __NetObject_H__