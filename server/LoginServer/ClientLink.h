#ifndef __CLIENTLINK_H__
#define __CLIENTLINK_H__

// 客户端连接的状态
enum eClientLinkState
{
	eLinkState_WaitLogin,
	eLinkState_Logining,
	eLinkState_WaitCharOperation,
	eLinkState_CharOperating,
	eLinkState_Complete,
};

#define KICK_WAIT_TIMER	(1000*60*3)

#include "../Utility/CommonDefs.h"
#include <string>

class PackCommon;

class ClientLink
{
public:
	ClientLink();
	~ClientLink();

	bool SendMsg(PackCommon* pPack);
	void SetWorldSvrKick();
	bool CheckWorldSvrKick();
protected:
	virtual void	OnAccept(unsigned int nNetworkIndex);
	virtual void	OnDisconnect();
	virtual	void	OnRecv(void *pMsg, short nSize);

	DF_PROPERTY(eClientLinkState, ClientState);
	DF_PROPERTY(UINT16, TempClientID);
	DF_PROPERTY(UINT32, AccountID);
	DF_PROPERTY(UINT32, KickTimer);

	DF_PROPERTY(UINT8, WorldSvrID);

	DF_PROPERTY(UINT32, DBLoginCode);
	DF_PROPERTY(std::string, AccountName);
	DF_PROPERTY(std::string, Password);
private:
	bool m_bWorldSvrKick;
};


#endif