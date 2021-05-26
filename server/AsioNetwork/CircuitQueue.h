#ifndef __CircuitQueue_H__
#define __CircuitQueue_H__

#include <stdio.h>
#include <string.h>
#include "AsioNetwork.h"

template<typename T>
class CircuitQueue
{
public:
    CircuitQueue()
        : m_pData(NULL)
        , m_nSize(0)
        , m_nHead(0)
        , m_nTail(0)
    {
    }

    virtual ~CircuitQueue()
    {
        if (m_pData)
            delete[] m_pData;
    }

    void Create(int nSize, int nExtraSize = 0)
    {
        if (m_pData)
            delete[] m_pData;

        m_pData      = new T[nSize + nExtraSize];
        m_nSize      = nSize;
        m_nExtraSize = nExtraSize;
    }

    inline void Clear()
    {
        m_nHead = 0;
        m_nTail = 0;
    }

    inline int GetSpace(int nHead, int nTail)
    {
        int iRet = m_nSize - GetLength(nHead, nTail) - 1;
        return iRet;
    }

    inline int GetLength(int nHead, int nTail)
    {
        int iRet;

        if (nHead == nTail)
            iRet = 0;
        else if (nHead < nTail)
            iRet = nTail - nHead;
        else if (nHead > nTail)
            iRet = m_nSize + nTail - nHead;

        return iRet;
    }

    inline int GetSpace()
    {
        int iRet = m_nSize - GetLength() - 1;
        return iRet;
    }

    inline int GetLength()
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        int iRet;

        if (nHead == nTail)
            iRet = 0;
        else if (nHead < nTail)
            iRet = nTail - nHead;
        else if (nHead > nTail)
            iRet = m_nSize + nTail - nHead;

        return iRet;
    }

    inline int GetBackDataCount() { return m_nSize - m_nHead; }

    inline T* GetReadPtr()
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        T* pRet;

        pRet = m_pData + nHead;

        int nSplitFirstDataCount;
        if (nHead > nTail && (nSplitFirstDataCount = m_nSize - nHead) < m_nExtraSize)
        {
            memcpy(m_pData + m_nSize, m_pData, sizeof(T) * (m_nExtraSize - nSplitFirstDataCount));
        }

        return pRet;
    }

    inline T* GetWritePtr()
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        T* pRet;

        pRet = m_pData + nTail;

        return pRet;
    }

    inline int GetReadableLen()
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        int iRet = GetLength(nHead, nTail);

        if (nHead > nTail)
        {
            iRet = std::min(iRet, m_nSize - nHead);
        }

        return iRet;
    }

    inline int GetWritableLen()
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        int iRet = GetSpace(nHead, nTail);

        if (m_nTail > m_nHead)
        {
            iRet = std::min(iRet, m_nSize - m_nTail);
        }

        return iRet;
    }

    inline bool Enqueue(T* pSrc, int nSize)
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        if (GetSpace(nHead, nTail) < nSize)
        {
            return false;
        }

        if (pSrc)
        {
            if (nHead <= nTail)
            {
                int nBackSpaceCount = m_nSize - nTail;

                if (nBackSpaceCount >= nSize)
                {
                    memcpy(m_pData + nTail, pSrc, sizeof(T) * nSize);
                }
                else
                {
                    memcpy(m_pData + nTail, pSrc, sizeof(T) * nBackSpaceCount);
                    memcpy(m_pData, pSrc + nBackSpaceCount, sizeof(T) * (nSize - nBackSpaceCount));
                }
            }
            else
            {
                memcpy(m_pData + nTail, pSrc, sizeof(T) * nSize);
            }
        }
        else
        {
            if (nHead <= nTail)
            {
                int nBackSpaceCount = m_nSize - nTail;
                if (nBackSpaceCount < nSize)
                {
                    memcpy(m_pData, m_pData + m_nSize, sizeof(T) * (nSize - nBackSpaceCount));
                }
            }
        }

        int iRet = (m_nTail + nSize) % m_nSize;
        m_nTail  = iRet;

        return true;
    }

    inline bool Dequeue(T* pTar, int nSize)
    {
        if (!Peek(pTar, nSize))
        {
            return false;
        }

        int nHead = m_nHead;
        int nTail = m_nTail;

        int iRet = (m_nHead + nSize) % m_nSize;
        m_nHead  = iRet;

        return true;
    }

    inline bool Peek(T* pTar, int nSize)
    {
        int nHead = m_nHead;
        int nTail = m_nTail;

        if (GetLength(nHead, nTail) < nSize)
        {
            return false;
        }

        if (pTar != NULL)
        {
            if (nHead < nTail)
            {
                memcpy(pTar, m_pData + nHead, sizeof(T) * nSize);
            }
            else
            {
                int nBackDataCount = (m_nSize - nHead);
                if (nBackDataCount >= nSize)
                {
                    memcpy(pTar, m_pData + nHead, sizeof(T) * nSize);
                }
                else
                {
                    memcpy(pTar, m_pData + nHead, sizeof(T) * nBackDataCount);
                    memcpy(pTar + nBackDataCount, m_pData, sizeof(T) * (nSize - nBackDataCount));
                }
            }
        }

        return true;
    }

    inline void CopyHeadDataToExtraBuffer(int nSize)
    {
        assert(nSize <= m_nExtraSize);

        memcpy(m_pData + m_nSize, m_pData, nSize);
    }

    inline void GetSendWritePtr(T** ppWritePtr, int& nLen)
    {
        int nTempTail = (m_nTail + sizeof(PACKET_HEADER)) % m_nSize;
        (*ppWritePtr) = m_pData + nTempTail;
        nLen          = GetSpace() - sizeof(PACKET_HEADER);
    }

protected:
    T*  m_pData;
    int m_nHead;
    int m_nTail;

    int m_nSize;
    int m_nExtraSize;
};

#endif  // __CircuitQueue_H__
