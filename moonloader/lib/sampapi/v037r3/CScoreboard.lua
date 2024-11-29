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
typedef struct SCScoreboard SCScoreboard;
#pragma pack(push, 1)
struct SCScoreboard {
    BOOL m_bIsEnabled;
    int m_nPlayerCount;
    float m_position[2];
    float m_fScalar;
    float m_size[2];
    float pad_[5];
    struct IDirect3DDevice9* m_pDevice;
    struct CDXUTDialog* m_pDialog;
    struct CDXUTListBox* m_pListbox;
    int m_nCurrentOffset;
    BOOL m_bIsSorted;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCScoreboard', 0x44)

local CScoreboard_constructor = ffi.cast('void(__thiscall*)(SCScoreboard*, IDirect3DDevice9*)', 0x6E2C0)
local function CScoreboard_new(...)
    local obj = ffi.new('struct SCScoreboard[1]')
    CScoreboard_constructor(obj, ...)
    return obj
end

local SCScoreboard_mt = {
    Recalc = ffi.cast('void(__thiscall*)(SCScoreboard*)', sampapi.GetAddress(0x6E1C0)),
    GetRect = ffi.cast('void(__thiscall*)(SCScoreboard*, SCRect*)', sampapi.GetAddress(0x6E220)),
    Close = ffi.cast('void(__thiscall*)(SCScoreboard*, bool)', sampapi.GetAddress(0x6E270)),
    ResetDialogControls = ffi.cast('void(__thiscall*)(SCScoreboard*, CDXUTDialog*)', sampapi.GetAddress(0x6E340)),
    SendNotification = ffi.cast('void(__thiscall*)(SCScoreboard*)', sampapi.GetAddress(0x6E4A0)),
    UpdateList = ffi.cast('void(__thiscall*)(SCScoreboard*)', sampapi.GetAddress(0x6E5C0)),
    Draw = ffi.cast('void(__thiscall*)(SCScoreboard*)', sampapi.GetAddress(0x6E960)),
    Enable = ffi.cast('void(__thiscall*)(SCScoreboard*)', sampapi.GetAddress(0x6EC80)),
}
mt.set_handler('struct SCScoreboard', '__index', SCScoreboard_mt)

local function RefScoreboard() return ffi.cast('SCScoreboard**', sampapi.GetAddress(0x26E894))[0] end

return {
    new = CScoreboard_new,
    RefScoreboard = RefScoreboard,
}