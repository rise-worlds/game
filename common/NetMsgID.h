#ifndef __NetMsgID_H__
#define __NetMsgID_H__

const int	BaseMsgID_ClientToLogin = 0;
const int	BaseMsgID_LoginToClient = 200;
const int	BaseMsgID_ClientToGate = 400;
const int	BaseMsgID_GateToClient = 800;

#pragma pack(push, 1)

//=====================================================================================
// Client To Login
//=====================================================================================
enum
{
	eMsg_Login_CL = BaseMsgID_ClientToLogin,	// 用户请求登陆
	eMsg_QueryCharInfo_CL,						// 请求角色信息
	eMsg_CreateChar_CL,							// 创建角色
	eMsg_DeleteChar_CL,							// 删除角色
	eMsg_EnterGame_CL,							// 进入游戏世界
	eMsg_BackToLogin_CL,						// 返回登陆画面
	eMsg_LoginInfo_CL,							// 登录随机数+密码MD5信息
	eMsg_QueueLogin_LC,							// 排队系统消息
};
//=====================================================================================
// Login To Client
//=====================================================================================
enum
{
	eMsg_LoginResult_LC = BaseMsgID_LoginToClient,	// 用户登陆结果
	eMsg_QueryCharInfo_LC,							// 查询到的角色信息
	eMsg_GateLinkInfo_LC,
	eMsg_SceneMapInfo_LC,
	eMsg_GameTime_LC,
	eMsg_MessageVer_LC,
	eMsg_CreateCharResult_LC,						// 创建角色的结果
	eMsg_DeleteCharResult_LC,						// 删除角色的结果
	eMsg_EnterGameResult_LC,						// 进入游戏世界的结果
	eMsg_BackToLoginResult_LC,						// 返回登陆画面结果
	eMsg_SocketDisconnect_LC,
	eMsg_LoginInfo_LC,								// 登录随机数信息
	eMsg_SvrLocalTime_LC,							// 游戏服务器本地时间信息
};
//=====================================================================================
// Client To Gate
//=====================================================================================
enum
{
	eMsg_ClientLogin_CG = BaseMsgID_ClientToGate,
	eMsg_Logout_CG,									// 退出消息
};
//=====================================================================================
// Gate To Client
//=====================================================================================
enum
{
	eMsg_ClientLoadSuccess_GC = BaseMsgID_GateToClient,

	eMsg_MaxCount,
};
#pragma pack(pop)
#endif