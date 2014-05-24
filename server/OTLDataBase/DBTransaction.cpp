
#include "DBTransaction.h"


DBTransaction::DBTransaction()
{
	m_IsSucceed = false;
}


DBTransaction::~DBTransaction()
{
}

int DBTransaction::OnExecute(DBConnectPtr* connect, int nConnectAmount)
{
	return DBTransactionSuccess;
}

void DBTransaction::OnFinish()
{
}