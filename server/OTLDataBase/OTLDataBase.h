#ifndef __OTLDATABASE_H__
#define __OTLDATABASE_H__
#include "../Utility/CommonDefs.h"

// 此类是从 OTLDataBase.dll 导出的
class COMMON_API COTLDataBase {
public:
	COTLDataBase(void);
	// TODO:  在此添加您的方法。
};

extern COMMON_API int nOTLDataBase;

COMMON_API int fnOTLDataBase(void);

#endif