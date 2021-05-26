#include "IoHandler.h"
#include <boost/bind.hpp>
#include <boost/asio.hpp>

#include "AsioNetwork.h"
#include "Session.h"
#include "SessionList.h"
#include "SessionPool.h"
#include "NetObject.h"
#include "SendBuf.h"
#include "RecvBuf.h"


#define EXTRA_ACCEPTEX_NUM 10

IoHandler::IoHandler()
{
    ENTER_FUNCTION_FOXNET
    m_IoServicePtr = new boost::asio::io_service;
    m_AcceptorPtr  = new boost::asio::ip::tcp::acceptor(*m_IoServicePtr);
    m_WorkPtr      = new boost::asio::io_service::work(*m_IoServicePtr);

    m_pAcceptSessionPool   = NULL;
    m_pConnectSessionPool  = NULL;
    m_pActiveSessionList   = NULL;
    m_pAcceptedSessionList = NULL;
    m_pConnectSuccessList  = NULL;
    m_pConnectFailList     = NULL;
    m_pTempList            = NULL;
#ifdef _DEBUG
    m_pWaitAcceptSessionList = NULL;
#endif
    m_numActiveSessions = 0;
    m_numWaitAccept     = 0;
    m_bShutdown         = false;

    m_fnCreateAcceptedObject  = NULL;
    m_fnDestroyAcceptedObject = NULL;
    m_bIsStartListen          = false;
    LEAVE_FUNCTION_FOXNET
}

IoHandler::~IoHandler()
{
    ENTER_FUNCTION_FOXNET
    if (!m_bShutdown)
        Shutdown();

    m_IoServicePtr->stop();
    for (int i = 0; i < int(m_Threads.size()); i++)
    {
        m_Threads[i]->join();
    }

    if (m_pAcceptSessionPool)
        delete m_pAcceptSessionPool;
    if (m_pConnectSessionPool)
        delete m_pConnectSessionPool;
    if (m_pActiveSessionList)
        delete m_pActiveSessionList;
    if (m_pAcceptedSessionList)
        delete m_pAcceptedSessionList;
    if (m_pConnectSuccessList)
        delete m_pConnectSuccessList;
    if (m_pConnectFailList)
        delete m_pConnectFailList;
    if (m_pTempList)
        delete m_pTempList;
#ifdef _DEBUG
    if (m_pWaitAcceptSessionList)
        delete m_pWaitAcceptSessionList;
#endif

    delete m_WorkPtr;
    delete m_AcceptorPtr;
    delete m_IoServicePtr;

    LEAVE_FUNCTION_FOXNET
}

void IoHandler::Init(AsioNetwork* pIOCPServer, LPIOHANDLER_DESC lpDesc)
{
    ENTER_FUNCTION_FOXNET
    m_pIOCPServer = pIOCPServer;

    m_fnCreateAcceptedObject  = lpDesc->fnCreateAcceptedObject;
    m_fnDestroyAcceptedObject = lpDesc->fnDestroyAcceptedObject;

    m_nKey = lpDesc->nIoHandlerKey;

    m_pActiveSessionList   = new SessionList;
    m_pAcceptedSessionList = new SessionList;
    m_pConnectSuccessList  = new SessionList;
    m_pConnectFailList     = new SessionList;
    m_pTempList            = new SessionList;
#ifdef _DEBUG
    m_pWaitAcceptSessionList = new SessionList;
#endif

    m_nMaxAcceptSession = lpDesc->nMaxAcceptSession;

    m_pAcceptSessionPool = new SessionPool(*m_IoServicePtr, lpDesc->nMaxAcceptSession + 2 * EXTRA_ACCEPTEX_NUM, lpDesc->nSendBufferSize,
                                           lpDesc->nRecvBufferSize, lpDesc->nMaxPacketSize, lpDesc->nTimeOut, 1, true);

    m_pConnectSessionPool = new SessionPool(*m_IoServicePtr, lpDesc->nMaxConnectSession, lpDesc->nSendBufferSize, lpDesc->nRecvBufferSize,
                                            lpDesc->nMaxPacketSize, lpDesc->nTimeOut, m_pAcceptSessionPool->GetLength() + 1, false);


    assert(lpDesc->nMaxPacketSize > sizeof(PACKET_HEADER));
    m_nMaxPacketSize = lpDesc->nMaxPacketSize;

    assert(lpDesc->nNumberOfIoThreads > 0);

    for (int i = 0; i < int(lpDesc->nNumberOfIoThreads); i++)
    {
        boost::shared_ptr<boost::thread> thread(new boost::thread(boost::bind(&boost::asio::io_service::run, m_IoServicePtr)));

        m_Threads.push_back(thread);
    }

    LEAVE_FUNCTION_FOXNET
}

