#include "ClientLink.h"
#include "../Utility/FunctionGuard.h"
#include "../ServerMsgDef/SvrLinkMgr.h"
#include "../../common/Packet.h"
#include "../../common/NetworkMsgRegister.h"
#include "../../common/Version.h"
#include "../../common/NetMsgID.h"
#include "ClientLinkMgr.h"
#include "Master.h"

ClientLink::ClientLink()
{
	SetClientState(eLinkState_WaitLogin);
	SetTempClientID(0);
	SetAccountID(0);
	SetKickTimer(KICK_WAIT_TIMER);
	SetWorldSvrID(0);
	m_bWorldSvrKick = false;
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
	//msg.gametime = CGameTime::GetSingleton().GetGameTime();
	//msg.fScale = CGameTime::GetSingleton().GetTimeScale();
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
			break;
		}

		// 比较版本号
		if (pMsg->nCurVer < CLIENT_VERSION_ADMISSION)
		{
			// 版本号旧
			Msg_LoginResult_LC	result;
			result.nErrCode = RC_LoginResult_OldVersion;
			SendMsg(&result);

			break;
		}

		CSvrSession *pDBSesstion = CSvrLinkMgr::GetSingle().GetSvrLinkByType(eSvrType_DBAgent);
		if (!pDBSesstion)
		{
			// 版本号旧
			Msg_LoginResult_LC	result;
			result.nErrCode = RC_LoginResult_OtherError;
			SendMsg(&result);

			break;
		}

		// 发消息给DBServer
		SvrMsg_CheckLogin_DBSvr checkpack;
		checkpack.nLoginUserID = MakeTempUserID(eSvrType_Login, Df_Master.GetSvrID(), GetTempClientID());
		checkpack.strUserName = pMsg->strName;
		pDBSesstion->SendMsg(&checkpack);

		SetClientState(eLinkState_Logining);
	}
		break;
	case eMsg_LoginInfo_CL:
	{
		Msg_LoginInfo_CL* pMsg = (Msg_LoginInfo_CL*)pPack;
		if (GetClientState() != eLinkState_Logining)
		{
			break;
		}

		if (GetDBLoginCode() != RC_LoginResult_Success)
		{
			SetClientState(eLinkState_WaitLogin);

			// 登录失败
			Msg_LoginResult_LC	loginresult;
			loginresult.nErrCode = GetDBLoginCode();
			SendMsg(&loginresult);
		}
		else if (pMsg->strPassword != GetPassword())
		{
			SetClientState(eLinkState_WaitLogin);

			// 登录失败
			Msg_LoginResult_LC	loginresult;
			loginresult.nErrCode = RC_LoginResult_ErrName;
			SendMsg(&loginresult);
		}
		else
		{
			SGuint8 nWorldID = MakeSvrID(GetAccountID(), Df_Master.GetWorldAmount());
			CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, nWorldID);
			if (!pWorldSession)
			{
				SetClientState(eLinkState_WaitLogin);

				// 登录失败
				Msg_LoginResult_LC	loginresult;
				loginresult.nErrCode = RC_LoginResult_OtherError;
				SendMsg(&loginresult);
			}
			else
			{
				//                 Msg_QueueLogin_LC queuLogic;
				//  				if(Df_Master.m_loginObserve.CanLogin())
				//  				{
				// 					if(Df_Master.m_loginObserve.GetTeamSize() > 0)
				// 					{
				// 						//有人在队里
				// 						if(Df_Master.m_loginObserve.GetFront() == m_AccountID)
				// 						{
				//是不是在队里的第一个
				//if(Df_ClientLinkMgr.BindAccountID(this))
				{
					// 登录成功 向World 发添加用户消息
					SvrMsg_AddUser_World	sAddUser;
					sAddUser.nAccountID = GetAccountID();
					sAddUser.strAccountName = GetAccountName();
					SetWorldSvrID(nWorldID);
					pWorldSession->SendMsg(&sAddUser);
				}

				// 							Df_Master.m_loginObserve.Pop_Front();
				// 						}
				// 						else
				// 						{
				// 							if(Df_Master.m_loginObserve.IsInTeam(m_AccountID))
				// 							{
				// 								queuLogic.nLoginType = 1;
				// 								queuLogic.nTime = 120;
				// 								long nPlace = 0;
				// 								Df_Master.m_loginObserve.QueryTeamPlace(m_AccountID, nPlace);
				// 								queuLogic.nBeforPeople = nPlace;
				// 								SendMsg(&queuLogic);
				// 								break;
				// 							}
				// 
				// 							if(!Df_Master.m_loginObserve.InsertTeam(m_AccountID))
				// 							{
				// 								//插入长连接队伍失败则插入短连接
				// 								LPSHORTLINKLOGIN pLoginUser = new SHORTLINKLOGIN;
				// 								pLoginUser->AccountID = m_AccountID;
				// 								pLoginUser->nCountTime = 120;
				// 								strncpy_s(pLoginUser->pAccountName, USER_NAME_LEN - 1, m_AccountName.c_str(), USER_NAME_LEN - 1);
				// 								long nPlace = 0;
				// 								Df_Master.m_loginObserve.QueryShortLinkTeam(pLoginUser, nPlace);
				// 
				// 								queuLogic.nLoginType = 2;
				// 								if(nPlace || !Df_Master.m_loginObserve.InsertShortLinkTeam(pLoginUser))
				// 								{
				// 									//如果短连接也失败，则释放
				// 									SGDelete (pLoginUser);
				// 									queuLogic.nLoginType = 3;
				// 								}
				// 								
				// 								queuLogic.nTime = 120;
				// 								queuLogic.nBeforPeople = nPlace + Df_Master.m_loginObserve.GetTeamSize();
				// 								SendMsg(&queuLogic);
				// 								Disconnect();
				// 							}
				// 							else
				// 							{
				// 								queuLogic.nLoginType = 1;
				// 								queuLogic.nTime = 120;
				// 								long nPlace = 0;
				// 								Df_Master.m_loginObserve.QueryTeamPlace(m_AccountID, nPlace);
				// 								queuLogic.nBeforPeople = nPlace;
				// 								SendMsg(&queuLogic);
				// 								break;
				// 							}
				// 						}
				// 					}
				// 					else
				// 					{
				// 						Df_ClientLinkMgr.BindAccountID(this);
				// 						// 登录成功 向World 发添加用户消息
				// 						SvrMsg_AddUser_World	sAddUser;
				// 						sAddUser.nAccountID	= GetAccountID();
				// 						sAddUser.strAccountName = GetAccountName();
				// 						SetWorldSvrID(nWorldID);
				// 						pWorldSession->SendMsg(&sAddUser);
				// 						Df_Master.m_loginObserve.Pop_Front();
				// 					}
				// 				}
				// 				else
				// 				{
				// 					if(!Df_Master.m_loginObserve.InsertTeam(m_AccountID))
				// 					{
				// 						//插入长连接队伍失败则插入短连接
				// 						LPSHORTLINKLOGIN pLoginUser = new SHORTLINKLOGIN;
				// 						pLoginUser->AccountID = m_AccountID;
				// 						pLoginUser->nCountTime = 120;
				// 						strncpy_s(pLoginUser->pAccountName, USER_NAME_LEN - 1, m_AccountName.c_str(), USER_NAME_LEN - 1);
				// 						long nPlace = 0;
				// 						Df_Master.m_loginObserve.QueryShortLinkTeam(pLoginUser, nPlace);
				// 						queuLogic.nLoginType = 2;
				// 						queuLogic.nTime = 120;
				// 						if(nPlace || !Df_Master.m_loginObserve.InsertShortLinkTeam(pLoginUser))
				// 						{
				// 							//如果短连接也失败，则释放
				// 							SGDelete (pLoginUser);
				// 							queuLogic.nLoginType = 3;
				// 						}
				// 						Disconnect();
				// 						SendMsg(&queuLogic);
				// 					}
				// 					else
				// 					{
				// 						queuLogic.nBeforPeople = Df_Master.m_loginObserve.GetTeamSize();
				// 						queuLogic.nLoginType = 1;
				// 						queuLogic.nTime = 120;
				// 						SendMsg(&queuLogic);
				// 					}
				// 				}
			}
		}
	}
		break;
	case eMsg_QueryCharInfo_CL:
	{
		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			break;
		}

		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingle().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pWorldSession)
		{
			Msg_QueryCharInfo_LC sMsg;
			SendMsg(&sMsg);
			break;
		}

		SetClientState(eLinkState_CharOperating);

		// 发送到World进行角色查询
		SvrMsg_QueryCharInfo_World sQueryCharInfo;
		sQueryCharInfo.nAccountID = GetAccountID();
		pWorldSession->SendMsg(&sQueryCharInfo);
	}
		break;
	case eMsg_CreateChar_CL:
	{
		Msg_CreateChar_CL* pMsg = (Msg_CreateChar_CL*)pPack;
		pMsg->CharInfo.strName[sizeof(pMsg->CharInfo.strName) - 1] = '\0';

		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			break;
		}

		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pWorldSession)
		{
			Msg_CreateCharResult_LC sMsg;
			sMsg.nCreateResult = RC_CreateCharResult_OtherError;
			SendMsg(&sMsg);
			break;
		}

		SetClientState(eLinkState_CharOperating);

		// 发送到World进行添加角色
		SvrMsg_CreateChar_World sCreateChar;
		sCreateChar.nAccountID = GetAccountID();
		memcpy(&sCreateChar.CharInfo, &pMsg->CharInfo, sizeof(sCreateChar.CharInfo));

		pWorldSession->SendMsg(&sCreateChar);
	}
		break;
	case eMsg_DeleteChar_CL:
	{
		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			break;
		}

		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pWorldSession)
		{
			Msg_DeleteCharResult_LC sMsg;
			sMsg.nDeleteResult = RC_DeleteCharResult_OtherError;
			SendMsg(&sMsg);
			break;
		}

		SetClientState(eLinkState_CharOperating);

		// 发送到World进行删除角色
		SvrMsg_DeleteChar_World sDeleteChar;
		sDeleteChar.nAccountID = GetAccountID();
		pWorldSession->SendMsg(&sDeleteChar);
	}
		break;
	case eMsg_EnterGame_CL:
	{
		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			break;
		}

		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pWorldSession)
		{
			Msg_EnterGameResult_LC sMsg;
			sMsg.nResult = RC_EnterGameResult_Unknown;
			SendMsg(&sMsg);
			break;
		}

		SetClientState(eLinkState_CharOperating);

		SvrMsg_EnterGame_World sendtoworld;
		sendtoworld.nAccountID = GetAccountID();

		pWorldSession->SendMsg(&sendtoworld);

	}
		break;
	case eMsg_BackToLogin_CL:
	{
		if (GetClientState() != eLinkState_WaitCharOperation)
		{
			Msg_BackToLoginResult_LC sMsg;
			sMsg.nResult = RC_BackToLoginResult_Fail;
			SendMsg(&sMsg);
			break;
		}

		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pWorldSession)
		{
			Msg_BackToLoginResult_LC sMsg;
			sMsg.nResult = RC_BackToLoginResult_Fail;
			SendMsg(&sMsg);
			break;
		}

		SvrMsg_DeleteUser_World sDeleteUser;
		sDeleteUser.nAccountID = GetAccountID();
		pWorldSession->SendMsg(&sDeleteUser);

		Df_ClientLinkMgr.UnBindAccountID(this);
		SetClientState(eLinkState_WaitLogin);
		SetAccountID(0);

		Msg_BackToLoginResult_LC sMsg;
		sMsg.nResult = RC_BackToLoginResult_Success;
		SendMsg(&sMsg);

	}
		break;
	case eMsg_QueueLogin_LC:
	{
		SGuint8 nWorldID = MakeSvrID(GetAccountID(), Df_Master.GetWorldAmount());
		CSvrSession* pWorldSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByTypeID(eSvrType_World, nWorldID);
		if (!pWorldSession)
		{
			SetClientState(eLinkState_WaitLogin);

			// 登录失败
			Msg_LoginResult_LC	loginresult;
			loginresult.nErrCode = RC_LoginResult_OtherError;
			SendMsg(&loginresult);
		}

		Msg_QueueLogin_LC* pMsg_QueueLogin_LC = static_cast<Msg_QueueLogin_LC*>(pPack);
		if (Msg_QueueLogin_LC::LOGINTYPE_SHORT == pMsg_QueueLogin_LC->nLoginType)
		{
			Disconnect();
			break;
		}
		// 			else
		// 			{
		// 				Msg_QueueLogin_LC queuLogic;
		// 				if(Df_Master.m_loginObserve.CanLogin())
		// 				{
		// 					if(Df_Master.m_loginObserve.GetTeamSize() > 0)
		// 					{
		// 						//有人在队里
		// 						if(Df_Master.m_loginObserve.GetFront() == m_AccountID)
		// 						{
		// 							//是不是在队里的第一个
		// 							Df_ClientLinkMgr.BindAccountID(this);
		// 登录成功 向World 发添加用户消息
		SvrMsg_AddUser_World	sAddUser;
		sAddUser.nAccountID = GetAccountID();
		sAddUser.strAccountName = GetAccountName();
		SetWorldSvrID(nWorldID);
		pWorldSession->SendMsg(&sAddUser);
		//							Df_Master.m_loginObserve.Pop_Front();
		// 						}
		// 						else
		// 						{
		// 							if(Df_Master.m_loginObserve.IsInTeam(m_AccountID))
		// 							{
		// 								queuLogic.nLoginType = 1;
		// 								queuLogic.nTime = 120;
		// 								long nPlace = 0;
		// 								Df_Master.m_loginObserve.QueryTeamPlace(m_AccountID, nPlace);
		// 								queuLogic.nBeforPeople = nPlace;
		// 								SendMsg(&queuLogic);
		// 								break;
		// 							}
		// 
		// 							if(!Df_Master.m_loginObserve.InsertTeam(m_AccountID))
		// 							{
		// 								//插入长连接队伍失败则插入短连接
		// 								LPSHORTLINKLOGIN pLoginUser = new SHORTLINKLOGIN;
		// 								pLoginUser->AccountID = m_AccountID;
		// 								pLoginUser->nCountTime = 120;
		// 								strncpy_s(pLoginUser->pAccountName, USER_NAME_LEN - 1, m_AccountName.c_str(), USER_NAME_LEN - 1);
		// 								long nPlace = 0;
		// 								Df_Master.m_loginObserve.QueryShortLinkTeam(pLoginUser, nPlace);
		// 
		// 								queuLogic.nLoginType = 2;
		// 								if(nPlace || !Df_Master.m_loginObserve.InsertShortLinkTeam(pLoginUser))
		// 								{
		// 									//如果短连接也失败，则释放
		// 									SGDelete (pLoginUser);
		// 									queuLogic.nLoginType = 3;
		// 								}
		// 
		// 								queuLogic.nTime = 120;
		// 								queuLogic.nBeforPeople = nPlace + Df_Master.m_loginObserve.GetTeamSize();
		// 								SendMsg(&queuLogic);
		// 								Disconnect();
		// 							}
		// 							else
		// 							{
		// 								queuLogic.nLoginType = 1;
		// 								queuLogic.nTime = 120;
		// 								long nPlace = 0;
		// 								Df_Master.m_loginObserve.QueryTeamPlace(m_AccountID, nPlace);
		// 								queuLogic.nBeforPeople = nPlace;
		// 								SendMsg(&queuLogic);
		// 								break;
		// 							}
		// 						}
		// 					}
		// 					else
		// 					{
		// 						Df_ClientLinkMgr.BindAccountID(this);
		// 						// 登录成功 向World 发添加用户消息
		// 						SvrMsg_AddUser_World	sAddUser;
		// 						sAddUser.nAccountID	= GetAccountID();
		// 						sAddUser.strAccountName = GetAccountName();
		// 						SetWorldSvrID(nWorldID);
		// 						pWorldSession->SendMsg(&sAddUser);
		// 						Df_Master.m_loginObserve.Pop_Front();
		// 					}
		// 				}
		// 				else
		// 				{
		// 					if(!Df_Master.m_loginObserve.InsertTeam(m_AccountID))
		// 					{
		// 						//插入长连接队伍失败则插入短连接
		// 						LPSHORTLINKLOGIN pLoginUser = new SHORTLINKLOGIN;
		// 						pLoginUser->AccountID = m_AccountID;
		// 						pLoginUser->nCountTime = 120;
		// 						strncpy_s(pLoginUser->pAccountName, USER_NAME_LEN - 1, m_AccountName.c_str(), USER_NAME_LEN - 1);
		// 						long nPlace = 0;
		// 						Df_Master.m_loginObserve.QueryShortLinkTeam(pLoginUser, nPlace);
		// 						queuLogic.nLoginType = 2;
		// 						queuLogic.nTime = 120;
		// 						if(nPlace || !Df_Master.m_loginObserve.InsertShortLinkTeam(pLoginUser))
		// 						{
		// 							//如果短连接也失败，则释放
		// 							SGDelete (pLoginUser);
		// 							queuLogic.nLoginType = 3;
		// 						}
		// 						Disconnect();
		// 						SendMsg(&queuLogic);
		// 					}
		// 					else
		// 					{
		// 						queuLogic.nBeforPeople = Df_Master.m_loginObserve.GetTeamSize();
		// 						queuLogic.nLoginType = 1;
		// 						queuLogic.nTime = 120;
		// 						SendMsg(&queuLogic);
		// 					}
		// 				}
		// 			}
	}
		break;
	default:
		break;
	};

	g_ClientPackMgr.Free(pPack);

	LEAVE_FUNCTION_FOXNET
}

