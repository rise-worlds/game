// AsioNetwork.cpp : 定义 DLL 应用程序的导出函数。
//

#include "stdafx.h"
#include "AsioNetwork.h"
#include "NetObject.h"
#include <assert.h>
#include "IoHandler.h"

AsioNetwork::AsioNetwork()
{
	ENTER_FUNCTION_FOXNET
		m_bShutdown = false;
#ifdef LW_MSG_LOG
	m_tTime = GetTickCount();
	char sz[1024] = "";
	::GetModuleFileName(NULL, sz, 1023);
	strcpy_s(m_szModuleName, strrchr(sz, '\\') + 1);
	m_nTimes = 0;
#endif
	LEAVE_FUNCTION_FOXNET
}

AsioNetwork::~AsioNetwork()
{
	ENTER_FUNCTION_FOXNET
		if (!m_bShutdown)		Shutdown();
	LEAVE_FUNCTION_FOXNET
}

bool				AsioNetwork::Init(LPIOHANDLER_DESC lpDesc, unsigned int nNumberofIoHandlers)
{
	ENTER_FUNCTION_FOXNET
		for (unsigned int i = 0; i < nNumberofIoHandlers; ++i)
		{
			CreateIoHandler(lpDesc + i);
		}

	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}

bool				AsioNetwork::StartListen(unsigned int nIoHandlerKey, char *pIP, unsigned short nPort)
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

	assert(it != m_mapIoHandlers.end());

	return it->second->StartListen(pIP, nPort);
	LEAVE_FUNCTION_RETURN_FALSE
}

void				AsioNetwork::Update()
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it;
#ifdef LW_MSG_LOG
	Thread::CGuard autoLock(m_Mutex.GetLock());
	bool bTimeOutSave = false;
	const int PER_CHECK_TIME = 5 * 60 * 1000;//X分钟
	time_t nCurrentTime = GetTickCount();
	int nCurActiveSesstion = 0;
	if (nCurrentTime > m_tTime + PER_CHECK_TIME)
	{
		bTimeOutSave = true;
		m_tTime = nCurrentTime;
		m_nTimes++;
	}
	MAP_MSG_INFO mapSend;
	MAP_MSG_INFO mapRec;
	MAP_LARGER_MSG mapLargerMsg;
#endif
	for (it = m_mapIoHandlers.begin(); it != m_mapIoHandlers.end(); ++it)
	{
		it->second->Update();
#ifdef LW_MSG_LOG
		if (bTimeOutSave)
		{
			SessionList* pSesstionset = it->second->GetActiveSession();
			if (!pSesstionset)
			{
				return;
			}
			nCurActiveSesstion += pSesstionset->size();
			SessionList::iterator iter = pSesstionset->begin();
			for (; iter != pSesstionset->end(); iter++)
			{
				MAP_MSG_INFO* pSendMap = (*iter)->GetSendMap();
				MAP_MSG_INFO::iterator iterMap = pSendMap->begin();
				//发送队列
				for (; iterMap != pSendMap->end(); iterMap++)
				{
					MAP_MSG_INFO::iterator iterTarget = mapSend.find(iterMap->first);
					if (iterTarget != mapSend.end())
					{
						((*iterTarget).second).nNum += ((*iterMap).second).nNum;
						((*iterTarget).second).nTotalUseTime += ((*iterMap).second).nTotalUseTime;
						((*iterTarget).second).nMillisecond += ((*iterMap).second).nMillisecond;
					}
					else
					{
						MSG_INFO info;
						info.nNum = ((*iterMap).second).nNum;
						info.nTotalUseTime = ((*iterMap).second).nTotalUseTime;
						info.nMillisecond = ((*iterMap).second).nMillisecond;
						mapSend[iterMap->first] = info;
					}
				}
				MAP_MSG_INFO* pRecMap = (*iter)->GetRecMap();
				iterMap = pRecMap->begin();
				//接收队列
				for (; iterMap != pRecMap->end(); iterMap++)
				{
					MAP_MSG_INFO::iterator iterTarget = mapRec.find(iterMap->first);
					if (iterTarget != mapRec.end())
					{
						((*iterTarget).second).nNum += ((*iterMap).second).nNum;
						((*iterTarget).second).nTotalUseTime += ((*iterMap).second).nTotalUseTime;
						((*iterTarget).second).nMillisecond += ((*iterMap).second).nMillisecond;
					}
					else
					{
						MSG_INFO info;
						info.nNum = ((*iterMap).second).nNum;
						info.nTotalUseTime = ((*iterMap).second).nTotalUseTime;
						info.nMillisecond = ((*iterMap).second).nMillisecond;
						mapRec[iterMap->first] = info;
					}
				}
				//超大消息记录
				MAP_LARGER_MSG* pLargerMsg = (*iter)->GetLargerMsgMap();
				MAP_LARGER_MSG::iterator iterLargerMsg = pLargerMsg->begin();
				for (; iterLargerMsg != pLargerMsg->end(); iterLargerMsg++)
				{
					mapLargerMsg[iterLargerMsg->first] = iterLargerMsg->second;
				}
			}
		}
#endif
	}
