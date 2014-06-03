#include "stdafx.h"
#include "CThread.h"
#include "assert.h"
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sstream>
#include <stdio.h>

#ifdef _WIN32
#include <process.h>
#endif

#include <time.h>

#ifndef _WIN32
#include <sys/time.h>
#else
#include <windows.h>
#endif

using namespace std;

BEGINNAMESPACE
namespace Thread
{

	void COMMON_API Sleep(unsigned uMiliSecond)
	{
#ifdef _WIN32
		::Sleep(uMiliSecond);
#else
		timespec ts;
		ts.tv_sec	= uMiliSecond / 1000;
		ts.tv_nsec	= uMiliSecond % 1000 * 1000000;
		if (-1 == nanosleep(&ts, &ts))
		{
			ostringstream strm;
			strm << "nanosleep failed with error:" << strerror(errno) << ends;
			printf(strm.str().c_str());
		}
#endif
	}

	//////////////////////////////////////////////////////////////////////////
	// Thread section
	int CreateThread(
	    HTHREAD* phThread,
	    unsigned long nStackSize,
	    XTHREAD_START_ROUTINE lpStartRoutineAddress,
	    void* lpParameter)
	{
		if (lpStartRoutineAddress == NULL)
			return false;
		if (nStackSize < 0)
			return false;
		assert(phThread);
#ifndef _WIN32
		int nRetCode = pthread_create(phThread, NULL,
		                              reinterpret_cast<void * (*)(void*)>(lpStartRoutineAddress), lpParameter);
		if (nRetCode != 0)
			return false;
#else
		unsigned ThreadID;
		*phThread = (HANDLE)_beginthreadex(0, nStackSize, lpStartRoutineAddress, lpParameter, 0, &ThreadID);
		//*phThread = ::CreateThread(NULL, nStackSize, lpStartRoutineAddress, lpParameter, 0, lpThreadID);
		if (*phThread == NULL)
			return false;
#endif
		return true;
	}

	void DetachThread(HTHREAD* phThread)
	{
#ifndef _WIN32
		pthread_detach(*phThread);
#else
		CloseHandle(*phThread);
#endif
	}

	void ExitThread(unsigned long dwExitCode)
	{
#ifndef _WIN32
		pthread_exit(&dwExitCode);
#else
		_endthreadex(dwExitCode);
#endif
	}

	int TerminateThread(HTHREAD* phThread, unsigned long dwExitCode)
	{
		int nRetCode = 0;

#ifndef _WIN32
		nRetCode = pthread_cancel(*phThread);
		nRetCode = !nRetCode;
#else
		nRetCode = ::TerminateThread(*phThread, dwExitCode);
#endif

		return nRetCode;
	}

	void GetCurrentThread(HTHREAD* phThread)
	{
#ifndef _WIN32
		*phThread = pthread_self();
#else
		*phThread = ::GetCurrentThread();
#endif
	}

	int JoinThread(HTHREAD* phThread)
	{
		int nRetCode = 0;

#ifndef _WIN32
		nRetCode = pthread_join(*phThread, NULL);
		phThread	= NULL;
		nRetCode = !nRetCode;
#else
		nRetCode = WaitForSingleObject(*phThread, INFINITE);
		switch (nRetCode)
		{
		case WAIT_FAILED:
			nRetCode = 0;
			break;
		case WAIT_ABANDONED:
		case WAIT_OBJECT_0:
			CloseHandle(*phThread);
			*phThread	= NULL;
			nRetCode = 1;
			break;
		default:
			printf("WaitForSingleObject failed.\n");
		}
#endif
		return nRetCode;
	}

	bool COMMON_API SetThreadPriority(HTHREAD* phThread, int nPriority)
	{
#ifndef _WIN32
		return true;
#else
		return ::SetThreadPriority(*phThread, nPriority) != 0;
#endif
	}

	//////////////////////////////////////////////////////////////////////////
	// Lock section
	int CreateLock(HLOCK* pLock)
	{
#ifndef _WIN32
		pthread_mutexattr_t attr;
		//attr.__mutexkind = PTHREAD_MUTEX_RECURSIVE_NP;
		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE_NP);

