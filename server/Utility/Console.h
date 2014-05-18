#ifndef __Console_H__
#define __Console_H__

#include "CommonDefs.h"
#include "Single.h"

BEGINNAMESPACE

typedef void (*COMMANDPROCFUN)(const char*);

struct ConsoleCmd
{
	const char* name;
	COMMANDPROCFUN tr;
	const char* help;
};

class COMMON_API Console: public Single<Console>
{
public:
	Console();
	~Console();

	void StartConsole(const char* strAppName = "");
	void StopConsole();

	void AddCommand(ConsoleCmd* pCmdProc, int nCmdCount);

	bool		IsQuit();
	void		Update();
	void		OutLog(const char* Format, ...);
	void		OutServerInfo(const char* strInfo);
};

ENDNAMESPACE

#endif // __Console_H__
