--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local sampapi = require 'sampapi'
local shared = sampapi.shared
local mt = require 'sampapi.metatype'
local ffi = require 'ffi'

shared.require 'CRect'

shared.ffi.cdef[[
typedef struct SCFont SCFont;
struct SCFont;

typedef struct SCFonts SCFonts;
#pragma pack(push, 1)
struct SCFonts {
    SCFont* m_pFont;
    SCFont* m_pLittleFont;
    SCFont* m_pShadow;
    SCFont* m_pLittleShadow;
    SCFont* m_pLicensePlateFont;
    struct ID3DXSprite* m_pDefaultSprite;
    struct IDirect3DDevice9* m_pDevice;
    char* m_szTempBuffer;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCFonts', 0x20)

local CFonts_constructor = ffi.cast('void(__thiscall*)(SCFonts*, IDirect3DDevice9*)', 0x67410)
local CFonts_destructor = ffi.cast('void(__thiscall*)(SCFonts*)', 0x66A20)
local function CFonts_new(...)
    local obj = ffi.gc(ffi.new('struct SCFonts[1]'), CFonts_destructor)
    CFonts_constructor(obj, ...)
    return obj
end

local SCFonts_mt = {
    OnLostDevice = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x66AA0)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x66AE0)),
    GetTextScreenSize = ffi.cast('void(__thiscall*)(SCFonts*, void*, const char*, unsigned long)', sampapi.GetAddress(0x66B20)),
    GetLittleTextScreenSize = ffi.cast('void(__thiscall*)(SCFonts*, void*, const char*, unsigned long)', sampapi.GetAddress(0x66BD0)),
    DrawText = ffi.cast('void(__thiscall*)(SCFonts*, ID3DXSprite*, const char*, SCRect, D3DCOLOR, BOOL)', sampapi.GetAddress(0x66C80)),
    DrawLittleText = ffi.cast('void(__thiscall*)(SCFonts*, ID3DXSprite*, const char*, SCRect, int, D3DCOLOR, BOOL)', sampapi.GetAddress(0x66E00)),
    DrawLicensePlateText = ffi.cast('void(__thiscall*)(SCFonts*, const char*, SCRect, D3DCOLOR)', sampapi.GetAddress(0x66F70)),
    Reset = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x67200)),
}
mt.set_handler('struct SCFonts', '__index', SCFonts_mt)

local function RefFontRenderer() return ffi.cast('SCFonts**', sampapi.GetAddress(0x21A0FC))[0] end

return {
    new = CFonts_new,
    RefFontRenderer = RefFontRenderer,
}