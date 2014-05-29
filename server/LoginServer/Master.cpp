#include "stdafx.h"
#include "Master.h"
#include "../AsioNetwork/AsioNetwork.h"
#include "../Utility/Ini.h"
#include "../Utility/Console.h"
#include "../Utility/FunctionGuard.h"
#include "../Utility/Log.h"
#include "ClientLinkMgr.h"
#include "mmsystem.h"
#pragma comment(lib, "winmm.lib")

//-------------------------------------------------------------------------------------------------
// Network Callback Functions
//-------------------------------------------------------------------------------------------------
NetObject* CreateAcceptedObject()
{
	ENTER_FUNCTION_FOXNET

		return CSvrLinkMgr::GetSingle().AllocSession(eSvrType_Temp);

	LEAVE_FUNCTION_FOXNET

	return NULL;
}

void DestroyAcceptedObject(NetObject *pNetworkObject)
{
	ENTER_FUNCTION_FOXNET

		CSvrLinkMgr::GetSingle().FreeSession((CSvrSession*)pNetworkObject);

	LEAVE_FUNCTION_FOXNET
}

NetObject* CreateAcceptedObjectCli()
{
	ENTER_FUNCTION_FOXNET
		//	Df_Master.m_loginObserve.JoinGame();
		return Df_ClientLinkMgr.AllocClient();

	LEAVE_FUNCTION_RETURN_NULL
}

void DestroyAcceptedObjectCli(NetObject *pNetworkObject)
{
	ENTER_FUNCTION_FOXNET
		//	Df_Master.m_loginObserve.LeaveGame();
		// 	if(Df_Master.m_loginObserve.IsInTeam( ((ClientLink*)pNetworkObject)->GetAccountID() ))
		// 	{
		// 		Df_Master.m_loginObserve.LeaveTeam( ((ClientLink*)pNetworkObject)->GetAccountID() );
		// 	}
		Df_ClientLinkMgr.FreeClient((ClientLink*)pNetworkObject);

	LEAVE_FUNCTION_FOXNET
}

//-------------------------------------------------------------------------------------------------
// Console Callback Functions
//-------------------------------------------------------------------------------------------------
void Console_GetVer(const char* strCmd)
{
	printf("Current Ver: %u", GetSvrVersion());
}

void Console_GetPlayerAmount(const char* strCmd)
{
	Common::CParamParse param(strCmd);
	int nIsShowAll = param.GetInt(1);

	Df_ClientLinkMgr.ShowPlayerInfo(nIsShowAll);
}

void Console_BugCount(const char* strCmd)
{
	Common::CDebugInfoHelper::getSingle().BugCount();
}

void Console_StartAcceptClient(const char* strCmd)
{
	Df_Master.SetCanAcceptClient(1);
}

void Console_StopAcceptClient(const char* strCmd)
{
	Df_Master.SetCanAcceptClient(0);
}

unsigned int MyGetTime()
{
	return timeGetTime();
}

bool	CMaster::Init()
{
	ENTER_FUNCTION_FOXNET

	Common::Timer::SetTimeFunction(MyGetTime);
	srand(Common::Timer::GetTime());

	Common::Ini	inifile("config.ini");

	// Init Console Callback
	{
		Common::ConsoleCmd	consoleCMD[] =
		{
			{ "GetVer", &Console_GetVer, "版本号：" },
			{ "GetPlayerAmount", &Console_GetPlayerAmount, "玩家数量" },
			{ "BugCount", &Console_BugCount, "BugCount" },
			{ "StartAcceptClient", &Console_StartAcceptClient, "StartAcceptClient" },
			{ "StopAcceptClient", &Console_StopAcceptClient, "StopAcceptClient" },

		};

		Common::Console::getSingle().AddCommand(consoleCMD, sizeof(consoleCMD) / sizeof(*consoleCMD));
	}

	// Init Network
	{
		m_pAsioNetwork = new AsioNetwork;

		IOHANDLER_DESC desc[2];

		desc[0].nIoHandlerKey = SERVER_IOHANDLER_KEY;
		desc[0].nMaxAcceptSession = 255;
		desc[0].nMaxConnectSession = 5;
		desc[0].nSendBufferSize = inifile.ReadInt("Network", "SvrSendBuf");
		desc[0].nRecvBufferSize = inifile.ReadInt("Network", "SvrRecvBuf");
		desc[0].nTimeOut = inifile.ReadInt("Network", "SvrTimeout");
		desc[0].nMaxPacketSize = inifile.ReadInt("Network", "SvrMaxPackSize");
		desc[0].nNumberOfIoThreads = inifile.ReadInt("Network", "SvrIoThread");
		desc[0].fnCreateAcceptedObject = CreateAcceptedObject;
		desc[0].fnDestroyAcceptedObject = DestroyAcceptedObject;

		desc[1].nIoHandlerKey = CLIENT_IOHANDLER_KEY;

		desc[1].nMaxAcceptSession = inifile.ReadInt("Network", "CliMaxAccept");
		//		m_loginObserve.SetTotalLogin(inifile.ReadInt("Network", "CliMaxLoginUser"));

		desc[1].nMaxConnectSession = 0;
		desc[1].nSendBufferSize = inifile.ReadInt("Network", "CliSendBuf");
		desc[1].nRecvBufferSize = inifile.ReadInt("Network", "CliRecvBuf");
		desc[1].nTimeOut = inifile.ReadInt("Network", "CliTimeout");

		desc[1].nMaxPacketSize = inifile.ReadInt("Network", "CliMaxPackSize");
		desc[1].nNumberOfIoThreads = inifile.ReadInt("Network", "CliIoThread");
		desc[1].fnCreateAcceptedObject = CreateAcceptedObjectCli;
		desc[1].fnDestroyAcceptedObject = DestroyAcceptedObjectCli;

		if (!m_pAsioNetwork->Init(desc, 2))
		{
			ERRMSG("InitNetwork() Error!!!");
			return false;
		}
	}

	// Init Global Data
	{
		new ClientLinkMgr;
	}

	// Init Member
	{
		char	strIni[50] = { 0 };
		inifile.ReadText("CenterSvr", "IP", strIni, sizeof(strIni));
		SetConfigSvrIP(strIni);
		SetConfigSvrPort(inifile.ReadInt("CenterSvr", "Port"));

		inifile.ReadText("IP", "IP1", strIni, sizeof(strIni));
		SetListenIP(strIni);

		SetSvrID(0);
		m_fCurFps = 0.0f;
		m_bIsExit = false;

		m_CheckConnectTimer.SetTimer(2000);

		SetDBSvrID(0);
		SetDBSvrIP(0);
		SetDBSvrPort(0);

		SetWorldAmount(0);

		m_SceneInfo.Reset(1024);

		SetCanAcceptClient(1);
	}

	return true;

	LEAVE_FUNCTION_FOXNET

		return false;
}

