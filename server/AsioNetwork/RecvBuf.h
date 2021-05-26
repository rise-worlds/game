#ifndef __RecvBuf_H__
#define __RecvBuf_H__

#include "CircuitQueue.h"
#include "AsioNetwork.h"

class RecvBuffer
{
public:
    RecvBuffer() { m_pQueue = NULL; }
    virtual ~RecvBuffer()
    {
        if (m_pQueue)
            delete m_pQueue;
    }

    inline void Create(int nBufferSize, unsigned int nExtraBufferSize)
    {
        if (m_pQueue)
            delete m_pQueue;
        m_pQueue = new CircuitQueue<char>;
        m_pQueue->Create(nBufferSize, nExtraBufferSize);
        m_bComplete = true;
    }

    inline void Completion(int nBytesRecvd)
    {
        m_pQueue->Enqueue(NULL, nBytesRecvd);
        m_bComplete = true;
    }

    inline void Clear()
    {
        m_pQueue->Clear();
        m_bComplete = true;
    }

    inline void GetRecvParam(char** ppRecvPtr, int& nLength)
    {
        if (!IsReadyToRecv())
        {
            nLength = 0;
        }

        *ppRecvPtr = m_pQueue->GetWritePtr();
        nLength    = m_pQueue->GetWritableLen();

        m_bComplete = false;
    }

    inline char* GetFirstPacketPtr()
    {
        PACKET_HEADER header;
        if (!m_pQueue->Peek((char*) &header, sizeof(PACKET_HEADER)))
            return NULL;
        if (m_pQueue->GetLength() < (int) (sizeof(PACKET_HEADER) + header.size))
            return NULL;
        if (m_pQueue->GetBackDataCount() < (int) (header.size + sizeof(header)))
        {
            m_pQueue->CopyHeadDataToExtraBuffer(header.size + sizeof(header) - m_pQueue->GetBackDataCount());
        }
        return m_pQueue->GetReadPtr();
    }

    inline void RemoveFirstPacket(unsigned short nSize) { m_pQueue->Dequeue(NULL, nSize); }

private:
    inline bool IsReadyToRecv() { return (m_bComplete && m_pQueue->GetSpace() > 0) ? true : false; }

private:
    bool                m_bComplete;
    CircuitQueue<char>* m_pQueue;
};

#endif  // __RecvBuf_H__