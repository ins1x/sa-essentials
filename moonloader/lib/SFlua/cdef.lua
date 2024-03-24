--[[
    Project: SF.lua <https://github.com/imring/SF.lua>
    License: GNU General Public License v3.0
    Authors: look in file <AUTHORS>.
]]

local ffi = require("ffi")
local memory = require("memory")

ffi.cdef[[
    typedef unsigned int UINT;
    typedef unsigned char BYTE;
    typedef unsigned long DWORD;
    typedef unsigned short WORD;
    typedef char *PCHAR;
    typedef const char *PCSTR;
    typedef long HRESULT;
    typedef int INT;
    typedef void *HWND;
    typedef unsigned int BOOL;

    typedef struct _stdvector
    {
        float x, y, z;
    } stdvector;

    typedef struct _stdstring {
        union {
            char str[16];
            char* pstr;
        };
        size_t length;
        size_t allocated;
    } stdstring;

    typedef void(__cdecl *CMDPROC) (PCHAR);

    typedef DWORD D3DCOLOR;

    typedef struct stRECT
    {
        int left, top, right, bottom;
    } RECT;

    typedef struct stID3DXFont
    {
        struct ID3DXFont_vtbl* vtbl;
    } ID3DXFont;

    struct ID3DXFont_vtbl
    {
        void* QueryInterface; // STDMETHOD(QueryInterface)(THIS_ REFIID iid, LPVOID *ppv) PURE;
        void* AddRef; // STDMETHOD_(ULONG, AddRef)(THIS) PURE;
        uint32_t (__stdcall * Release)(ID3DXFont* font); // STDMETHOD_(ULONG, Release)(THIS) PURE;

        // ID3DXFont
        void* GetDevice; // STDMETHOD(GetDevice)(THIS_ LPDIRECT3DDEVICE9 *ppDevice) PURE;
        void* GetDescA; // STDMETHOD(GetDescA)(THIS_ D3DXFONT_DESCA *pDesc) PURE;
        void* GetDescW; // STDMETHOD(GetDescW)(THIS_ D3DXFONT_DESCW *pDesc) PURE;
        void* GetTextMetricsA; // STDMETHOD_(BOOL, GetTextMetricsA)(THIS_ TEXTMETRICA *pTextMetrics) PURE;
        void* GetTextMetricsW; // STDMETHOD_(BOOL, GetTextMetricsW)(THIS_ TEXTMETRICW *pTextMetrics) PURE;

        void* GetDC; // STDMETHOD_(HDC, GetDC)(THIS) PURE;
        void* GetGlyphData; // STDMETHOD(GetGlyphData)(THIS_ UINT Glyph, LPDIRECT3DTEXTURE9 *ppTexture, RECT *pBlackBox, POINT *pCellInc) PURE;

        void* PreloadCharacters; // STDMETHOD(PreloadCharacters)(THIS_ UINT First, UINT Last) PURE;
        void* PreloadGlyphs; // STDMETHOD(PreloadGlyphs)(THIS_ UINT First, UINT Last) PURE;
        void* PreloadTextA; // STDMETHOD(PreloadTextA)(THIS_ LPCSTR pString, INT Count) PURE;
        void* PreloadTextW; // STDMETHOD(PreloadTextW)(THIS_ LPCWSTR pString, INT Count) PURE;

        int (__stdcall * DrawTextA)(ID3DXFont* font, void* pSprite, const char* pString, int Count, RECT* pRect, uint32_t Format, uint32_t Color); // STDMETHOD_(INT, DrawTextA)(THIS_ LPD3DXSPRITE pSprite, LPCSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;
        void* DrawTextW; // STDMETHOD_(INT, DrawTextW)(THIS_ LPD3DXSPRITE pSprite, LPCWSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;

        void (__stdcall * OnLostDevice)(ID3DXFont* font); // STDMETHOD(OnLostDevice)(THIS) PURE;
        void (__stdcall * OnResetDevice)(ID3DXFont* font); // STDMETHOD(OnResetDevice)(THIS) PURE;
    };
]]