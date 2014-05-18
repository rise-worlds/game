#include "Console.h"
#include "CThread.h"
#include <vector>
#include <string>
#include <memory.h>
#include <string.h>
#include <stdio.h>
#if defined _WIN32
#include <conio.h>
#else
#include "./linux/conio.h"
#endif

BEGINNAMESPACE

class ConsoleThread: public IThreadInterface
{
public:
	ConsoleThread()
	{
		m_bExit			= false;
	}

	virtual ~ConsoleThread()
	{
		Thread::CGuard autoLock(m_Mutex1.GetLock());

		for (CMD_VECTOR::iterator it = m_AllCommand.begin();
		        it != m_AllCommand.end(); it++)
		{
			ConsoleCmd* pCmd	= *it;

			delete pCmd;
		}
	}

	virtual void	EndThread()
	{
		m_bExit	= true;
		Thread::JoinThread(GetHandle());
	}

	void AddCommand(ConsoleCmd* pCmdProc, int nCmdCount)
	{
		Thread::CGuard autoLock(m_Mutex1.GetLock());

		for (int i = 0; i < nCmdCount; i++)
		{
			ConsoleCmd* pCmd	= new ConsoleCmd;
			*pCmd	= *(pCmdProc + i);
			m_AllCommand.push_back(pCmd);
		}
	}

	void Update()
	{
		CMD_VECTOR	tempCMD;
		CMD_PARAM	tempParam;
		{
			Thread::CGuard autoLock(m_Mutex2.GetLock());
			tempCMD	= m_WaitRunCmd;
			tempParam	= m_WaitRunParam;

			m_WaitRunCmd.clear();
			m_WaitRunParam.clear();
		}

		if (tempCMD.size() != tempParam.size())
		{
			assert(0);
			return;
		}

		for (int i = 0; i < int(tempCMD.size()); i++)
		{
			ConsoleCmd* pConsoleCmd	= tempCMD[i];

			(pConsoleCmd->tr)(tempParam[i].c_str());
		}
	}

	bool	IsQuit()
	{
		return m_bExit;
	}

protected:
	virtual int					Run()
	{
		char cmd[96];

		// Make sure our buffer is clean to avoid Array bounds overflow
		printf(">");
		memset(cmd, 0, sizeof(cmd));

		while (m_bExit != true)
		{
			if (kbhit())
			{
				gets(cmd);

				ProcessCmd(cmd);

				printf("\n>");
			}

			Common::Thread::Sleep(1);
		}

		return true;
	}

private:
	const ConsoleThread& operator =(const ConsoleThread&) {}

	// Process one command
	void ProcessCmd(char *cmd)
	{
		CMD_VECTOR	tempCMD;
		{
			Thread::CGuard autoLock(m_Mutex1.GetLock());
			tempCMD	= m_AllCommand;
		}

		char cmd2[80];
		strcpy(cmd2, cmd);
		//for( size_t i = 0; i < strlen( cmd ); ++i )
		//	cmd2[i] = tolower( cmd[i] );

		if (strncmp(cmd2, "help", strlen("help")) == 0
		        || strncmp(cmd2, "HELP", strlen("HELP")) == 0
		        || strncmp(cmd2, "?", strlen("?")) == 0)
		{

			for (CMD_VECTOR::iterator it = tempCMD.begin();
			        it != tempCMD.end(); it++)
			{
				ConsoleCmd* pCommand	= *it;

				printf("    %s \t\t %s \n", pCommand->name, pCommand->help);
			}

			printf("\n");

			return;
		}

		if (strncmp(cmd2, "exit", strlen("exit")) == 0)
		{
			m_bExit	= true;
			return;
		}

		for (CMD_VECTOR::iterator it = tempCMD.begin();
		        it != tempCMD.end(); it++)
		{
			ConsoleCmd* pCommand	= *it;

			if (strncmp(cmd2, pCommand->name, strlen(pCommand->name)) == 0)
			{
				Thread::CGuard autoLock(m_Mutex2.GetLock());
				m_WaitRunCmd.push_back(pCommand);
				m_WaitRunParam.push_back(std::string(cmd));
				return;
			}
		}

		printf("Console: Unknown console command (use \"help\" for help; use \"exit\" for exit).\n");
	}

private:
	bool	m_bExit;

private:
	typedef std::vector<ConsoleCmd*>	CMD_VECTOR;
	typedef std::vector<std::string>	CMD_PARAM;
	CMD_VECTOR	m_AllCommand;
	Thread::CLock	m_Mutex1;

	CMD_VECTOR	m_WaitRunCmd;
	CMD_PARAM	m_WaitRunParam;
	Thread::CLock	m_Mutex2;
};

static ConsoleThread*	s_WorkThread	= NULL;

Console::Console()
{

}

Console::~Console()
{
	StopConsole();
}

void Console::StartConsole(const char* strAppName)
{
	if (s_WorkThread != NULL)
	{
		return;
	}

	s_WorkThread	= new ConsoleThread;
	s_WorkThread->StartThread();
}

void Console::StopConsole()
{
	if (s_WorkThread)
	{
		s_WorkThread->EndThread();
		delete	s_WorkThread;
		s_WorkThread	= NULL;
	}
}

void Console::AddCommand(ConsoleCmd* pCmdProc, int nCmdCount)
{
	assert(s_WorkThread);
	s_WorkThread->AddCommand(pCmdProc, nCmdCount);
}

bool		Console::IsQuit()
{
	assert(s_WorkThread);
	return s_WorkThread->IsQuit();
}

void		Console::Update()
{
	assert(s_WorkThread);
	s_WorkThread->Update();
}

void		Console::OutLog(const char* Format, ...)
{

}

void		Console::OutServerInfo(const char* strInfo)
{

}

ENDNAMESPACE
