#include "stdafx.h"
#include "CMaster.h"
#include "mmsystem.h"
#include "common/Version.h"
#pragma comment(lib, "winmm.lib")

//-------------------------------------------------------------------------------------------------
// Network Callback Functions
//-------------------------------------------------------------------------------------------------
NetObject* CreateAcceptedObject()
{
	return CSvrLinkMgr::GetSingleton().AllocSession(eSvrType_Temp);
}

void DestroyAcceptedObject(NetObject *pNetworkObject)
{
	CSvrLinkMgr::GetSingleton().FreeSession((CSvrSession*)pNetworkObject);
}

//-------------------------------------------------------------------------------------------------
// Console Callback Functions
//-------------------------------------------------------------------------------------------------
void Console_GetVer(const char* strCmd)
{
	printf("Current Ver: %u", GetSvrVersion());
}

void Console_Test(const char*)
{
	// 	SvrMsg_QueryOneFriendData_DBSvr*	pPack	= (SvrMsg_QueryOneFriendData_DBSvr*)g_SvrPackMgr.AllocPack(eSvrMsg_QueryOneFriendData_DBSvr);
	// 	pPack->nAccountID	= 1;
	// 	pPack->nFriendID	= 2;
	// 	pPack->nFriendType	= 0;
	// 	pPack->strName[0]	= '\0';
	// 	pPack->strRemark[0]	= '\0';
	//
	// 	CTransaction_QueryOneFriend* pTransaction	= new CTransaction_QueryOneFriend;
	// 	pTransaction->queryinfo	= (SvrMsg_QueryOneFriendData_DBSvr*)pPack;
	//
	// 	Df_Master.GetOTLDatabase().AddTransaction(pTransaction);
}

void Console_BugCount(const char* strCmd)
{
	Common::CDebugInfoHelper::getSingleton().BugCount();
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
		Common::SConsoleCmd	consoleCMD[] =
		{
			{ "GetVer", &Console_GetVer, "版本号" },
			{ "Test", &Console_Test, "" },
			{ "BugCount", &Console_BugCount, "BugCount" },
		};

		Common::Console::getSingle().AddCommand(consoleCMD, sizeof(consoleCMD) / sizeof(*consoleCMD));
	}

	// Init Network
	{
		m_pAsioNetwork = new AsioNetwork;

		IOHANDLER_DESC desc;

		desc.nIoHandlerKey = CLIENT_IOHANDLER_KEY;
		desc.nMaxAcceptSession = 255;
		desc.nMaxConnectSession = 5;
		desc.nSendBufferSize = inifile.ReadInt("Network", "SvrSendBuf");
		desc.nRecvBufferSize = inifile.ReadInt("Network", "SvrRecvBuf");
		desc.nTimeOut = inifile.ReadInt("Network", "SvrTimeout");
		desc.nMaxPacketSize = inifile.ReadInt("Network", "SvrMaxPackSize");
		desc.nNumberOfIoThreads = inifile.ReadInt("Network", "SvrIoThread");
		desc.fnCreateAcceptedObject = CreateAcceptedObject;
		desc.fnDestroyAcceptedObject = DestroyAcceptedObject;

		if (!m_pAsioNetwork->Init(&desc, 1))
		{
			ERRMSG("InitNetwork() Error!!!");
			return false;
		}
	}

	m_pOTLDatabase = new COTLDatabase;
	// 	CONNECT_INFO	info;
	// 	info.nTimeOut	= 5;
	// 	strcpy(info.strConnect, "sa/ubuntu@test1");
	// 	m_pOTLDatabase->Init(3, &info, 1);

	// Init Global Data
	{
		new CDBUserMgr;
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
		m_CheckActionLogTable.SetTimer(60 * 1000);
		SetWorldAmount(0);

		SetDBThreadAmount(inifile.ReadInt("DBAgent", "DBThreadAmount"));
		if (GetDBThreadAmount() == 0)
		{
			SetDBThreadAmount(1);
		}
	}
	m_strActionLogTable = "";
	m_tCurActionLogTable = 0;
	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}

bool	CMaster::Terminate()
{
	ENTER_FUNCTION_FOXNET
		if (Df_DBUserMgr.getSingletonPtr())
		{
		delete Df_DBUserMgr.getSingletonPtr();
		}

	if (m_pOTLDatabase)
	{
		m_pOTLDatabase->Shutdown();
		delete 	m_pOTLDatabase;
		m_pOTLDatabase = NULL;
	}

	if (m_pAsioNetwork)
	{
		m_pAsioNetwork->Shutdown();
		delete m_pAsioNetwork;
		m_pAsioNetwork = NULL;
	}

	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}

void	CMaster::Update()
{
	ENTER_FUNCTION_FOXNET
		UpdateFps();
	m_pAsioNetwork->Update();
	m_pOTLDatabase->Update();

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
			m_pAsioNetwork->Connect(CLIENT_IOHANDLER_KEY, pSession, (char*)(GetConfigSvrIP().c_str()), GetConfigSvrPort());
			pSession->SetLinkState(eLinkState_Connecting);
		}

	}
	if (m_CheckActionLogTable.IsExpired())
	{
		time_t long_time;
		time(&long_time);                /* Get time as long integer. */

		struct tm objTime;
		localtime_s(&objTime, &long_time); /* Convert to local time. */

		time_t tCurActionLogTable = (objTime.tm_year + 1900) * 10000 +
			(objTime.tm_mon + 1) * 100 +
			objTime.tm_mday;
		if (tCurActionLogTable > m_tCurActionLogTable)
		{
			m_tCurActionLogTable = tCurActionLogTable;
			char szName[64] = "";
			sprintf_s(szName, "ActionLog%u", m_tCurActionLogTable);
			m_strActionLogTable = szName;
			CTransaction_CreateActionLogTable* pTransaction = new CTransaction_CreateActionLogTable;
			this->GetOTLDatabase().AddTransaction(pTransaction);
		}

	}
	LEAVE_FUNCTION_FOXNET
}

void	CMaster::UpdateFps()
{
#define FPS_UPDATE_TIME	1000
#define	FPS_WARNING_COUNT	5

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
}

bool	CMaster::InitDatabase(int nThreadAmount, CONNECT_INFO* ptr, int nAmount)
{
	bool bOK = m_pOTLDatabase->Init(nThreadAmount, ptr, nAmount);
	CHECKF(bOK);

	time_t long_time;
	time(&long_time);                /* Get time as long integer. */

	struct tm objTime;
	localtime_s(&objTime, &long_time); /* Convert to local time. */

	m_tCurActionLogTable = (objTime.tm_year + 1900) * 10000 +
		(objTime.tm_mon + 1) * 100 +
		objTime.tm_mday;
	char szName[64] = "";
	sprintf_s(szName, "ActionLog%u", m_tCurActionLogTable);
	m_strActionLogTable = szName;

	CTransaction_CreateActionLogTable* pTransaction = new CTransaction_CreateActionLogTable;
	this->GetOTLDatabase().AddTransaction(pTransaction);
	return bOK;
}
const char* CMaster::GetActionLogTable()
{
	CHECKF(m_strActionLogTable != "");
	return m_strActionLogTable.c_str();
}