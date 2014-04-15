#ifndef __CommonDefs_H__
#define __CommonDefs_H__

#if defined(_WIN32)

#pragma warning(disable: 4996)

#ifndef COMMON_INCLUDE

#if defined(COMMON_EXPORTS)

#define COMMON_API __declspec(dllexport)
#define COMMON_CAPI extern "C" __declspec(dllexport)

#else

#define COMMON_API __declspec(dllimport)
#define COMMON_CAPI extern "C" __declspec(dllimport)

#endif

#else

#define COMMON_API
#define COMMON_CAPI

#endif

#else

#define COMMON_API
#define COMMON_CAPI

#endif

#endif