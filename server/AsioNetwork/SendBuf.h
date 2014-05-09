#ifndef __SendBuf_H__
#define __SendBuf_H__

#include "CircuitQueue.h"
#include "AsioNetwork.h"

class SendBuffer
{
public:
	SendBuffer()
	{
		m_pQueue = NULL;
	}
	virtual ~SendBuffer()
	{
		if (m_pQueue) delete m_pQueue;
	}

	inline void Create(int nBufferSize, unsigned int nExtraBuffeSize)
	{
		if (m_pQueue) delete m_pQueue;
		m_pQueue = new CircuitQueue<char>;
		m_pQueue->Create(nBufferSize, nExtraBuffeSize);
		m_bComplete = true;
	}
	inline void Clear()
	{
		m_pQueue->Clear();
		m_bComplete = true;
	}

	inline void Completion(int nBytesSend)
	{
		m_pQueue->Dequeue(NULL, nBytesSend);
		m_bComplete = true;
	}

	inline bool	GetSendParam(char **ppSendPtr, int &nLength)
	{
		if (!IsReadyToSend())
		{
			nLength = 0;
			return false;
		}
		*ppSendPtr	= m_pQueue->GetReadPtr();
		nLength		= m_pQueue->GetReadableLen();
		m_bComplete = false;
		return true;
	}

	inline bool Write(PACKET_HEADER *pHeader, char *pMsg)
	{
		if (m_pQueue->GetSpace() < int(sizeof(PACKET_HEADER) + pHeader->size))
		{
			return false;
		}

		if (!m_pQueue->Enqueue((char*)pHeader, sizeof(PACKET_HEADER)))	return false;
		if (!m_pQueue->Enqueue(pMsg, pHeader->size))						return false;
		return true;
	}

	inline bool Write(char *pMsg, unsigned short nSize)
	{
		if (!m_pQueue->Enqueue(pMsg, nSize)) return false;
		return true;
	}

	inline unsigned int GetLength()
	{
		return m_pQueue->GetLength();
	}
	inline unsigned int GetSpace()
	{
		return m_pQueue->GetSpace();
	}

	inline void	GetDataWriteParam(char** ppWritePtr, int& nLen)
	{
		m_pQueue->GetSendWritePtr(ppWritePtr, nLen);
	}

	inline bool	CompletionDataWrite(int nLen)
	{
		if (m_pQueue->GetSpace() < int(nLen + sizeof(PACKET_HEADER)))
		{
			return false;
		}

		PACKET_HEADER head;
		head.size	= nLen;
		m_pQueue->Enqueue((char*)&head, sizeof(head));
		m_pQueue->Enqueue(NULL, nLen);
		return true;
	}

private:
	inline bool			IsReadyToSend()
	{
		return (m_bComplete && m_pQueue->GetLength() > 0) ? true : false;
	}

private:
	bool				m_bComplete;
	CircuitQueue<char>	*m_pQueue;
};

#endif // __SendBuf_H__