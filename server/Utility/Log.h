#ifndef __Log_H__
#define __Log_H__

#include "CommonDefs.h"
#include "Single.h"

BEGINNAMESPACE

// 日志等级
enum eLogLevel
{
	eLog_Error		= 0,
	eLog_Warning	= 1000,
	eLog_Success	= 2000,
	eLog_Normal		= 3000,
};

const int MAX_MESSAGE_LEN	= 1024;

class COMMON_API Log: public Single<Log>
{
public:
	Log();
	~Log();
	bool	CreateLog(const char* pszDir, const char* pszFileName);
	bool	OutLog(eLogLevel eLevel, const char* pszModule, const char * pszFormat, ...);

	void	ShowLogView();
};

ENDNAMESPACE

#define DISPMSG(...)	Common::Log::getSingle().OutLog(Common::eLog_Normal, __FUNCTION__, __VA_ARGS__);
#define WARNINGMSG(...)	Common::Log::getSingle().OutLog(Common::eLog_Warning, __FUNCTION__, __VA_ARGS__);
#define SUCCESSMSG(...)	Common::Log::getSingle().OutLog(Common::eLog_Success, __FUNCTION__, __VA_ARGS__);
#define ERRMSG(...)	Common::Log::getSingle().OutLog(Common::eLog_Error, __FUNCTION__, __VA_ARGS__);

//#undef	SAFE_DELETE
//#define SAFE_DELETE(ptr)		{ if(ptr){ try{ delete ptr; }catch(...){ ERRMSG("CATCH: *** SAFE_DELETE() crash! *** at %s, %d", __FILE__, __LINE__); } ptr = 0; } }
//
//#undef	SAFE_RELEASE
//#define SAFE_RELEASE(ptr)		{ if(ptr){ try{ ptr->Release(); }catch(...){ ERRMSG("CATCH: *** SAFE_RELEASE() crash! *** at %s, %d", __FILE__, __LINE__); } ptr = 0; } }

#ifdef	_DEBUG
#undef		ASSERT
#define		ASSERT		assert
#define		CHECK(x)	{ if(!(x)) { assert(!("CHECK: " #x)); return;} }
#define		CHECKF(x)	{ if(!(x)) { assert(!("CHECKF: " #x)); return 0;} }
#define		IF_NOT(x)	if( (!(x)) ? ( assert(!("IF_NOT: " #x)),1 ) : 0 )
#define		IF_NOT_(x)	if( (!(x)) ? ( assert(!("IF_NOT_: " "#x")),1 ) : 0 )
#define		IF_OK(x)	if( ((x)) ? 1 : ( assert(!("IF_OK: " #x)),0 ) )
#define		IF_OK_(x)	if( ((x)) ? 1 : ( assert(!("IF_OK_: " "#x")),0 ) )
#else
#undef		ASSERT
#define		ASSERT(x)	{ if(!(x)) ERRMSG("★ASSERT(%s)★ in %s, %d", #x, __FILE__, __LINE__); }
#define		CHECK(x)	{ if(!(x)) { ERRMSG("★CHECK(%s)★ in %s, %d", #x, __FILE__, __LINE__); return;} }
#define		CHECKF(x)	{ if(!(x)) { ERRMSG("★CHECKF(%s)★ in %s, %d", #x, __FILE__, __LINE__); return 0;} }
#define		IF_NOT(x)	{if(!(x)) { ERRMSG("★IF_NOT(%s)★ in %s, %d", #x, __FILE__, __LINE__);} }\
	if( (!(x)) ? 1 : 0)
#define		IF_NOT_(x)	{if(!(x)) { ERRMSG("★IF_NOT(%s)★ in %s, %d", "#x", __FILE__, __LINE__);} }\
	if( (!(x)) ? 1 : 0)

#define		IF_OK(x)	{ if(!(x)) {ERRMSG("★IF_OK(%s)★ in %s, %d", #x, __FILE__, __LINE__);} }\
	if( ((x)) ? 1 : 0)
#define		IF_OK_(x)	{ if(!(x)) {ERRMSG("★IF_OK(%s)★ in %s, %d", "#x", __FILE__, __LINE__);} }\
	if( ((x)) ? 1 : 0)
#endif


//#define		IF_TRUE			IF_OK
//#define		IF_SUCCEED		IF_OK
//
//#define		IF_FALSE		IF_NOT
//#define		IF_FAIL			IF_NOT

#endif // __Log_H__