#include "stdafx.h"
#include "SessionPool.h"
#include <assert.h>
#include "SessionList.h"
#include "Session.h"

SessionPool::SessionPool(boost::asio::io_service& ioservice, unsigned int nSize, unsigned int nSendBufferSize, unsigned int nRecvBufferSize, unsigned int nMaxPacketSize, unsigned int nTimeOutTick, unsigned int nIndexStart, bool bAcceptSocket)
{
    ENTER_FUNCTION_FOXNET
	m_pList = NULL;
	Create(ioservice, nSize, nSendBufferSize, nRecvBufferSize, nMaxPacketSize, nTimeOutTick, nIndexStart, bAcceptSocket);
    LEAVE_FUNCTION_FOXNET
}

SessionPool::~SessionPool()
{
    ENTER_FUNCTION_FOXNET
	if (m_pList) delete m_pList;
    LEAVE_FUNCTION_FOXNET
}

Session*		SessionPool::Alloc()
{
    ENTER_FUNCTION_FOXNET
	m_pList->Lock();

	if (m_pList->empty())
	{
		m_pList->Unlock();

		return NULL;
	}

// 	Session *pSession = m_pList->front();
// 	m_pList->pop_front();

	Session* pSession = m_pList->back();
	m_pList->pop_back();

	m_pList->Unlock();

	return pSession;
    LEAVE_FUNCTION_RETURN_NULL
}

void			SessionPool::Free(Session* pSession)
{
    ENTER_FUNCTION_FOXNET
	m_pList->Lock();

	assert(m_pList->size() < m_nMaxSize);

	m_pList->push_back(pSession);

	m_pList->Unlock();
    LEAVE_FUNCTION_FOXNET
}

int				SessionPool::GetLength()
{
    ENTER_FUNCTION_FOXNET
	m_pList->Lock();

	int size = (int)(m_pList->size());

	m_pList->Unlock();

	return size;
    LEAVE_FUNCTION_RETURN_0
}

void			SessionPool::Create(boost::asio::io_service& ioservice, unsigned int nSize, unsigned int nSendBufferSize, unsigned int nRecvBufferSize, unsigned int nMaxPacketSize, unsigned int nTimeOutTick, unsigned int nIndexStart, bool bAcceptSocket)
{
    ENTER_FUNCTION_FOXNET
	m_nMaxSize			= nSize;

	m_pList = new SessionList;

	Session *pSession;

	for (unsigned int i = 0; i < nSize; ++i)
	{
		pSession = new Session(ioservice, nSendBufferSize, nRecvBufferSize, nMaxPacketSize, nTimeOutTick);

		pSession->SetIndex(nIndexStart + i);

		if (bAcceptSocket)
		{
			pSession->SetAcceptSocketFlag();
		}

		m_pList->push_back(pSession);
	}
    LEAVE_FUNCTION_FOXNET
}
