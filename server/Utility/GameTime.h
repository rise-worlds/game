#pragma once
#include "Utility/Single.h"

#if defined(COMMON_EXPORTS)
#define GAMETIME_API __declspec(dllexport)
#else
#define GAMETIME_API __declspec(dllimport)
#endif

struct GameTimeInfo
{
	UINT32	nYear;
	UINT32	nMonth;
	UINT32	nDay;
	UINT32	nHour;
	UINT32	nMinute;
	UINT32	nSecond;
};

namespace GameTime
{
	class WorkThread;
};

class GAMETIME_API CGameTime : public Common::Single<CGameTime>
{
protected:
	CGameTime();
	~CGameTime();

public:
	//static CGameTime&	GetSingleton()
	//{
	//	static CGameTime s_GameTime;
	//	return s_GameTime;
	//}

	void	SetTime(GameTimeInfo starttime, float fScale);
	void	Update();

	GameTimeInfo	GetGameTime();
	float	GetTimeScale();

	bool	IsInit();

private:
	GameTime::WorkThread*	m_WorkThreadPtr;
	bool m_bStartThread;
};