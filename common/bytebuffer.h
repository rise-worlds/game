#pragma once

#include <assert.h>
#include "GlobalDefine.h"

class WriteBuf
{
public:
	WriteBuf(SGuint32 nCount): m_WritePos(0), m_bData(NULL), m_nCount(0) 
	{
		Reset(nCount);
	}

	WriteBuf(): m_WritePos(0), m_bData(NULL), m_nCount(0) 
	{
	}

	WriteBuf(SGuint8* ptr, SGuint32 nCount)
	{ 
		Reset(ptr, nCount); 
	}

	~WriteBuf()
	{ 
		if (m_bData && m_bIsNew) 
			delete[] m_bData;	
	}

	void Reset(SGuint32 nCount)
	{
		m_bIsNew	= true;

		if (m_bData)
		{
			delete[] m_bData;
			m_bData	= NULL;
		}

		m_WritePos	= 0;
		m_nCount	= nCount;
		m_bData	= new SGuint8[nCount];
	}

	void Reset(SGuint8* ptr, SGuint32 nCount)
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
		append((SGuint8 *)&value, sizeof(value));
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
	DEFINE_FAST_WRITE_OPERATOR(SGuint8, 1);	
	DEFINE_FAST_WRITE_OPERATOR(SGuint16, 2);	
	DEFINE_FAST_WRITE_OPERATOR(SGuint32, 4);	
	DEFINE_FAST_WRITE_OPERATOR(SGuint64, 8);	
	DEFINE_FAST_WRITE_OPERATOR(SGint8, 1);	
	DEFINE_FAST_WRITE_OPERATOR(SGint16, 2);	
	DEFINE_FAST_WRITE_OPERATOR(SGint32, 4);	
	DEFINE_FAST_WRITE_OPERATOR(SGint64, 8);	
	DEFINE_FAST_WRITE_OPERATOR(SGreal32, 4);	
	DEFINE_FAST_WRITE_OPERATOR(SGreal64, 8);	

#undef DEFINE_FAST_WRITE_OPERATOR

	WriteBuf &operator<<(const std::string &value) 
	{
		append((SGuint8 *)value.c_str(), value.length());
		append((SGuint8)0);
		return *this;
	}

	WriteBuf &operator<<(char *str) 
	{
		append((SGuint8 *)str, strlen(str));
		append((SGuint8)0);
		return *this;
	}

	WriteBuf &operator<<(const char *str) 
	{
		append((SGuint8 *)str, strlen(str));
		append((SGuint8)0);
		return *this;
	}

	void append(const SGuint8 *src, size_t cnt) 
	{
		if (!cnt) return;

		assert(m_WritePos + cnt <= m_nCount);

		memcpy(&m_bData[m_WritePos], src, cnt);
		m_WritePos += SGuint32(cnt);
	}

    SGuint8* GetPtr()
	{
		return m_bData;
	}

	SGuint8*	GetCurPtr()
	{
		return (SGuint8*)(m_bData + m_WritePos);
	}

	SGuint16	GetReadSize()
	{
		return static_cast<SGuint16>(m_WritePos);
	}

	SGuint16	GetBufferSize()
	{
		return m_nCount;
	}

private:
	SGuint8	m_bIsNew;
	SGuint32	m_nCount;
	SGuint32	m_WritePos;
	SGuint8*	m_bData;
};

class ReadBuf
{
public:
	ReadBuf(const SGuint8* pData, SGuint16 nMaxSize)
	{
		Reset(pData, nMaxSize);
	}

	void Reset(const SGuint8* pData, SGuint16 nMaxSize)
	{
		m_MaxSize	= nMaxSize;
		m_pData	= pData;
		m_ReadPos	= 0;
	}

	SGuint8*	GetPtr()
	{
		return const_cast<SGuint8*>(m_pData);
	}

	SGuint16	GetReadSize()
	{
		return m_MaxSize;
	}	

	SGuint8*	GetCurPtr()
	{
		return (SGuint8*)(m_pData + m_ReadPos);
	}

	void SetCurPtr(SGuint16 nLen)
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

	void read(SGuint8 *dest, size_t len) 
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

		m_ReadPos += SGuint16(len);
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
	DEFINE_FAST_READ_OPERATOR(SGuint8, 1);	
	DEFINE_FAST_READ_OPERATOR(SGuint16, 2);	
	DEFINE_FAST_READ_OPERATOR(SGuint32, 4);	
	DEFINE_FAST_READ_OPERATOR(SGuint64, 8);	
	DEFINE_FAST_READ_OPERATOR(SGint8, 1);	
	DEFINE_FAST_READ_OPERATOR(SGint16, 2);	
	DEFINE_FAST_READ_OPERATOR(SGint32, 4);	
	DEFINE_FAST_READ_OPERATOR(SGint64, 8);	
	DEFINE_FAST_READ_OPERATOR(SGreal32, 4);	
	DEFINE_FAST_READ_OPERATOR(SGreal64, 8);

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
	const SGuint8* m_pData;
	SGuint16	m_ReadPos;
	SGuint16	m_MaxSize;
};

#define GetDataByPack(pack, type, name, init)	type name(init); pack >> name;
#define FillDataByPack(pack, type, value) { type temp; pack >> temp; value = temp; }
