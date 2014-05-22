#include "FuncPerformanceLog.h"
#include "CTimer.h"
#include <stdio.h>
#include <time.h>
#include <string>

BEGINNAMESPACE

CFuncPerformanceLog&	CFuncPerformanceLog::GetInstance()
{
	static CFuncPerformanceLog s_FuncPerformanceLog;
	return s_FuncPerformanceLog;
}

CFuncPerformanceLog::CFuncPerformanceLog(void)
{
	SetFile("funcperformance.log");
}

CFuncPerformanceLog::~CFuncPerformanceLog(void)
{
	WriteLog();
}

void CFuncPerformanceLog::WriteLog()
{
	FILE *fp;

	time_t tt;
	time(&tt);
	std::string strTime(ctime(&tt));

	if (m_map.size() <= 0)
		return;

	fp = fopen(m_szFile, "ab");
	if (!fp)
		return;

	fprintf(fp, "时间:%s", strTime.c_str());

#ifdef _DEBUG
	fprintf(fp, "\n\nDebug version\r\n");
#else
	fprintf(fp, "Release version\r\n");
#endif

	//DWORD iTotal = GetTickCount() - m_dwStartLogTick;
	float fTotal = HQ_Timer(TIMER_GETAPPTIME);
	fprintf(fp, "Total:%d\r\n", (INT32)(fTotal * 1000));
	mapPeriod::iterator it;
	fprintf(fp, "functions performance log:\r\n");
	fprintf(fp, "|%-30s|%-11s|%-11s|%-15s|%-12s|\r\n", "功能", "花费时间", "调用次数", "平均调用时间", "总百分比");
	for (it = m_map.begin() ; it != m_map.end(); it ++)
	{
		CMyString s = (*it).first;;
		fprintf(fp,
		        "|%-30s|%11d|%11d|%15f|%12f|\r\n",
		        (*it).first,
		        //(*it).second.dwAllPeriod,
				INT32((*it).second.fAllPeriod * 1000),
		        (*it).second.dwCallTimes,
		        (float)((*it).second.fAllPeriod * 1000 / (float)(*it).second.dwCallTimes),
		        //((float)((*it).second.dwAllPeriod)/(float)iTotal)*100.0f );
		        (*it).second.fAllPeriod / fTotal * 100.0f);
	}

	fclose(fp);
}

void CFuncPerformanceLog::BeginPeriod(char* lpName)
{
	mapPeriod::iterator it;
	SPeriod period;
	it = m_map.find(lpName);
	if (it == m_map.end())
	{
		period.bBeginPeriod = true;
		period.fAbsTime = HQ_Timer(TIMER_GETABSOLUTETIME);
		period.dwCallTimes = 0;
		period.fAllPeriod = 0;
		period.pParent = NULL;

		m_map.insert(mapPeriod::value_type(lpName, period));
	}
	else
	{
		(*it).second.bBeginPeriod = true;
		(*it).second.fAbsTime = HQ_Timer(TIMER_GETABSOLUTETIME);
	}
}

void CFuncPerformanceLog::EndPeriod(char* lpName)
{
	mapPeriod::iterator it;
	it = m_map.find(lpName);
	if (it == m_map.end() || !(*it).second.bBeginPeriod)
	{
		assert(false);
		return;
	}

	float fTime = HQ_Timer(TIMER_GETABSOLUTETIME);
	fTime -= (*it).second.fAbsTime;
	(*it).second.fAllPeriod += fTime;


	(*it).second.dwCallTimes ++;
}

CTimeLog::CTimeLog(const char *funcname)
{
	assert(funcname);
	pString = funcname;
	CFuncPerformanceLog::GetInstance().BeginPeriod((char*)pString);
}
CTimeLog::~CTimeLog()
{
	CFuncPerformanceLog::GetInstance().EndPeriod((char*)pString);
}

