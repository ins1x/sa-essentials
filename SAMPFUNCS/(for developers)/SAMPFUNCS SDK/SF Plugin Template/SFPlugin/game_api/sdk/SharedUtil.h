/*****************************************************************************
*
*  PROJECT:     Multi Theft Auto v1.0
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        SharedUtil.h
*  PURPOSE:     Solution wide utility functions
*  DEVELOPERS:  ccw <chris@codewave.co.uk>
*               Alberto Alonso <rydencillo@gmail.com>
*
*  Multi Theft Auto is available from http://www.multitheftauto.com/
*
*****************************************************************************/
//#pragma once      Don't do this

/*************************************************************************
	Simplification of some 'unsigned' types
*************************************************************************/
//                                                  VS      GCC
//                      Actual sizes:      32bit   64bit   64bit
typedef	unsigned long	    ulong;      //  32      32      64
typedef unsigned int	    uint;       //  32
typedef unsigned short	    ushort;     //  16  
typedef unsigned char	    uchar;      //  8

typedef unsigned long long  uint64;     //  64
typedef unsigned int        uint32;     //  32
typedef unsigned short      uint16;     //  16
typedef unsigned char       uint8;      //  8

// signed types
typedef signed long long    int64;      //  64
typedef signed int          int32;      //  32
typedef signed short        int16;      //  16
typedef signed char         int8;       //  8

// Windowsesq types
typedef unsigned char       BYTE;       //  8
typedef unsigned short      WORD;       //  16
typedef unsigned long       DWORD;      //  32      32      64
typedef float               FLOAT;      //  32


//
// System wide defines
//
#if defined(WIN32)
    #if _MSC_VER <= 1500
        // VS08 does not have isnan, but _isnan
        #include <float.h>
        #define isnan _isnan
    #endif
#endif

//
// Macro for counting the number of elements in a static array
//
#ifndef NUMELMS     // from DShow.h
    #define NUMELMS(aa) (sizeof(aa)/sizeof((aa)[0]))
#endif

// Auto clear a class when new'ed. (Won't work for inline creation.)
#define ZERO_ON_NEW \
    void* operator new ( size_t size )              { void* ptr = ::operator new(size); memset(ptr,0,size); return ptr; } \
    void* operator new ( size_t size, void* where ) { memset(where,0,size); return where; }

#define dassert(_Expression)     ((void)0)
#define SAFE_DELETE(p) { if(p) { delete (p); (p)=NULL; } }
#define PI (3.14159265358979323846f)

// Clear all member variables to zero for a struct.
// Note: Struct should have simple member variables and no virtual functions.
#define ZERO_POD_STRUCT(ptr) \
        memset ( ptr, 0, sizeof(*(ptr)) )

// Crazy thing
#define LOCAL_FUNCTION_START    struct local {
#define LOCAL_FUNCTION_END      };
#define LOCAL_FUNCTION          local

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

#ifndef stricmp
#define stricmp _stricmp
#endif

#ifndef strnicmp
#define strnicmp _strnicmp
#endif

// Vendor
#ifndef _
#define _ //Use a dummy localisation define for modules that don't need it
#endif


#include <assert.h>
#include <list>
#include <vector>
#include <map>
#include <set>
#include <deque>
#include <algorithm>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <string>

#include "SString.h"
#include "WString.h"

#include "SharedUtil.Map.h"
#include "SharedUtil.HashMap.h"
#include "SharedUtil.FastHashMap.h"
#include "SharedUtil.FastHashSet.h"
#include "SharedUtil.Misc.h"
#include "SharedUtil.Time.h"
#include "SharedUtil.Buffer.h"
#include "SharedUtil.Game.h"
#include "SharedUtil.MemAccess.h"