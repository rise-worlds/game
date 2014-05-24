// OTLDataBase.cpp : 定义 DLL 应用程序的导出函数。
//

#include "OTLDataBase.h"
#include "DBTransaction.h"
#include "../Utility/CThread.h"
#include "../Utility/RingBuffer.h"
#include "../Utility/CTimer.h"
#include "../Utility/FunctionGuard.h"

#define CONNECT_MAXAMOUNT 20

class PingTransaction : public DBTransaction
{
public:
	virtual int OnExecute(DBConnectPtr* connect, int nConnectAmount)
	{
		ENTER_FUNCTION_FOXNET
			try
		{
			(connect[m_nConnectID])->direct_exec("select 1");
		}
		catch (otl_exception& p)
		{
			printf("%s\n", p.msg);	// print out error message
			printf("%s\n", p.sqlstate);	// print out SQLSTATE
			printf("%s\n", p.stm_text);	// print out SQL that caused the error
			printf("%s\n", p.var_info);	// print out the variable that caused the error

			(connect[m_nConnectID])->connected = 0;
		}

		return DBTransactionSuccess;
		LEAVE_FUNCTION_RETURN_0
	}

	virtual void OnFinish()
	{
	}

	int	m_nConnectID;
};

class CDBWorkThread : public Common::IThreadInterface
{
public:
	typedef std::vector<DBTransaction*>	TransactionBuf;

public:
	CDBWorkThread()
	{
		ENTER_FUNCTION_FOXNET
			m_bIsExit = false;
		m_ConnectInfo = NULL;
		LEAVE_FUNCTION_FOXNET
	}

	~CDBWorkThread()
	{
		ENTER_FUNCTION_FOXNET
			for (int i = 0; i < m_nConnectNum; i++)
			{
			otl_connect* pConnect = m_Connects[i];
			pConnect->logoff();
			delete pConnect;
			}

		delete[] m_ConnectInfo;
		LEAVE_FUNCTION_FOXNET
	}

	bool	Init(COTLDataBase* pDatabase, LPCONNECT_INFO lpConnectInfo, int nConnectNum)
	{
		ENTER_FUNCTION_FOXNET
			memset(m_vecConnectErrErr, 0, sizeof(m_vecConnectErrErr));
		memset(m_Connects, 0, sizeof(m_Connects));
		m_pDatabase = pDatabase;

		m_ConnectInfo = new CONNECT_INFO[nConnectNum];
		memcpy(m_ConnectInfo, lpConnectInfo, sizeof(CONNECT_INFO)*nConnectNum);
		m_nConnectNum = nConnectNum;

		bool bIsSuccess = true;;
		// �������ݿ�
		for (int i = 0; i < nConnectNum; i++)
		{
			try
			{
				otl_connect* pConnect = new otl_connect;
				m_Connects[i] = pConnect;

				pConnect->rlogon(lpConnectInfo[i].strConnect);
				pConnect->set_timeout(lpConnectInfo[i].nTimeOut);
			}
			catch (otl_exception& p)
			{
				bIsSuccess = false;

				printf("%s\n", p.msg);	// print out error message
				printf("%s\n", p.sqlstate);	// print out SQLSTATE
				printf("%s\n", p.stm_text);	// print out SQL that caused the error
				printf("%s\n", p.var_info);	// print out the variable that caused the error
			}
		}

		m_CheckConnect.SetTimer(10000);
		m_PingConnect.SetTimer(30000);

		return bIsSuccess;
		LEAVE_FUNCTION_RETURN_FALSE
	}

	bool AddConnect(LPCONNECT_INFO lpConnectInfo, int nConnectNum)
	{
		ENTER_FUNCTION_FOXNET
			memcpy(m_ConnectInfo + m_nConnectNum, lpConnectInfo, sizeof(CONNECT_INFO)*nConnectNum);

		// �������ݿ�
		for (int i = 0; i < nConnectNum; i++)
		{
			try
			{
				otl_connect* pConnect = new otl_connect;
				m_Connects[m_nConnectNum + i] = pConnect;

				pConnect->rlogon(lpConnectInfo[i].strConnect);
				pConnect->set_timeout(lpConnectInfo[i].nTimeOut);
			}
			catch (otl_exception& p)
			{
				printf("%s\n", p.msg);	// print out error message
				printf("%s\n", p.sqlstate);	// print out SQLSTATE
				printf("%s\n", p.stm_text);	// print out SQL that caused the error
				printf("%s\n", p.var_info);	// print out the variable that caused the error
			}
		}

		m_nConnectNum += nConnectNum;

		return true;
		LEAVE_FUNCTION_RETURN_FALSE
	}

