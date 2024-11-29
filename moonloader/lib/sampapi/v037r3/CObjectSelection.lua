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
typedef struct SCObjectSelection SCObjectSelection;
#pragma pack(push, 1)
struct SCObjectSelection {
    BOOL m_bIsActive;
    ID m_nHoveredObject;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCObjectSelection', 0x6)

local CObjectSelection_constructor = ffi.cast('void(__thiscall*)(SCObjectSelection*)', 0x6D290)
local function CObjectSelection_new(...)
    local obj = ffi.new('struct SCObjectSelection[1]')
    CObjectSelection_constructor(obj, ...)
    return obj
end

local SCObjectSelection_mt = {
    DefineObject = ffi.cast('ID(__thiscall*)(SCObjectSelection*)', sampapi.GetAddress(0x6D2A0)),
    DrawLabels = ffi.cast('void(__thiscall*)(SCObjectSelection*)', sampapi.GetAddress(0x6D2F0)),
    Enable = ffi.cast('void(__thiscall*)(SCObjectSelection*, BOOL)', sampapi.GetAddress(0x6D410)),
    Draw = ffi.cast('void(__thiscall*)(SCObjectSelection*)', sampapi.GetAddress(0x6D490)),
    SendNotification = ffi.cast('void(__thiscall*)(SCObjectSelection*)', sampapi.GetAddress(0x6D560)),
    MsgProc = ffi.cast('BOOL(__thiscall*)(SCObjectSelection*, int, int, int)', sampapi.GetAddress(0x6D6D0)),
}
mt.set_handler('struct SCObjectSelection', '__index', SCObjectSelection_mt)

local function RefObjectSelection() return ffi.cast('SCObjectSelection**', sampapi.GetAddress(0x26E8AC))[0] end

return {
    new = CObjectSelection_new,
    RefObjectSelection = RefObjectSelection,
}