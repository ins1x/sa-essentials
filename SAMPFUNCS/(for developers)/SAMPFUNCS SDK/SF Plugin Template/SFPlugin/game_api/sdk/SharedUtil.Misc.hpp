/*****************************************************************************
*
*  PROJECT:     Multi Theft Auto v1.0
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        SharedUtil.Misc.hpp
*  PURPOSE:
*  DEVELOPERS:  ccw <chris@codewave.co.uk>
*               Alberto Alonso <rydencillo@gmail.com>
*               Cecill Etheredge <ijsf@gmx-topmail.de>
*
*  Multi Theft Auto is available from http://www.multitheftauto.com/
*
*****************************************************************************/

#include "UTF8.h"
#include "UTF8Detect.cpp"

SharedUtil::CCriticalSection::CCriticalSection(void)
{
	m_pCriticalSection = new CRITICAL_SECTION;
	InitializeCriticalSection((CRITICAL_SECTION*)m_pCriticalSection);
}

SharedUtil::CCriticalSection::~CCriticalSection(void)
{
	DeleteCriticalSection((CRITICAL_SECTION*)m_pCriticalSection);
	delete (CRITICAL_SECTION*)m_pCriticalSection;
}

void SharedUtil::CCriticalSection::Lock(void)
{
	if (m_pCriticalSection)
		EnterCriticalSection((CRITICAL_SECTION*)m_pCriticalSection);
}

void SharedUtil::CCriticalSection::Unlock(void)
{
	if (m_pCriticalSection)
		LeaveCriticalSection((CRITICAL_SECTION*)m_pCriticalSection);
}


// Return true if currently executing the main thread.
// Main thread being defined as the thread the function is first called from.
//
bool SharedUtil::IsMainThread ( void )
{
#ifdef WIN32
    static DWORD dwMainThread = GetCurrentThreadId ();
    return GetCurrentThreadId () == dwMainThread;
#else
    static pthread_t dwMainThread = pthread_self ();
    return pthread_equal ( pthread_self (), dwMainThread ) != 0;
#endif
}


// Convert a standard multibyte UTF-8 std::string into a UTF-16 std::wstring
std::wstring SharedUtil::MbUTF8ToUTF16 (const std::string& input)
{
    return utf8_mbstowcs (input);
}

// Convert a UTF-16 std::wstring into a multibyte UTF-8 string
std::string SharedUtil::UTF16ToMbUTF8 (const std::wstring& input)
{
    return utf8_wcstombs (input);
}

// Get UTF8 confidence
int SharedUtil::GetUTF8Confidence (const unsigned char* input, int len)
{
    return icu_getUTF8Confidence (input, len);
}

// Translate a true ANSI string to the UTF-16 equivalent (reencode+convert)
std::wstring SharedUtil::ANSIToUTF16 ( const std::string& input )
{
    size_t len = mbstowcs ( NULL, input.c_str(), input.length() );
    if ( len == (size_t)-1 )
        return L"?";
    wchar_t* wcsOutput = new wchar_t[len+1];
    mbstowcs ( wcsOutput, input.c_str(), input.length() );
    wcsOutput[len] = 0; //Null terminate the string
    std::wstring strOutput(wcsOutput);
    delete [] wcsOutput;
    return strOutput;
}

// Check for BOM bytes
bool SharedUtil::IsUTF8BOM( const void* pData, uint uiLength )
{
    const uchar* pCharData = (const uchar*)pData;
    return ( uiLength > 2 && pCharData[0] == 0xEF && pCharData[1] == 0xBB && pCharData[2] == 0xBF );
}


namespace SharedUtil
{
    //
    // class CRanges
    //
    //  Ranges of numbers. i.e.   100-4000, 5000-6999, 7000-7010
    //
    void CRanges::SetRange ( uint uiStart, uint uiLength )
    {
        if ( uiLength < 1 )
            return;
        uint uiLast = uiStart + uiLength - 1;

        // Make a hole
        UnsetRange ( uiStart, uiLength );

        // Insert
        m_StartLastMap [ uiStart ] = uiLast;

        // Maybe join adjacent ranges one day
    }

