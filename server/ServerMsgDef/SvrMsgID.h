#ifndef __SvrMsgID_H__
#define __SvrMsgID_H__

const int	SVRMSGID_CONFIG = 50;
const int	SVRMSGID_LOGIN = 100;
const int	SVRMSGID_WORLD = 500;
const int	SVRMSGID_DBAGENT = 900;
const int	SVRMSGID_SCENE = 1300;
const int	SVRMSGID_GATE = 1700;
const int	SVRMSGID_GMCMD = 2000;

#define SVRMSGID_REGISTER	32
#define SVRMSGID_GAMETIME	33

enum
{
	eSvrMsg_ConfigInit_Login = SVRMSGID_LOGIN,
	eSvrMsg_LoginResult_Login,
	eSvrMsg_QueryCharResult_Login,
	eSvrMsg_CreateCharResult_Login,
	eSvrMsg_DeleteCharResult_Login,
	eSvrMsg_EnterGameResult_Login,
	eSvrMsg_AllMapInfo_Login,
	eSvrMsg_GateLinkInfo_Login,
	eSvrMsg_UserEnterResult_Login,
	eSvrMsg_ProcKickPlayer_Login,
};

enum
{
	eSvrMsg_ConfigInit_World = SVRMSGID_WORLD,
	eSvrMsg_AddUser_World,
	eSvrMsg_DeleteUser_World,
	eSvrMsg_QueryCharInfo_World,
	eSvrMsg_QueryCharResult_World,
	eSvrMsg_QueryCharEquipResult_World,
	eSvrMsg_QueryAllCharNameReuslt_World,
	eSvrMsg_CreateChar_World,
	eSvrMsg_DeleteChar_World,
};

enum
{
	eSvrMsg_ConfigInit_DBAgent = SVRMSGID_DBAGENT,
	eSvrMsg_CheckLogin_DBSvr,
	eSvrMsg_QueryAllName_DBSvr,
	eSvrMsg_QueryCharInfo_DBSvr,
	eSvrMsg_CharEquipInfo_DBSvr,
	eSvrMsg_UpdateCharData_DBSvr,
	eSvrMsg_ClearCharGameData_DBSvr,
};

enum eSceneSvrMsg
{
	eSvrMsg_ConfigInit_Scene = SVRMSGID_SCENE,
	eSvrMsg_CreateInstance_Scene,
	eSvrMsg_DestroyInstance_Scene,
	eSvrMsg_PlayerProcTransport_Scene,
	eSvrMsg_PlayerEnter_Scene,
	eSvrMsg_ProcKickPlayer_Scene,
	eSvrMsg_ProcInstantTrans_Scene,
	eSvrMsg_GateRegister_Scene,
	eSvrMsg_UserEnterResult_Scene,
	eSvrMsg_ClientMsg_Scene,
};

#endif