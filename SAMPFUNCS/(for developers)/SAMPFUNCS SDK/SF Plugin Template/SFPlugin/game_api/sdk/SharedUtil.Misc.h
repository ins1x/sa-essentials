/*****************************************************************************
*
*  PROJECT:     Multi Theft Auto v1.0
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        SharedUtil.Misc.h
*  PURPOSE:
*  DEVELOPERS:  ccw <chris@codewave.co.uk>
*               Alberto Alonso <rydencillo@gmail.com>
*
*  Multi Theft Auto is available from http://www.multitheftauto.com/
*
*****************************************************************************/


#include <cmath>
#include <direct.h>

namespace SharedUtil
{
    //
    // Return true if currently executing the main thread
    // See implementation for details
    bool            IsMainThread                    ( void );

    // string stuff
    //

    std::wstring MbUTF8ToUTF16 (const std::string& s);

    std::string  UTF16ToMbUTF8 (const std::wstring& ws);

    std::wstring  ANSIToUTF16 (const std::string& s);

    int  GetUTF8Confidence (const unsigned char* input, int len);

    bool IsUTF8BOM( const void* pData, uint uiLength );

    //
    // Some templates
    //
    template < class T >
    T Min ( const T& a, const T& b )
    {
        return a < b ? a : b;
    }

    template < class T >
    T Max ( const T& a, const T& b )
    {
        return a > b ? a : b;
    }

    // Clamps a value between two other values ( min < a < max )
    template < class T >
    T Clamp ( const T& min, const T& a, const T& max )
    {
        return a < min ? min : a > max ? max : a;
    }

    // Lerps between two values depending on the weight
    template< class T >
    T Lerp ( const T& from, float fAlpha, const T& to )
    {
        return (T)( ( to - from ) * fAlpha + from );
    }

    // Find the relative position of Pos between From and To
    inline const float Unlerp ( const double dFrom, const double dPos, const double dTo )
    {
        // Avoid dividing by 0 (results in INF values)
        if ( dFrom == dTo ) return 1.0f;

        return static_cast < float > ( ( dPos - dFrom ) / ( dTo - dFrom ) );
    }

    // Unlerp avoiding extrapolation
    inline const float UnlerpClamped ( const double dFrom, const double dPos, const double dTo )
    {
        return Clamp ( 0.0f, Unlerp( dFrom, dPos, dTo ), 1.0f );
    }

    template < class T >
    int Round ( T value )
    {
        return static_cast < int > ( std::floor ( value + 0.5f ) );
    }

    template < class T >
    T WrapAround ( T fLow, T fValue, T fHigh )
    {
        const T fSize = fHigh - fLow;
        return fValue - ( fSize * std::floor ( ( fValue - fLow ) / fSize ) );
    }


	//
    // Cross platform critical section
    //
	class CCriticalSection
    {
    public:
                    CCriticalSection        ( void );
                    ~CCriticalSection       ( void );
        void        Lock                    ( void );
        void        Unlock                  ( void );

    private:
        void*       m_pCriticalSection;
    };


    //
    // SColor
    //
    // Encapsulates the most common usage of 4 byte color storage.
    // Casts to and from a DWORD as 0xAARRGGBB
    //
    class SColor
    {
        // No shifting allowed to access the color channel information
        void operator >> ( int ) const;
        void operator << ( int ) const;
        void operator >>= ( int );
        void operator <<= ( int );
    public:
        union
        {
            struct
            {
                unsigned char B, G, R, A;
            };
            unsigned long ulARGB;
        };

        SColor () {}
        SColor ( unsigned long ulValue )
        {
            ulARGB = ulValue;
        }

        operator unsigned long () const
        {
            return ulARGB;
        }
    };


    //
    // SColorARGB
    //
    // Make an SColor from A,R,G,B
    //
    class SColorARGB : public SColor
    {
    public:
        SColorARGB ( unsigned char ucA, unsigned char ucR, unsigned char ucG, unsigned char ucB )
        {
            A = ucA; R = ucR; G = ucG; B = ucB;
        }

