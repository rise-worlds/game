#include "stdafx.h"
#include "DBAgentSession.h"

REGISTER_SVRSESSION(eSvrType_DBAgent, DBAgentSession);

void	DBAgentSession::OnAccept(UINT32 nNetworkIndex)
{

}

void	DBAgentSession::OnDisconnect()
{
	ENTER_FUNCTION_FOXNET
		CSvrLinkMgr::GetSingle().DelSvrLink(this);
	LEAVE_FUNCTION_FOXNET
}

void	DBAgentSession::OnRecv(void *pMsg, INT16 nSize)
{
	ENTER_FUNCTION_FOXNET
		MsgHead* pHead = (MsgHead*)pMsg;
	PackCommon* pPack = g_SvrPackMgr.AllocPack(pHead->GetMsgID());
	if (!pPack)
	{
		return;
	}

	ReadBuf read((UINT8*)pMsg, nSize);
	pPack->UnPack(read);

	switch (pHead->GetMsgID())
	{
	case eSvrMsg_CheckLogin_DBSvr:
	{

	}
		break;
	default:
		g_SvrPackMgr.Free(pPack);
		break;
	};
	LEAVE_FUNCTION_FOXNET
}

void	DBAgentSession::OnConnect(bool bSuccess, UINT32 dwNetworkIndex)
{
}

void	DBAgentSession::OnRedirect()
{
	CSvrLinkMgr::GetSingle().AddSvrLink(this);
}