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
typedef struct SCTextDrawSelection SCTextDrawSelection;
#pragma pack(push, 1)
struct SCTextDrawSelection {
    BOOL m_bIsActive;
    D3DCOLOR m_hoveredColor;
    ID m_nHoveredId;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCTextDrawSelection', 0xa)

local SCTextDrawSelection_mt = {
    ResetTextDraws = ffi.cast('void(__thiscall*)(SCTextDrawSelection*)', sampapi.GetAddress(0x70BC0)),
    RawProcess = ffi.cast('void(__thiscall*)(SCTextDrawSelection*)', sampapi.GetAddress(0x70C20)),
    Process = ffi.cast('void(__thiscall*)(SCTextDrawSelection*)', sampapi.GetAddress(0x70D20)),
    Enable = ffi.cast('void(__thiscall*)(SCTextDrawSelection*, D3DCOLOR)', sampapi.GetAddress(0x70D50)),
    SendNotification = ffi.cast('void(__thiscall*)(SCTextDrawSelection*)', sampapi.GetAddress(0x70D90)),
    Disable = ffi.cast('void(__thiscall*)(SCTextDrawSelection*)', sampapi.GetAddress(0x70E30)),
    MsgProc = ffi.cast('BOOL(__thiscall*)(SCTextDrawSelection*, int, int, int)', sampapi.GetAddress(0x70E80)),
}
mt.set_handler('struct SCTextDrawSelection', '__index', SCTextDrawSelection_mt)

local function RefTextDrawSelection() return ffi.cast('SCTextDrawSelection**', sampapi.GetAddress(0x26E8B0))[0] end

return {
    RefTextDrawSelection = RefTextDrawSelection,
}