void	ClientLink::OnDisconnect()
{
	ENTER_FUNCTION_FOXNET

		// 	eClientLinkState type =	GetClientState();
		// 	UINT8 nTmpAccountID	= GetAccountID();
		// Í¨ÖŞWorld
		if (GetClientState() == eLinkState_WaitCharOperation
			|| GetClientState() == eLinkState_CharOperating
			|| GetClientState() == eLinkState_Complete)
		{
		if (!m_bWorldSvrKick)
		{
			CSvrSession* pSession = CSvrLinkMgr::GetSingle().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
			if (!pSession)
			{
				return;
			}

			SvrMsg_DeleteUser_World	sDeleteUser;
			sDeleteUser.nAccountID = GetAccountID();

			pSession->SendMsg(&sDeleteUser);
		}
		}

	if (GetClientState() == eLinkState_WaitLogin)
	{
		CSvrSession* pSession = CSvrLinkMgr::GetSingle().GetSvrLinkByTypeID(eSvrType_World, GetWorldSvrID());
		if (!pSession)
		{
			return;
		}
		SvrMsg_LeaveLink_World LeaveLinkmsg;
		LeaveLinkmsg.nAccountID = GetAccountID();
		LeaveLinkmsg.nType = eLinkState_WaitLogin;
		strncpy_s(LeaveLinkmsg.strAccountName, USER_NAME_LEN - 1, GetAccountName().c_str(), USER_NAME_LEN - 1);
		pSession->SendMsg(&LeaveLinkmsg);
	}
	LEAVE_FUNCTION_FOXNET
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

	LEAVE_FUNCTION_FOXNET

		return false;
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
