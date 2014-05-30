#include "stdafx.h"
#include "LoginSession.h"

REGISTER_SVRSESSION(eSvrType_Login, LoginSession);

void	LoginSession::OnAccept(UINT32 nNetworkIndex)
{

}

void	LoginSession::OnDisconnect()
{
	ENTER_FUNCTION_FOXNET
		CSvrLinkMgr::GetSingle().DelSvrLink(this);
	LEAVE_FUNCTION_FOXNET
}

void	LoginSession::OnRecv(void *pMsg, INT16 nSize)
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
		CTransaction_CheckLogin* pTransaction = new CTransaction_CheckLogin;
		//pTransaction->checklogin = (SvrMsg_CheckLogin_DBSvr*)pPack;

		Df_Master.GetOTLDatabase().AddTransaction(pTransaction);
	}
		break;
	default:
		g_SvrPackMgr.Free(pPack);
		break;
	};
	LEAVE_FUNCTION_FOXNET
}

void	LoginSession::OnConnect(bool bSuccess, UINT32 dwNetworkIndex)
{
}

void	LoginSession::OnRedirect()
{
	CSvrLinkMgr::GetSingle().AddSvrLink(this);
}