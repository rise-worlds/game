#include "Windows.h"
#include <tchar.h>
#include "assert.h"
#include <iostream>
#include "PostMortem.h"

#pragma comment(lib, "Dbghelp.lib")

#define DP1(fmt, var)				\
{									\
	TCHAR sOut[256];				\
	_stprintf(sOut, fmt, var);		\
	OutputDebugString(sOut);		\
}


// based on dbghelp.h
typedef BOOL (WINAPI *MINIDUMPWRITEDUMP)(HANDLE hProcess, DWORD dwPid, HANDLE hFile,
		MINIDUMP_TYPE DumpType,
		CONST PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam,
		CONST PMINIDUMP_USER_STREAM_INFORMATION UserStreamParam,
		CONST PMINIDUMP_CALLBACK_INFORMATION CallbackParam
	);


LPCTSTR	MiniDumper::m_szAppName;
TCHAR	MiniDumper::m_szCmdLinePrefix[MAX_PATH];		// 异常发生后执行的命令行
TCHAR	MiniDumper::m_szExeNameToReboot[MAX_PATH];		// 异常发生后用于重启程序执行的程序文件名
TCHAR	MiniDumper::m_szDumpPath[MAX_PATH];				// Dump文件名
TCHAR	MiniDumper::m_szDumpIniPath[MAX_PATH];			// Dump INI 文件名

MiniDumper::MiniDumper(LPCTSTR DumpFileNamePrefix)
{
	// if this assert fires then you have two instances of MiniDumper
	// which is not allowed
	assert(m_szAppName == NULL);

	m_szCmdLinePrefix[0] = '\0';
	m_szAppName = DumpFileNamePrefix ? /*strdup*/(DumpFileNamePrefix) : _T("Application");

	::SetUnhandledExceptionFilter(TopLevelFilter);
}

MiniDumper::MiniDumper(LPCTSTR DumpFileNamePrefix, LPCTSTR CmdLine, LPCTSTR ExeNameToReboot /* = NULL */)
{
	// if this assert fires then you have two instances of MiniDumper
	// which is not allowed
	assert(m_szAppName == NULL);

	m_szCmdLinePrefix[0] = '\0';
	m_szExeNameToReboot[0] = '\0';
	m_szAppName = DumpFileNamePrefix ? /*strdup*/(DumpFileNamePrefix) : _T("Application");

	::SetUnhandledExceptionFilter(TopLevelFilter);

	_tcscpy(m_szCmdLinePrefix, CmdLine);

	if (ExeNameToReboot != NULL)
		_tcscpy(m_szExeNameToReboot, ExeNameToReboot);

}

