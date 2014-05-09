#include "stdafx.h"
#include "NetObject.h"
#include <stdio.h>
#include <assert.h>
#include "SendBuf.h"
#include "Session.h"

NetObject::NetObject()
{
	m_pSession = NULL;
}

NetObject::~NetObject()
{

}

void			NetObject::Disconnect(bool bForceDisconnect)
{
    ENTER_FUNCTION_FOXNET
	if (m_pSession)
	{
		m_pSession->Disconnect(bForceDisconnect);
	}
    LEAVE_FUNCTION_FOXNET
}

bool			NetObject::Send(void *pMsg, unsigned short nSize, int nPackLevel)
{
    ENTER_FUNCTION_FOXNET
	if (!m_pSession || m_pSession->HasDisconnectOrdered() || nSize == 0) return false;

    if (!OnPreSendPack(pMsg, nSize, m_pSession->GetSendBufferRatio(), nPackLevel))
    {
        return false;
    }

	return m_pSession->Send((char*)pMsg, nSize);
    LEAVE_FUNCTION_RETURN_FALSE
}

bool			NetObject::SendEx(unsigned int nNumberOfMessages, void **ppMsg, unsigned short *pnSize, int nPackLevel)
{
    ENTER_FUNCTION_FOXNET
	if (!m_pSession || m_pSession->HasDisconnectOrdered()) return false;

    for (unsigned int i=0; i<nNumberOfMessages; i++)
    {
        if (!OnPreSendPack(ppMsg[i], pnSize[i], m_pSession->GetSendBufferRatio(), nPackLevel))
        {
            return false;
        }
    }

	return m_pSession->SendEx(nNumberOfMessages, (char**)ppMsg, pnSize);
    LEAVE_FUNCTION_RETURN_FALSE
}

void			NetObject::Redirect(NetObject *pNetworkObject)
{
    ENTER_FUNCTION_FOXNET
	assert(pNetworkObject != NULL && "NULL Ä¿±ê Redirect");
	assert(m_pSession != NULL);

	m_pSession->BindNetworkObject(pNetworkObject);
    LEAVE_FUNCTION_FOXNET
}

char*			NetObject::GetIP()
{
    ENTER_FUNCTION_FOXNET
	if (m_pSession)
	{
		return m_pSession->GetIP();
	}
	else
	{
		return NULL;
	}
    LEAVE_FUNCTION_RETURN_NULL
}
unsigned short  NetObject::GetPort()
{
    ENTER_FUNCTION_FOXNET
	if( m_pSession )
	{
		return m_pSession->GetPort();
	}
	else
	{
		return 0;
	}
    LEAVE_FUNCTION_RETURN_0
}
void			NetObject::GetSendBuffPtr(char** ptr, int& nSize)
{
    ENTER_FUNCTION_FOXNET
	if (!m_pSession || m_pSession->HasDisconnectOrdered())
	{
		(*ptr)	= NULL;
		nSize	= 0;
		return;
	}

	m_pSession->GetSendBuffer()->GetDataWriteParam(ptr, nSize);
    LEAVE_FUNCTION_FOXNET
}

bool			NetObject::CompleteSend(int nSize, int nMsgType)
{
    ENTER_FUNCTION_FOXNET
	if (!m_pSession || m_pSession->HasDisconnectOrdered()) return false;

	return m_pSession->CompleteSend(nSize, nMsgType);
    LEAVE_FUNCTION_RETURN_FALSE
}

bool            NetObject::OnPreSendPack(void* pMsg, int nSize, float fBufferRation, int nMsgLevel)
{
    return true;
}

float           NetObject::GetSendBufferRatio()
{
    ENTER_FUNCTION_FOXNET
    if (!m_pSession || m_pSession->HasDisconnectOrdered()) return 0.0f;

    return m_pSession->GetSendBufferRatio();
    LEAVE_FUNCTION_FOXNET
    return 0.0f;
}
