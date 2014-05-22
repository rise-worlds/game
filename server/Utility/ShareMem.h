#ifndef __ShareMem_H__
#define __ShareMem_H__
#include "CommonDefs.h"
#ifdef _WIN32
#include <Windows.h>
#endif
BEGINNAMESPACE
namespace ShareMem
{
typedef	unsigned long	SM_KEY;
#ifdef _WIN32
typedef	HANDLE	SMHandle;
#define INVALID_SM_HANDLE	 (HANDLE)(-1)
#else
typedef	int	SMHandle;
#define INVALID_SM_HANDLE	 (0)
#endif
	/*创建ShareMem 内存区
	*
	*	key   创建ShareMem 的关键值
	*
	*   Size  创建大小
	*
	*	返回 对应ShareMem保持值
	*/
	COMMON_API SMHandle		CreateShareMem(SM_KEY key, unsigned int Size);
	/*打开ShareMem 内存区
	*
	* key   打开ShareMem 的关键值
	*
	* Size  打开大小
	*
	* 返回  对应ShareMem 保持值
	*/
	COMMON_API SMHandle		OpenShareMem(SM_KEY key, unsigned int Size);

	/*映射ShareMem 内存区
	*
	*	handle 映射ShareMem 的保持值
	*
	*   返回 ShareMem 的数据指针
	*/
	COMMON_API char*			MapShareMem(SMHandle handle);

	/*关闭映射 ShareMem 内存区
	*
	*	MemoryPtr			ShareMem 的数据指针
	*
	*
	*/
	COMMON_API void 		UnMapShareMem(char* MemoryPtr);

	/*	关闭ShareMem
	* 	handle  需要关闭的ShareMem 保持值
	*/
	COMMON_API void 		CloseShareMem(SMHandle handle);
}
ENDNAMESPACE
#endif