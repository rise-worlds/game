#ifndef __AsioNetwork_H__
#define __AsioNetwork_H__

#if defined(_WIN32)
#if defined(ASIONETWORK_EXPORTS)
#define ASIONETWORK_API __declspec(dllexport)
#else
#define ASIONETWORK_API __declspec(dllimport)
#endif
#else
#define ASIONETWORK_API
#endif

#include <map>
#include <string>
class NetObject;
class IoHandler;

typedef std::map<unsigned int, IoHandler*>		IOHANDLER_MAP;
typedef std::pair<unsigned int, IoHandler*>		IOHANDLER_MAP_PAIR;
typedef IOHANDLER_MAP::iterator					IOHANDLER_MAP_ITER;

typedef NetObject*(*fnCallBackCreateAcceptedObject)();
typedef void(*fnCallBackDestroyAcceptedObject)(NetObject *pNetworkObject);

typedef struct tagIOHANDLER_DESC
{
	unsigned int						nIoHandlerKey;
	unsigned int						nMaxAcceptSession;
	unsigned int						nMaxConnectSession;
	unsigned int						nSendBufferSize;
	unsigned int						nRecvBufferSize;
	unsigned int						nTimeOut;
	unsigned int						nMaxPacketSize;
	unsigned int						nNumberOfIoThreads;
	fnCallBackCreateAcceptedObject		fnCreateAcceptedObject;
	fnCallBackDestroyAcceptedObject		fnDestroyAcceptedObject;
} IOHANDLER_DESC, *LPIOHANDLER_DESC;

struct  PACKET_HEADER
{
	unsigned short size;
};

#pragma warning(push)
#pragma warning(disable: 4251)
class ASIONETWORK_API AsioNetwork
{
public:
	AsioNetwork();
	virtual ~AsioNetwork();

	bool				Init(LPIOHANDLER_DESC lpDesc, unsigned int nNumberofIoHandlers);
	bool				StartListen(unsigned int nIoHandlerKey, char *pIP, unsigned short nPort);
	void				Update();
	void				Shutdown();
	unsigned int		Connect(unsigned int nIoHandlerKey, NetObject *pNetworkObject, char *pszIP, unsigned short nPort);
	bool				IsListening(unsigned int nIoHandlerKey);
	unsigned int		GetNumberOfConnections(unsigned int nIoHandlerKey);

	static unsigned int	ConvAddr(const char* strIP);
	static std::string	ConvAddr(unsigned int nIP);

	void				CloseHandle(unsigned int nNumberofIoHandlers);
	//#ifdef LW_MSG_LOG
private:
	time_t				m_tTime;
	char				m_szModuleName[128];
	int					m_nTimes;//��¼����
	//#endif
private:
	void				CreateIoHandler(LPIOHANDLER_DESC lpDesc);

	bool				m_bShutdown;
	IOHANDLER_MAP		m_mapIoHandlers;
};

#pragma warning(pop)

#endif