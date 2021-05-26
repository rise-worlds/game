#include "Session.h"
#include <boost/bind.hpp>
#include <boost/asio/ip/tcp.hpp>

#include "SendBuf.h"
#include "RecvBuf.h"
#include "NetObject.h"

#include "../Utility/FuncPerformanceLog.h"
#include "../Utility/CTimer.h"

Session::Session(boost::asio::io_service& io_service, unsigned int nSendBufferSize, unsigned int nRecvBufferSize,
                 unsigned int nMaxPacketSize, unsigned int nTimeOut)
    : m_Socket(io_service)
    , m_Strand(io_service)
{
    ENTER_FUNCTION_FOXNET
    m_pSendBuffer = new SendBuffer;
    m_pSendBuffer->Create(nSendBufferSize, nMaxPacketSize);

    m_pRecvBuffer = new RecvBuffer;
    m_pRecvBuffer->Create(nRecvBufferSize, nMaxPacketSize);

    m_pNetworkObject     = NULL;
    m_bRemove            = false;
    m_nIndex             = 0;
    m_bAcceptSocket      = false;
    m_bDisconnectOrdered = false;

    m_nTimeOut = nTimeOut;

    Init();

    LEAVE_FUNCTION_FOXNET
}

Session::~Session()
{
    ENTER_FUNCTION_FOXNET
    if (m_pSendBuffer)
        delete m_pSendBuffer;
    if (m_pRecvBuffer)
        delete m_pRecvBuffer;
    LEAVE_FUNCTION_FOXNET
}

void Session::Init()
{
    ENTER_FUNCTION_FOXNET
    m_pSendBuffer->Clear();
    m_pRecvBuffer->Clear();
    SetWaitPreRecv(false);

    ResetKillFlag();

    m_bDisconnectOrdered = false;
    LEAVE_FUNCTION_FOXNET
}

