#include "Log.h"
#include <time.h>
#include <stdio.h>
#include <string>
#include <stdarg.h>
#include "RingBuffer.h"
#include "CThread.h"
#include "FileSystemUtil.h"

#ifdef _WIN32
#define snprintf _snprintf_s
#endif

BEGINNAMESPACE

struct LogInfo
{
	time_t	Time;
	eLogLevel	eLevel;
	int		nThreadID;
	char	strModule[MAX_PATH];
	char	strMsg[MAX_MESSAGE_LEN];

	LogInfo()
	{
		memset(this, 0, sizeof(*this));
	}
};

class LogWork: public IThreadInterface
{
public:
	LogWork()
	{
		m_nSequence	= 0;
		m_bIsExit	= false;
	}

	~LogWork()
	{
		EndThread();

		if (m_pFile)
		{
			fclose(m_pFile);
			m_pFile	= NULL;
		}

	}

	virtual void	EndThread()
	{
		m_bIsExit	= true;
		if (GetHandle())
		{
			Thread::JoinThread(GetHandle());
		}
	}

	virtual int	Run()
	{
		while (!m_bIsExit)
		{
			SaveAllInfo();

			Thread::Sleep(1);
		}

		return 0;
	}

	// 创建日志
	bool	CreateLog(const char* pszDir, const char* pszFileName)
	{
		std::string strSaveCurDir	= GetCurDir();

		char szLogDirectory[MAX_PATH] = {0};
		char szTemp[MAX_PATH] = {0};
		time_t	systime;
		time(&systime);

		tm Systime	= *localtime(&systime);

		SafeStringCopy(szLogDirectory, pszDir, sizeof(szLogDirectory));
		//CreateDir(szLogDirectory);

		snprintf(szTemp, sizeof(szTemp) - 1, "%s/%04d-%02d-%02d",
		         szLogDirectory,
		         Systime.tm_year + 1900,
		         Systime.tm_mon + 1,
		         Systime.tm_mday);
		SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));
		CreateDir(szLogDirectory);
		ChangeDir(szLogDirectory);

		snprintf(szTemp, sizeof(szTemp) - 1, "%s[%02d_%02d_%02d].log",
		         pszFileName,
		         Systime.tm_hour,
		         Systime.tm_min,
		         Systime.tm_sec);
		SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));

		strLogFileName	= szLogDirectory;

		m_pFile = fopen(szLogDirectory, "w");

		if (m_pFile == NULL)
		{
			return false;
		}

		StartThread();

		ChangeDir(strSaveCurDir);
		return true;
	}

	// 写日志到缓冲区
	bool	OutLog(eLogLevel eLevel, const char* pszModule, const char * pszMessage)
	{
		LogInfo*	pLogInfo	= NULL;
		int			nWriteSize	= 0;

		LogBuffer.GetWritePtr(pLogInfo, nWriteSize);

		if (nWriteSize == 0)
		{
			return false;
		}

		time(&(pLogInfo->Time));
		pLogInfo->eLevel	= eLevel;
		pLogInfo->nThreadID	= 0;
		SafeStringCopy(pLogInfo->strModule,
		               strrchr(pszModule, '/') ? strrchr(pszModule, '/') + 1 : pszModule,
		               sizeof(pLogInfo->strModule));
		SafeStringCopy(pLogInfo->strMsg, pszMessage, sizeof(pLogInfo->strMsg));

		LogBuffer.AddData(1);

		return true;
	}

	// 将缓冲区的日志保存到文件
	void	SaveAllInfo()
	{
		LogInfo* pReadPtr	= 0;
		int nReadSize	= 0;
		LogBuffer.GetReadPtr(pReadPtr, nReadSize);
		if (nReadSize != 0)
		{
			for (int i = 0; i < nReadSize; i++)
			{
				LogInfo* pInfo	= pReadPtr + i;
#ifndef _DEBUG
				if(!pInfo || (pInfo->eLevel != eLog_Error && pInfo->eLevel != eLog_Warning))
				{
					continue;
				}
#endif
				tm Time	= *localtime(&(pInfo->Time));

				// print to screen
				printf("[%2d:%2d:%2d] %s\n",
				       Time.tm_hour, Time.tm_min, Time.tm_sec,
				       pInfo->strMsg);

				// print to file
				char szBuffer[2048] = {0};
				snprintf(szBuffer, sizeof(szBuffer) - 1,
				         "%4d-%2d-%2d %2d:%2d:%2d,\t%4d,\t%4d,\t%4d,%s,%s,%s,\n",
				         Time.tm_year + 1900, Time.tm_mon + 1, Time.tm_mday,
				         Time.tm_hour, Time.tm_min, Time.tm_sec,
				         m_nSequence++,
				         pInfo->eLevel,
				         pInfo->nThreadID,
				         pInfo->strModule,
				         "",
				         pInfo->strMsg);

				fwrite(szBuffer, strlen(szBuffer), 1, m_pFile);
			}

			LogBuffer.DeleteData(nReadSize);

			fflush(m_pFile);
		}
	}

private:
	std::string	strLogFileName;
	FILE*	m_pFile;
	int		m_nSequence;
	bool	m_bIsExit;

	RingBuffer<LogInfo>	LogBuffer;

};

static LogWork* s_LogWork	= NULL;

Log::Log()
{

}

Log::~Log()
{
	if (s_LogWork)
	{
		delete s_LogWork;
		s_LogWork	= NULL;
	}
}

bool	Log::CreateLog(const char* pszDir, const char* pszFileName)
{
	if (s_LogWork)
	{
		return false;
	}

	s_LogWork	= new LogWork;
	bool bResult	= s_LogWork->CreateLog(pszDir, pszFileName);
	if (!bResult)
	{
		delete s_LogWork;
		s_LogWork	= NULL;
	}

	return bResult;
}

bool	Log::OutLog(eLogLevel eLevel, const char* pszModule, const char * pszFormat, ...)
{
	assert(s_LogWork);
	char szMessage[MAX_MESSAGE_LEN]	= {0};

	// Format the variable length parameter list
	va_list va;
	va_start(va, pszFormat);
	vsnprintf(szMessage, sizeof(szMessage), pszFormat, va);
	va_end(va);

	s_LogWork->OutLog(eLevel, pszModule, szMessage);

	return true;
}

void	Log::ShowLogView()
{

}

ENDNAMESPACE
