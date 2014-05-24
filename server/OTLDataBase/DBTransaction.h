#ifndef __DBTRANSACTION_H__
#define __DBTRANSACTION_H__

#include "OTLDataBase.h"

#define DBTransactionSuccess	(-1)

class DBTransaction
{
public:
	DBTransaction();
	~DBTransaction();

	virtual int OnExecute(DBConnectPtr* connect, int nConnectAmount);
	virtual void OnFinish();

protected:
	bool		m_IsSucceed;

	void SetResult(bool IsSucceed)
	{
		m_IsSucceed = IsSucceed;
	}
};

#endif