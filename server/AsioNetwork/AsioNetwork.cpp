#include "AsioNetwork.h"
#include "NetObject.h"
#include <assert.h>
#include "IoHandler.h"
#include "Session.h"

AsioNetwork::AsioNetwork()
{
    ENTER_FUNCTION_FOXNET
    m_bShutdown = false;
    LEAVE_FUNCTION_FOXNET
}

AsioNetwork::~AsioNetwork()
{
    ENTER_FUNCTION_FOXNET
    if (!m_bShutdown)
        Shutdown();
    LEAVE_FUNCTION_FOXNET
}

bool AsioNetwork::Init(LPIOHANDLER_DESC lpDesc, unsigned int nNumberofIoHandlers)
{
    ENTER_FUNCTION_FOXNET
    for (unsigned int i = 0; i < nNumberofIoHandlers; ++i)
    {
        CreateIoHandler(lpDesc + i);
    }

    return true;
    LEAVE_FUNCTION_RETURN_FALSE
}

bool AsioNetwork::StartListen(unsigned int nIoHandlerKey, char* pIP, unsigned short nPort)
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

    assert(it != m_mapIoHandlers.end());

    return it->second->StartListen(pIP, nPort);
    LEAVE_FUNCTION_RETURN_FALSE
}

void AsioNetwork::Update()
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it;
    for (it = m_mapIoHandlers.begin(); it != m_mapIoHandlers.end(); ++it)
    {
        it->second->Update();
    }
    LEAVE_FUNCTION_FOXNET
}

void AsioNetwork::Shutdown()
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it;
    IoHandler*         pIoHandler;

    for (it = m_mapIoHandlers.begin(); it != m_mapIoHandlers.end(); ++it)
    {
        pIoHandler = it->second;
        pIoHandler->Shutdown();
        delete pIoHandler;
    }
    m_mapIoHandlers.clear();

    m_bShutdown = true;
    LEAVE_FUNCTION_FOXNET
}

unsigned int AsioNetwork::Connect(unsigned int nIoHandlerKey, NetObject* pNetworkObject, char* pszIP, unsigned short nPort)
{
    ENTER_FUNCTION_FOXNET
    if (pNetworkObject == NULL)
        return 0;

    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

    assert(it != m_mapIoHandlers.end());

    return it->second->Connect(pNetworkObject, pszIP, nPort);

    LEAVE_FUNCTION_RETURN_0
}

bool AsioNetwork::IsListening(unsigned int nIoHandlerKey)
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

    assert(it != m_mapIoHandlers.end());

    return it->second->IsListening();
    LEAVE_FUNCTION_RETURN_FALSE
}

unsigned int AsioNetwork::GetNumberOfConnections(unsigned int nIoHandlerKey)
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nIoHandlerKey);

    assert(it != m_mapIoHandlers.end());

    return it->second->GetNumberOfConnections();
    LEAVE_FUNCTION_RETURN_0
}

void AsioNetwork::CreateIoHandler(LPIOHANDLER_DESC lpDesc)
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(lpDesc->nIoHandlerKey);
    assert(it == m_mapIoHandlers.end());

    IoHandler* pIoHandler = new IoHandler;

    pIoHandler->Init(this, lpDesc);

    m_mapIoHandlers.insert(IOHANDLER_MAP_PAIR(pIoHandler->GetKey(), pIoHandler));

    LEAVE_FUNCTION_FOXNET
}

unsigned int AsioNetwork::ConvAddr(const char* strIP)
{
    ENTER_FUNCTION_FOXNET
    boost::asio::ip::address adrs(boost::asio::ip::address::from_string(strIP));
    return adrs.to_v4().to_ulong();
    LEAVE_FUNCTION_RETURN_0
}

std::string AsioNetwork::ConvAddr(unsigned int nIP)
{
    ENTER_FUNCTION_FOXNET
    boost::asio::ip::address_v4 adrs(nIP);
    return adrs.to_string();
    LEAVE_FUNCTION_FOXNET
    return "";
}

void AsioNetwork::CloseHandle(unsigned int nNumberofIoHandlers)
{
    ENTER_FUNCTION_FOXNET
    IOHANDLER_MAP_ITER it = m_mapIoHandlers.find(nNumberofIoHandlers);

    assert(it != m_mapIoHandlers.end());

    it->second->CloseHandle();
    LEAVE_FUNCTION_FOXNET
}
