#ifndef __GlobalDefine_H__
#define __GlobalDefine_H__

#include <memory.h>

#pragma pack(push, 1)

// 客户端收发消息的最大值
#define NETWORK_MaxClientMsgLen	(4096)
// Gate中设的客户端连接的缓冲区大小
#define NETWORK_ClientMsgBufLen (NETWORK_MaxClientMsgLen * 100)
#define NETWORK_SessionTimeout	(2592000000)

#define GD_BIT(x)	(1 << x)

enum eRC_LoginResult
{
	RC_LoginResult_Success,				// 成功
	RC_LoginResult_ErrName,				// 用户名密码错
	RC_LoginResult_AgainLogin,			// 重复登录
	RC_LoginResult_Disabled,			// 账号禁用
	RC_LoginResult_NotActivation,		// 账号没有激活
	RC_LoginResult_OldVersion,			// 消息版本旧
	RC_LoginResult_OtherError,			// 其他问题，可能是服务器没启动完成
	RC_LoginResult_KEEPLINK,			// 等待长连接
	RC_LoginResult_SHORTLINK,			// 断开短连接
	RC_LoginResult_ISFULL,				// 断开短连接不进入队伍
	RC_LoginResult_IMMEDIATELY,			// 通知队中的第一个玩家进入
};

enum eRC_CreateCharResult
{
	RC_CreateCharResult_Success,		// 创建成功
	RC_CreateCharResult_CharExist,		// 角色已存在
	RC_CreateCharResult_NameExist,		// 名字已存在
	RC_CreateCharResult_NameError,		// 名字不合法
	RC_CreateCharResult_OtherError,		// 其他错误
};

enum eRC_EnterGameResult
{
	RC_EnterGameResult_Success,			// 成功进入
	RC_EnterGameResult_NotExistChar,	// 没有建立角色
	RC_EnterGameResult_NotFindMap,		// 没有找到该角色所在的地图信息
	RC_EnterGameResult_NotFindScene,	// 没有找到地图所在的服务器
	RC_EnterGameResult_WorldFull,	    // 服务器人数已满,请稍后重试
	RC_EnterGameResult_Unknown,			// 未知原因，服务端内部问题
};

#pragma pack(pop)

#endif