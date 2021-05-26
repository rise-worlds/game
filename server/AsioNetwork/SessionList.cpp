#include "SessionList.h"

void SessionList::Clear()
{
    ENTER_FUNCTION_FOXNET
    SESSION_LIST_ITER it;

    Session* pSession;

    Lock();

    for (it = begin(); it != end(); ++it)
    {
        pSession = *it;
        delete pSession;
    }
    clear();

    Unlock();
    LEAVE_FUNCTION_FOXNET
}
