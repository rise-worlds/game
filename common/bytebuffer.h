#pragma once

#include <assert.h>

class WriteBuf
{
public:
	WriteBuf(UINT32 nCount): m_WritePos(0), m_bData(NULL), m_nCount(0) 
	{
		Reset(nCount);
	}

	WriteBuf(): m_WritePos(0), m_bData(NULL), m_nCount(0) 
	{
	}

	WriteBuf(UINT8* ptr, UINT32 nCount)
	{ 
		Reset(ptr, nCount); 
	}

	~WriteBuf()
	{ 
		if (m_bData && m_bIsNew) 
			delete[] m_bData;	
	}

	void Reset(UINT32 nCount)
	{
		m_bIsNew	= true;

		if (m_bData)
		{
			delete[] m_bData;
			m_bData	= NULL;
		}

		m_WritePos	= 0;
		m_nCount	= nCount;
		m_bData = new UINT8[nCount];
	}

	void Reset(UINT8* ptr, UINT32 nCount)
	{
		m_bIsNew	= false;

		m_WritePos	= 0;
		m_nCount	= nCount;
		m_bData	= ptr;
	}

	void Clear()
	{
		m_WritePos	= 0;
	}

public:
	template <typename T> 
	void append(const T& value) 
	{
		append((UINT8 *)&value, sizeof(value));
	}

	template <typename T>
	WriteBuf& operator<<(const T& value)
	{
		append<T>(value);
		return *this;
	}

#define DEFINE_FAST_WRITE_OPERATOR(type, size) 	WriteBuf &operator<<(type value) { \
													append<type>((type)value); \
													return *this; \
												}
	DEFINE_FAST_WRITE_OPERATOR(bool, 1);	
	DEFINE_FAST_WRITE_OPERATOR(UINT8, 1);
	DEFINE_FAST_WRITE_OPERATOR(UINT16, 2);
	DEFINE_FAST_WRITE_OPERATOR(UINT32, 4);
	DEFINE_FAST_WRITE_OPERATOR(UINT64, 8);
	DEFINE_FAST_WRITE_OPERATOR(INT8, 1);	
	DEFINE_FAST_WRITE_OPERATOR(INT16, 2);	
	DEFINE_FAST_WRITE_OPERATOR(INT32, 4);	
	DEFINE_FAST_WRITE_OPERATOR(INT64, 8);	
	DEFINE_FAST_WRITE_OPERATOR(REAL32, 4);	
	DEFINE_FAST_WRITE_OPERATOR(REAL64, 8);	

#undef DEFINE_FAST_WRITE_OPERATOR

	WriteBuf &operator<<(const std::string &value) 
	{
		append((UINT8 *)value.c_str(), value.length());
		append((UINT8)0);
		return *this;
	}

	WriteBuf &operator<<(char *str) 
	{
		append((UINT8 *)str, strlen(str));
		append((UINT8)0);
		return *this;
	}

	WriteBuf &operator<<(const char *str) 
	{
		append((UINT8 *)str, strlen(str));
		append((UINT8)0);
		return *this;
	}

	void append(const UINT8 *src, size_t cnt)
	{
		if (!cnt) return;

		assert(m_WritePos + cnt <= m_nCount);

		memcpy(&m_bData[m_WritePos], src, cnt);
		m_WritePos += UINT32(cnt);
	}

	UINT8* GetPtr()
	{
		return m_bData;
	}

	UINT8*	GetCurPtr()
	{
		return (UINT8*)(m_bData + m_WritePos);
	}

	UINT16	GetReadSize()
	{
		return static_cast<UINT16>(m_WritePos);
	}

	UINT16	GetBufferSize()
	{
		return m_nCount;
	}

private:
	UINT8	m_bIsNew;
	UINT32	m_nCount;
	UINT32	m_WritePos;
	PUINT8	m_bData;
};

class ReadBuf
{
public:
	ReadBuf(const UINT8* pData, UINT16 nMaxSize)
	{
		Reset(pData, nMaxSize);
	}

	void Reset(const UINT8* pData, UINT16 nMaxSize)
	{
		m_MaxSize	= nMaxSize;
		m_pData	= pData;
		m_ReadPos	= 0;
	}

	PUINT8	GetPtr()
	{
		return const_cast<PUINT8>(m_pData);
	}

	UINT16	GetReadSize()
	{
		return m_MaxSize;
	}	

	PUINT8	GetCurPtr()
	{
		return (UINT8*)(m_pData + m_ReadPos);
	}

	void SetCurPtr(UINT16 nLen)
	{
		assert(m_ReadPos + nLen <= m_MaxSize);
		m_ReadPos += nLen;
	}

	void ToBegin()
	{
		m_ReadPos = 0;
	}


	template <typename T> 
	T read()
	{
		T r=read<T>(m_ReadPos);
		m_ReadPos += sizeof(T);
		return r;
	}

	template <typename T> 
	T read(size_t pos) const 
	{
		if(pos + sizeof(T) > m_MaxSize)	
		{
			assert(0);
			return T();
		} 
		else 
		{
			return *((T*)&m_pData[pos]);
		}
	}

	void read(UINT8 *dest, size_t len)
	{
		if (m_ReadPos + len <= m_MaxSize) 
		{
			memcpy(dest, &m_pData[m_ReadPos], len);
		} 
		else 
		{
			assert(0);
			memset(dest, 0, len);
		}

		m_ReadPos += UINT16(len);
	}

public:
	template <typename T>
	ReadBuf& operator>> (T& value) 
	{
		value = read<T>();
		return *this;
	}

#define DEFINE_FAST_READ_OPERATOR(type, size) 	ReadBuf &operator>>(type& value) { \
													value = read<type>(); \
													return *this; \
												}

	DEFINE_FAST_READ_OPERATOR(bool, 1);	
	DEFINE_FAST_READ_OPERATOR(UINT8, 1);	
	DEFINE_FAST_READ_OPERATOR(UINT16, 2);	
	DEFINE_FAST_READ_OPERATOR(UINT32, 4);	
	DEFINE_FAST_READ_OPERATOR(UINT64, 8);	
	DEFINE_FAST_READ_OPERATOR(INT8, 1);	
	DEFINE_FAST_READ_OPERATOR(INT16, 2);	
	DEFINE_FAST_READ_OPERATOR(INT32, 4);	
	DEFINE_FAST_READ_OPERATOR(INT64, 8);	
	DEFINE_FAST_READ_OPERATOR(REAL32, 4);	
	DEFINE_FAST_READ_OPERATOR(REAL64, 8);

	ReadBuf &operator>>(std::string& value) 
	{
		value.clear();
		while (true) 
		{
			char c=read<char>();
			if (c==0)
				break;
			value+=c;
		}
		return *this;
	}

	ReadBuf &operator>>(char* pStr) 
	{
		size_t wPos	= 0;
		while (true)
		{
			char c=read<char>();
			if (c==0)
				break;
			pStr[wPos++] = c;
		}
		
		pStr[wPos++]	= '\0';
		return *this;
	}


private:
	const UINT8* m_pData;
	UINT16	m_ReadPos;
	UINT16	m_MaxSize;
};

#define GetDataByPack(pack, type, name, init)	type name(init); pack >> name;
#define FillDataByPack(pack, type, value) { type temp; pack >> temp; value = temp; }
