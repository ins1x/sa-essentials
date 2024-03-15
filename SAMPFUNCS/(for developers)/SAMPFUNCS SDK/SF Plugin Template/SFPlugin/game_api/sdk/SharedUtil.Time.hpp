/*****************************************************************************
*
*  PROJECT:     Multi Theft Auto v1.0
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        SharedUtil.Time.hpp
*  PURPOSE:
*  DEVELOPERS:  
*
*  Multi Theft Auto is available from http://www.multitheftauto.com/
*
*****************************************************************************/

static CCriticalSection ms_criticalSection;
static long long ms_llTickCountAdd = 0;
unsigned long GetTickCountInternal ( void );

// Debugging
void SharedUtil::AddTickCount( long long llTickCountAdd )
{
    ms_criticalSection.Lock ();
    ms_llTickCountAdd = llTickCountAdd;
    ms_criticalSection.Unlock ();
}


//
// Retrieves the number of milliseconds that have elapsed since the function was first called (plus a little bit to make it look good).
// This keeps the counter as low as possible to delay any precision or wrap around issues.
// Note: Return value is module dependent
//
uint SharedUtil::GetTickCount32 ( void )
{
    return (uint)GetTickCount64_();
}


//
// Retrieves the number of milliseconds that have elapsed since some arbitrary point in time.
//
// GetTickCount64() exists on Vista and up and is like GetTickCount() except it returns
// an __int64 and will effectively never wrap. This is an emulated version for XP and down.
// Note: Wrap around issue is only defeated if the gap between calls is less than 24 days.
//
long long SharedUtil::GetTickCount64_ ( void )
{
    ms_criticalSection.Lock ();

    static long long llCurrent = ( GetTickCountInternal () % 300000 + 200000 );
    static uint uiWas      = GetTickCountInternal();
    uint        uiNow      = GetTickCountInternal();
    uint        uiDelta    = uiNow - uiWas;
    uiWas = uiNow;

    // Ensure delta is not negative
    if ( uiDelta > 0x80000000 )
        uiDelta = 0;

    // Or greater than 600 seconds
    if ( uiDelta > 600 * 1000 )
        uiDelta = 600 * 1000;

    // Add delta to accumulator
    llCurrent += uiDelta;

    // Add debug value
    llCurrent += ms_llTickCountAdd;
    ms_llTickCountAdd = 0;

    long long llResult = llCurrent;
    ms_criticalSection.Unlock ();
    return llResult;
}


//
// Retrieves the number of seconds that have elapsed since some arbitrary point in time.
//
double SharedUtil::GetSecondCount ( void )
{
    return GetTickCount64_ () * ( 1 / 1000.0 );
}


//
// Transfer a value from one thread to another without locks
//
template < class T, int BUFFER_SIZE = 4 >
class CThreadResultValue
{
public:
    CThreadResultValue ( void ) : m_ucLastWrittenIndex ( 0 ) {}

    void Initialize ( const T& initialValue )
    {
        m_ucLastWrittenIndex = 0;
        for ( uint i = 0 ; i < BUFFER_SIZE ; i++ )
        {
            m_OutputBuffersA[ i ] = initialValue;
            m_OutputBuffersB[ i ] = initialValue;
        }
    }

    void SetValue ( const T& value )
    {
        if ( value != m_OutputBuffersA[m_ucLastWrittenIndex] )
        {
            uchar ucIndex = m_ucLastWrittenIndex;
            ucIndex = ( ucIndex + 1 ) % BUFFER_SIZE;
            m_OutputBuffersA[ ucIndex ] = value;
            m_OutputBuffersB[ ucIndex ] = value;
            m_ucLastWrittenIndex = ucIndex;
        }
    }

    T GetValue ( void )
    {
        while ( true )
        {
            uchar ucIndex = m_ucLastWrittenIndex;
            T resultA = m_OutputBuffersA[ ucIndex ];
            T resultB = m_OutputBuffersB[ ucIndex ];
            if ( resultA == resultB )
                return resultA;
        }
    }

protected:
    volatile uchar   m_ucLastWrittenIndex;
    volatile T       m_OutputBuffersA[ BUFFER_SIZE ];
    volatile T       m_OutputBuffersB[ BUFFER_SIZE ];
};


namespace SharedUtil
{
    //
    // ModuleTickCount is a per-module cached tickcount value
    //
    class CPerModuleTickCount
    {
    public:
        CPerModuleTickCount ( void )
        {
    #ifdef _DEBUG
            m_TimeSinceUpdated.SetMaxIncrement ( 500 );
    #endif
            m_ResultValue.Initialize ( GetTickCount64_ () );
        }

