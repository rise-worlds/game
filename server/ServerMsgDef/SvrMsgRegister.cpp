
#include "Utility/Utility.h"
#include "SvrMsgCommon.h"

CPackManager<2048>	g_SvrPackMgr;

REGISTER_PACK(g_SvrPackMgr, eSvrMsg_ConfigInit_DBAgent, SvrMsg_ConfigInit_DBAgent);
