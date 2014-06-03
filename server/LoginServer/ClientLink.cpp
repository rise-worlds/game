#include "stdafx.h"
#include "ClientLink.h"
#include "Utility/FunctionGuard.h"
#include "ServerMsgDef/SvrLinkMgr.h"

#include "ClientLinkMgr.h"
#include "Master.h"

ClientLink::ClientLink()
{
	SetClientState(eLinkState_WaitLogin);
	SetTempClientID(0);
	SetAccountID(0);
	SetKickTimer(KICK_WAIT_TIMER);
	SetWorldSvrID(0);
}

ClientLink::~ClientLink()
{
}

void	ClientLink::OnAccept(unsigned int nNetworkIndex)
{
	ENTER_FUNCTION_FOXNET

		if (Df_Master.GetCanAcceptClient() == 0)
		{
		// 断开连接
		Disconnect();
		return;
		}

	//Msg_GameTime_LC msg;
	//msg.gametime = CGameTime::GetSingle().GetGameTime();
	//msg.fScale = CGameTime::GetSingle().GetTimeScale();
	//SendMsg(&msg);

	//Msg_SvrLocalTime_LC msgSvrLocalTime;
	//msgSvrLocalTime.nLocalTime = time(NULL);
	//SendMsg(&msgSvrLocalTime);

	//Msg_MessageVer_LC ver;
	//ver.nMessageVer = CLIENT_VERSION;
	//ver.nAdmissionVer = CLIENT_VERSION_ADMISSION;
	//SendMsg(&ver);

	LEAVE_FUNCTION_FOXNET
}

void	ClientLink::OnRecv(void *pMsg, short nSize)
{
	ENTER_FUNCTION_FOXNET

		MsgHead* pHead = (MsgHead*)pMsg;
	if (pHead->nMsgID == UINT16(-1))
	{
		// ping
		Send(pMsg, nSize);
		return;
	}

	PackCommon* pPack = g_ClientPackMgr.AllocPack(pHead->GetMsgID());
	if (!pPack)
	{
		return;
	}

	ReadBuf	read((UINT8*)pMsg, nSize);
	pPack->UnPack(read);

	switch (pPack->GetMsgID())
	{
	case eMsg_Login_CL:
	{
		Msg_Login_CL* pMsg = (Msg_Login_CL*)pPack;
		if (GetClientState() != eLinkState_WaitLogin)
		{
			Msg_LoginResult_LC	result;
			result.nErrCode = RC_LoginResult_AgainLogin;
			SendMsg(&result);

			return;
		}

		// 比较版本号
		if (pMsg->nCurVer < VERSION_COMPATIBLE)
		{
			// 版本号旧
			Msg_LoginResult_LC	result;
			result.nErrCode = RC_LoginResult_OldVersion;
			SendMsg(&result);

			return;
		}

		SetClientState(eLinkState_Logining);


		return;
	}
	break;
		break;
	case eMsg_QueryCharInfo_CL:
	{
		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			break;
		}
	}
		break;
	case eMsg_CreateChar_CL:
	{
	}
		break;
	case eMsg_DeleteChar_CL:
	{
	}
		break;
	case eMsg_EnterGame_CL:
	{

	}
		break;
	case eMsg_BackToLogin_CL:
	{

	}
	break;
	default:
	{
		ERRMSG("未处理消息%d\n", pPack->GetMsgID());
	}
	break;
	};

	g_ClientPackMgr.Free(pPack);

	LEAVE_FUNCTION_FOXNET
}

void ClientLink::OnDisconnect()
{
	//// 通知World
	//if (getAccountID() != 0
	//        && getClientState() != eLinkState_LoginSuccess)
	{
// 		SvrMsg_DeleteUser_World	pack;
// 		pack.nAccountID = GetAccountID();
//
// 		Df_Master.SendMsgToWorld(&pack, sizeof(pack));
	}
}

bool ClientLink::SendMsg(PackCommon* pPack)
{
	ENTER_FUNCTION_FOXNET
	char* ptr = NULL;
	int	nMaxWriteSize = 0;
	GetSendBuffPtr(&ptr, nMaxWriteSize);

	if (nMaxWriteSize < pPack->GetPackSize())
	{
		return false;
	}

	WriteBuf	buffer((UINT8*)ptr, nMaxWriteSize);
	pPack->Pack(buffer);

	return CompleteSend(buffer.GetReadSize(), pPack->GetMsgID());
	LEAVE_FUNCTION_RETURN_FALSE
}

void ClientLink::SetWorldSvrKick()
{
	ENTER_FUNCTION_FOXNET
	m_bWorldSvrKick = true;
	LEAVE_FUNCTION_FOXNET
}
bool ClientLink::CheckWorldSvrKick()
{
	return m_bWorldSvrKick;
}
