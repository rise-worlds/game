#ifndef __RingBufferEx_H__
#define __RingBufferEx_H__
#include "RingBuffer.h"

template < class T, int MAX_LEN = 1024, int EXTRA_LEN = 128 >
class Sg_RingBufEx
{
public:
	typedef Sg_RingBuffer<T, MAX_LEN, EXTRA_LEN> REAL_RINGBUF;
	typedef REAL_RINGBUF*	REAL_RINGBUF_PTR;

	Sg_RingBufEx()
	{
		m_pMappingFile = 0;
		m_pRingBuffer_Send = NULL;
		m_pRingBuffer_Recv = NULL;

		m_bIsCreate = false;
	}

	~Sg_RingBufEx()
	{
		if (m_bIsCreate)
		{
			m_pRingBuffer_Send->~Sg_RingBuffer();
			m_pRingBuffer_Recv->~Sg_RingBuffer();
		}

		ShareMem::UnMapShareMem((char*)m_pRingBuffer_Send);
		ShareMem::CloseShareMem(m_pMappingFile);

		m_pRingBuffer_Send = NULL;
		m_pRingBuffer_Recv = NULL;
		m_pMappingFile = INVALID_SM_HANDLE;
	}

	// 创建或者打开一个通信会话
	bool Create(int nMappingName, bool bIsCreate)
	{
		m_bIsCreate = bIsCreate;
		unsigned int	dwSize = sizeof(REAL_RINGBUF)+sizeof(REAL_RINGBUF);

		if (bIsCreate)
		{
			m_pMappingFile = ShareMemAPI::CreateShareMem(nMappingName, dwSize);
			if (m_pMappingFile == INVALID_SM_HANDLE)
			{
				return false;
			}

			void* pVoid = ShareMemAPI::MapShareMem(m_pMappingFile);
			if (pVoid == NULL)
			{
				return false;
			}

			m_pRingBuffer_Send = new(pVoid)REAL_RINGBUF;
			m_pRingBuffer_Recv = new((char*)pVoid + sizeof(REAL_RINGBUF)) REAL_RINGBUF;
			if (m_pRingBuffer_Send == NULL || m_pRingBuffer_Recv == NULL)
			{
				return false;
			}
		}
		else
		{
			m_pMappingFile = ShareMemAPI::OpenShareMem(nMappingName, dwSize);
			if (m_pMappingFile == INVALID_SM_HANDLE)
			{
				return false;
			}

			void* pVoid = ShareMemAPI::MapShareMem(m_pMappingFile);
			if (pVoid == NULL)
			{
				return false;
			}

			m_pRingBuffer_Send = REAL_RINGBUF_PTR(pVoid);
			m_pRingBuffer_Recv = REAL_RINGBUF_PTR((char*)pVoid + sizeof(REAL_RINGBUF));
			if (m_pRingBuffer_Send == NULL || m_pRingBuffer_Recv == NULL)
			{
				return false;
			}
		}

		return true;
	}

	// 向另一方发送数据
	void PushData(char* pMsg, int nMsgLen)
	{
		REAL_RINGBUF_PTR pRingBuffer = NULL;
		if (m_bIsCreate)
		{
			pRingBuffer = m_pRingBuffer_Send;
		}
		else
		{
			pRingBuffer = m_pRingBuffer_Recv;
		}

		if (pRingBuffer == NULL
			|| nMsgLen > EXTRA_LEN)
		{
			return;
		}

		unsigned short	nSize = (unsigned short)nMsgLen;

		if (pRingBuffer->GetMaxWriteSize() < int(nSize + sizeof(nSize)))
		{
			return;
		}

		pRingBuffer->PushData((char*)&nSize, sizeof(nSize));
		pRingBuffer->PushData((char*)pMsg, nMsgLen);
	}

	void PushDataEx(char** pMsg, int* nMsgLen, int nAmount)
	{
		REAL_RINGBUF_PTR pRingBuffer = NULL;
		if (m_bIsCreate)
		{
			pRingBuffer = m_pRingBuffer_Send;
		}
		else
		{
			pRingBuffer = m_pRingBuffer_Recv;
		}

		if (pRingBuffer == NULL)
		{
			return;
		}

		unsigned short	nSize = 0;
		for (int i = 0; i < nAmount; i++)
		{
			nSize += nMsgLen[i];
		}

		if (nSize > EXTRA_LEN || pRingBuffer->GetMaxWriteSize() < int(nSize + sizeof(nSize)))
		{
			return;
		}

		pRingBuffer->PushData((char*)&nSize, sizeof(nSize));

		for (int i = 0; i < nAmount; i++)
		{
			pRingBuffer->PushData((char*)pMsg[i], nMsgLen[i]);
		}
	}


	// 取读数据指针
	void PopData(char*& pMsgPtr, int& nMsgLen)
	{
		REAL_RINGBUF_PTR pRingBuffer = NULL;
		if (!m_bIsCreate)
		{
			pRingBuffer = m_pRingBuffer_Send;
		}
		else
		{
			pRingBuffer = m_pRingBuffer_Recv;
		}

		pMsgPtr = NULL;
		nMsgLen = 0;

		if (pRingBuffer == NULL)
		{
			return;
		}

		char*	pReadPtr = NULL;
		int		nReadSize = 0;
		pRingBuffer->GetReadPtr(pReadPtr, nReadSize);
		if (pReadPtr == NULL
			|| nReadSize <= sizeof(unsigned short))
		{
			return;
		}

		unsigned short	wMsgSize = *(unsigned short*)pReadPtr;
		if (nReadSize < int(wMsgSize + sizeof(wMsgSize)))
		{
			return;
		}

		pMsgPtr = (pReadPtr + sizeof(wMsgSize));
		nMsgLen = wMsgSize;
	}

	// 完成读数据
	void CompletePop(int nMsgLen)
	{
		REAL_RINGBUF_PTR pRingBuffer = NULL;
		if (!m_bIsCreate)
		{
			pRingBuffer = m_pRingBuffer_Send;
		}
		else
		{
			pRingBuffer = m_pRingBuffer_Recv;
		}

		if (pRingBuffer == NULL)
		{
			return;
		}

		pRingBuffer->DeleteData(nMsgLen + sizeof(unsigned short));
	}

private:
	bool m_bIsCreate;
	SMHandle m_pMappingFile;
	REAL_RINGBUF_PTR m_pRingBuffer_Send;	// 相对于创建方的发送Buffer 打开方的接收Buffer
	REAL_RINGBUF_PTR m_pRingBuffer_Recv;	// 相对于创建方的接收Buffer 打开方的发送Buffer

};

#endif