#include "Utility.h"
#include "FunctionGuard.h"
#include "FileSystemUtil.h"
#include <time.h>
#include <stdio.h>
#include <string>
#include <stdarg.h>
#include "StackWalker.h"
#include <tchar.h>
#include "dbghelp.h"
#pragma warning(disable: 4800)
#ifdef _WIN32
#define snprintf _snprintf_s
#endif

#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

    void * _ReturnAddress(void);
#pragma intrinsic(_ReturnAddress)

#ifdef _X86_
    void * _AddressOfReturnAddress(void);
#pragma intrinsic(_AddressOfReturnAddress)
#endif  /* _X86_ */
}
#ifndef _WIN32
#define STATUS_INVALID_PARAMETER         ((LONG)0xC000000DL)
#endif

// based on dbghelp.h
typedef BOOL (WINAPI *MINIDUMPWRITEDUMP)(HANDLE hProcess, DWORD dwPid, HANDLE hFile, MINIDUMP_TYPE DumpType,
                                         CONST PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam,
                                         CONST PMINIDUMP_USER_STREAM_INFORMATION UserStreamParam,
                                         CONST PMINIDUMP_CALLBACK_INFORMATION CallbackParam
                                         );


BEGINNAMESPACE

class MyStackWalker: public StackWalker
{
public:
    virtual void OnOutput(LPCSTR szText)
    {
		CDebugInfoHelper::getSingle().Output("%s", szText);
    }

    virtual void OnCallstackEntry(CallstackEntryType eType, CallstackEntry &entry)
    {
        StackWalker::OnCallstackEntry(eType, entry);
        vStackInfoIndex.push_back((unsigned int)entry.offset);
    }

    std::vector<unsigned int> vStackInfoIndex;
};

CDebugInfoHelper::CDebugInfoHelper(const char* strPath, const char* strProcessName, unsigned int nVer)
{
    m_strPath = strPath;
    m_strProcessName = strProcessName;
    m_nVer = nVer;

    m_pFile = NULL;
}

CDebugInfoHelper::~CDebugInfoHelper()
{

}

