#ifndef __Utility_H__
#define __Utility_H__

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#undef _WIN32_WINNT
#define _WIN32_WINNT	0x0501

#undef WINVER
#define WINVER			0x0501
#endif


#include "CommonDefs.h"
//#include "MemallocDef.h"
#include "ConsoleParamParse.h"
#include "Console.h"
#include "Log.h"
#include "Memory.h"
#include "FileSystemUtil.h"
#include "CThread.h"
#include "CTimer.h"
#include "FuncPerformanceLog.h"
#include "Ini.h"
//#include "MarkupSTL.h"
#include "RingBuffer.h"
#include "RingBufferEx.h"
#include "ShareMem.h"
#include "Single.h"
#include "FunctionGuard.h"

#endif // __Utility_H__