#ifndef __NetworkMsgRegister_H__
#define __NetworkMsgRegister_H__
#include "GlobalDefine.h"
#include "NetworkMsgDef.h"

CPackManager<eMsg_MaxCount>	g_ClientPackMgr;

REGISTER_PACK(g_ClientPackMgr, eMsg_Login_CL, Msg_Login_CL);

REGISTER_PACK(g_ClientPackMgr, eMsg_LoginResult_LC, Msg_LoginResult_LC);

#endif
