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

shared.ffi.cdef[[
enum {
    MAX_MENU_ITEMS = 12,
    MAX_COLUMNS = 2,
    MAX_MENU_LINE = 33,
};

typedef struct SInteraction SInteraction;
#pragma pack(push, 1)
struct SInteraction {
    BOOL m_bMenu;
    BOOL m_bRow[12];
    BOOL m_bPadding[3];
};
#pragma pack(pop)

typedef struct SCMenu SCMenu;
#pragma pack(push, 1)
struct SCMenu {
    unsigned char m_nId;
    char m_szTitle[33];
    char m_szItems[12][2][33];
    char m_szHeader[2][33];
    float m_fPosX;
    float m_fPosY;
    float m_fFirstColumnWidth;
    float m_fSecondColumnWidth;
    unsigned char m_nColumns;
    SInteraction m_interaction;
    unsigned char m_nColumnCount[2];
    GTAREF m_panel;
};
#pragma pack(pop)
]]

shared.validate_size('struct SInteraction', 0x40)
shared.validate_size('struct SCMenu', 0x3d3)

local CMenu_constructor = ffi.cast('void(__thiscall*)(SCMenu*, float, float, char, float, float, const SInteraction*)', 0xA7420)
local function CMenu_new(...)
    local obj = ffi.new('struct SCMenu[1]')
    CMenu_constructor(obj, ...)
    return obj
end

local SCMenu_mt = {
    SetTitle = ffi.cast('void(__thiscall*)(SCMenu*, const char*)', sampapi.GetAddress(0xA7530)),
    AddItem = ffi.cast('void(__thiscall*)(SCMenu*, NUMBER, NUMBER, const char*)', sampapi.GetAddress(0xA7580)),
    SetColumnTitle = ffi.cast('void(__thiscall*)(SCMenu*, NUMBER, const char*)', sampapi.GetAddress(0xA7600)),
    Hide = ffi.cast('void(__thiscall*)(SCMenu*)', sampapi.GetAddress(0xA7670)),
    GetItem = ffi.cast('char*(__thiscall*)(SCMenu*, NUMBER, NUMBER)', sampapi.GetAddress(0xA7690)),
    GetTitle = ffi.cast('char*(__thiscall*)(SCMenu*)', sampapi.GetAddress(0xA76B0)),
    MS = ffi.cast('char*(__thiscall*)(SCMenu*, NUMBER, NUMBER)', sampapi.GetAddress(0xA76E0)),
    GetActiveRow = ffi.cast('char(__thiscall*)(SCMenu*)', sampapi.GetAddress(0xA7710)),
    Show = ffi.cast('void(__thiscall*)(SCMenu*)', sampapi.GetAddress(0xA7740)),
}
mt.set_handler('struct SCMenu', '__index', SCMenu_mt)

return {
    new = CMenu_new,
}