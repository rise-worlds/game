#include "stdafx.h"
#include "CTimer.h"
#include "CThread.h"
#include <time.h>
#include <assert.h>
#ifndef _WIN32
#include <sys/time.h>
#endif

using namespace Common::Thread;

BEGINNAMESPACE

namespace Timer
{
	inline static HLOCK* GetTimeLock()
	{
		static CLock lock;
		return lock.GetLock();
	}


#if defined WIN32
	LARGE_INTEGER CTime::ms_uFrequency = {0};
#endif
	unsigned CTime::ms_uBaseTime;
	bool CTime::ms_bInited = false;

	CTime::CTime()
	{
		CGuard	guard(GetTimeLock());
		if (!ms_bInited)
		{
#if defined WIN32
			LARGE_INTEGER uFrequency;
			QueryPerformanceFrequency(&uFrequency);
			ms_uFrequency = uFrequency;
			assert(ms_uFrequency.QuadPart >= 1000);
			ms_uFrequency.QuadPart /= 1000;
			LARGE_INTEGER uCounter;
			QueryPerformanceCounter(&uCounter);
			ms_uBaseTime = unsigned(uCounter.QuadPart / ms_uFrequency.QuadPart);
#else
			timeval tv;
			gettimeofday(&tv, NULL);
			ms_uBaseTime = tv.tv_sec * 1000 + tv.tv_usec / 1000;
#endif
			ms_bInited = true;
		}
	}

	unsigned CTime::GetTime()
	{
#ifndef _WIN32
		timeval tv;
		gettimeofday(&tv, NULL);
		return (tv.tv_sec * 1000 + tv.tv_usec / 1000) - ms_uBaseTime;
#else
		LARGE_INTEGER uTime;
		QueryPerformanceCounter(&uTime);
		return unsigned(uTime.QuadPart / ms_uFrequency.QuadPart) - ms_uBaseTime;
#endif
	}


	static unsigned(*CustomTimeFun)() = NULL;
	static time_t (*CustomCTimeFun)() = NULL;


	unsigned GetTime()
	{
		static CTime s_Time;
		if (CustomTimeFun)
			return CustomTimeFun();
		return s_Time.GetTime();
	}

	time_t GetCTime()
	{
		if (CustomCTimeFun)
			return CustomCTimeFun();
		time_t t;
		return time(&t);
	}

	void SetTimeFunction(unsigned(*TimeFun)())
	{
		CustomTimeFun = TimeFun;
	}

	void SetCTimeFunction(time_t (*CTimeFun)())
	{
		CustomCTimeFun = CTimeFun;
	}


	CTimeCheckPoint::CTimeCheckPoint()
	{
		SetCheckPoint();
	}

	void CTimeCheckPoint::SetCheckPoint()
	{
		m_uCheckTime = GetTime();
	}


	unsigned CTimeCheckPoint::GetElapse()const
	{
		return GetTime() - m_uCheckTime;
	}
}
ENDNAMESPACE