	virtual void					EndThread()
	{
		ENTER_FUNCTION_FOXNET
			m_bIsExit = true;
		if (GetHandle())
		{
			Common::Thread::JoinThread(GetHandle());
		}

		// 		DBConnect::iterator it	= m_Connects.begin();
		// 		while (it != m_Connects.end())
		// 		{
		// 			//m_pDatabase->OnShutdown(*it);
		// 			it++;
		// 		}
		LEAVE_FUNCTION_FOXNET
	}

	virtual int						Run()
	{
		ENTER_FUNCTION_FOXNET
			while (!m_bIsExit)
			{
			TransactionBuf vecWaitTransaction;
			TransactionBuf vecFinishTransaction;
			{
				Common::Thread::CGuard guard(m_WaitLock.GetLock());
				vecWaitTransaction = m_WaitTransaction;
				m_WaitTransaction.clear();
			}

			for (unsigned int i = 0; i<vecWaitTransaction.size(); i++)
			{
				DBTransaction*	pTransaction = vecWaitTransaction[i];
				if (pTransaction)
				{
					int nResult = pTransaction->OnExecute(m_Connects, m_nConnectNum);
					if (nResult != DBTransactionSuccess
						&& nResult >= 0 && nResult < m_nConnectNum)
					{
						m_vecConnectErrErr[nResult]++;
					}

					vecFinishTransaction.push_back(pTransaction);
				}
			}

			vecWaitTransaction.clear();

			{
				Common::Thread::CGuard guard(m_FinishLock.GetLock());
				m_FinishTransaction.insert(m_FinishTransaction.end(), vecFinishTransaction.begin(), vecFinishTransaction.end());
				vecFinishTransaction.clear();
			}

			if (m_CheckConnect.IsExpired())
			{
				for (int i = 0; i < m_nConnectNum; i++)
				{
					DBConnectPtr ptr = m_Connects[i];
					bool	bIsResetConnect = false;

					do
					{
						if (ptr->connected == 0)
						{
							bIsResetConnect = true;
							break;
						}

						if (m_vecConnectErrErr[i] != 0)
						{
							PingTransaction ping;
							ping.m_nConnectID = i;

							ping.OnExecute(m_Connects, m_nConnectNum);
							m_vecConnectErrErr[i] = 0;
						}

					} while (0);


					if (bIsResetConnect)
					{
						try
						{
							ptr->logoff();
							delete ptr;

							otl_connect* ptr = new otl_connect;
							m_Connects[i] = ptr;
							m_vecConnectErrErr[i] = 0;

							ptr->rlogon(m_ConnectInfo[i].strConnect);
						}
						catch (otl_exception& p)
						{
							printf("%s\n", p.msg);	// print out error message
							printf("%s\n", p.sqlstate);	// print out SQLSTATE
							printf("%s\n", p.stm_text);	// print out SQL that caused the error
							printf("%s\n", p.var_info);	// print out the variable that caused the error
						}
					}

				}
			}

			if (m_PingConnect.IsExpired())
			{
				for (int i = 0; i < m_nConnectNum; i++)
				{
					DBConnectPtr ptr = m_Connects[i];
					bool	bIsResetConnect = false;

					if (ptr->connected == 0
						|| m_vecConnectErrErr[i] != 0)
					{
						continue;
					}

					PingTransaction ping;
					ping.m_nConnectID = i;

					ping.OnExecute(m_Connects, m_nConnectNum);
				}
			}


			Common::Thread::Sleep(1);
			}

		return 0;
		LEAVE_FUNCTION_RETURN_0
	}

	void	AddTransaction(DBTransaction* pDBTansaction)
	{
		ENTER_FUNCTION_FOXNET
			Common::Thread::CGuard guard(m_WaitLock.GetLock());
		m_WaitTransaction.push_back(pDBTansaction);
		LEAVE_FUNCTION_FOXNET
	}

	TransactionBuf	GetFinish()
	{
		ENTER_FUNCTION_FOXNET
			Common::Thread::CGuard guard(m_FinishLock.GetLock());
		TransactionBuf result = m_FinishTransaction;
		m_FinishTransaction.clear();
		return result;
		LEAVE_FUNCTION_FOXNET
			return TransactionBuf();
	}

private:
	volatile bool	m_bIsExit;
	DBConnectPtr	m_Connects[CONNECT_MAXAMOUNT];
	COTLDataBase*	m_pDatabase;