LONG MiniDumper::TopLevelFilter(struct _EXCEPTION_POINTERS *pExceptionInfo)
{
	LONG retval = EXCEPTION_CONTINUE_SEARCH;
	//HWND hParent = NULL;						// find a better value for your app
	SYSTEMTIME time;
	GetLocalTime(&time);

	// firstly see if dbghelp.dll is around and has the function we need
	// look next to the EXE first, as the one in System32 might be old
	// (e.g. Windows 2000)
	HMODULE hDll = NULL;
	TCHAR szDbgHelpPath[_MAX_PATH];

	if (GetModuleFileName(NULL, szDbgHelpPath, _MAX_PATH))
	{
		TCHAR *pSlash = _tcsrchr(szDbgHelpPath, '\\');
		if (pSlash)
		{
			_tcscpy(pSlash + 1, _T("DBGHELP.DLL"));
			hDll = ::LoadLibrary(szDbgHelpPath);
		}
	}

	if (hDll == NULL)
	{
		// load any version we can
		hDll = ::LoadLibrary(_T("DBGHELP.DLL"));
	}

	LPCTSTR szResult = NULL;
	TCHAR	szScratch [ _MAX_PATH ];

	if (hDll)
	{
		MINIDUMPWRITEDUMP pDump = (MINIDUMPWRITEDUMP)::GetProcAddress(hDll, "MiniDumpWriteDump");
		if (pDump)
		{
			// work out a good place for the dump file
//			if (!GetTempPath( _MAX_PATH, szDumpPath ))
//				_tcscpy( szDumpPath, "c:\\temp\\" );

			_stprintf(m_szDumpPath, _T("log\\%s_%02d-%02d_%02d-%02d-%02d.dmp")
			          , m_szAppName, time.wMonth, time.wDay, time.wHour, time.wMinute, time.wSecond);

			// don't ask user
			// ask the user if they want to save a dump file
			if (_tcslen(m_szCmdLinePrefix) > 0 ||
						::MessageBox(NULL, _T("WARNING: An exception occured,save the dump file to debug it？"), m_szAppName, MB_YESNO) == IDYES)
			{
				// create the file
				HANDLE hFile = ::CreateFile(m_szDumpPath, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS,
												FILE_ATTRIBUTE_NORMAL, NULL);

				if (hFile != INVALID_HANDLE_VALUE)
				{
					_MINIDUMP_EXCEPTION_INFORMATION ExInfo;

					ExInfo.ThreadId = ::GetCurrentThreadId();
					ExInfo.ExceptionPointers = pExceptionInfo;
					ExInfo.ClientPointers = NULL;

					// write the dump
					BOOL bOK = pDump(GetCurrentProcess(), GetCurrentProcessId(), hFile, MiniDumpNormal, &ExInfo, NULL, NULL);
					if (bOK)
					{
						_stprintf(szScratch, _T("Saved dump file to '%s'"), m_szDumpPath);
						szResult = szScratch;
						retval = EXCEPTION_EXECUTE_HANDLER;
					}
					else
					{
						_stprintf(szScratch, _T("Failed to save dump file to '%s' (error %d)"), m_szDumpPath, GetLastError());
						szResult = szScratch;
					}
					::CloseHandle(hFile);
				}
				else
				{
					_stprintf(szScratch, _T("Failed to create dump file '%s' (error %d)"), m_szDumpPath, GetLastError());
					szResult = m_szDumpPath;//_T("AAAA");//szScratch;
				}

				ContextDump(pExceptionInfo);

				{
					TCHAR CmdLine[MAX_PATH];
					_stprintf(CmdLine, _T("%s \"%s\" \"%s\""), m_szCmdLinePrefix, m_szDumpPath, m_szDumpIniPath);
					OutputDebugString(CmdLine);

					STARTUPINFO si;
					PROCESS_INFORMATION pi;
					ZeroMemory(&si, sizeof(si));
					si.cb = sizeof(si);
					ZeroMemory(&pi, sizeof(pi));

					BOOL suc = CreateProcess(NULL, CmdLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
					if (!suc)
					{
						DWORD rv = GetLastError();

						DP1(_T("运行结果 : %d"), rv);
						//::MessageBox(NULL, CmdLine, m_szAppName, MB_OK);
					}
				}

				if (_tcslen(m_szExeNameToReboot) != 0)
				{
					STARTUPINFO si;
					PROCESS_INFORMATION pi;
					ZeroMemory(&si, sizeof(si));
					si.cb = sizeof(si);
					ZeroMemory(&pi, sizeof(pi));

					BOOL suc = CreateProcess(NULL, m_szExeNameToReboot, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
					if (!suc)
					{
						DWORD rv = GetLastError();

						DP1(_T("重新启动%s结果 : %d"), m_szExeNameToReboot, rv);
						//::MessageBox(NULL, m_szExeNameToReboot, m_szAppName, MB_OK);
					}
				}
			}
		}
		else
		{
			szResult = _T("DBGHELP.DLL too old");
		}
	}
	else
	{
		szResult = _T("DBGHELP.DLL not found");
	}

	::SymCleanup(::GetCurrentProcess());

	return retval;
}


void MiniDumper::ContextDump(struct _EXCEPTION_POINTERS *pExceptionInfo)
{
	SYSTEMTIME time;
	GetLocalTime(&time);

	_stprintf(m_szDumpIniPath, _T("log\\%s_%02d-%02d_%02d-%02d-%02d.log"),
				m_szAppName, time.wMonth, time.wDay, time.wHour, time.wMinute, time.wSecond);

	FILE * fp = NULL;
#ifdef _UNICODE
	if (::_wfopen_s(&fp, m_szDumpIniPath, L"wb") != 0)
#else
	if (::fopen_s(&fp, m_szDumpIniPath, "wb") != 0)
#endif
	{
		return;
	}

	::SymInitialize(::GetCurrentProcess(), NULL, TRUE);

	EXCEPTION_RECORD * pRecord = pExceptionInfo->ExceptionRecord;
	CONTEXT * pContext = pExceptionInfo->ContextRecord;

	::fprintf(fp, "%04X:%08X raise 0x%08X", pContext->SegCs, pContext->Eip, pRecord->ExceptionCode);

	switch (pRecord->ExceptionCode)
	{
	case EXCEPTION_ACCESS_VIOLATION:
	{
		::fprintf(fp, "(ACCESS_VIOLATION)\n");

		if (2 == pRecord->NumberParameters)
		{
			::fprintf(fp, "Memory at 0x%08X could not be ", pRecord->ExceptionInformation[1]);

			if (0 == pRecord->ExceptionInformation[0])
			{
				::fprintf(fp, "read\n");
			}
			else
			{
				::fprintf(fp, "written\n");
			}
		}
	}
	break;
	case EXCEPTION_INT_DIVIDE_BY_ZERO:
	{
		::fprintf(fp, "(DIVIDE_BY_ZERO)\n");
	}
	break;
	case EXCEPTION_STACK_OVERFLOW:
	{
		::fprintf(fp, "(STACK_OVERFLOW)\n");
	}
	break;
	default:
	{
		::fprintf(fp, "\n");
	}
	break;
	}

	::fprintf(fp, "\n");

	IMAGEHLP_LINE line;
	DWORD displacement;
	char symbol[sizeof(IMAGEHLP_SYMBOL) + 256];
	IMAGEHLP_SYMBOL * pSymbol = (IMAGEHLP_SYMBOL *)symbol;

	STACKFRAME sf;
	MEMORY_BASIC_INFORMATION mbi;

	::memset(&sf, 0, sizeof(sf));

	sf.AddrPC.Mode = AddrModeFlat;
	sf.AddrPC.Offset = pContext->Eip;
	sf.AddrFrame.Mode = AddrModeFlat;
	sf.AddrFrame.Offset = pContext->Ebp;
	sf.AddrStack.Mode = AddrModeFlat;
	sf.AddrStack.Offset = pContext->Esp;

	::fprintf(fp, "Call stack unwind : \r\n");
	::fprintf(fp, "-------------------------------------------------------------------------------\n");

	char fname[MAX_PATH];

	size_t nSkip = 1;
	size_t nDepth = 1000;
	size_t i = 0;
	while (::StackWalk(
	            IMAGE_FILE_MACHINE_I386,
	            ::GetCurrentProcess(),
	            ::GetCurrentThread(),
	            &sf,
	            NULL,
	            NULL,
	            SymFunctionTableAccess,
	            SymGetModuleBase,
	            NULL))
	{
		++i;
		if (i < nSkip)
			continue;
		if (i > nDepth)
			break;

		if (::VirtualQuery((LPCVOID)sf.AddrPC.Offset, &mbi, sizeof(mbi)))
		{
			if (::GetModuleFileNameA((HMODULE)mbi.AllocationBase, fname, sizeof(fname)))
			{
				::fprintf(fp, "    %s!",
				          strrchr(fname, '\\') ? strrchr(fname, '\\') + 1 : fname);
			}
		}

		::memset(&line, 0, sizeof(line));
		line.SizeOfStruct = sizeof(line);
		displacement = 0;
		if (::SymGetLineFromAddr(::GetCurrentProcess(), sf.AddrPC.Offset, &displacement, &line))
		{
			::fprintf(fp, "%s(%d) : ", line.FileName, line.LineNumber);
		}
		else
		{
			::fprintf(fp, "%d(File and line number not available) : ", sf.AddrPC.Offset);
		}


		::memset(pSymbol, 0, sizeof(symbol));
		pSymbol->SizeOfStruct = sizeof(symbol);
		pSymbol->MaxNameLength = MAX_PATH;
		displacement = 0;
		if (::SymGetSymFromAddr(::GetCurrentProcess(), sf.AddrPC.Offset, &displacement, pSymbol))
		{
			::fprintf(fp, "%s", pSymbol->Name);
		}
		else
		{
			::fprintf(fp, "(Function name unavailable)");
		}
		::fprintf(fp, "\n");

	}

	::fprintf(fp, "-------------------------------------------------------------------------------\n");
	::fclose(fp);
}
