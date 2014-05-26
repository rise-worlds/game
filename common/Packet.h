#pragma once

#include "ByteBuffer.h"

class NetObject;

#pragma pack(push, 1)

struct MsgHead
{
public:
	SGuint16	nMsgID;
	//SGuint16	size;
	//SGuint16	nLevel;
	SGuint16		GetMsgID()
	{
		return nMsgID;
	}
};

class PackCommon: public MsgHead
{
public:
	PackCommon()
	{
		memset(m_szBuffer, 0, sizeof(m_szBuffer));
	}
	virtual ~PackCommon(){}
	virtual	void	Pack(WriteBuf& buffer)
	{
		buffer << nMsgID;
// 		buffer.append((Sg_UInt8*)m_szBuffer, this->GetPackSize() - sizeof(MsgHead));
	}
	virtual	void	UnPack(ReadBuf& buffer)
	{
		buffer >> nMsgID;
// 		buffer.read((Sg_UInt8*)m_szBuffer, this->GetPackSize() - sizeof(MsgHead));
	}
	virtual	int		GetPackSize()
	{
		return int(sizeof(MsgHead));
	}
protected:
	char m_szBuffer[1024*16];
};


class IPackRegisterHelper
{
public:
	virtual	void*	New()	= 0;
	virtual	void	Free(void*)	= 0;	
};

template<class T>
class CPackRegisterHelper: public IPackRegisterHelper
{
public:
	void* New()
	{
		return new T;
	}

	void	Free(void* ptr)
	{
		delete ((T*)ptr);
	}
};

template<int MsgSize = 1024>
class CPackManager
{
public:
	CPackManager()
	{
		for (int i=0; i<MsgSize; i++)
		{
			m_pHelper[i]	= NULL;
		}
	}

	~CPackManager()
	{

	}

public:
	void RegisterPack(int nMsgID,	IPackRegisterHelper* pHelper)
	{
		if (nMsgID >= MsgSize
			|| m_pHelper[nMsgID] != NULL)
		{
			return;
		}

		m_pHelper[nMsgID]	= pHelper;
	}

	PackCommon*	AllocPack(int nMsgID)
	{
		if (nMsgID >= MsgSize
			|| m_pHelper[nMsgID] == NULL)
		{
			return NULL;
		}
		
		return	(PackCommon*)(m_pHelper[nMsgID]->New());
	}

	void		Free(PackCommon* pPack)
	{
		m_pHelper[pPack->GetMsgID()]->Free(pPack);
	}

	void		Free(PackCommon* pPack, int nMsgID)
	{
		m_pHelper[nMsgID]->Free(pPack);
	}


private:
	IPackRegisterHelper*	m_pHelper[MsgSize];
};

#define REGISTER_PACK(mgr, id, x) \
	CPackRegisterHelper<x>	g_PackRegister_##x; \
	struct PackRegister_##x \
	{ \
		PackRegister_##x() \
		{ \
			mgr.RegisterPack(id, &(g_PackRegister_##x)); \
		} \
	} g_PackRegisterS_##x;


#pragma pack(pop)
