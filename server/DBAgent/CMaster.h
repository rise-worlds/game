#ifndef __CMaster_H__
#define __CMaster_H__

class AsioNetwork;
class CMaster : public Common::Single < CMaster >
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

	DF_PROPERTY(UINT8, WorldAmount);

	DF_PROPERTY(UINT8, DBThreadAmount);

	AsioNetwork*	GetAsioNetwork()
	{
		return m_pAsioNetwork;
	}

	COTLDataBase&	GetOTLDatabase()
	{
		return *m_pOTLDatabase;
	}

	bool	InitDatabase(int nThreadAmount, CONNECT_INFO* ptr, int nAmount);
	const char* GetActionLogTable();
private:
	AsioNetwork*	m_pAsioNetwork;
	COTLDataBase*	m_pOTLDatabase;

	float		m_fCurFps;
	bool		m_bIsExit;

	Common::SGtimer	m_CheckConnectTimer;
	Common::SGtimer	m_CheckActionLogTable;
	std::string m_strActionLogTable;
	time_t m_tCurActionLogTable;
};

#define Df_Master	CMaster::getSingle()

const int	CLIENT_IOHANDLER_KEY = 0;

#endif