//-----------------------------------------------------------------------------
// Name: DXUtil_Timer()
// Desc: Performs timer opertations. Use the following commands:
//          TIMER_RESET           - to reset the timer
//          TIMER_START           - to start the timer
//          TIMER_STOP            - to stop (or pause) the timer
//          TIMER_ADVANCE         - to advance the timer by 0.1 seconds
//          TIMER_GETABSOLUTETIME - to get the absolute system time
//          TIMER_GETAPPTIME      - to get the current time
//          TIMER_GETELAPSEDTIME  - to get the time that elapsed between
//                                  TIMER_GETELAPSEDTIME calls
//-----------------------------------------------------------------------------
float CFuncPerformanceLog::HQ_Timer(TIMER_COMMAND command)
{
	static bool     m_bTimerInitialized = false;
	static bool     m_bUsingQPF         = false;
	static bool     m_bTimerStopped     = true;
	static INT64	m_llQPFTicksPerSec  = 0;

	//// Initialize the timer
	//if( false == m_bTimerInitialized )
	//{
	//	m_bTimerInitialized = true;

	//	// Use QueryPerformanceFrequency() to get frequency of timer.  If QPF is
	//	// not supported, we will timeGetTime() which returns milliseconds.
	//	LARGE_INTEGER qwTicksPerSec;
	//	m_bUsingQPF = QueryPerformanceFrequency( &qwTicksPerSec );
	//	if( m_bUsingQPF )
	//		m_llQPFTicksPerSec = qwTicksPerSec.QuadPart;
	//}

	//if( m_bUsingQPF )
	//{
	//	static SGint64 m_llStopTime        = 0;
	//	static SGint64 m_llLastElapsedTime = 0;
	//	static SGint64 m_llBaseTime        = 0;
	//	double fTime;
	//	double fElapsedTime;
	//	LARGE_INTEGER qwTime;

	//	// Get either the current time or the stop time, depending
	//	// on whether we're stopped and what command was sent
	//	if( m_llStopTime != 0 && command != TIMER_START && command != TIMER_GETABSOLUTETIME)
	//		qwTime.QuadPart = m_llStopTime;
	//	else
	//		QueryPerformanceCounter( &qwTime );

	//	// Return the elapsed time
	//	if( command == TIMER_GETELAPSEDTIME )
	//	{
	//		fElapsedTime = (double) ( qwTime.QuadPart - m_llLastElapsedTime ) / (double) m_llQPFTicksPerSec;
	//		m_llLastElapsedTime = qwTime.QuadPart;
	//		return (float) fElapsedTime;
	//	}

	//	// Return the current time
	//	if( command == TIMER_GETAPPTIME )
	//	{
	//		double fAppTime = (double) ( qwTime.QuadPart - m_llBaseTime ) / (double) m_llQPFTicksPerSec;
	//		return (float) fAppTime;
	//	}

	//	// Reset the timer
	//	if( command == TIMER_RESET )
	//	{
	//		m_llBaseTime        = qwTime.QuadPart;
	//		m_llLastElapsedTime = qwTime.QuadPart;
	//		m_llStopTime        = 0;
	//		m_bTimerStopped     = FALSE;
	//		return 0.0f;
	//	}

	//	// Start the timer
	//	if( command == TIMER_START )
	//	{
	//		if( m_bTimerStopped )
	//			m_llBaseTime += qwTime.QuadPart - m_llStopTime;
	//		m_llStopTime = 0;
	//		m_llLastElapsedTime = qwTime.QuadPart;
	//		m_bTimerStopped = FALSE;
	//		return 0.0f;
	//	}

	//	// Stop the timer
	//	if( command == TIMER_STOP )
	//	{
	//		m_llStopTime = qwTime.QuadPart;
	//		m_llLastElapsedTime = qwTime.QuadPart;
	//		m_bTimerStopped = TRUE;
	//		return 0.0f;
	//	}

	//	// Advance the timer by 1/10th second
	//	if( command == TIMER_ADVANCE )
	//	{
	//		m_llStopTime += m_llQPFTicksPerSec/10;
	//		return 0.0f;
	//	}

	//	if( command == TIMER_GETABSOLUTETIME )
	//	{
	//		fTime = qwTime.QuadPart / (double) m_llQPFTicksPerSec;
	//		return (float) fTime;
	//	}

	//	return -1.0f; // Invalid command specified
	//}
	//else
	{
		// Get the time using timeGetTime()
		static double m_fLastElapsedTime  = 0.0;
		static double m_fBaseTime         = 0.0;
		static double m_fStopTime         = 0.0;
		double fTime;
		double fElapsedTime;

		// Get either the current time or the stop time, depending
		// on whether we're stopped and what command was sent
		if (m_fStopTime != 0.0 && command != TIMER_START && command != TIMER_GETABSOLUTETIME)
			fTime = m_fStopTime;
		else
			fTime = Timer::GetTime() * 0.001;

		// Return the elapsed time
		if (command == TIMER_GETELAPSEDTIME)
		{
			fElapsedTime = (double)(fTime - m_fLastElapsedTime);
			m_fLastElapsedTime = fTime;
			return (float) fElapsedTime;
		}

		// Return the current time
		if (command == TIMER_GETAPPTIME)
		{
			return (float)(fTime - m_fBaseTime);
		}

		// Reset the timer
		if (command == TIMER_RESET)
		{
			m_fBaseTime         = fTime;
			m_fLastElapsedTime  = fTime;
			m_fStopTime         = 0;
			m_bTimerStopped     = false;
			return 0.0f;
		}

		// Start the timer
		if (command == TIMER_START)
		{
			if (m_bTimerStopped)
				m_fBaseTime += fTime - m_fStopTime;
			m_fStopTime = 0.0f;
			m_fLastElapsedTime  = fTime;
			m_bTimerStopped = false;
			return 0.0f;
		}

		// Stop the timer
		if (command == TIMER_STOP)
		{
			m_fStopTime = fTime;
			m_fLastElapsedTime  = fTime;
			m_bTimerStopped = true;
			return 0.0f;
		}

		// Advance the timer by 1/10th second
		if (command == TIMER_ADVANCE)
		{
			m_fStopTime += 0.1f;
			return 0.0f;
		}

		if (command == TIMER_GETABSOLUTETIME)
		{
			return (float) fTime;
		}

		return -1.0f; // Invalid command specified
	}
}

ENDNAMESPACE