        template < class T, class U, class V, class W >
        SColorARGB ( T a, U r, V g, W b )
        {
            A = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( a ), 255 );
            R = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( r ), 255 );
            G = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( g ), 255 );
            B = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( b ), 255 );
        }
    };


    //
    // SColorRGBA
    //
    // Make an SColor from R,G,B,A
    //
    class SColorRGBA : public SColor
    {
    public:
        SColorRGBA ( unsigned char ucR, unsigned char ucG, unsigned char ucB, unsigned char ucA )
        {
            A = ucA; R = ucR; G = ucG; B = ucB;
        }

        template < class T, class U, class V, class W >
        SColorRGBA ( T r, U g, V b, W a )
        {
            A = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( a ), 255 );
            R = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( r ), 255 );
            G = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( g ), 255 );
            B = Clamp < unsigned char > ( 0, static_cast < unsigned char > ( b ), 255 );
        }
    };


    //
    // Things to make it simpler to use SColor with the source code as it stands
    //
    typedef SColor RGBA;

    inline unsigned char COLOR_RGBA_R ( SColor color ) { return color.R; }
    inline unsigned char COLOR_RGBA_G ( SColor color ) { return color.G; }
    inline unsigned char COLOR_RGBA_B ( SColor color ) { return color.B; }
    inline unsigned char COLOR_RGBA_A ( SColor color ) { return color.A; }
    inline unsigned char COLOR_ARGB_A ( SColor color ) { return color.A; }

    inline SColor COLOR_RGBA ( unsigned char R, unsigned char G, unsigned char B, unsigned char A ) { return SColorRGBA ( R, G, B, A ); }
    inline SColor COLOR_ARGB ( unsigned char A, unsigned char R, unsigned char G, unsigned char B ) { return SColorRGBA ( R, G, B, A ); }
    inline SColor COLOR_ABGR ( unsigned char A, unsigned char B, unsigned char G, unsigned char R ) { return SColorRGBA ( R, G, B, A ); }


    ///////////////////////////////////////////////////////////////
    //
    // CMappedContainer
    //
    // Combination list and map - For fast list Contains() method
    //
    ///////////////////////////////////////////////////////////////
    template < class T, class LIST_TYPE >
    class CMappedContainer
    {
    public:

        // map only
        bool Contains ( const T& item ) const { return MapContains ( m_Map, item ); }

        // list only
        typename LIST_TYPE ::iterator               begin ( void )          { return m_List.begin (); }
        typename LIST_TYPE ::iterator               end ( void )            { return m_List.end (); }
        typename LIST_TYPE ::reverse_iterator       rbegin ( void )         { return m_List.rbegin (); }
        typename LIST_TYPE ::reverse_iterator       rend ( void )           { return m_List.rend (); }
        uint                                        size ( void ) const     { return m_List.size (); }
        bool                                        empty ( void ) const    { return m_List.empty (); }
        const T&                                    back ( void ) const     { return m_List.back (); }
        const T&                                    front ( void ) const    { return m_List.front (); }

        // list and map
        void push_back ( const T& item )
        {
            AddMapRef ( item );
            m_List.push_back ( item );
        }

        void push_front ( const T& item )
        {
            AddMapRef ( item );
            m_List.push_front ( item );
        }

        void pop_back ( void )
        {
            RemoveMapRef ( m_List.back () );
            m_List.pop_back ();
        }

        void pop_front ( void )
        {
            RemoveMapRef ( m_List.front () );
            m_List.pop_front ();
        }

        // Remove all occurrences of item
        void remove ( const T& item )
        {
            if ( Contains ( item ) )
            {
                // Remove all refs from map and list
                MapRemove ( m_Map, item );
                ListRemove ( m_List, item );
            }
        }

        void clear ( void )
        {
            m_Map.clear ();
            m_List.clear ();
        }

        typename LIST_TYPE ::iterator erase ( typename LIST_TYPE ::iterator iter )
        {
            RemoveMapRef ( *iter );
            return m_List.erase ( iter );
        }

    protected:
        // Increment reference count for item
        void AddMapRef ( const T& item )
        {
            if ( int* pInt = MapFind ( m_Map, item ) )
                ( *pInt )++;
            else
                MapSet ( m_Map, item, 1 );
        }

        // Decrement reference count for item
        void RemoveMapRef ( const T& item )
        {
            typename std::map < T, int > ::iterator it = m_Map.find ( item );
            if ( it != m_Map.end () )
                if ( !--( it->second ) )
                    m_Map.erase ( it );
        }

        // Debug
        void Validate ( void ) const
        {
            int iTotalRefs = 0;
            for ( typename std::map < T, int > ::const_iterator it = m_Map.begin () ; it != m_Map.end () ; ++it )
                iTotalRefs += it->second;
            assert ( iTotalRefs == m_List.size () );
        }

        std::map < T, int > m_Map;
        LIST_TYPE           m_List;
    };

    template < class T >
    class CMappedArray : public CMappedContainer < T, std::vector < T > >
    {
    public:
        const T& operator[] ( int idx ) const   { return CMappedContainer < T, std::vector < T > >::m_List[idx]; }
        T& operator[] ( int idx )               { return CMappedContainer < T, std::vector < T > >::m_List[idx]; }
    };
	
    template < class T >
    class CMappedList : public CMappedContainer < T, std::list < T > >
    {
    };

	// Returns true if the item is in the itemList
    template < class U, class T >
    bool ListContains ( const CMappedList < U >& itemList, const T& item )
    {
        return itemList.Contains ( item );
    }

    // Returns true if the item is in the itemList
    template < class U, class T >
    bool ListContains ( const CMappedArray < U >& itemList, const T& item )
    {
        return itemList.Contains ( item );
    }


    // Remove all occurrences of item from itemList
    template < class U, class T >
    void ListRemove ( CMappedList < U >& itemList, const T& item )
    {
        itemList.remove ( item );
    }

    // Remove all occurrences of item from itemList
    template < class U, class T >
    void ListRemove ( CMappedArray < U >& itemList, const T& item )
    {
        itemList.remove ( item );
    }

	// Remove all occurrences of item from itemList
    template < class T >
    void ListRemove ( std::list < T >& itemList, const T& item )
    {
        itemList.remove ( item );
    }

	// Remove all occurrences of item from itemList
    template < class T >
    void ListRemove ( std::vector < T >& itemList, const T& item )
    {
        typename std::vector < T >::iterator it = itemList.begin ();
        while ( it != itemList.end () )
        {
            if ( item == *it )
                it = itemList.erase ( it );
            else
                ++it;
        }
    }
	
    // Returns true if the item is in the itemList
    template < class TL, class T >
    bool ListContains ( const TL& itemList, const T& item )
    {
        typename TL ::const_iterator it = itemList.begin ();
        for ( ; it != itemList.end () ; ++it )
            if ( item == *it )
                return true;
        return false;
    }


    //
    // Fast wildcard matching
    //
    inline
    bool WildcardMatch(const char *wild, const char *string) {
      // Written by Jack Handy - jakkhandy@hotmail.com
      assert ( wild && string );

      const char *cp = NULL, *mp = NULL;

      while ((*string) && (*wild != '*')) {
        if ((*wild != *string) && (*wild != '?')) {
          return 0;
        }
        wild++;
        string++;
      }

      while (*string) {
        if (*wild == '*') {
          if (!*++wild) {
            return 1;
          }
          mp = wild;
          cp = string+1;
        } else if ((*wild == *string) || (*wild == '?')) {
          wild++;
          string++;
        } else {
          wild = mp;
          string = cp++;
        }
      }

      while (*wild == '*') {
        wild++;
      }
      return !*wild;
    }


    //
    // Fixed size array
    //
    // Replacement for e.g.  int var[100]
    // Checks bounds
    //
    template < class T, int SIZE >
    struct SFixedArray
    {
        T& operator[] ( uint uiIndex )
        {
            assert ( uiIndex < SIZE );
            return data [ uiIndex ];
        }

        const T& operator[] ( uint uiIndex ) const
        {
            assert ( uiIndex < SIZE );
            return data [ uiIndex ];
        }

        T data [ SIZE ];
    };

    //
    //  Ranges of numbers. i.e. 100-4000, 5000-6999, 7000-7010
    //
    class CRanges
    {
    public:
        void    SetRange                    ( uint uiStart, uint uiLength );
        void    UnsetRange                  ( uint uiStart, uint uiLength );
        bool    IsRangeSet                  ( uint uiStart, uint uiLength );    // Returns true if any part of the range already exists in the map

    protected:
        typedef std::map < uint, uint >::iterator IterType;

        void    RemoveObscuredRanges        ( uint uiStart, uint uiLast );
        bool    GetRangeOverlappingPoint    ( uint uiPoint, IterType& result );

        std::map < uint, uint >     m_StartLastMap;
    };

	WString FromUTF8(const SString& strPath);
	SString ToUTF8(const WString& strPath);
};

using namespace SharedUtil;