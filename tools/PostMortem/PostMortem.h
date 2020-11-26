/*

Remarks:

Issuing SetUnhandledExceptionFilter replaces the existing top-level exception filter for all existing and all future threads in the calling process.

The exception handler specified by lpTopLevelExceptionFilter is executed in the context of the thread that caused the fault. This can affect the exception handler's ability to recover from certain exceptions, such as an invalid stack.

Requirements:

Client: Included in Windows XP, Windows 2000 Professional, Windows NT Workstation 3.5 and later, Windows Me, Windows 98, and Windows 95.
Server: Included in Windows Server 2003, Windows 2000 Server, and Windows NT Server 3.5 and later.
Header: Declared in Winbase.h; include Windows.h.
Library: Use Kernel32.lib.

无法在一个调试器内调试此模块功能，因为异常被调试器（如VCZ）捕获了。

*/

#pragma once
#ifndef __PostMortem_H__
#define __PostMortem_H__

#include "dbghelp.h"

class MiniDumper
{
private:
	static LPCTSTR m_szAppName;

	static LONG WINAPI TopLevelFilter(struct _EXCEPTION_POINTERS *pExceptionInfo);

	static void ContextDump(struct _EXCEPTION_POINTERS *pExceptionInfo);
public:
	// 缺省方式，只保存 Dump 文件到本地
	// 并弹出对话框通知
	MiniDumper(LPCTSTR DumpFileNamePrefix);

	// BugReport方式，保存文件并执行 CmdLine
	// 可以用来发送错误报告等

	// Param List:
	//		DumpFileNamePrefix		产生的Dump文件的文件名前缀
	//		CmdLine					生成Dump之后，执行的WinExec参数，形式为："Bugreport.exe + 空格 + 服务器名参数, + 端口参数, +路径参数"
	//		ExeNameToReboot			完成Dump后，用于重启Crash掉的程序的文件名（目前只针对BugReporter.exe）
	MiniDumper(LPCTSTR DumpFileNamePrefix, LPCTSTR CmdLine, LPCTSTR ExeNameToReboot = NULL);

	static TCHAR m_szCmdLinePrefix[MAX_PATH];		// 异常发生后执行的命令行
	static TCHAR m_szExeNameToReboot[MAX_PATH];		// 异常发生后用于重启程序执行的程序文件名
	static TCHAR m_szDumpPath[MAX_PATH];			// Dump文件名
	static TCHAR m_szDumpIniPath[MAX_PATH];			// Dump INI 文件名
};

#endif
