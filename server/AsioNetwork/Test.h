#include "NetObject.h"
#include "AsioNetwork.h"

#include "windows.h"

//-------------------------------------------------------------------------------------------------
// User Class
//-------------------------------------------------------------------------------------------------
class User : public NetObject
{
public:
	User() {}
	~User() {}
protected:
	virtual void	OnAccept(unsigned int nNetworkIndex)
	{

	};

	virtual void	OnDisconnect() {};
	virtual	void	OnRecv(void *pMsg, short nSize)
	{
		Send(pMsg, nSize);
	}

	virtual void	OnConnect(bool bSuccess, unsigned int dwNetworkIndex) {}
};

//-------------------------------------------------------------------------------------------------
// Callback Functions
//-------------------------------------------------------------------------------------------------
NetObject* CreateAcceptedObject()
{
	return new User;
}
void DestroyAcceptedObject(NetObject *pNetworkObject)
{
	delete pNetworkObject;
}
void DestroyConnectedObject(NetObject *pNetworkObject)
{
	delete pNetworkObject;
}


//-------------------------------------------------------------------------------------------------
// Main
//-------------------------------------------------------------------------------------------------
int main()
{
	const unsigned int CLIENT_IOHANDLER_KEY = 0;

	AsioNetwork *pIOCPServer = new AsioNetwork;

	IOHANDLER_DESC desc;

	desc.nIoHandlerKey				= CLIENT_IOHANDLER_KEY;
	desc.nMaxAcceptSession			= 1000;
	desc.nMaxConnectSession		= 0;
	desc.nSendBufferSize			= 60000;
	desc.nRecvBufferSize			= 60000;
	desc.nTimeOut					= 30000;
	desc.nMaxPacketSize			= 4096;
	desc.nNumberOfIoThreads		= 3;
	desc.fnCreateAcceptedObject		= CreateAcceptedObject;
	desc.fnDestroyAcceptedObject	= DestroyAcceptedObject;
	desc.fnDestroyConnectedObject	= DestroyConnectedObject;

	if (!pIOCPServer->Init(&desc, 1))
	{
		printf("IOCP ³õÊ¼»¯Ê§°Ü");
		return 0;
	}

	if (!pIOCPServer->StartListen(CLIENT_IOHANDLER_KEY, "192.168.1.153", 6000))
	{
		printf("¼àÌýÊ§°Ü");
		return 0;
	}

	printf("Server started!\n");

	while (1)
	{
		Sleep(10);
		pIOCPServer->Update();
	}

	printf("Server is terminated...\n");

	pIOCPServer->Shutdown();

	delete pIOCPServer;

	return 0;
}