void CDebugInfoHelper::OnCatch()
{
    std::string strSaveCurDir	= GetCurDir();

    try
    {
        unsigned int nBugIndex = 0;
        // 判断是否已经存在的BUG
		try
        {
            MyStackWalker myStackWalker;
            myStackWalker.ShowCallstack();

            for (; nBugIndex<m_vecExistStackAddr.size(); nBugIndex++)
            {
                if (myStackWalker.vStackInfoIndex == m_vecExistStackAddr[nBugIndex].first)
                {
                    break;
                }
            }

            if (nBugIndex >= m_vecExistStackAddr.size())
            {
                //　是新问题
                m_vecExistStackAddr.push_back(std::make_pair(myStackWalker.vStackInfoIndex, std::make_pair(int(nBugIndex), 1)));
            }
            else
            {
                m_vecExistStackAddr[nBugIndex].second.second++;
                return;
            }
        }
		catch (...)
		{
			
		}

        // 更改工作目录
        const char* pszDir = m_strPath.c_str();

        char szLogDirectory[MAX_PATH] = {0};
        char szTemp[MAX_PATH] = {0};
        time_t	systime;
        time(&systime);

        tm Systime	= *localtime(&systime);

        SafeStringCopy(szLogDirectory, pszDir, sizeof(szLogDirectory));

        snprintf(szTemp, sizeof(szTemp) - 1, "%s/%04d-%02d-%02d",
            szLogDirectory,
            Systime.tm_year + 1900,
            Systime.tm_mon + 1,
            Systime.tm_mday);
        SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));

        snprintf(szTemp, sizeof(szTemp) - 1, "%s/%s",
            szLogDirectory,
            m_strProcessName.c_str());
        SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));

        snprintf(szTemp, sizeof(szTemp) - 1, "%s/Bug%02d_%02d_%02d_%02d",
            szLogDirectory,
            nBugIndex,
            Systime.tm_hour,
            Systime.tm_min,
            Systime.tm_sec);
        SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));
        
        CreateDir(szLogDirectory);
        ChangeDir(szLogDirectory);

        // 记录堆栈信息
        try
        {
            do 
            {
                m_pFile = fopen("StackWalker.txt", "w");

                if (m_pFile == NULL)
                {
                    break;
                }

                MyStackWalker myStackWalker;
                myStackWalker.ShowCallstack();

            } while (0);

            if (m_pFile)
            {
                fclose(m_pFile);
                m_pFile = NULL;
            }
        }
        catch(...)
        {

        }

        // 记录程序信息
        try
        {
            do 
            {
                m_pFile = fopen("SelfInfo.txt", "w");

                if (m_pFile == NULL)
                {
                    break;
                }

                fprintf(m_pFile, "当前程序版本:0x%08X\n", m_nVer);

                MEMORYSTATUS memstatus;
                memset(&memstatus, 0, sizeof(memstatus));
                memstatus.dwLength = sizeof(memstatus);

                GlobalMemoryStatus(&memstatus);
                SIZE_T dwUseVirtual = memstatus.dwTotalVirtual - memstatus.dwAvailVirtual;
                SIZE_T dwUsePhys = memstatus.dwTotalPhys - memstatus.dwAvailPhys;
                fprintf(m_pFile, "当前虚拟内存总数:[%d]Byte\t[%.2f]M\n", memstatus.dwTotalVirtual, memstatus.dwTotalVirtual/1024.0f/1024.0f);
                fprintf(m_pFile, "当前可用虚拟内存总数:[%d]Byte\t[%.2f]M\n", memstatus.dwAvailVirtual, memstatus.dwAvailVirtual/1024.0f/1024.0f);
                fprintf(m_pFile, "当前已用虚拟内存总数:[%d]Byte\t[%.2f]M\n", dwUseVirtual, dwUseVirtual/1024.0f/1024.0f);

                fprintf(m_pFile, "当前物理内存总数:[%d]Byte\t[%.2f]M\n", memstatus.dwTotalPhys, memstatus.dwTotalPhys/1024.0f/1024.0f);
                fprintf(m_pFile, "当前可用物理内存总数:[%d]Byte\t[%.2f]M\n", memstatus.dwAvailPhys, memstatus.dwAvailPhys/1024.0f/1024.0f);
                fprintf(m_pFile, "当前已用物理内存总数:[%d]Byte\t[%.2f]M\n", dwUsePhys, dwUsePhys/1024.0f/1024.0f);

                OnOutputSelfInfo();

            } while (0);

            if (m_pFile)
            {
                fclose(m_pFile);
                m_pFile = NULL;
            }
        }
        catch(...)
        {

        }

        // 产生Dump文件
        try
        {
            do 
            {
                // firstly see if dbghelp.dll is around and has the function we need
                // look next to the EXE first, as the one in System32 might be old 
                // (e.g. Windows 2000)
                HMODULE hDll = NULL;
                char szDbgHelpPath[_MAX_PATH];

                if (GetModuleFileName( NULL, szDbgHelpPath, _MAX_PATH ))
                {
                    char *pSlash = _tcsrchr( szDbgHelpPath, '\\' );
                    if (pSlash)
                    {
                        _tcscpy( pSlash+1, "DBGHELP.DLL" );
                        hDll = ::LoadLibrary( szDbgHelpPath );
                    }
                }

                if (hDll==NULL)
                {
                    // load any version we can
                    hDll = ::LoadLibrary( "DBGHELP.DLL" );
                }

                LPCTSTR szResult = NULL;
                char	szDumpPath[ _MAX_PATH ];
                char	szScratch [ _MAX_PATH ];

                if (hDll)
                {
                    MINIDUMPWRITEDUMP pDump = (MINIDUMPWRITEDUMP)::GetProcAddress( hDll, "MiniDumpWriteDump" );
                    if (pDump)
                    {
                        // work out a good place for the dump file
                        //			if (!GetTempPath( _MAX_PATH, szDumpPath ))
                        //				_tcscpy( szDumpPath, "c:\\temp\\" );

                        sprintf(szDumpPath,"%s.dmp",m_strProcessName.c_str());

                        // don't ask user
                        // ask the user if they want to save a dump file
                        {
                            // create the file
                            HANDLE hFile = ::CreateFile( szDumpPath, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS,
                                FILE_ATTRIBUTE_NORMAL, NULL );

                            if (hFile!=INVALID_HANDLE_VALUE)
                            {
                                /* Fake an exception to call reportfault. */
                                EXCEPTION_RECORD ExceptionRecord;
                                CONTEXT ContextRecord;
                                EXCEPTION_POINTERS ExceptionPointers;
                                BOOL wasDebuggerPresent = FALSE;
                                DWORD ret = 0;

    #ifdef _X86_

                                __asm {
                                    mov dword ptr [ContextRecord.Eax], eax
                                        mov dword ptr [ContextRecord.Ecx], ecx
                                        mov dword ptr [ContextRecord.Edx], edx
                                        mov dword ptr [ContextRecord.Ebx], ebx
                                        mov dword ptr [ContextRecord.Esi], esi
                                        mov dword ptr [ContextRecord.Edi], edi
                                        mov word ptr [ContextRecord.SegSs], ss
                                        mov word ptr [ContextRecord.SegCs], cs
                                        mov word ptr [ContextRecord.SegDs], ds
                                        mov word ptr [ContextRecord.SegEs], es
                                        mov word ptr [ContextRecord.SegFs], fs
                                        mov word ptr [ContextRecord.SegGs], gs
                                        pushfd
                                        pop [ContextRecord.EFlags]
                                }

                                ContextRecord.ContextFlags = CONTEXT_CONTROL;
    #pragma warning(push)
    #pragma warning(disable:4311)
                                ContextRecord.Eip = (ULONG)_ReturnAddress();
                                ContextRecord.Esp = (ULONG)_AddressOfReturnAddress();
    #pragma warning(pop)
                                ContextRecord.Ebp = *((ULONG *)_AddressOfReturnAddress()-1);

    #elif defined (_IA64_) || defined (_AMD64_)

                                /* Need to fill up the Context in IA64 and AMD64. */
                                RtlCaptureContext(&ContextRecord);

    #else  /* defined (_IA64_) || defined (_AMD64_) */

                                ZeroMemory(&ContextRecord, sizeof(ContextRecord));

    #endif  /* defined (_IA64_) || defined (_AMD64_) */

                                ZeroMemory(&ExceptionRecord, sizeof(ExceptionRecord));

                                ExceptionRecord.ExceptionCode = STATUS_INVALID_PARAMETER;
                                ExceptionRecord.ExceptionAddress = _ReturnAddress();

                                ExceptionPointers.ExceptionRecord = &ExceptionRecord;
                                ExceptionPointers.ContextRecord = &ContextRecord;

                                _MINIDUMP_EXCEPTION_INFORMATION ExInfo;

                                ExInfo.ThreadId = ::GetCurrentThreadId();
                                ExInfo.ExceptionPointers = &ExceptionPointers;
                                ExInfo.ClientPointers = NULL;

                                // write the dump
                                BOOL bOK = pDump( GetCurrentProcess(), GetCurrentProcessId(), hFile, MiniDumpNormal, &ExInfo, NULL, NULL );
                                if (bOK)
                                {
                                    sprintf( szScratch, "Saved dump file to '%s'", szDumpPath );
                                    szResult = szScratch;
                                }
                                else
                                {
                                    sprintf( szScratch, "Failed to save dump file to '%s' (error %d)", szDumpPath, GetLastError() );
                                    szResult = szScratch;
                                }
                                ::CloseHandle(hFile);
                            }
                            else
                            {
                                sprintf( szScratch, "Failed to create dump file '%s' (error %d)", szDumpPath, GetLastError() );
                                szResult = szScratch;
                            }
                        }
                    }
                    else
                    {
                        szResult = "DBGHELP.DLL too old";
                    }
                }
                else
                {
                    szResult = "DBGHELP.DLL not found";
                }

            } while (0);
        }
        catch(...)
        {

        }

    }
    catch (...)
    {
    }
    ChangeDir(strSaveCurDir);

}

