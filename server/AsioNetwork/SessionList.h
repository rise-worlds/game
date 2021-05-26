#ifndef __SessionList_H__
#define __SessionList_H__

#include "Session.h"

#include <list>
#include "boost/thread.hpp"

typedef std::list<Session*>    SESSION_LIST;
typedef SESSION_LIST::iterator SESSION_LIST_ITER;

class SessionList : public std::list<Session*>
{
public:
    SessionList() {}

    ~SessionList() { Clear(); }

    void Clear();

    inline void Lock() { m_Mutex.lock(); }
    inline void Unlock() { m_Mutex.unlock(); }

private:
    boost::mutex m_Mutex;
};


#endif  // __SessionList_H__