#ifndef __SVRMSGCOMMON_H__
#define __SVRMSGCOMMON_H__
#include "common/GlobalDefine.h"
#include "common/Packet.h"
#include "common/GameTime/GameTime.h"
#include "SvrMsgID.h"
// 服务器消息版本号
const int	SVRMSG_VERSION		= 0;

const int	SERVER_SESSION_PACK	= 8192;
const int	SERVER_SESSION_BUFFER	= SERVER_SESSION_PACK * 16;


enum eServerType
{
	eSvrType_Temp,
	eSvrType_Config,
	eSvrType_Login,
	eSvrType_World,
	eSvrType_DBAgent,
	eSvrType_Scene,
	eSvrType_Gate,
	eSvrType_SvrStat,
	eSvrType_GmCMD,
	eSvrType_Count,
};
#define TypeServerMaxAmount	255

const char* const SERVERNAME[]	=
{
	"TempLink",
	"ConfigServer",
	"LoginServer",
	"WorldServer",
	"DBAgentServer",
	"SceneServer",
	"GateServer",
};

enum eLinkState
{
	eLinkState_Disconnect,
	eLinkState_Connecting,
	eLinkState_Connected,
};

inline UINT32	MakeTempUserID(UINT8 nSvrType, UINT8 nSvrID, UINT16 nTempID)
{
	return SGCommon::MakeUInt32(SGCommon::MakeUInt16(nSvrType, nSvrID), nTempID);
}

inline UINT8	MakeSvrID(UINT32 nID, UINT32 nAmount)
{
	return (nID % nAmount) + 1;
}

#pragma warning(push)
#pragma warning(disable:4267)

class SvrRegisterMsg: public PackCommon
{
public:
	SvrRegisterMsg()
	{
		nMsgID	= SVRMSGID_REGISTER;
		nMsgVersion	= (SVRMSG_VERSION);
		nSvrType	= (0);
		nSvrID	= (0);
	}

	virtual	void	Pack(WriteBuf& buffer)
	{
		buffer << nMsgID;
		buffer << nMsgVersion;
		buffer << nSvrType;
		buffer << nSvrID;
	}

	virtual	void	UnPack(ReadBuf& buffer)
	{
		buffer >> nMsgID;
		buffer >> nMsgVersion;
		buffer >> nSvrType;
		buffer >> nSvrID;
	}

	virtual	int		GetPackSize()
	{
		return sizeof(SvrRegisterMsg);
	}

public:
	UINT32	nMsgVersion;
	UINT8	nSvrType;
	UINT8	nSvrID;
};

class SvrGameTimeMsg: public PackCommon
{
public:
	SvrGameTimeMsg()
	{
		nMsgID	= SVRMSGID_GAMETIME;
	}

	virtual	void	Pack(WriteBuf& buffer)
	{
		buffer << nMsgID;
		buffer << gametime.nYear;
		buffer << gametime.nMonth;
		buffer << gametime.nDay;
		buffer << gametime.nHour;
		buffer << gametime.nMinute;
		buffer << gametime.nSecond;
		buffer << fScale;
	}

	virtual	void	UnPack(ReadBuf& buffer)
	{
		buffer >> nMsgID;
		buffer >> gametime.nYear;
		buffer >> gametime.nMonth;
		buffer >> gametime.nDay;
		buffer >> gametime.nHour;
		buffer >> gametime.nMinute;
		buffer >> gametime.nSecond;
		buffer >> fScale;
	}

	virtual	int		GetPackSize()
	{
		return sizeof(MsgHead) + sizeof(GameTimeInfo) + sizeof(float);
	}

public:
	GameTimeInfo	gametime;
	float	fScale;
};

#pragma warning(pop)

extern CPackManager<2048>	g_SvrPackMgr;

#endif