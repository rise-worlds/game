#ifndef __SvrLinkMgr_H__
#define __SvrLinkMgr_H__

#include "Utility/Utility.h"
#include "AsioNetwork/NetObject.h"
#include "SvrMsgCommon.h"
//#include "SvrMsg_Config.h"
//#include "SvrMsg_DBAgent.h"
//#include "SvrMsg_LoginServer.h"
//#include "SvrMsg_WorldServer.h"
//#include "SvrMsg_SceneServer.h"
class CSvrSession: public NetObject
{
public:
	CSvrSession()
	{
		SetServerType(0);
		SetServerID(0);
		SetLinkState(eLinkState_Disconnect);
		SetLinkIP(0);
		SetLinkPort(0);
	}

	bool	SendMsg(PackCommon* pMsg)
	{
		ENTER_FUNCTION_FOXNET

		char* ptr	= NULL;
		int	nMaxWriteSize	= 0;
		GetSendBuffPtr(&ptr, nMaxWriteSize);

		if (nMaxWriteSize < pMsg->GetPackSize())
		{
			return false;
		}

		WriteBuf	buffer((SGuint8*)ptr, nMaxWriteSize);
		pMsg->Pack(buffer);

		return CompleteSend(buffer.GetReadSize(), pMsg->GetMsgID());

		LEAVE_FUNCTION_FOXNET

		return false;
	}
	unsigned short  GetPort()
	{
		return NetObject::GetPort();
	}

	virtual void	OnDisconnect();

public:
	DF_PROPERTY(UINT8, ServerType);
	DF_PROPERTY(UINT8, ServerID);
	DF_PROPERTY(eLinkState, LinkState);
	DF_PROPERTY(UINT32, LinkIP);
	DF_PROPERTY(UINT16, LinkPort);
};

class CSendMsgToType
{
public:
	CSendMsgToType(PackCommon* pPack)
	{
		m_pPack	= pPack;
	}

	void operator()(CSvrSession* pSession)
	{
		pSession->SendMsg(m_pPack);
	}

private:
	PackCommon*	m_pPack;
};

class CSvrLinkMgr
{
public:
	static CSvrLinkMgr&	GetSingleton()
	{
		static CSvrLinkMgr s_SvrLinkMgr;
		return s_SvrLinkMgr;
	}

protected:
	CSvrLinkMgr()
	{
		for (int i=0; i<eSvrType_Count; i++)
		{
			m_pHelper[i]	= NULL;
		}
	}

	~CSvrLinkMgr()
	{

	}

public:
	void	RegisterSession(int type, Common::IRegisterHelper* pHelper)
	{
		ENTER_FUNCTION_FOXNET

		if (type >= eSvrType_Count
			|| m_pHelper[type] != NULL)
		{
			return;
		}

		m_pHelper[type]	= pHelper;

		LEAVE_FUNCTION_FOXNET
	}

	CSvrSession*	AllocSession(int type)
	{
		ENTER_FUNCTION_FOXNET

		if (type >= eSvrType_Count
			|| m_pHelper[type] == NULL)
		{
			return NULL;
		}

		CSvrSession* pNewSession	= (CSvrSession*)(m_pHelper[type]->New());
		pNewSession->SetServerType(type);

		return pNewSession;

		LEAVE_FUNCTION_FOXNET

		return NULL;
	}

	void	FreeSession(CSvrSession* ptr)
	{
		//m_pHelper[ptr->GetServerType()]->Free(ptr);
		delete ptr;
	}

private:
	Common::IRegisterHelper*	m_pHelper[eSvrType_Count];

public:
	template<class T>
	void	Foreach_SvrLinkByType(eServerType type, T fun)
	{
		ENTER_FUNCTION_FOXNET

		if (type >= eSvrType_Count)
		{
			return;
		}

		FOREACH_COUNT (nSvrID, 0, TypeServerMaxAmount)
		{
			CSvrSession* pLink	= m_AllSvrLink[type][nSvrID];
			if (pLink)
			{
				fun(pLink);
			}
		}

		LEAVE_FUNCTION_FOXNET
	}

	CSvrSession*	GetSvrLinkByTypeID(eServerType type, SGuint8 ID)
	{
		ENTER_FUNCTION_FOXNET

		if (type >= eSvrType_Count
			|| ID >= TypeServerMaxAmount)
		{
			return NULL;
		}

		return m_AllSvrLink[type][ID];

		LEAVE_FUNCTION_FOXNET

		return NULL;
	}

	CSvrSession*	GetSvrLinkByType(eServerType type)
	{
		ENTER_FUNCTION_FOXNET

		if (type >= eSvrType_Count)
		{
			return NULL;
		}

		FOREACH_COUNT (id, 0, TypeServerMaxAmount)
		{
			if (m_AllSvrLink[type][id])
			{
				return m_AllSvrLink[type][id];
			}
		}

		return NULL;

		LEAVE_FUNCTION_FOXNET

		return NULL;
	}

	void			AddSvrLink(CSvrSession* pServerLink)
	{
		ENTER_FUNCTION_FOXNET

		UINT8 type = pServerLink->GetServerType();
		UINT8 ID = pServerLink->GetServerID();
		if (!ID 
			|| type >= eSvrType_Count
			|| ID >= TypeServerMaxAmount)
		{
			return;
		}

		if (m_AllSvrLink[type][ID])
		{
			printf("?????????? IP[%s] Type[%s] ID[%d]\n", pServerLink->GetIP(), SERVERNAME[type], ID);
			pServerLink->SetServerID(0);
			pServerLink->Disconnect();
			return;
		}

		m_AllSvrLink[type][ID]	= pServerLink;

		printf("????????? IP[%s] Type[%s] ID[%d]\n", pServerLink->GetIP(), SERVERNAME[type], ID);

		LEAVE_FUNCTION_FOXNET
	}

	void			DelSvrLink(CSvrSession* pServerLink)
	{
		ENTER_FUNCTION_FOXNET

		UINT8 type = pServerLink->GetServerType();
		UINT8 ID = pServerLink->GetServerID();
		if (!ID 
			|| type >= eSvrType_Count
			|| ID >= TypeServerMaxAmount)
		{
			return;
		}

		if (!m_AllSvrLink[type][ID])
		{
			printf("????????????\n");
			return;
		}

		m_AllSvrLink[type][ID]	= NULL;

		printf("????§Ø???? IP[%s] Type[%s] ID[%d]\n", pServerLink->GetIP(), SERVERNAME[type], ID);

		LEAVE_FUNCTION_FOXNET
	}

private:
	CSvrSession*	m_AllSvrLink[eSvrType_Count][TypeServerMaxAmount];
};

inline void	CSvrSession::OnDisconnect()
{
	CSvrLinkMgr::GetSingle().DelSvrLink(this);
}

#define REGISTER_SVRSESSION(type, x)	\
	SGCommon::CRegisterHelper<x>	g_SvrSessionRegister_##x; \
	struct SvrSessionRegister_##x \
	{ \
		SvrSessionRegister_##x() \
		{ \
			CSvrLinkMgr::GetSingle().RegisterSession(type, &(g_SvrSessionRegister_##x)); \
		} \
	} g_SvrSessionRegisterS_##x;


#endif // __SvrLinkMgr_H__