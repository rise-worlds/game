#ifndef __RingBuffer_H__
#define __RingBuffer_H__

template<class T, int MAX_LEN = 1024, int EXTRA_LEN = 128>
class RingBuffer
{
public:
	RingBuffer()
	{
		Reset();
	}
	~RingBuffer()
	{
		Reset();
	}
	void Reset()
	{
		m_nReadPos = 0;
		m_nWritePos = 0;
	}
	// 最多读个数
	int GetMaxReadSize()
	{
		int nReadSize = 0;

		int nTempReadPos = m_nReadPos;
		int nTempWritePos = m_nWritePos;

		if (nTempReadPos == nTempWritePos)
			nReadSize = 0;
		if (nTempReadPos < nTempWritePos)
			nReadSize = nTempWritePos - nTempReadPos;
		if (nTempReadPos > nTempWritePos)
			nReadSize = MAX_LEN + nTempWritePos - nTempReadPos;

		return nReadSize;
	}

	// 最多写个数
	int GetMaxWriteSize()
	{
		int nWriteSize = 0;

		int nTempReadPos = m_nReadPos;
		int nTempWritePos = m_nWritePos;

		if (nTempReadPos == nTempWritePos)
			nWriteSize = MAX_LEN;
		if (nTempReadPos < nTempWritePos)
			nWriteSize = MAX_LEN - (nTempWritePos - nTempReadPos);
		if (nTempReadPos > nTempWritePos)
			nWriteSize = nTempReadPos - nTempWritePos;

		return nWriteSize - 1;
	}

	// 取读指针
	void GetReadPtr(T*& pPtr, int& nMaxReadSize)
	{
		nMaxReadSize = GetMaxReadSize() < EXTRA_LEN ? GetMaxReadSize() : EXTRA_LEN;

		int	nCopyDataCount = 0;
		int	nTempReadPos = m_nReadPos;
		int	nTempWritePos = m_nWritePos;

		T*	pReadPtr = m_RingBuffer + nTempReadPos;

		if ((nTempReadPos > nTempWritePos)
			&& (nCopyDataCount = MAX_LEN - nTempReadPos) < EXTRA_LEN)
		{
			SafeCopy(m_RingBuffer + MAX_LEN, m_RingBuffer, EXTRA_LEN - nCopyDataCount);
		}

		pPtr = pReadPtr;
	}

	// 取写指针
	void GetWritePtr(T*& pPtr, int& nMaxWriteSize)
	{
		int	nTempReadPos = m_nReadPos;
		int	nTempWritePos = m_nWritePos;

		if ((nTempWritePos + 1) % MAX_LEN == nTempReadPos)	// 队列满
		{
			nMaxWriteSize = 0;
			pPtr = NULL;
			return;
		}

		int nWriteSize = 0;
		if (nTempReadPos == nTempWritePos)
			nWriteSize = MAX_LEN;
		if (nTempReadPos < nTempWritePos)
			nWriteSize = MAX_LEN - (nTempWritePos - nTempReadPos);
		if (nTempReadPos > nTempWritePos)
			nWriteSize = nTempReadPos - nTempWritePos;

		nMaxWriteSize = nWriteSize - 1;

		//if (nTempWritePos > nTempReadPos)
		//	nMaxWriteSize	= MAX_LEN - (nTempWritePos - nTempReadPos);
		//else if (nTempWritePos < nTempReadPos)
		//	nMaxWriteSize	= nTempReadPos - nTempWritePos;
		//else
		//	nMaxWriteSize	= MAX_LEN - nTempWritePos;

		pPtr = m_RingBuffer + nTempWritePos;
	}

	// 添加数据
	bool PushData(T* pData, int nLength = 1)
	{
		if (pData == NULL || nLength > GetMaxWriteSize())
		{
			return false;
		}

		int nTempWritePos = m_nWritePos;

		if ((nTempWritePos + nLength) <= MAX_LEN)
		{
			SafeCopy(m_RingBuffer + nTempWritePos, pData, nLength);

			int size = (nTempWritePos + nLength) % MAX_LEN;
			m_nWritePos = size;
		}
		else
		{
			int size1 = MAX_LEN - nTempWritePos;
			int size2 = nLength - size1;

			SafeCopy(m_RingBuffer + nTempWritePos, pData, size1);
			SafeCopy(m_RingBuffer, pData + size1, size2);

			m_nWritePos = size2;
		}

		return true;
	}

	// 取出并删除数据
	bool PopData(T* pData, int nLength = 1)
	{
		if (pData == NULL || nLength > GetMaxReadSize())		//不够读
		{
			return false;
		}

		int	nTempReadPos = m_nReadPos;

		if ((nTempReadPos + nLength) <= MAX_LEN)
		{
			SafeCopy(pData, m_RingBuffer + nTempReadPos, nLength);

			int size = (nTempReadPos + nLength) % MAX_LEN;
			m_nReadPos = size;
		}
		else
		{
			int size1 = MAX_LEN - nTempReadPos;
			int size2 = nLength - size1;

			SafeCopy(pData, m_RingBuffer + nTempReadPos, size1);
			SafeCopy(pData + size1, m_RingBuffer, size2);

			m_nReadPos = size2;
		}

		return true;
	}

	// 查看数据 不删除
	bool PeekData(T* pData, int nLen)
	{
		if (nLen > GetMaxReadSize())		//不够读
		{
			return false;
		}

		int nTempReadPos = m_nReadPos;

		if ((nTempReadPos + nLen) <= MAX_LEN)
		{
			SafeCopy(pData, m_RingBuffer + nTempReadPos, nLen);
		}
		else
		{
			int size1 = MAX_LEN - nTempReadPos;
			int size2 = nLen - size1;

			SafeCopy(pData, m_RingBuffer + nTempReadPos, size1);
			SafeCopy(pData + size1, m_RingBuffer, size2);
		}

		return true;
	}

	// 删除数据
	bool DeleteData(int nLen)
	{
		if (nLen > GetMaxReadSize())		//不够读
		{
			return false;
		}

		int nTempReadPos = m_nReadPos;

		if ((nTempReadPos + nLen) <= MAX_LEN)
		{
			int size = (nTempReadPos + nLen) % MAX_LEN;
			m_nReadPos = size;
		}
		else
		{
			int size1 = MAX_LEN - nTempReadPos;
			int size2 = nLen - size1;

			m_nReadPos = size2;
		}

		return true;
	}

	// 添加数据
	bool AddData(int nLength = 1)
	{
		if (nLength > GetMaxWriteSize())
		{
			return false;
		}

		int nTempWritePos = m_nWritePos;

		if ((nTempWritePos + nLength) <= MAX_LEN)
		{
			int size = (nTempWritePos + nLength) % MAX_LEN;
			m_nWritePos = size;
		}
		else
		{
			int size1 = MAX_LEN - nTempWritePos;
			int size2 = nLength - size1;
			SafeCopy(m_RingBuffer, m_RingBuffer + MAX_LEN, size2);

			m_nWritePos = size2;
		}

		return true;
	}


private:
	void SafeCopy(T* pDst, T* pSrc, int nSize)
	{
		for (int i = 0; i < nSize; i++)
		{
			pDst[i] = pSrc[i];
		}
	}

private:
	T m_RingBuffer[MAX_LEN + EXTRA_LEN];
	int	m_nReadPos;
	int	m_nWritePos;
};
#endif