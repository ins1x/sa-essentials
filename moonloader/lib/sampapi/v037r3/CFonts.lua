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
shared.require 'v037r3.CFont'

shared.ffi.cdef[[
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
    int m_nCharHeight;
    int m_nLittleCharHeight;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCFonts', 0x28)

local function RefFontRenderer() return ffi.cast('SCFonts**', sampapi.GetAddress(0x26E8E4))[0] end
local CFonts_constructor = ffi.cast('void(__thiscall*)(SCFonts*, IDirect3DDevice9*)', 0x6B380)
local CFonts_destructor = ffi.cast('void(__thiscall*)(SCFonts*)', 0x6A990)
local function CFonts_new(...)
    local obj = ffi.gc(ffi.new('struct SCFonts[1]'), CFonts_destructor)
    CFonts_constructor(obj, ...)
    return obj
end

local SCFonts_mt = {
    OnLostDevice = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x6AA10)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x6AA50)),
    GetTextScreenSize = ffi.cast('void(__thiscall*)(SCFonts*, void*, const char*, int)', sampapi.GetAddress(0x6AA90)),
    GetLittleTextScreenSize = ffi.cast('void(__thiscall*)(SCFonts*, void*, const char*, int)', sampapi.GetAddress(0x6AB40)),
    DrawText = ffi.cast('void(__thiscall*)(SCFonts*, ID3DXSprite*, const char*, SCRect, D3DCOLOR, BOOL)', sampapi.GetAddress(0x6ABF0)),
    DrawLittleText = ffi.cast('void(__thiscall*)(SCFonts*, ID3DXSprite*, const char*, SCRect, int, D3DCOLOR, BOOL)', sampapi.GetAddress(0x6AD70)),
    DrawLicensePlateText = ffi.cast('void(__thiscall*)(SCFonts*, const char*, SCRect, D3DCOLOR)', sampapi.GetAddress(0x6AEE0)),
    Reset = ffi.cast('void(__thiscall*)(SCFonts*)', sampapi.GetAddress(0x6B170)),
}
mt.set_handler('struct SCFonts', '__index', SCFonts_mt)

return {
    RefFontRenderer = RefFontRenderer,
    new = CFonts_new,
}