#include "Windows.h"
#include <tchar.h>
#include "assert.h"
#include <iostream>
#include "PostMortem.h"

#pragma warning(push)
#pragma warning(disable:4996)

// based on dbghelp.h
typedef BOOL (WINAPI *MINIDUMPWRITEDUMP)(HANDLE hProcess, DWORD dwPid, HANDLE hFile, MINIDUMP_TYPE DumpType,
									CONST PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam,
									CONST PMINIDUMP_USER_STREAM_INFORMATION UserStreamParam,
									CONST PMINIDUMP_CALLBACK_INFORMATION CallbackParam
									);


LPCSTR	MiniDumper::m_szAppName;
char	MiniDumper::m_szCmdLinePrefix[ MAX_PATH ];		// 异常发生后执行的命令行
char	MiniDumper::m_szExeNameToReboot[ MAX_PATH ];	// 异常发生后用于重启程序执行的程序文件名

MiniDumper::MiniDumper( LPCSTR DumpFileNamePrefix )
{
	// if this assert fires then you have two instances of MiniDumper
	// which is not allowed
	assert( m_szAppName==NULL );

	m_szCmdLinePrefix[0] = '\0';
	m_szAppName = DumpFileNamePrefix ? /*strdup*/(DumpFileNamePrefix) : "Application";

	::SetUnhandledExceptionFilter( TopLevelFilter );
}

MiniDumper::MiniDumper( LPCSTR DumpFileNamePrefix,LPCSTR CmdLine,LPCSTR ExeNameToReboot /* = NULL */ )
{
	// if this assert fires then you have two instances of MiniDumper
	// which is not allowed
	assert( m_szAppName==NULL );

	m_szCmdLinePrefix[0] = '\0';
	m_szExeNameToReboot[0] = '\0';
	m_szAppName = DumpFileNamePrefix ? /*strdup*/(DumpFileNamePrefix) : "Application";

	::SetUnhandledExceptionFilter( TopLevelFilter );

	strcpy( m_szCmdLinePrefix,CmdLine );

	if( ExeNameToReboot != NULL )
		strcpy( m_szExeNameToReboot,ExeNameToReboot );
}

LONG MiniDumper::TopLevelFilter( struct _EXCEPTION_POINTERS *pExceptionInfo )
{
	LONG retval = EXCEPTION_CONTINUE_SEARCH;
	//HWND hParent = NULL;						// find a better value for your app
	SYSTEMTIME time;
	GetLocalTime( &time );

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

			sprintf( szDumpPath,"%s_%d-%d_%d-%d-%d.dmp",m_szAppName,time.wMonth,time.wDay,time.wHour,time.wMinute,time.wSecond );

			// don't ask user
			// ask the user if they want to save a dump file
			if ( strlen( m_szCmdLinePrefix ) > 0 
                || true
				/*|| ::MessageBox( NULL, "WARNING: An exception occured,save the dump file to debug it？",m_szAppName, MB_YESNO )==IDYES*/ )
			{
				// create the file
				HANDLE hFile = ::CreateFile( szDumpPath, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS,
					FILE_ATTRIBUTE_NORMAL, NULL );

				if (hFile!=INVALID_HANDLE_VALUE)
				{
					_MINIDUMP_EXCEPTION_INFORMATION ExInfo;

					ExInfo.ThreadId = ::GetCurrentThreadId();
					ExInfo.ExceptionPointers = pExceptionInfo;
					ExInfo.ClientPointers = NULL;

					// write the dump
					BOOL bOK = pDump( GetCurrentProcess(), GetCurrentProcessId(), hFile, MiniDumpNormal, &ExInfo, NULL, NULL );
					if (bOK)
					{
						sprintf( szScratch, "Saved dump file to '%s'", szDumpPath );
						szResult = szScratch;
						retval = EXCEPTION_EXECUTE_HANDLER;
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

	// 如果不使用BugReport的话
	if( strlen( m_szCmdLinePrefix ) == 0 )
	{
// 		if (szResult)
// 			::MessageBox( NULL, szResult, m_szAppName, MB_OK );
	}

	if( strlen( m_szCmdLinePrefix ) > 0 )
	{
		char CmdLine[MAX_PATH];
		
		if( strlen(m_szExeNameToReboot) == 0 )
			// 对应执行 CmdLine 后不需要重启程序的参数
			sprintf( CmdLine,"%s,%s",m_szCmdLinePrefix,szDumpPath );
		else
			// 对应执行 CmdLine 后需要重启程序的参数
			sprintf( CmdLine,"%s,%s,%s",m_szCmdLinePrefix,szDumpPath,m_szExeNameToReboot );

		WinExec( CmdLine,SW_SHOWNORMAL );
	}

	return retval;
}

#pragma warning(pop)
