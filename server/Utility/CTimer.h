#ifndef __CTimer_H__
#define __CTimer_H__

#include "CommonDefs.h"

#ifndef _WIN32
#include <sys/time.h>
#else
#include <windows.h>
#endif

namespace Timer
{
	class COMMON_API CTime
	{
	private:
#if defined WIN32
		static LARGE_INTEGER	ms_uFrequency;
#endif
		static bool				ms_bInited;
		static unsigned			ms_uBaseTime;
	public:
		CTime();
		unsigned GetTime();
	};


	class COMMON_API CTimeCheckPoint//毫秒为单位
	{
	private:
		unsigned	m_uCheckTime;
	public:
		CTimeCheckPoint();
		void SetCheckPoint();
		unsigned GetElapse()const;
	};

	time_t COMMON_API GetCTime();
	unsigned int COMMON_API GetTime();

	void COMMON_API SetTimeFunction(unsigned(*TimeFun)());
	void COMMON_API SetCTimeFunction(time_t (*CTimeFun)());
}

class SGtimer
{
public:
	SGtimer(): m_dwExpireTime(0), m_dwIntervalTime(0), m_bCheckTime(false) {}
	~SGtimer() {}

public:

	// 设置间隔
	inline void SetTimer(unsigned int dwIntervalTime)
	{
		m_dwIntervalTime	= dwIntervalTime;
		Reset();
	}

	inline unsigned int GetIntervalTime()
	{
		return m_dwIntervalTime;
	}

	inline void Reset()
	{
		m_dwExpireTime		= Timer::GetTime() + m_dwIntervalTime;
		EnableCheckTime();
	}
	inline bool IsEnableCheckTime()
	{
		return m_bCheckTime;
	}
	inline void EnableCheckTime()
	{
		m_bCheckTime = true;
	}

	inline void DisableCheckTime()
	{
		m_bCheckTime = false;
	}

	inline void IncreasingExpireTime(unsigned int dwExpireTime)
	{
		m_dwExpireTime += dwExpireTime;
	}

	float GetProgressRatio()
	{
		int dwProgressTime = Timer::GetTime() - (m_dwExpireTime - m_dwIntervalTime);
		return min(1.0f, ((float)dwProgressTime / (float)m_dwIntervalTime));
	}

	inline bool IsExpired(bool bReset = true)
	{
		unsigned int dwCurTime;
		if (m_bCheckTime && (dwCurTime = Timer::GetTime()) >= m_dwExpireTime)
		{
			if (bReset)
			{
				m_dwExpireTime = dwCurTime + m_dwIntervalTime;
			}
			return true;
		}
		else
			return false;
	}

	inline bool IsExpiredManual(bool bReset = true)
	{
		unsigned int dwCurTime;
		if (m_bCheckTime && (dwCurTime = Timer::GetTime()) >= m_dwExpireTime)
		{
			if (bReset)
			{
				m_dwExpireTime = dwCurTime + m_dwIntervalTime;
			}
			DisableCheckTime();
			return true;
		}
		else
			return false;
	}

	void InitCoolTime()
	{
		m_dwExpireTime = 0;
	}

	inline unsigned int GetExpireTime()
	{
		return m_dwExpireTime;
	}

private:
	bool		m_bCheckTime;
	unsigned int		m_dwExpireTime;
	unsigned int		m_dwIntervalTime;

};

#endif // __CTimer_H__