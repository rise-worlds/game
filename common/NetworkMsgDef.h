#ifndef __NetworkMsgDef_H__
#define __NetworkMsgDef_H__

#include <vector>
#include <bitset>
#include "Packet.h"
#include "PacketDefine.h"
#include "GlobalDefine.h"

#pragma pack(push, 1)

#pragma warning(push)
#pragma warning(disable: 4267)
#pragma warning(disable: 4018)
//=====================================================================================
// Client To Login
//=====================================================================================
// ÕÊºÅµÇÂ¼
class Msg_Login_CL : public PackCommon
{
public:
	Msg_Login_CL()
	{
		nMsgID = eMsg_Login_CL;
		nCurVer = 0;
	}

	UINT32	nCurVer;
	std::string	strName;

	MSGPACK_DEFINE(nCurVer, strName);
};
//=====================================================================================
// Login To Client
//=====================================================================================
// µÇÂ¼Login½á¹û
class Msg_LoginResult_LC : public PackCommon
{
public:
	Msg_LoginResult_LC()
	{
		nMsgID = eMsg_LoginResult_LC;
		nErrCode = RC_LoginResult_Success;
	}

	UINT8	nErrCode;	// ´íÎóÂë ¼û eRC_LoginResult

	MSGPACK_DEFINE(nErrCode);
};
#pragma warning(pop)

#pragma pack(pop)

extern CPackManager<eMsg_MaxCount>	g_ClientPackMgr;

#endif