void CDebugInfoHelper::OnOutputSelfInfo()
{

}

void CDebugInfoHelper::Output(const char * pszFormat, ...)
{
    if (m_pFile == NULL)
    {
        assert(0);
        return;
    }

    static char szMessage[4096]	= {0};

    // Format the variable length parameter list
    va_list va;
    va_start(va, pszFormat);
    vsnprintf(szMessage, sizeof(szMessage), pszFormat, va);
    va_end(va);

    fprintf(m_pFile, "%s", szMessage);
}

void CDebugInfoHelper::BugCount()
{
    std::string strSaveCurDir	= GetCurDir();

    // 更改工作目录
    const char* pszDir = m_strPath.c_str();

    char szLogDirectory[MAX_PATH] = {0};
    char szTemp[MAX_PATH] = {0};
    time_t	systime;
    time(&systime);

    tm Systime	= *localtime(&systime);

    SafeStringCopy(szLogDirectory, pszDir, sizeof(szLogDirectory));

    snprintf(szTemp, sizeof(szTemp) - 1, "%s/%04d-%02d-%02d",
        szLogDirectory,
        Systime.tm_year + 1900,
        Systime.tm_mon + 1,
        Systime.tm_mday);
    SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));

    snprintf(szTemp, sizeof(szTemp) - 1, "%s/%s",
        szLogDirectory,
        m_strProcessName.c_str());
    SafeStringCopy(szLogDirectory, szTemp, sizeof(szLogDirectory));

    CreateDir(szLogDirectory);
    ChangeDir(szLogDirectory);

    // 记录数量
    FILE* file = fopen("BugCount.txt", "w");

    if (file == NULL)
    {
        return;
    }

    fprintf(file, "总数量:%d\n", m_vecExistStackAddr.size());

    for (unsigned int i=0; i<m_vecExistStackAddr.size(); i++)
    {
        fprintf(file, "\t BugID[%d]\t Amount[%d]\n", m_vecExistStackAddr[i].second.first, m_vecExistStackAddr[i].second.second);
    }

    fclose(file);

    ChangeDir(strSaveCurDir);

}

ENDNAMESPACE