#include "assert.h"
#include "windows.h"
#include "GameTime.h"
#include "process.h"
#include "mmsystem.h"

#pragma comment(lib, "winmm.lib")

namespace GameTime
{
	class IThreadInterface
	{
	public:
		IThreadInterface(void);
		virtual ~IThreadInterface(void);

		void			StartThread(bool bSuspend = false);
		virtual void	EndThread() = 0;

		inline HANDLE*	GetHandle()	{ return &m_hThread; }

		virtual int	Run() = 0;

	private:
		HANDLE		m_hThread;
	};

	unsigned int __stdcall MyThreadFn(void * pt)
	{
		IThreadInterface * pthis = (IThreadInterface *)pt;

		int rt = pthis->Run();

		ExitThread(0);

		return rt;
	}

	IThreadInterface::IThreadInterface(void)
	{
		m_hThread = NULL;
	}

	IThreadInterface::~IThreadInterface(void)
	{
		if (NULL != m_hThread)
		{
			m_hThread = NULL;
		}
	}

	void		IThreadInterface::StartThread(bool bSuspend)
	{
		assert(NULL == m_hThread);
		if (NULL == m_hThread)
		{
			unsigned int nThreadID;
			m_hThread = (HANDLE)_beginthreadex(NULL, 1024 * 1024, MyThreadFn, this, 0, &nThreadID);
		}
	}

	class CGuard
	{
	public:
		CGuard(CRITICAL_SECTION* cs)
		{
			m_cs = cs;
			EnterCriticalSection(m_cs);
		}

		~CGuard()
		{
			LeaveCriticalSection(m_cs);
		}

	private:
		CRITICAL_SECTION* m_cs;
	};

	class WorkThread : public IThreadInterface
	{
	public:
		WorkThread()
		{
			m_bIsInit = false;

			m_bIsExit = false;
			InitializeCriticalSection(&m_TimeCS);
		}

		virtual void					EndThread()
		{
			m_bIsExit = true;
			Sleep(1);
			//  		WaitForSingleObject(*(GetHandle()), INFINITE);
		}

		virtual int						Run()
		{
			float fScale = 1.0f;
			unsigned int nTotalMS = 0;

			unsigned int nLastTime = timeGetTime();

			while (!m_bIsExit)
			{
				unsigned int nCurrentTime = timeGetTime();
				unsigned int nDiffTime = nCurrentTime - nLastTime;

				if (nCurrentTime > nLastTime && nDiffTime >= 100)
				{
					nLastTime = nCurrentTime;

					nTotalMS += (unsigned int)(nDiffTime * fScale);
				}


				if (nTotalMS > 100 && TryEnterCriticalSection(&m_TimeCS))
				{
					fScale = m_fScale;

					m_GameTime.nSecond += nTotalMS / 1000;
					nTotalMS %= 1000;

					m_GameTime.nMinute += m_GameTime.nSecond / 60;
					m_GameTime.nSecond %= 60;

					m_GameTime.nHour += m_GameTime.nMinute / 60;
					m_GameTime.nMinute %= 60;

					m_GameTime.nDay += m_GameTime.nHour / 24;
					m_GameTime.nHour %= 24;

					m_GameTime.nMonth += m_GameTime.nDay / 30;
					m_GameTime.nDay %= 30;

					m_GameTime.nYear += m_GameTime.nMonth / 12;
					m_GameTime.nMonth %= 12;

					LeaveCriticalSection(&m_TimeCS);
				}

				Sleep(1);
			}

			return 0;
		}

		void	SetTime(GameTimeInfo starttime, float fScale)
		{
			CGuard guard(&m_TimeCS);

			m_GameTime = starttime;
			m_fScale = fScale;

			m_bIsInit = true;
		}

		GameTimeInfo	GetGameTime()
		{
			CGuard guard(&m_TimeCS);
			return m_GameTime;
		}

		float	GetTimeScale()
		{
			CGuard guard(&m_TimeCS);
			return m_fScale;
		}

		bool	IsInit()
		{
			return m_bIsInit;
		}

	private:
		volatile bool	m_bIsExit;
		CRITICAL_SECTION	m_TimeCS;

		GameTimeInfo	m_GameTime;
		float m_fScale;
		bool  m_bIsInit;
	};

}

CGameTime::CGameTime()
{
	m_WorkThreadPtr = new GameTime::WorkThread;
	m_bStartThread = false;
}

CGameTime::~CGameTime()
{
	if (m_bStartThread)
	{
		m_WorkThreadPtr->EndThread();
		// 	delete m_WorkThreadPtr;
	}
}

void	CGameTime::SetTime(GameTimeInfo starttime, float fScale)
{
	m_WorkThreadPtr->SetTime(starttime, fScale);

	if (!m_bStartThread)
	{
		m_WorkThreadPtr->StartThread();
		m_bStartThread = true;
	}
}

GameTimeInfo	CGameTime::GetGameTime()
{
	if (!m_WorkThreadPtr->IsInit())
	{
		GameTimeInfo time;
		memset(&time, 0, sizeof(time));
		return time;
	}

	return m_WorkThreadPtr->GetGameTime();
}

float	CGameTime::GetTimeScale()
{
	if (!m_WorkThreadPtr->IsInit())
	{
		return 0.0f;
	}

	return m_WorkThreadPtr->GetTimeScale();
}

void	CGameTime::Update()
{

}

bool	CGameTime::IsInit()
{
	return m_WorkThreadPtr->IsInit();
}