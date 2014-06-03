// LoginServer.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#ifdef _WIN32
#include "Utility/PostMortem.h"
#endif

#define ApplicationName	"LoginServer"

class CMyService
{
public:
	CMyService()
	{
		pMaster = NULL;
	}

	void Run(DWORD argc, LPTSTR* argv)
	{
		ENTER_FUNCTION_FOXNET

#ifdef _WIN32
		MiniDumper minidump(ApplicationName);
#endif

		Common::Console console;
		Common::Log	log;
		log.CreateLog("log", ApplicationName);
		console.StartConsole(ApplicationName);

		pMaster = new CMaster;

		if (!pMaster->Init())
		{
			assert(0);
			return;
		}

		while (!(console.IsQuit() || pMaster->IsExit()))
		{
			console.Update();

			pMaster->Update();

			Common::Thread::Sleep(1);
		}

		pMaster->Terminate();
		delete pMaster;
		pMaster = NULL;

		LEAVE_FUNCTION_FOXNET
	}

	void	Stop()
	{
		pMaster->Exit();
	}
private:
	CMaster* pMaster;
};


int _tmain(int argc, _TCHAR* argv[])
{
	Common::CDebugInfoHelper helper("log", ApplicationName, SERVER_VERSION);

	_set_error_mode(_OUT_TO_MSGBOX);
	CMyService serv;
	serv.Run(argc, argv);

	return 0;
}