    void CRanges::UnsetRange ( uint uiStart, uint uiLength )
    {
        if ( uiLength < 1 )
            return;
        uint uiLast = uiStart + uiLength - 1;
 
        RemoveObscuredRanges ( uiStart, uiLast );

        IterType iterOverlap;
        if ( GetRangeOverlappingPoint ( uiStart, iterOverlap ) )
        {
            uint uiOverlapPrevLast = iterOverlap->second;

            // Modify overlapping range last point
            uint uiNewLast = uiStart - 1;
            iterOverlap->second = uiNewLast;

            if ( uiOverlapPrevLast > uiLast )
            {
                // Need to add range after hole
                uint uiNewStart = uiLast + 1;
                m_StartLastMap[ uiNewStart ] = uiOverlapPrevLast;
            }
        }

        if ( GetRangeOverlappingPoint ( uiLast, iterOverlap ) )
        {
            // Modify overlapping range start point
            uint uiNewStart = uiLast + 1;
            uint uiOldLast = iterOverlap->second;
            m_StartLastMap.erase ( iterOverlap );
            m_StartLastMap[ uiNewStart ] = uiOldLast;
        }
    }

    // Returns true if any part of the range already exists in the map
    bool CRanges::IsRangeSet ( uint uiStart, uint uiLength )
    {
        if ( uiLength < 1 )
            return false;
        uint uiLast = uiStart + uiLength - 1;

        IterType iter = m_StartLastMap.lower_bound ( uiStart );
        // iter is on or after start

        if ( iter != m_StartLastMap.end () )
        {
            // If start of found range is before or at query last, then range is used
            if ( iter->first <= uiLast )
                return true;
        }

        if ( iter != m_StartLastMap.begin () )
        {
            iter--;
            // iter is now before start

            // If last of found range is after or at query start, then range is used
            if ( iter->second >= uiStart )
                return true;
        }

        return false;
    }

    void CRanges::RemoveObscuredRanges ( uint uiStart, uint uiLast )
    {
        while ( true )
        {
            IterType iter = m_StartLastMap.lower_bound ( uiStart );
            // iter is on or after start

            if ( iter == m_StartLastMap.end () )
                return;

            // If last of found range is after query last, then range is not obscured
            if ( iter->second > uiLast )
                return;

            // Remove obscured
            m_StartLastMap.erase ( iter );
        }
    }

    bool CRanges::GetRangeOverlappingPoint ( uint uiPoint, IterType& result )
    {
        IterType iter = m_StartLastMap.lower_bound ( uiPoint );
        // iter is on or after point - So it can't overlap the point

        if ( iter != m_StartLastMap.begin () )
        {
            iter--;
            // iter is now before point

            // If last of found range is after or at query point, then range is overlapping
            if ( iter->second >= uiPoint )
            {
                result = iter;
                return true;
            }
        }
        return false;
    }

}

WString SharedUtil::FromUTF8( const SString& strPath )
{
#ifdef WIN32_TESTING   // This might be faster - Needs testing
    const char* szSrc = strPath;
    uint cCharacters = strlen ( szSrc ) + 1 ;
    uint cbUnicode = cCharacters * 4;
    wchar_t* Dest = (wchar_t*)alloca ( cbUnicode );

    if ( MultiByteToWideChar ( CP_UTF8, 0, szSrc, -1, Dest, (int)cbUnicode ) == 0 )
    {
        return WString();
    }
    else
    {
        return Dest;
    }
#else
    return MbUTF8ToUTF16( strPath );
#endif
}

SString SharedUtil::ToUTF8( const WString& strPath )
{
#ifdef WIN32_TESTING   // This might be faster - Needs testing
    const wchar_t* pszW = strPath;
    uint cCharacters = wcslen(pszW)+1;
    uint cbAnsi = cCharacters * 6;
    char* pData = (char*)alloca ( cbAnsi );

    if (0 == WideCharToMultiByte(CP_UTF8, 0, pszW, cCharacters, pData, cbAnsi, NULL, NULL))
    {
        return "";
    }
    return pData;
#else
    return UTF16ToMbUTF8( strPath );
#endif
}
