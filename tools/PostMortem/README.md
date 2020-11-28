# Windows C++ 程序崩溃收集工具

### 说明
MiniDumper(LPCTSTR DumpFileNamePrefix)

MiniDumper(LPCTSTR DumpFileNamePrefix, LPCTSTR CmdLine, LPCTSTR ExeNameToReboot /* = NULL */)

`DumpFileNamePrefix` 崩溃文件名前缀

`CmdLine` 生成崩溃文件后执行命令（包含参数）

`ExeNameToReboot` 生成崩溃文件后执行指定程序

### 使用示例

在崩溃时调用指定的程序，下面的示例是调用`CrashReport.exe`上传到指定的服务器

```c++
#include "PostMortem.h"

char *szArgs = new char[2048];
ZeroMemory(szArgs, 2048);
StringCbPrintf(szArgs, 2048, _T("./CrashReport.exe \"dumper.wanwanol.com\" \"%s\""), g_pLogSys->GetLogFileName());
MiniDumper g_MiniDumper(_T("Client"), szArgs);
SAFE_DELETE_ARRAY(szArgs);
```

### 大致说明

MiniDumper 初始化时调用 Win32 API [`SetUnhandledExceptionFilter`][SetUnhandledExceptionFilter] 注册过滤函数`TopLevelFilter`，
当发生崩溃时会调用`TopLevelFilter`生成minidump文件，其过程如下：
1. 显式加载`DBGHELP.DLL`，并定位到`MiniDumpWriteDump`函数地址
2. 调用`MiniDumpWriteDump`函数生成`DumpFileNamePrefix`前缀的minidump文件
3. 调用`ContextDump`函数生成当前堆栈日志文件
4. 创建进程`CmdLine`如果指定，这里一般会调用上传程序把相关日志记录上传到远程服务器，由工程师统一调查处理。
5. 创建进程`ExeNameToReboot`如果指定

[Github 仓库地址](https://github.com/rise-worlds/game/tree/master/tools/PostMortem)

[SetUnhandledExceptionFilter]:https://docs.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-setunhandledexceptionfilter