bool IoHandler::StartListen(char* pIP, unsigned short nPort)
{
    ENTER_FUNCTION_FOXNET
    if (IsListening())
        return true;
    m_bIsStartListen = true;

    boost::asio::ip::address       adrs(boost::asio::ip::address::from_string(pIP));
    boost::asio::ip::tcp::endpoint endpoint(adrs, nPort);
    m_AcceptorPtr->open(endpoint.protocol());
    m_AcceptorPtr->set_option(boost::asio::ip::tcp::acceptor::reuse_address(true));
    m_AcceptorPtr->bind(endpoint);
    m_AcceptorPtr->listen();

    m_numWaitAccept = 0;

    for (int i = 0; i < EXTRA_ACCEPTEX_NUM; i++)
    {
        Session* pSession = AllocAcceptSession();

        m_AcceptorPtr->async_accept(pSession->m_Socket,
                                    boost::bind(&IoHandler::handle_accept, this, pSession, boost::asio::placeholders::error));

#ifdef _DEBUG
        m_pWaitAcceptSessionList->Lock();
        m_pWaitAcceptSessionList->push_back(pSession);
        m_pWaitAcceptSessionList->Unlock();
#endif
    }

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

void IoHandler::handle_accept(Session* pSession, const boost::system::error_code& e)
{
    ENTER_FUNCTION_FOXNET
#ifdef _DEBUG
    m_pWaitAcceptSessionList->Lock();
    for (SessionList::iterator it = m_pWaitAcceptSessionList->begin(); it != m_pWaitAcceptSessionList->end(); it++)
    {
        if (*it == pSession)
        {
            m_pWaitAcceptSessionList->erase(it);
            break;
        }
    }

    m_pWaitAcceptSessionList->Unlock();
#endif

    if (!e)
    {
        m_pAcceptedSessionList->Lock();
        m_pAcceptedSessionList->push_back(pSession);
        m_pAcceptedSessionList->Unlock();
    }
    else
    {
        FreeSession(pSession);
    }

    if (m_bIsStartListen)
    {
        do
        {
            Session* pSession = AllocAcceptSession();
            if (!pSession)
            {
                m_numWaitAccept++;
                break;
            }

            m_AcceptorPtr->async_accept(pSession->m_Socket,
                                        boost::bind(&IoHandler::handle_accept, this, pSession, boost::asio::placeholders::error));

#ifdef _DEBUG
            m_pWaitAcceptSessionList->Lock();
            m_pWaitAcceptSessionList->push_back(pSession);
            m_pWaitAcceptSessionList->Unlock();
#endif
        } while (0);
    }

    LEAVE_FUNCTION_FOXNET
}


void IoHandler::Update()
{
    ENTER_FUNCTION_FOXNET
    BEGINFUNCPERLOG("ProcessActiveSessionList");
    ProcessActiveSessionList();
    ENDFUNCPERLOG("ProcessActiveSessionList");

    if (!m_pAcceptedSessionList->empty())
    {
        BEGINFUNCPERLOG("ProcessAcceptedSessionList");
        ProcessAcceptedSessionList();
        ENDFUNCPERLOG("ProcessAcceptedSessionList");
    }

    if (!m_pConnectSuccessList->empty())
    {
        BEGINFUNCPERLOG("ProcessConnectSuccessList");
        ProcessConnectSuccessList();
        ENDFUNCPERLOG("ProcessConnectSuccessList");
    }

    if (!m_pConnectFailList->empty())
    {
        BEGINFUNCPERLOG("ProcessConnectFailList");
        ProcessConnectFailList();
        ENDFUNCPERLOG("ProcessConnectFailList");
    }

    BEGINFUNCPERLOG("KickDeadSessions");
    KickDeadSessions();
    ENDFUNCPERLOG("KickDeadSessions");
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::Shutdown()
{
    ENTER_FUNCTION_FOXNET
    m_bShutdown = true;

    KickAllSessions();

    ProcessActiveSessionList();

    KickDeadSessions();
    LEAVE_FUNCTION_FOXNET
}

unsigned int IoHandler::Connect(NetObject* pNetworkObject, char* pszIP, unsigned short nPort)
{
    ENTER_FUNCTION_FOXNET
    Session* pSession = AllocConnectSession();
    pSession->BindNetworkObject(pNetworkObject);

    {
        pSession->Init();
        boost::asio::ip::address       adrs(boost::asio::ip::address::from_string(pszIP));
        boost::asio::ip::tcp::endpoint endpoint(adrs, nPort);

        pSession->m_Socket.async_connect(endpoint,
                                         boost::bind(&IoHandler::handle_connect, this, pSession, boost::asio::placeholders::error));

        return true;
    }

    return 0;
    LEAVE_FUNCTION_RETURN_0
}

bool IoHandler::IsListening() { return m_bIsStartListen; }

Session* IoHandler::AllocAcceptSession()
{
    ENTER_FUNCTION_FOXNET
    return m_pAcceptSessionPool->Alloc();
    LEAVE_FUNCTION_RETURN_NULL
}

Session* IoHandler::AllocConnectSession()
{
    ENTER_FUNCTION_FOXNET
    return m_pConnectSessionPool->Alloc();
    LEAVE_FUNCTION_RETURN_NULL
}

void IoHandler::FreeSession(Session* pSession)
{
    ENTER_FUNCTION_FOXNET
    pSession->m_Socket.close();
    pSession->Init();
    if (pSession->IsAcceptSocket())
    {
        if (m_numWaitAccept == 0 || !m_bIsStartListen)
        {
            m_pAcceptSessionPool->Free(pSession);
        }
        else
        {
            m_numWaitAccept--;

            m_AcceptorPtr->async_accept(pSession->m_Socket,
                                        boost::bind(&IoHandler::handle_accept, this, pSession, boost::asio::placeholders::error));

#ifdef _DEBUG
            m_pWaitAcceptSessionList->Lock();
            m_pWaitAcceptSessionList->push_back(pSession);
            m_pWaitAcceptSessionList->Unlock();
#endif
        }
    }
    else
    {
        m_pConnectSessionPool->Free(pSession);
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::ProcessConnectSuccessList()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;
    Session*          pSession;

    m_pConnectSuccessList->Lock();
    m_pTempList->splice(m_pTempList->end(), *m_pConnectSuccessList);
    m_pConnectSuccessList->Unlock();

    it = m_pTempList->begin();
    while (it != m_pTempList->end())
    {
        SESSION_LIST_ITER it2 = it++;

        pSession = *it2;

        if (pSession->PreRecv())
        {
            pSession->OnConnect(true);
        }
        else
        {
            m_pTempList->erase(it2);

            FreeSession(pSession);

            pSession->OnConnect(false);
        }
    }

    if (!m_pTempList->empty())
    {
        m_numActiveSessions += (unsigned int) m_pTempList->size();

        m_pActiveSessionList->Lock();
        m_pActiveSessionList->splice(m_pActiveSessionList->end(), *m_pTempList);
        m_pActiveSessionList->Unlock();
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::ProcessConnectFailList()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;
    Session*          pSession;

    m_pConnectFailList->Lock();

    for (it = m_pConnectFailList->begin(); it != m_pConnectFailList->end(); ++it)
    {
        pSession = *it;

        FreeSession(pSession);

        pSession->OnConnect(false);
    }

    m_pConnectFailList->clear();
    m_pConnectFailList->Unlock();
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::ProcessAcceptedSessionList()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;
    Session*          pSession;

    m_pAcceptedSessionList->Lock();
    m_pTempList->splice(m_pTempList->end(), *m_pAcceptedSessionList);
    m_pAcceptedSessionList->Unlock();

    it = m_pTempList->begin();
    while (it != m_pTempList->end())
    {
        SESSION_LIST_ITER it2 = it++;
        pSession              = *it2;

        if (m_numActiveSessions >= m_nMaxAcceptSession)
        {
            printf("connection full! no available accept socket!\n");
            m_pTempList->erase(it2);
            FreeSession(pSession);
            continue;
        }

        if (!pSession->PreRecv())
        {
            m_pTempList->erase(it2);
            FreeSession(pSession);
            continue;
        }

        NetObject* pNetworkObject = m_fnCreateAcceptedObject();
        assert(pNetworkObject);

        pSession->BindNetworkObject(pNetworkObject);

        pSession->OnAccept();

        ++m_numActiveSessions;
    }

    if (!m_pTempList->empty())
    {
        m_pActiveSessionList->Lock();
        m_pActiveSessionList->splice(m_pActiveSessionList->begin(), *m_pTempList);
        m_pActiveSessionList->Unlock();
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::ProcessActiveSessionList()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;
    Session*          pSession;

    for (it = m_pActiveSessionList->begin(); it != m_pActiveSessionList->end(); ++it)
    {
        pSession = *it;

        if (pSession->ShouldBeRemoved())
            continue;

        if (pSession->HasDisconnectOrdered())
        {
            if (pSession->GetSendBuffer()->GetLength() == 0)
            {
                printf("发送缓冲区长度为0\n");
                pSession->Remove();
            }
            else
            {
                if (pSession->PreSend() != true)
                {
                    printf("投递写数据失败\n");
                    pSession->Remove();
                    continue;
                }
            }
        }
        else
        {
            // 断线检测
            if (pSession->IsAcceptSocket() && pSession->IsOnIdle())
            {
                pSession->Remove();
                continue;
            }

            if (!pSession->ProcessRecvdPacket(m_nMaxPacketSize))
            {
                printf("处理接收到的数据包时出错\n");
                pSession->Remove();
                continue;
            }

            if (pSession->PreSend() != true)
            {
                printf("投递写数据失败\n");
                pSession->Remove();
                continue;
            }

            if (pSession->GetIsWaitPreRecv() && pSession->PreRecv())
            {
                // TODO: 存在同步问题? 当此处切换线程导致投递后的读数据失败　然后重新设置此标志为TRUE 而后此处重设为FALSE 导致无投递的情况
                pSession->SetWaitPreRecv(false);
            }
        }
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::KickDeadSessions()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;
    Session*          pSession;

    m_pActiveSessionList->Lock();

    it = m_pActiveSessionList->begin();
    while (it != m_pActiveSessionList->end())
    {
        pSession                 = *it;
        SESSION_LIST_ITER tempIT = it++;

        if (pSession->ShouldBeRemoved())
        {
            m_pActiveSessionList->erase(tempIT);
            m_pTempList->push_back(pSession);
        }
    }

    m_pActiveSessionList->Unlock();

    for (it = m_pTempList->begin(); it != m_pTempList->end(); ++it)
    {
        Session* pSession = *it;

        --m_numActiveSessions;

        NetObject* pNetworkObject = pSession->GetNetworkObject();
        pNetworkObject->OnDisconnect();
        pSession->UnbindNetworkObject();


        FreeSession(pSession);
        if (pSession->IsAcceptSocket())
            m_fnDestroyAcceptedObject(pNetworkObject);
    }

    m_pTempList->clear();
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::ProcessSend() {}

void IoHandler::KickAllSessions()
{
    ENTER_FUNCTION_FOXNET
    printf("断开所有连接\n");

    SESSION_LIST_ITER it;
    for (it = m_pActiveSessionList->begin(); it != m_pActiveSessionList->end(); ++it)
    {
        (*it)->Remove();
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::handle_connect(Session* pSession, const boost::system::error_code& e)
{
    ENTER_FUNCTION_FOXNET
    if (!e)
    {
        m_pConnectSuccessList->Lock();
        m_pConnectSuccessList->push_back(pSession);
        m_pConnectSuccessList->Unlock();
    }
    else
    {
        m_pConnectFailList->Lock();
        m_pConnectFailList->push_back(pSession);
        m_pConnectFailList->Unlock();
    }
    LEAVE_FUNCTION_FOXNET
}

void IoHandler::CloseHandle()
{
    ENTER_FUNCTION_FOXNET
    if (m_bIsStartListen)
    {
        m_AcceptorPtr->close();
    }

    m_bIsStartListen    = false;
    m_numActiveSessions = 0;
    m_nMaxPacketSize    = 0;

    Shutdown();

    m_bShutdown = false;
    LEAVE_FUNCTION_FOXNET
}
