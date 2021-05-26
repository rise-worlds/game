#ifndef __Session_H__
#define __Session_H__

#include <boost/asio.hpp>
#include <hash_map>
class NetObject;
class SendBuffer;
class RecvBuffer;


class Session
{
    friend class IoHandler;

public:
    Session(boost::asio::io_service& io_service, unsigned int nSendBufferSize, unsigned int nRecvBufferSize, unsigned int nMaxPacketSize,
            unsigned int nTimeOut);
    virtual ~Session();

    void Init();
    bool Send(char* pMsg, unsigned short nSize);
    bool SendEx(unsigned short nNumberOfMessages, char** ppMsg, unsigned short* pnSize);
    bool PreSend();
    bool PreRecv();
    bool ProcessRecvdPacket(unsigned int nMaxPacketSize);
    void BindNetworkObject(NetObject* pNetworkObject);
    void UnbindNetworkObject();
    void OnAccept();
    void OnConnect(bool bSuccess);

    inline NetObject*  GetNetworkObject() { return m_pNetworkObject; }
    inline SendBuffer* GetSendBuffer() { return m_pSendBuffer; }
    inline RecvBuffer* GetRecvBuffer() { return m_pRecvBuffer; }
    inline char*       GetIP()
    {
        static std::string s_RemoteAddr;
        s_RemoteAddr = m_Socket.remote_endpoint().address().to_string();
        return (char*) (s_RemoteAddr.c_str());
    }
    inline unsigned short GetPort()
    {
        unsigned short port = m_Socket.remote_endpoint().port();
        return port;
    }
    inline unsigned int GetIndex() { return m_nIndex; }
    inline bool         IsAcceptSocket() { return m_bAcceptSocket; }
    inline void         SetAcceptSocketFlag() { m_bAcceptSocket = true; }
    void                Remove() { m_bRemove = true; }
    inline void         ResetKillFlag() { m_bRemove = false; }
    inline bool         ShouldBeRemoved() { return m_bRemove; }
    void                Disconnect(bool bForceDisconnect);
    inline bool         HasDisconnectOrdered() { return m_bDisconnectOrdered; }

    void SetIndex(unsigned int index) { m_nIndex = index; }

    void ResetTimeOut();
    bool IsOnIdle();

    float GetSendBufferRatio();

    bool CompleteSend(int nSize, int nMsgType);

private:
    NetObject*  m_pNetworkObject;
    SendBuffer* m_pSendBuffer;
    RecvBuffer* m_pRecvBuffer;

    bool         m_bRemove;
    unsigned int m_nIndex;
    bool         m_bAcceptSocket;
    bool         m_bDisconnectOrdered;

    unsigned int m_nLastSyncTick;
    unsigned int m_nTimeOut;

public:
    bool GetIsWaitPreRecv() { return m_bWaitPreRecv; }
    void SetWaitPreRecv(bool b) { m_bWaitPreRecv = b; }

private:
    bool m_bWaitPreRecv;

private:
    /// Handle completion of a read operation.
    void handle_read(const boost::system::error_code& e, std::size_t bytes_transferred);

    /// Handle completion of a write operation.
    void handle_write(const boost::system::error_code& e, std::size_t bytes_transferred);

    /// Strand to ensure the connection's handlers are not called concurrently.
    boost::asio::io_service::strand m_Strand;

    /// Socket for the connection.
    boost::asio::ip::tcp::socket m_Socket;
};

#endif  // __Session_H__