bool	CMaster::Terminate()
{
	ENTER_FUNCTION_FOXNET

		if (m_pAsioNetwork)
		{
		m_pAsioNetwork->Shutdown();
		delete m_pAsioNetwork;
		m_pAsioNetwork = NULL;
		}

	if (Df_ClientLinkMgr.getSingletonPtr())
	{
		delete Df_ClientLinkMgr.getSingletonPtr();
	}

	return true;

	LEAVE_FUNCTION_FOXNET

		return false;
}

void	CMaster::Update()
{
	ENTER_FUNCTION_FOXNET
		UpdateFps();
	m_pAsioNetwork->Update();
	//	m_loginObserve.Update();
	if (m_CheckConnectTimer.IsExpired())
	{
		CSvrSession* pSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByType(eSvrType_Config);
		if (!pSession)
		{
			pSession = CSvrLinkMgr::GetSingleton().AllocSession(eSvrType_Config);
			CSvrLinkMgr::GetSingleton().AddSvrLink(pSession);
		}

		if (pSession->GetLinkState() == eLinkState_Disconnect)
		{
			m_pAsioNetwork->Connect(SERVER_IOHANDLER_KEY, pSession, (char*)(GetConfigSvrIP().c_str()), GetConfigSvrPort());
			pSession->SetLinkState(eLinkState_Connecting);
		}

		if (GetDBSvrID() != 0)
		{
			pSession = CSvrLinkMgr::GetSingleton().GetSvrLinkByType(eSvrType_DBAgent);
			if (!pSession)
			{
				pSession = CSvrLinkMgr::GetSingleton().AllocSession(eSvrType_DBAgent);
				pSession->SetServerID(GetDBSvrID());
				CSvrLinkMgr::GetSingleton().AddSvrLink(pSession);
			}

			if (pSession->GetLinkState() == eLinkState_Disconnect)
			{
				std::string strIP = AsioNetwork::ConvAddr(GetDBSvrIP());
				m_pAsioNetwork->Connect(SERVER_IOHANDLER_KEY, pSession, (char*)(strIP.c_str()), GetDBSvrPort());
				pSession->SetLinkState(eLinkState_Connecting);
			}
		}
	}
	LEAVE_FUNCTION_FOXNET
}

void	CMaster::UpdateFps()
{
#define FPS_UPDATE_TIME	1000
#define	FPS_WARNING_COUNT	5

	ENTER_FUNCTION_FOXNET

		static unsigned int s_nCount = 0;
	static unsigned int s_nLastTime = Common::Timer::GetTime();

	s_nCount++;
	unsigned int nCurTime = Common::Timer::GetTime();
	unsigned int nDiffTime = nCurTime >= s_nLastTime ? nCurTime - s_nLastTime : s_nLastTime - nCurTime;
	if (nDiffTime >= FPS_UPDATE_TIME)
	{
		float fFps = 0.0f;
		fFps = ((float)s_nCount * 1000.0f) / (float)nDiffTime;

		s_nCount = 0;
		s_nLastTime = Common::Timer::GetTime();

		m_fCurFps = fFps;

		if (fFps < FPS_WARNING_COUNT)
		{
			WARNINGMSG("Current FPS[%f]", fFps);
		}
	}

	LEAVE_FUNCTION_FOXNET
}