#ifndef __IoHandler_H__
#define __IoHandler_H__

#include "SessionPool.h"
#include <boost/asio.hpp>
#include <boost/thread.hpp>

#include "AsioNetwork.h"

class IoHandler
{
public:
    IoHandler();
    ~IoHandler();

    void                Init(AsioNetwork* pIOCPServer, LPIOHANDLER_DESC lpDesc);
    bool                StartListen(char* pIP, unsigned short nPort);
    void                Update();
    void                Shutdown();
    unsigned int        Connect(NetObject* pNetworkObject, char* pszIP, unsigned short nPort);
    bool                IsListening();
    inline unsigned int GetNumberOfConnections() { return m_numActiveSessions; }
    inline unsigned int GetKey() { return m_nKey; }

    void CloseHandle();

private:
    Session* AllocAcceptSession();
    Session* AllocConnectSession();
    void     FreeSession(Session* pSession);
    void     ProcessConnectSuccessList();
    void     ProcessConnectFailList();
    void     ProcessAcceptedSessionList();
    void     ProcessActiveSessionList();
    void     KickDeadSessions();
    void     ProcessSend();
    void     KickAllSessions();

    AsioNetwork* m_pIOCPServer;
    SessionPool* m_pAcceptSessionPool;
    SessionPool* m_pConnectSessionPool;
    SessionList* m_pActiveSessionList;
    SessionList* m_pAcceptedSessionList;
    SessionList* m_pConnectSuccessList;
    SessionList* m_pConnectFailList;
    SessionList* m_pTempList;
#ifdef _DEBUG
    SessionList* m_pWaitAcceptSessionList;
#endif
    unsigned int m_numWaitAccept;
    bool         m_bShutdown;

    unsigned int m_nKey;
    unsigned int m_nMaxPacketSize;
    unsigned int m_numActiveSessions;
    unsigned int m_nMaxAcceptSession;

    std::vector<boost::shared_ptr<boost::thread>> m_Threads;

    boost::asio::io_service*        m_IoServicePtr;
    boost::asio::ip::tcp::acceptor* m_AcceptorPtr;
    boost::asio::io_service::work*  m_WorkPtr;

    /// Handle completion of a connect operation.
    void handle_accept(Session* pSession, const boost::system::error_code& e);

    /// Handle completion of a connect operation.
    void handle_connect(Session* pSession, const boost::system::error_code& e);

    bool m_bIsStartListen;

    fnCallBackCreateAcceptedObject  m_fnCreateAcceptedObject;
    fnCallBackDestroyAcceptedObject m_fnDestroyAcceptedObject;
};

#endif  // __IoHandler_H__