bool Session::Send(char* pMsg, unsigned short nSize)
{
    ENTER_FUNCTION_FOXNET
    PACKET_HEADER header;
    header.size = nSize;
    if (m_pSendBuffer->Write(&header, pMsg) == false)
    {
        // printf("发送队列满  CurSize[%d] MsgSize[%d]\n", m_pSendBuffer->GetLength(), header.size);
        // Remove();
        return false;
    }

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

bool Session::SendEx(unsigned short nNumberOfMessages, char** ppMsg, unsigned short* pnSize)
{
    ENTER_FUNCTION_FOXNET
    PACKET_HEADER header;
    header.size = 0;
    unsigned int i;
    for (i = 0; i < nNumberOfMessages; ++i)
    {
        header.size += pnSize[i];
    }

    if (m_pSendBuffer->GetSpace() < (sizeof(PACKET_HEADER) + header.size))
    {
        // printf("发送队列满  CurSize[%d] MsgSize[%d]\n", m_pSendBuffer->GetLength(), header.size);
        return false;
    }

    if (!m_pSendBuffer->Write((char*) &header, sizeof(PACKET_HEADER)))
    {
        Remove();
        return false;
        // printf( "发送队列满  CurSize[%d] MsgSize[%d]\n", m_pSendBuffer->GetLength(), header.size);
        // Remove();
        // return false;
    }

    for (i = 0; i < nNumberOfMessages; ++i)
    {
        if (!m_pSendBuffer->Write(ppMsg[i], pnSize[i]))
        {
            Remove();
            return false;

            // printf( "发送队列满  CurSize[%d] MsgSize[%d]\n", m_pSendBuffer->GetLength(), header.size);
            // Remove();
            // return false;
        }
    }

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

bool Session::PreSend()
{
    ENTER_FUNCTION_FOXNET
    char* pSendBuf  = NULL;
    int   nSendSize = 0;

    if (GetSendBuffer()->GetSendParam((char**) &pSendBuf, (int&) nSendSize) == false)
    {
        return true;
    }
    if (nSendSize == 0)
    {
        return true;
    }

    m_Socket.async_write_some(boost::asio::buffer(pSendBuf, nSendSize),
                              boost::bind(&Session::handle_write, this, boost::asio::placeholders::error,
                                          boost::asio::placeholders::bytes_transferred));


    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

bool Session::PreRecv()
{
    ENTER_FUNCTION_FOXNET
    char* pRecvBuf  = NULL;
    int   nRecvSize = 0;

    m_pRecvBuffer->GetRecvParam((char**) &pRecvBuf, (int&) nRecvSize);

    if (nRecvSize == 0)
    {
        return false;
    }

    m_Socket.async_read_some(
            boost::asio::buffer(pRecvBuf, nRecvSize),
            boost::bind(&Session::handle_read, this, boost::asio::placeholders::error, boost::asio::placeholders::bytes_transferred));

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

bool Session::ProcessRecvdPacket(unsigned int nMaxPacketSize)
{
    ENTER_FUNCTION_FOXNET
    char*          pPacket;
    PACKET_HEADER* pHeader;

    while (pPacket = GetRecvBuffer()->GetFirstPacketPtr())
    {
        pHeader = (PACKET_HEADER*) pPacket;

        if (pHeader->size <= 0)
        {
            return false;
        }

        if (pHeader->size + sizeof(PACKET_HEADER) > nMaxPacketSize)
        {
            return false;
        }

        BEGINFUNCPERLOG("Network OnRecv");
        m_pNetworkObject->OnRecv(pPacket + sizeof(PACKET_HEADER), pHeader->size);
        ENDFUNCPERLOG("Network OnRecv");
        GetRecvBuffer()->RemoveFirstPacket(sizeof(PACKET_HEADER) + pHeader->size);

        ResetTimeOut();
    }

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

void Session::BindNetworkObject(NetObject* pNetworkObject)
{
    ENTER_FUNCTION_FOXNET
    m_pNetworkObject = pNetworkObject;
    pNetworkObject->SetSession(this);
    LEAVE_FUNCTION_FOXNET
}

void Session::UnbindNetworkObject()
{
    ENTER_FUNCTION_FOXNET
    if (m_pNetworkObject == NULL)
    {
        return;
    }
    m_pNetworkObject->SetSession(NULL);

    m_pNetworkObject = NULL;
    LEAVE_FUNCTION_FOXNET
}

void Session::OnAccept()
{
    ENTER_FUNCTION_FOXNET
    // Init();

    ResetKillFlag();

    ResetTimeOut();

    m_pNetworkObject->OnAccept(GetIndex());
    LEAVE_FUNCTION_FOXNET
}

void Session::OnConnect(bool bSuccess)
{
    ENTER_FUNCTION_FOXNET
    // 	Init();

    NetObject* pNetworkObject = m_pNetworkObject;
    pNetworkObject->OnConnect(bSuccess, GetIndex());

    if (!bSuccess)
    {
        UnbindNetworkObject();
    }
    LEAVE_FUNCTION_FOXNET
}

void Session::Disconnect(bool bForceDisconnect)
{
    ENTER_FUNCTION_FOXNET
    if (bForceDisconnect)
    {
        Remove();
    }
    else
    {
        m_bDisconnectOrdered = true;
    }
    LEAVE_FUNCTION_FOXNET
}

void Session::handle_read(const boost::system::error_code& e, std::size_t bytes_transferred)
{
    ENTER_FUNCTION_FOXNET
    if (!e)
    {
        do
        {
            if (bytes_transferred == 0)
            {
                // printf("接收到0字节 正常关闭\n %s, %d\n", __FILE__, __LINE__);
                Remove();
                break;
            }

            GetRecvBuffer()->Completion((int) bytes_transferred);
            if (PreRecv() != true)
            {
                // printf("投递读不成功\n %s, %d\n", __FILE__, __LINE__);
                // Remove();
                SetWaitPreRecv(true);
            }
        } while (0);
    }
    else
    {
        boost::system::error_code e11    = e;
        int                       nError = e11.value();
#ifdef _DEBUG
        printf("返回读数据时错误[%d %s]\n %s, %d\n", nError, e11.message().c_str(), __FILE__, __LINE__);
#else
        // 2     -- End of file
        // 10054 --远程连接关闭
        // 1236  --由本地终止网络连接
        if (nError != 2 && nError != 10054 && nError != 1236)
        {
            printf("返回读数据时错误[%d %s]\n %s, %d\n", nError, e11.message().c_str(), __FILE__, __LINE__);
        }
#endif
        Remove();
    }
    LEAVE_FUNCTION_FOXNET
}

void Session::handle_write(const boost::system::error_code& e, std::size_t bytes_transferred)

{
    ENTER_FUNCTION_FOXNET
    if (!e)
    {
        GetSendBuffer()->Completion((int) bytes_transferred);

        if (HasDisconnectOrdered() && GetSendBuffer()->GetLength() == 0)
        {
            Remove();
        }
    }
    else
    {
        boost::system::error_code e11    = e;
        int                       nError = e11.value();
#ifdef _DEBUG
        printf("返回写数据时错误[%d %s]\n %s, %d\n", e11.value(), e11.message().c_str(), __FILE__, __LINE__);
#else
        // 2     -- End of file
        // 10054 --远程连接关闭
        // 1236  --由本地终止网络连接
        if (nError != 2 && nError != 10054 && nError != 1236)
        {
            printf("返回读数据时错误[%d %s]\n %s, %d\n", nError, e11.message().c_str(), __FILE__, __LINE__);
        }
#endif
        Remove();
    }
    LEAVE_FUNCTION_FOXNET
}

void Session::ResetTimeOut()
{
    ENTER_FUNCTION_FOXNET
    m_nLastSyncTick = Common::Timer::GetTime();
    LEAVE_FUNCTION_FOXNET
}

bool Session::IsOnIdle()
{
    ENTER_FUNCTION_FOXNET
    if (m_nTimeOut)
    {
        unsigned int nCurTime = Common::Timer::GetTime();
        if (m_nTimeOut >= nCurTime)
        {
            return false;
        }

        unsigned int nDiffTime = nCurTime - m_nTimeOut;
        if (nDiffTime >= m_nLastSyncTick)
        {
            return true;
        }

        return false;
    }

    return false;
    LEAVE_FUNCTION_FOXNET
    return true;
}

float Session::GetSendBufferRatio()
{
    ENTER_FUNCTION_FOXNET
    return (float(m_pSendBuffer->GetLength())) / (m_pSendBuffer->GetLength() + m_pSendBuffer->GetSpace());
    LEAVE_FUNCTION_FOXNET
    return 0.0f;
}

bool Session::CompleteSend(int nSize, int nMsgType)
{
    ENTER_FUNCTION_FOXNET

    bool bOk = this->GetSendBuffer()->CompletionDataWrite(nSize);

    return bOk;
    LEAVE_FUNCTION_RETURN_FALSE
}