		pthread_mutex_init(pLock, &attr);
#else
		InitializeCriticalSection(pLock);
#endif
		return true;
	}

	int ReleaseLock(HLOCK* pLock)
	{
#ifndef _WIN32
		int nRetCode = 0;
		nRetCode = pthread_mutex_destroy(pLock);
		if (nRetCode != 0)
			return false;
#else
		DeleteCriticalSection(pLock);
#endif
		return true;
	}

	int Lock(HLOCK* pLock)
	{
#ifndef _WIN32
		pthread_mutex_lock(pLock);
#else
		EnterCriticalSection(pLock);
#endif
		return true;
	}

	int Unlock(HLOCK* pLock)
	{
#ifndef _WIN32
		pthread_mutex_unlock(pLock);
#else
		LeaveCriticalSection(pLock);
#endif
		return true;
	}

	//////////////////////////////////////////////////////////////////////////
	// Event section
	int CreateEvent(
	    HEVENT* phEvent,
	    bool bManualReset,
	    bool bInitialState,
	    char* szName
	)
	{
#ifndef _WIN32
		pthread_cond_init(&(phEvent->hCond), NULL);
		pthread_mutex_init(&(phEvent->hMutex), NULL);
		phEvent->bSignaled = bInitialState;
		phEvent->bAutoReset = bManualReset;
#else
		*phEvent = ::CreateEvent(NULL, bManualReset, bInitialState, szName);
#endif
		return true;
	}

	int DestroyEvent(HEVENT* phEvent)
	{
		int nRetCode = false;

#ifndef _WIN32
		pthread_cond_destroy(&(phEvent->hCond));
		pthread_mutex_destroy(&(phEvent->hMutex));

		nRetCode = true;
#else
		nRetCode = CloseHandle(*phEvent);
		nRetCode = !nRetCode;
#endif

		return nRetCode;
	}

	int SetEvent(HEVENT* phEvent, bool bSignalAll)
	{
		int nRetCode = 0;

#ifndef _WIN32
		//Wake up all waiting thread
		if (bSignalAll)
			nRetCode = pthread_cond_broadcast(&(phEvent->hCond));
		//Just wake up a single thread
		else
			nRetCode = pthread_cond_signal(&(phEvent->hCond));

		nRetCode = !nRetCode;
#else
		// In windows, unsupport broadcast??
		nRetCode = ::SetEvent(*phEvent);
#endif

		return nRetCode;
	}

	int ResetEvent(HEVENT* phEvent)
	{
#ifndef _WIN32
		if (phEvent->bAutoReset)
			return false;

		phEvent->bSignaled = false;
#else
		::ResetEvent(phEvent);
#endif

		return true;
	}

	int WaitForEvent(HEVENT* phEvent, unsigned uMilliSecond)
	{
		//			int nRetCode = 0;
		//
		//#ifndef _WIN32
		//			struct timespec tsTimeout;
		//
		//			if (phEvent == NULL)
		//				return 0;
		//
		//			if (phEvent->bSignaled)
		//			{
		//			}
		//			else if (uMilliSecond==0)
		//			{
		//				return -1;
		//			}
		//			else if (uMilliSecond==UINT_MAX)
		//			{
		//				int nResult=pthread_cond_wait(&(phEvent->hCond), &(phEvent->hMutex));
		//				switch(nResult)
		//				{
		//				case ETIMEDOUT:
		//					GenErr("pthread_cond_wait timeout under infinite wait.");
		//				case 0:
		//					break;
		//				default:
		//					return 0;
		//				}
		//			}
		//			else
		//			{
		//				tsTimeout.tv_sec = uMilliSecond/1000;
		//				tsTimeout.tv_nsec = uMilliSecond%1000*10000000;
		//
		//				nRetCode = pthread_cond_timedwait(&(phEvent->hCond), &(phEvent->hMutex), &tsTimeout);
		//				//Time out
		//				switch(nRetCode == ETIMEDOUT)
		//				{
		//				case ETIMEDOUT:
		//					return -1;
		//				case 0:
		//					return 1;
		//				default:
		//					return 0;
		//			}
		//
		//			if (phEvent->bAutoReset)
		//				phEvent->bSignaled = false;
		//#else
		//			int nTimeout;
		//
		//			nTimeout = 0;
		//			if (nSeconds > 0)
		//				nTimeout = nSeconds / 1000;
		//			else if (nSeconds == INFINITE)
		//				nTimeout = INFINITE;
		//			else
		//			{
		//				if (nNanoSeconds > 0)
		//				{
		//					nTimeout = nNanoSeconds * 1000;
		//				}
		//			}
		//			if (nTimeout == 0)
		//				nTimeout = INFINITE;
		//
		//			nRetCode = WaitForSingleObject(phEvent, nTimeout);
		//			if (nRetCode == WAIT_FAILED)
		//				nRetCode = 0;
		//			else
		//				nRetCode = 1;
		//#endif
		//			return nRetCode;
		printf("Not implement yet\n");
		return 0;
	}

	//////////////////////////////////////////////////////////////////////////
	// Semaphore section
	int CreateSemaphore(HSEMAPHORE* phSemaphore, int nInitCount, int nMaxCount)
	{
#ifndef _WIN32
		sem_init(phSemaphore, 0, nInitCount);
#else
		*phSemaphore = ::CreateSemaphore(NULL, nInitCount, nMaxCount, NULL);
#endif
		return true;
	}

	int PutSemaphore(HSEMAPHORE* phSemaphore)
	{
#ifndef _WIN32
		sem_post(phSemaphore);
#else
		// Once a semaphore was release, called "put" here, increase the COUNT by 1.
		ReleaseSemaphore(*phSemaphore, 1, NULL);
#endif
		return true;
	}

	int GetSemaphore(HSEMAPHORE* phSemaphore, unsigned uMilliSecs)
	{
#ifndef _WIN32
		timeval tv;
		gettimeofday(&tv, NULL);
		uMilliSecs += tv.tv_sec * 1000 + tv.tv_usec / 1000;

		timespec ts;
		ts.tv_sec = tv.tv_sec + uMilliSecs / 1000;
		ts.tv_nsec = uMilliSecs % 1000 * 1000000;
		if (ts.tv_nsec > 1000000000)
		{
			ts.tv_sec += ts.tv_nsec / 1000000000;
			ts.tv_nsec = ts.tv_nsec % 1000000000;
		}
again:
		if (0 == sem_timedwait(phSemaphore, &ts))
			return 1;

		switch (errno)
		{
		case ETIMEDOUT:
			return 0;
		case EINTR:
			goto again;
		default:
			return -1;
		}
#else
		switch (WaitForSingleObject(*phSemaphore, uMilliSecs))
		{
		case WAIT_OBJECT_0:
			return 1;
		case WAIT_TIMEOUT:
			return 0;
		default:
			return -1;
		}
#endif
	}

	int DestroySemaphore(HSEMAPHORE* phSemaphore)
	{
#ifndef _WIN32
		sem_destroy(phSemaphore);
#else
		CloseHandle(*phSemaphore);
#endif
		return true;
	}
}


#ifdef _WIN32
static unsigned int __stdcall MyThreadFn(void * pt)
#else
static unsigned int MyThreadFn(void * pt)
#endif
{
	IThreadInterface * pthis = (IThreadInterface *)pt;

	int rt = pthis->Run();

	Thread::ExitThread(0);

	return rt;
}

IThreadInterface::IThreadInterface(void)
{
	m_hThread	= NULL;
}

IThreadInterface::~IThreadInterface(void)
{
	if (NULL != m_hThread)
	{
		//Thread::DetachThread( &m_hThread );
		m_hThread = NULL;
	}
}

void		IThreadInterface::StartThread(bool bSuspend)
{
	assert(NULL == m_hThread);
	if (NULL == m_hThread)
	{
		Thread::CreateThread(&m_hThread, 1024 * 1024, MyThreadFn, this);
	}
}

ENDNAMESPACE
