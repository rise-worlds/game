#ifndef __SessionPool_H__
#define __SessionPool_H__

#include <boost/asio.hpp>

class Session;
class Session;
class SessionList;

class SessionPool
{
public:
    SessionPool(boost::asio::io_service& ioservice, unsigned int nSize, unsigned int nSendBufferSize, unsigned int nRecvBufferSize,
                unsigned int nMaxPacketSize, unsigned int nTimeOutTick, unsigned int nIndexStart, bool bAcceptSocket);
    ~SessionPool();

    Session* Alloc();
    void     Free(Session* pSession);
    int      GetLength();

private:
    void Create(boost::asio::io_service& ioservice, unsigned int nSize, unsigned int nSendBufferSize, unsigned int nRecvBufferSize,
                unsigned int nMaxPacketSize, unsigned int nTimeOutTick, unsigned int nIndexStart, bool bAcceptSocket);

    unsigned int m_nMaxSize;
    SessionList* m_pList;
};


#endif  // __SessionPool_H__