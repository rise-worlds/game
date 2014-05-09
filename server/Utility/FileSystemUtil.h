#ifndef __FILESYSTEM_UTIL_H__
#define __FILESYSTEM_UTIL_H__

#include "CommonDefs.h"

#include <string>
#ifdef _WIN32
#include <direct.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#endif

BEGINNAMESPACE

std::string COMMON_API ChangeDir(const std::string& strPath);
std::string COMMON_API GetCurDir();
std::string COMMON_API GetFileDir(const std::string& strFilePath);
std::string COMMON_API GetFileName(const std::string& strFilePath);
void COMMON_API CreateDir(const std::string& strPath);
std::string COMMON_API GetTempPath();

ENDNAMESPACE

#endif // __FILESYSTEM_UTIL_H__