	TransactionBuf	m_WaitTransaction;
	TransactionBuf	m_FinishTransaction;
	Common::Thread::CLock m_WaitLock;
	Common::Thread::CLock m_FinishLock;

	LPCONNECT_INFO	m_ConnectInfo;
	volatile int	m_nConnectNum;

	int				m_vecConnectErrErr[CONNECT_MAXAMOUNT];
	Common::SGtimer	m_CheckConnect;
	Common::SGtimer	m_PingConnect;
};

// 这是已导出类的构造函数。
// 有关类定义的信息，请参阅 OTLDataBase.h
COTLDataBase::COTLDataBase()
{
	ENTER_FUNCTION_FOXNET
		otl_connect::otl_initialize(1);
	LEAVE_FUNCTION_FOXNET
}

COTLDataBase::~COTLDataBase()
{

}

bool	COTLDataBase::Init(int nWorkThreadNum, LPCONNECT_INFO lpConnectInfo, int nConnectNum)
{
	ENTER_FUNCTION_FOXNET
		m_WorkThreads.resize(nWorkThreadNum);
	m_WorkQueueAmount.resize(nWorkThreadNum);

	for (int i = 0; i < nWorkThreadNum; i++)
	{
		CDBWorkThread* pWorkThread = new CDBWorkThread;
		pWorkThread->Init(this, lpConnectInfo, nConnectNum);

		m_WorkThreads[i] = pWorkThread;
		m_WorkQueueAmount[i] = 0;
	}

	for (int i = 0; i < nWorkThreadNum; i++)
	{
		m_WorkThreads[i]->StartThread();
	}

	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}

void	COTLDataBase::Shutdown()
{
	ENTER_FUNCTION_FOXNET
		WorkThreadVec::iterator	it = m_WorkThreads.begin();
	while (it != m_WorkThreads.end())
	{
		CDBWorkThread* pWorkThread = *it;
		pWorkThread->EndThread();
		delete	pWorkThread;

		it++;
	}

	m_WorkThreads.clear();

	LEAVE_FUNCTION_FOXNET
}

bool	COTLDataBase::AddConnect(LPCONNECT_INFO lpConnectInfo, int nConnectNum)
{
	ENTER_FUNCTION_FOXNET
		int nWorkThreadNum = (int)m_WorkThreads.size();

	for (int i = 0; i < nWorkThreadNum; i++)
	{
		m_WorkThreads[i]->AddConnect(lpConnectInfo, nConnectNum);
	}

	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}

void	COTLDataBase::Update()
{
	ENTER_FUNCTION_FOXNET
		for (unsigned int nIndex = 0; nIndex<m_WorkThreads.size(); nIndex++)
		{
		CDBWorkThread* pWorkThread = m_WorkThreads[nIndex];

		CDBWorkThread::TransactionBuf vecSyncResult(pWorkThread->GetFinish());
		for (unsigned int i = 0; i<vecSyncResult.size(); i++)
		{
			DBTransaction* pDBTansaction = vecSyncResult[i];
			pDBTansaction->OnFinish();
		}

		if (m_WorkQueueAmount[nIndex] > vecSyncResult.size())
		{
			m_WorkQueueAmount[nIndex] -= int(vecSyncResult.size());
		}
		else
		{
			m_WorkQueueAmount[nIndex] = 0;
		}
		}
	LEAVE_FUNCTION_FOXNET
}

bool	COTLDataBase::AddTransaction(DBTransaction* pDBTansaction, unsigned int nContext)
{
	ENTER_FUNCTION_FOXNET

		if (nContext == 0)
		{
		int nIndex = 0;
		for (unsigned int i = 0; i<m_WorkQueueAmount.size(); i++)
		{
			if (m_WorkQueueAmount[i] < m_WorkQueueAmount[nIndex])
			{
				nIndex = i;
			}
		}

		m_WorkThreads[nIndex]->AddTransaction(pDBTansaction);
		m_WorkQueueAmount[nIndex]++;
		}
		else
		{
			int nIndex = nContext % m_WorkThreads.size();
			m_WorkThreads[nIndex]->AddTransaction(pDBTansaction);
			m_WorkQueueAmount[nIndex]++;
		}

	return true;
	LEAVE_FUNCTION_RETURN_FALSE
}
