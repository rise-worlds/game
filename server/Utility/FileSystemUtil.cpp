#include "FileSystemUtil.h"
#include <stdio.h>
#ifndef _WIN32
#include <sys/types.h>
#include <dirent.h>
#else
#include <Windows.h>
#include <direct.h>
#endif

BEGINNAMESPACE

std::string ChangeDir(const std::string& strPath)
{
	char szCurPath[ FILENAME_MAX ];
	getcwd(szCurPath, FILENAME_MAX);
	chdir(strPath.c_str());
	return szCurPath;
};

std::string GetCurDir()
{
	char szCurPath[ FILENAME_MAX ];
	getcwd(szCurPath, FILENAME_MAX);
	return szCurPath;
};

std::string GetFileDir(const std::string& strFilePath)
{
	std::string::size_type pos = strFilePath.find_last_of("\\/");
	if (pos != std::string::npos)
		return strFilePath.substr(0, pos);
	else
		return "";
};

std::string GetFileName(const std::string& strFilePath)
{
	std::string::size_type pos = strFilePath.find_last_of("\\/");
	if (pos != std::string::npos)
		return strFilePath.substr(pos + 1);
	else
		return "";
}

void CreateDir(const std::string& strPath)
{
	std::string savedPath = GetCurDir();

	std::string::size_type lastpos = 0;
	std::string::size_type pos = strPath.find_first_of("\\/");
	while (pos != std::string::npos)
	{
		std::string subPath = strPath.substr(lastpos, pos - lastpos);
#ifdef _WIN32
		mkdir(subPath.c_str());
#else
		mkdir(subPath.c_str(), S_IRWXU);
#endif
		ChangeDir(subPath);
		lastpos = pos + 1;
		pos = strPath.find_first_of("\\/", lastpos);
	};

	std::string subPath = strPath.substr(lastpos);
#ifdef _WIN32
	mkdir(subPath.c_str());
#else
	mkdir(subPath.c_str(), S_IRWXU);
#endif

	ChangeDir(savedPath)	;
};

std::string GetTempPath()
{
	char szTempPath[ FILENAME_MAX ];
#ifdef _WIN32
	::GetTempPath(FILENAME_MAX, szTempPath);
	return szTempPath;
#else
	return "/tmp";
#endif
}

ENDNAMESPACE