        long long Get ( void )
        {
    #ifdef _DEBUG
            if ( m_TimeSinceUpdated.Get () > 10000 )
            {
                m_TimeSinceUpdated.Reset ();
                OutputDebugLine ( "WARNING: UpdateModuleTickCount64 might not be called for the current module" );
            }
    #endif
            return m_ResultValue.GetValue ();
        }

        void Update ( void )
        {
    #ifdef _DEBUG
            m_TimeSinceUpdated.Reset ();
    #endif
            m_ResultValue.SetValue ( GetTickCount64_ () );
        }
    
		static CPerModuleTickCount& Instance(void)
		{
			static CPerModuleTickCount PerModuleTickCount;
			return PerModuleTickCount;
		}

    protected:
        CThreadResultValue < long long > m_ResultValue;
    #ifdef _DEBUG
        CElapsedTime    m_TimeSinceUpdated;
    #endif
    };
}

long long SharedUtil::GetModuleTickCount64 ( void )
{
	return CPerModuleTickCount::Instance().Get();
}

void SharedUtil::UpdateModuleTickCount64 ( void )
{
	return CPerModuleTickCount::Instance().Update();
}


//
// Cross-platform GetTickCount() implementations
//   Returns the number of milliseconds since some fixed point in time.
//   Wraps every 49.71 days and should always increase monotonically.
//
// ACHTUNG: This function should be scrapped and replaced by a cross-platform time class
//
#if defined(__APPLE__) && defined(__MACH__)

// Apple / Darwin platforms with Mach monotonic clock support
#include <mach/mach_time.h>
unsigned long GetTickCountInternal ( void )
{
    mach_timebase_info_data_t info;

    // Get the absolute time
    uint64_t nAbsTime = mach_absolute_time();

    // Get the timebase info (could be done once, statically?)
    mach_timebase_info( &info );

    // Calculate the time in milliseconds
    uint64_t nNanoTime = nAbsTime * ( info.numer / info.denom );
    return ( nNanoTime / 1000000 );
}

#elif !defined(WIN32)

// BSD / Linux platforms with POSIX monotonic clock support
unsigned long GetTickCountInternal ( void )
{
    #if !defined(CLOCK_MONOTONIC)
    #error "This platform does not have monotonic clock support."
    #endif

    /*
    ** clock_gettime() is granted to be increased monotonically when the
    ** monotonic clock is queried. Time starting point is unspecified, it
    ** could be the system start-up time, the Epoch, or something else,
    ** in any case the time starting point does not change once that the
    ** system has started up.
    */
    struct timeval now;
    struct timespec tsnow;
    if(0 == clock_gettime(CLOCK_MONOTONIC, &tsnow)) {
        now.tv_sec = tsnow.tv_sec;
        now.tv_usec = tsnow.tv_nsec / 1000;
    }
    /*
    ** Even when the configure process has truly detected monotonic clock
    ** availability, it might happen that it is not actually available at
    ** run-time. When this occurs simply fallback to other time source.
    */
    else
        (void)gettimeofday(&now, NULL);

    // ACHTUNG: Note that the above gettimeofday fallback is dangerous because it is a wall clock
    // and thus not guaranteed to be monotonic. Ideally, this function should throw a fatal error
    // or assertion instead of using a fallback method.

    long long llMilliseconds = ( ( long long ) now.tv_sec ) * 1000 + now.tv_usec / 1000;
    return llMilliseconds;
}

#else

// Win32 platforms
#include <Mmsystem.h>
#pragma comment(lib, "Winmm.lib")
unsigned long GetTickCountInternal ( void )
{
    // Uses timeGetTime() as Win32 GetTickCount() has a resolution of 16ms.
    //   (timeGetTime() has a resolution is 1ms assuming timeBeginPeriod(1) has been called at startup).
    return timeGetTime ();
}

#endif


// Get time in microseconds
// Due to issues with QueryPerformanceCounter, this function should only be used for profiling
TIMEUS SharedUtil::GetTimeUs()
{
    static bool bInitialized = false;
    static LARGE_INTEGER lFreq, lStart;
    static LARGE_INTEGER lDivisor;
    if ( !bInitialized )
    {
        bInitialized = true;
        QueryPerformanceFrequency(&lFreq);
        QueryPerformanceCounter(&lStart);
        lDivisor.QuadPart = lFreq.QuadPart / 1000000;
    }

    LARGE_INTEGER lEnd;
    QueryPerformanceCounter(&lEnd);
    LONGLONG llDuration = ( lEnd.QuadPart - lStart.QuadPart ) * 1000000LL / lFreq.QuadPart;
    return llDuration & 0xffffffff;
}