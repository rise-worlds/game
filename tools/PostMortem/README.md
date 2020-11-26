# Windows C++ 程序崩溃收集工具

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
