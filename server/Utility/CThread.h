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

BEGINNAMESPACE
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

	void COMMON_API Sleep(unsigned uMilliSecond);
	// Thread
	int COMMON_API SGCreateThread(
	    HTHREAD* phThread,
	    unsigned long nStackSize,
	    XTHREAD_START_ROUTINE lpStartRoutineAddress,
	    void* lpParameter);
	void COMMON_API DetachThread(HTHREAD* phThread);
	void COMMON_API ExitThread(unsigned long dwExitCode);
	int COMMON_API TerminateThread(HTHREAD* HTHREAD, unsigned long dwExitCode);
	void COMMON_API GetCurrentThread(HTHREAD* phThread);
	int COMMON_API JoinThread(HTHREAD* phThread);
	bool COMMON_API SetThreadPriority(HTHREAD* phThread, int nPriority);

	// Lock
	int COMMON_API CreateLock(HLOCK* pLock);
	int COMMON_API ReleaseLock(HLOCK* pLock);

	int COMMON_API Lock(HLOCK* pLock);
	int COMMON_API Unlock(HLOCK* pLock);

	// Event
	int COMMON_API CreateEvent(
	    HEVENT* phEvent,
	    bool bManualReset,
	    bool bInitialState,
	    char* szName
	);
	int COMMON_API DestroyEvent(HEVENT* phEvent);
	int COMMON_API SetEvent(HEVENT* phEvent, bool bSignalAll);
	int COMMON_API ResetEvent(HEVENT* phEvent);
	int COMMON_API WaitForEvent(HEVENT* phEvent, unsigned uMilliSecond);

	// Semaphore
	int COMMON_API CreateSemaphore(HSEMAPHORE* phSemaphore, int nInitCount, int nMaxCount);
	int COMMON_API PutSemaphore(HSEMAPHORE* phSemaphore);
	int COMMON_API GetSemaphore(HSEMAPHORE* phSemaphore, unsigned uMilliSecond);
	int COMMON_API DestroySemaphore(HSEMAPHORE* phSemaphore);

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
		CreateLock(&m_Lock);
	}

	inline CLock::~CLock()
	{
		ReleaseLock(&m_Lock);
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
		Lock(m_pLock);
	}

	inline CGuard::~CGuard()
	{
		Unlock(m_pLock);
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
ENDNAMESPACE

#endif // __CThread_H__
