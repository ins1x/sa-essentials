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

shared.require 'CVector'

shared.ffi.cdef[[
typedef struct STransmit STransmit;
#pragma pack(push, 1)
struct STransmit {
    union {
        struct {
            unsigned char m_bBox : 1;
            unsigned char m_bLeft : 1;
            unsigned char m_bRight : 1;
            unsigned char m_bCenter : 1;
            unsigned char m_bProportional : 1;
        };
        unsigned char m_nFlags;
    };
    float m_fLetterWidth;
    float m_fLetterHeight;
    D3DCOLOR m_letterColor;
    float m_fBoxWidth;
    float m_fBoxHeight;
    D3DCOLOR m_boxColor;
    unsigned char m_nShadow;
    bool m_bOutline;
    D3DCOLOR m_backgroundColor;
    unsigned char m_nStyle;
    unsigned char unknown;
    float m_fX;
    float m_fY;
    short unsigned int m_nModel;
    SCVector m_rotation;
    float m_fZoom;
    short unsigned int m_aColor[2];
};
#pragma pack(pop)

typedef struct SData SData;
#pragma pack(push, 1)
struct SData {
    float m_fLetterWidth;
    float m_fLetterHeight;
    D3DCOLOR m_letterColor;
    unsigned char unknown;
    unsigned char m_bCenter;
    unsigned char m_bBox;
    float m_fBoxSizeX;
    float m_fBoxSizeY;
    D3DCOLOR m_boxColor;
    unsigned char m_nProportional;
    D3DCOLOR m_backgroundColor;
    unsigned char m_nShadow;
    unsigned char m_nOutline;
    unsigned char m_bLeft;
    unsigned char m_bRight;
    int m_nStyle;
    float m_fX;
    float m_fY;
    unsigned char pad_[8];
    long unsigned int field_99B;
    long unsigned int field_99F;
    long unsigned int m_nIndex;
    unsigned char field_9A7;
    short unsigned int m_nModel;
    SCVector m_rotation;
    float m_fZoom;
    short unsigned int m_aColor[2];
    unsigned char field_9BE;
    unsigned char field_9BF;
    unsigned char field_9C0;
    long unsigned int field_9C1;
    long unsigned int field_9C5;
    long unsigned int field_9C9;
    long unsigned int field_9CD;
    unsigned char field_9D1;
    long unsigned int field_9D2;
};
#pragma pack(pop)

typedef struct SCTextDraw SCTextDraw;
#pragma pack(push, 1)
struct SCTextDraw {
    char m_szText[801];
    char m_szString[1602];
    SData m_data;
};
#pragma pack(pop)
]]

shared.validate_size('struct STransmit', 0x3f)
shared.validate_size('struct SData', 0x73)
shared.validate_size('struct SCTextDraw', 0x9d6)

local CTextDraw_constructor = ffi.cast('void(__thiscall*)(SCTextDraw*, STransmit*, const char*)', 0xACF10)
local CTextDraw_destructor = ffi.cast('void(__thiscall*)(SCTextDraw*)', 0xAC860)
local function CTextDraw_new(...)
    local obj = ffi.gc(ffi.new('struct SCTextDraw[1]'), CTextDraw_destructor)
    CTextDraw_constructor(obj, ...)
    return obj
end

local SCTextDraw_mt = {
    SetText = ffi.cast('void(__thiscall*)(SCTextDraw*, const char*)', sampapi.GetAddress(0xAC870)),
    Draw = ffi.cast('void(__thiscall*)(SCTextDraw*)', sampapi.GetAddress(0xACD90)),
}
mt.set_handler('struct SCTextDraw', '__index', SCTextDraw_mt)

return {
    new = CTextDraw_new,
}