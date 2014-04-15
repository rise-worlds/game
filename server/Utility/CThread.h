#ifndef __CThread_H__
#define __CThread_H__

#include "CommonDefs.h"

#ifndef _WIN32
#include <semaphore.h>
#include <unistd.h>
#include <pthread.h>
#else
#include <windows.h>
#endif

#ifndef _WIN32
#define		INFINITE				0
#endif

namespace Thread
{

#ifndef _WIN32

	typedef	pthread_t			HTHREAD;
	typedef pthread_mutex_t		HLOCK;
	typedef	struct _HEVENT
	{
		pthread_cond_t hCond;
		pthread_mutex_t hMutex;
		bool bSignaled;
		bool bAutoReset;
	} HEVENT;
	typedef sem_t				HSEMAPHORE;

	typedef unsigned int (* XTHREAD_START_ROUTINE)(void*);
	typedef void*		HMODULE;
	typedef void*		PROC;
#define		THREAD_PROC			unsigned int

#else

	typedef	HANDLE				HTHREAD;
	typedef	CRITICAL_SECTION	HLOCK;
	typedef	HANDLE				HEVENT;
	typedef HANDLE				HSEMAPHORE;

#define		THREAD_PROC			unsigned int __stdcall
	typedef unsigned int (__stdcall *XTHREAD_START_ROUTINE)(void *);

#endif

	void COMMON_API SGSleep(unsigned uMilliSecond);
	// Thread
	int COMMON_API SGCreateThread(
	    HTHREAD* phThread,
	    unsigned long nStackSize,
	    XTHREAD_START_ROUTINE lpStartRoutineAddress,
	    void* lpParameter);
	void COMMON_API SGDetachThread(HTHREAD* phThread);
	void COMMON_API SGExitThread(unsigned long dwExitCode);
	int COMMON_API SGTerminateThread(HTHREAD* HTHREAD, unsigned long dwExitCode);
	void COMMON_API SGGetCurrentThread(HTHREAD* phThread);
	int COMMON_API SGJoinThread(HTHREAD* phThread);
	bool COMMON_API SGSetThreadPriority(HTHREAD* phThread, int nPriority);

	// Lock
	int COMMON_API SGCreateLock(HLOCK* pLock);
	int COMMON_API SGReleaseLock(HLOCK* pLock);

	int COMMON_API SGLock(HLOCK* pLock);
	int COMMON_API SGUnlock(HLOCK* pLock);

	// Event
	int COMMON_API SGCreateEvent(
	    HEVENT* phEvent,
	    bool bManualReset,
	    bool bInitialState,
	    char* szName
	);
	int COMMON_API SGDestroyEvent(HEVENT* phEvent);
	int COMMON_API SGSetEvent(HEVENT* phEvent, bool bSignalAll);
	int COMMON_API SGResetEvent(HEVENT* phEvent);
	int COMMON_API SGWaitForEvent(HEVENT* phEvent, unsigned uMilliSecond);

	// Semaphore
	int COMMON_API SGCreateSemaphore(HSEMAPHORE* phSemaphore, int nInitCount, int nMaxCount);
	int COMMON_API SGPutSemaphore(HSEMAPHORE* phSemaphore);
	int COMMON_API SGGetSemaphore(HSEMAPHORE* phSemaphore, unsigned uMilliSecond);
	int COMMON_API SGDestroySemaphore(HSEMAPHORE* phSemaphore);

	class CLock
	{
	private:
		HLOCK	m_Lock;
	public:
		HLOCK* GetLock();
		CLock();
		~CLock();
	};

	inline HLOCK* CLock::GetLock()
	{
		return &m_Lock;
	}

	inline CLock::CLock()
	{
		SGCreateLock(&m_Lock);
	}

	inline CLock::~CLock()
	{
		SGReleaseLock(&m_Lock);
	}



	class CGuard
	{
	private:
		HLOCK*	m_pLock;
	public:
		CGuard(HLOCK* pLock);
		~CGuard();
	};


	inline CGuard::CGuard(HLOCK* pLock)
		: m_pLock(pLock)
	{
		SGLock(m_pLock);
	}

	inline CGuard::~CGuard()
	{
		SGUnlock(m_pLock);
	}

}

class COMMON_API IThreadInterface
{
public:
	IThreadInterface(void);
	virtual ~IThreadInterface(void);

	void							StartThread(bool bSuspend = false);
	virtual void					EndThread() = 0;

	inline Thread::HTHREAD*		GetHandle()
	{
		return &m_hThread;
	}

	virtual int						Run() = 0;

private:
	Thread::HTHREAD							m_hThread;
};


#endif // __CThread_H__