#ifdef LW_MSG_LOG
	if (bTimeOutSave)
	{
		//所有sesstion发送接收信息
		char szPath[128] = "";
		sprintf_s(szPath, "log/MsgStat/%s", m_szModuleName);
		FILE* fp = basecode::BeginLog(szPath);
		CHECK(fp);
		basecode::AddLog(fp,
			"★连接数★ %s 当前的活动连接数[%u]!",
			m_szModuleName,
			nCurActiveSesstion);
		basecode::AddLog(fp,
			"★发送★ %s 在 %u 分钟内的消息数!",
			m_szModuleName,
			m_nTimes * (PER_CHECK_TIME / (60 * 1000)));
#ifdef _DEBUG
		printf_s("%s 在 %u 分钟内发送的消息数!\n",
			m_szModuleName,
			m_nTimes * (PER_CHECK_TIME / (60 * 1000)));
#endif
		char szPerCounter[64] = "";
		char szMillisecond[64] = "";
		MAP_MSG_INFO::iterator iterMap = mapSend.begin();
		for (; iterMap != mapSend.end(); iterMap++)
		{
			char szData[100] = "";
			strcpy_s(szPerCounter, _i64toa(((*iterMap).second).nTotalUseTime, szData, 10));
			strcpy_s(szMillisecond, _i64toa(((*iterMap).second).nMillisecond, szData, 10));
			basecode::AddLog(fp,
				"Send Msg[%5u] Num[%8u] PerformanceCounter[%14s] Millisecond[%12s]",
				(*iterMap).first,
				((*iterMap).second).nNum,
				szPerCounter,
				szMillisecond);
		}
		basecode::AddLog(fp,
			"★接收★ %s 在 %u 分钟内的消息数!",
			m_szModuleName,
			m_nTimes * (PER_CHECK_TIME / (60 * 1000)));
#ifdef _DEBUG
		printf_s("%s 在 %u 分钟内接收的消息数!\n",
			m_szModuleName,
			m_nTimes * (PER_CHECK_TIME / (60 * 1000)));
#endif
		iterMap = mapRec.begin();
		for (; iterMap != mapRec.end(); iterMap++)
		{
			char szData[100] = "";
			strcpy_s(szPerCounter, _i64toa(((*iterMap).second).nTotalUseTime, szData, 10));
			strcpy_s(szMillisecond, _i64toa(((*iterMap).second).nMillisecond, szData, 10));
			basecode::AddLog(fp,
				"Rec Msg[%5u] Num[%8u] PerformanceCounter[%14s] Millisecond[%12s]",
				(*iterMap).first,
				((*iterMap).second).nNum,
				szPerCounter,
				szMillisecond);
		}

		basecode::AddLog(fp,
			"★超大消息★ %s 消息数[%u]!",
			m_szModuleName,
			mapLargerMsg.size());
		MAP_LARGER_MSG::iterator iterLargerMsg = mapLargerMsg.begin();
		for (; iterLargerMsg != mapLargerMsg.end(); iterLargerMsg++)
		{
			basecode::AddLog(fp,
				"Msg[%5u] Size[%8u]",
				iterLargerMsg->first,
				iterLargerMsg->second);
		}
		basecode::EndLog(fp);
	}
#endif
	LEAVE_FUNCTION_FOXNET
}

void				AsioNetwork::Shutdown()
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER		it;
	IoHandler				*pIoHandler;

	for (it = m_mapIoHandlers.begin(); it != m_mapIoHandlers.end(); ++it)
	{
		pIoHandler = it->second;
		pIoHandler->Shutdown();
		delete pIoHandler;
	}
	m_mapIoHandlers.clear();

	m_bShutdown = true;
	LEAVE_FUNCTION_FOXNET
}

unsigned int		AsioNetwork::Connect(unsigned int nIoHandlerKey, NetObject *pNetworkObject, char *pszIP, unsigned short nPort)
{
	ENTER_FUNCTION_FOXNET
		if (pNetworkObject == NULL) return 0;

	IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

	assert(it != m_mapIoHandlers.end());

	return it->second->Connect(pNetworkObject, pszIP, nPort);

	LEAVE_FUNCTION_RETURN_0
}

bool				AsioNetwork::IsListening(unsigned int nIoHandlerKey)
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

	assert(it != m_mapIoHandlers.end());

	return it->second->IsListening();
	LEAVE_FUNCTION_RETURN_FALSE
}

unsigned int		AsioNetwork::GetNumberOfConnections(unsigned int nIoHandlerKey)
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

	assert(it != m_mapIoHandlers.end());

	return it->second->GetNumberOfConnections();
	LEAVE_FUNCTION_RETURN_0
}

void				AsioNetwork::CreateIoHandler(LPIOHANDLER_DESC lpDesc)
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(lpDesc->nIoHandlerKey);
	assert(it == m_mapIoHandlers.end());

	IoHandler *pIoHandler = new IoHandler;

	pIoHandler->Init(this, lpDesc);

	m_mapIoHandlers.insert(IOHANDLER_MAP_PAIR(pIoHandler->GetKey(), pIoHandler));

	LEAVE_FUNCTION_FOXNET
}

unsigned int	AsioNetwork::ConvAddr(const char* strIP)
{
	ENTER_FUNCTION_FOXNET
		boost::asio::ip::address adrs(boost::asio::ip::address::from_string(strIP));
	return adrs.to_v4().to_ulong();
	LEAVE_FUNCTION_RETURN_0
}

std::string	AsioNetwork::ConvAddr(unsigned int nIP)
{
	ENTER_FUNCTION_FOXNET
		boost::asio::ip::address_v4 adrs(nIP);
	return adrs.to_string();
	LEAVE_FUNCTION_FOXNET
		return "";
}

void	AsioNetwork::CloseHandle(unsigned int nNumberofIoHandlers)
{
	ENTER_FUNCTION_FOXNET
		IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nNumberofIoHandlers);

	assert(it != m_mapIoHandlers.end());

	it->second->CloseHandle();
	LEAVE_FUNCTION_FOXNET
}
