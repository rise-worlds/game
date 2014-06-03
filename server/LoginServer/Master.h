#ifndef __MASTER_H__
#define __MASTER_H__

#include <string>
#include "Utility/CommonDefs.h"
#include "Utility/Single.h"
#include "Utility/CTimer.h"
#include "common/bytebuffer.h"

class AsioNetwork;

class CMaster : public Common::Single<CMaster>
{
public:
	bool	Init();
	bool	Terminate();

	void	Update();
	void	UpdateFps();

	bool	IsExit()
	{
		return m_bIsExit;
	}
	void	Exit()
	{
		m_bIsExit = true;
	}

	DF_PROPERTY(std::string, ListenIP);
	DF_PROPERTY(UINT8, SvrID);
	DF_PROPERTY(std::string, ConfigSvrIP);
	DF_PROPERTY(UINT16, ConfigSvrPort);

	DF_PROPERTY(UINT8, DBSvrID);
	DF_PROPERTY(UINT32, DBSvrIP);
	DF_PROPERTY(UINT16, DBSvrPort);

	DF_PROPERTY(UINT8, WorldAmount);

	DF_PROPERTY(UINT8, CanAcceptClient);

	AsioNetwork*	GetAsioNetwork()
	{
		return m_pAsioNetwork;
	}

	WriteBuf	m_SceneInfo;
private:
	AsioNetwork*	m_pAsioNetwork;

	float		m_fCurFps;
	bool		m_bIsExit;

	Common::SGtimer	m_CheckConnectTimer;
};

#define Df_Master CMaster::getSingle()
const int	SERVER_IOHANDLER_KEY = 0;
const int	CLIENT_IOHANDLER_KEY = 1;

#endif