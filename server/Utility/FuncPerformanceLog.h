#ifndef __FuncPerformanceLog_H__
#define __FuncPerformanceLog_H__

#include "CommonDefs.h"

#include <map>
#include <stack>
#include <functional>
#include <list>
#include <vector>


BEGINNAMESPACE
#pragma warning(push)
#pragma warning(disable: 4251)

class COMMON_API CFuncPerformanceLog
{
public:
	enum TIMER_COMMAND
	{
		TIMER_RESET,
		TIMER_START,
		TIMER_STOP,
		TIMER_ADVANCE,
		TIMER_GETABSOLUTETIME,
		TIMER_GETAPPTIME,
		TIMER_GETELAPSEDTIME
	};

	class CMyString
	{
	public:
		char *m_pString;

		CMyString(char*p)
		{
			m_pString = p;
		}
		bool operator<(const CMyString& str)const
		{
			return strcmp(m_pString, str.m_pString) < 0;
		}
	};

protected:
	unsigned int m_dwStartLogTick;
	struct SPeriod
	{
		bool bBeginPeriod;
		unsigned int dwCallTimes;
		float fAbsTime;
		float fAllPeriod;
		SPeriod* pParent;
		SPeriod():	bBeginPeriod(false),
			dwCallTimes(0),
			fAbsTime(0.0f),
			fAllPeriod(0.0f),
			//pMe(this),
			pParent(NULL) {}
	};
	void WriteLog();
	typedef std::map<CMyString, SPeriod, std::less<CMyString> > mapPeriod;
	mapPeriod m_map;
	std::stack<SPeriod*> m_stack;

	char	m_szFile[ 200 ];
public:
	CFuncPerformanceLog(void);
	~CFuncPerformanceLog(void);

	static CFuncPerformanceLog&	GetInstance();

	void BeginPeriod(char* lpName);
	void EndPeriod(char* lpName);

	float HQ_Timer(TIMER_COMMAND command);

	void SetFile(char *szFile)
	{
		//strncpy(m_szFile, szFile, sizeof(m_szFile)-1);
		strncpy_s(m_szFile, szFile, sizeof(m_szFile)-1);
	}
};

class COMMON_API CTimeLog
{
public:
	CTimeLog(const char *funcname);
	virtual ~CTimeLog();
	const char* pString;
};



#pragma warning(pop)
ENDNAMESPACE

//#define USETRUETIME


#ifdef USETRUETIME

#define BEGINFUNCPERLOG(x) Common::CFuncPerformanceLog::GetInstance().BeginPeriod(x);
#define ENDFUNCPERLOG(x) Common::CFuncPerformanceLog::GetInstance().EndPeriod(x);

#define TRUETIMEFUNC() Common::CTimeLog gTrueTime_localvar(__FUNCTION__);
#define TRUETIMEBLOCK(a) Common::CTimeLog gTrueTime_localvar(a);

#else

#define BEGINFUNCPERLOG(x)
#define ENDFUNCPERLOG(x)

#define TRUETIMEFUNC()
#define TRUETIMEBLOCK(a)

#endif
#endif // __FuncPerformanceLog_H__