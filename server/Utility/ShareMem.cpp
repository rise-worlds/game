#include "ShareMem.h"
#if defined(_WIN32)
#include <WinBase.h>
#else
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <errno.h>
#endif

#include <stdio.h>

BEGINNAMESPACE
namespace ShareMem
{
	COMMON_API SMHandle CreateShareMem(SM_KEY key, unsigned int Size)
	{
	#ifdef _WIN32
		char keybuf[64];
		memset(keybuf, 0, 64);
		_snprintf_s(keybuf, sizeof(keybuf)-1, "%d", key);
		return  CreateFileMapping((HANDLE)-1, NULL, PAGE_READWRITE, 0, Size, keybuf);
	#else
		//key = ftok(keybuf,'w');
		SMHandle hd = shmget(key, Size, IPC_CREAT | IPC_EXCL | 0666);
		printf("handle = %d ,key = %d ,error: %d \r\n", hd, key, errno);
		return hd;
	#endif
	}

	COMMON_API SMHandle OpenShareMem(SM_KEY key, unsigned int Size)
	{
	#ifdef _WIN32
		char keybuf[64];
		memset(keybuf, 0, 64);
		_snprintf_s(keybuf, sizeof(keybuf)-1, "%d", key);
		return OpenFileMapping(FILE_MAP_ALL_ACCESS, TRUE, keybuf);
	#else
		//key = ftok(keybuf,'w');
		SMHandle hd = shmget(key, Size, 0);
		printf("handle = %d ,key = %d ,error: %d \r\n", hd, key, errno);
		return hd;
	#endif
	}

	COMMON_API void UnMapShareMem(char* MemoryPtr)
	{
	#ifdef _WIN32
		UnmapViewOfFile(MemoryPtr);
	#else
		shmdt(MemoryPtr);
	#endif
	}


	COMMON_API void CloseShareMem(SMHandle handle)
	{
	#ifdef _WIN32
		CloseHandle(handle);
	#else
		shmctl(handle, IPC_RMID, 0);
	#endif
	}

	COMMON_API char* MapShareMem(SMHandle handle)
	{
	#ifdef _WIN32
		return (char *)MapViewOfFile(handle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
	#else
		return (char*)shmat(handle, 0, 0);
	#endif
	}
}
ENDNAMESPACE