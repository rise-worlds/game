#ifndef __OTLDATABASE_H__
#define __OTLDATABASE_H__

#define OTL_ODBC_MSSQL_2005
#define OTL_STL

#ifndef _WIN32
#define OTL_ODBC_UNIX
#endif
#include "otlv4.h"

#include "../Utility/CTimer.h"

#include <vector>
typedef otl_connect*	DBConnectPtr;
typedef std::vector< DBConnectPtr > DBConnect;

typedef struct tagCONNECT_INFO
{
	unsigned int						nTimeOut;
	char								strConnect[100];
} CONNECT_INFO, *LPCONNECT_INFO;

class DBTransaction;
class CDBWorkThread;

#pragma warning(push)
#pragma warning(disable: 4251)

class COMMON_API COTLDataBase {
public:
	COTLDataBase(void);
	virtual ~COTLDataBase();
	
	bool	Init(int nWorkThreadNum, LPCONNECT_INFO lpConnectInfo, int nConnectNum);
	void	Shutdown();
	bool	AddConnect(LPCONNECT_INFO lpConnectInfo, int nConnectNum);

	void	Update();
	bool	AddTransaction(DBTransaction* pDBTansaction, unsigned int nContext = 0);

private:
	typedef std::vector<CDBWorkThread*>	WorkThreadVec;
	typedef std::vector<unsigned int>	WorkQueueVec;
	WorkThreadVec	m_WorkThreads;
	WorkQueueVec	m_WorkQueueAmount;
};

#pragma warning(pop)

#endif