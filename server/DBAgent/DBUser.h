#ifndef __DBUser_H__
#define __DBUser_H__

struct eITEM_INFO
{
	GD_PlayerItem eBaseInfo;
	GD_ItemInfo eExtInfo;
	BOOL bDelete;			//记录物品是否需要删除，默认为TRUE都要删除，不需要删除的请设置为FALSE
	BOOL bNeedUpdate;		//是否需要更新用户数据, 默认FALSE不需要更新， 需要更新的设置为TRUE
	eITEM_INFO()
	{
		memset(this, 0, sizeof(*this));
	}
};
typedef std::map<Sg_UInt32, eITEM_INFO*> MAP_ITEM_INFO;
typedef std::vector<GD_AttackLog> VEC_ATTACK_INFO;

class CDBUser
{
public:
	CDBUser();
	~CDBUser();

	SG_DF_PROPERTY(Sg_UInt32, AccountID);	// 帐号ID
	SG_DF_PROPERTY(Sg_UInt8, SceneSvrID);
	SG_DF_PROPERTY(Sg_UInt8, WorldSvrID);

	// DB 数据缓存
public:
	void Release();
	void ResetItemInfoMap();
	GD_BaseCharInfo	m_CharInfo;

	Sg_UInt8		m_nFriendAmount;
	GD_FriendData	m_FriendData[FRIEND_MAXAMOUNT];

	std::vector<GD_MailInfo> m_MailInfoVec;//邮箱信息
public:
	MAP_ITEM_INFO* GetItemInfoset();
	VEC_ATTACK_INFO* GetAttackInfoVec();

private:
	MAP_ITEM_INFO m_mapItemInfoset;
	VEC_ATTACK_INFO m_vecAttackInfo;
};

#endif