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

shared.require 'v037r1.CEntity'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
typedef struct SCActor SCActor;
#pragma pack(push, 1)
struct SCActor : SCEntity {
    struct CPed* m_pGamePed;
    GTAREF m_marker;
    GTAREF m_arrow;
    bool m_bNeedsToCreateMarker;
    bool m_bInvulnerable;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCActor', 0x56)

local CActor_constructor = ffi.cast('void(__thiscall*)(SCActor*, int, SCVector, float)', 0x97C60)
local function CActor_new(...)
    local obj = ffi.new('struct SCActor[1]')
    CActor_constructor(obj, ...)
    return obj
end

local SCActor_mt = {
    Destroy = ffi.cast('void(__thiscall*)(SCActor*)', sampapi.GetAddress(0x97DA0)),
    PerformAnimation = ffi.cast('void(__thiscall*)(SCActor*, const char*, const char*, float, int, int, int, int, int)', sampapi.GetAddress(0x97E00)),
    SetRotation = ffi.cast('void(__thiscall*)(SCActor*, float)', sampapi.GetAddress(0x97F10)),
    SetHealth = ffi.cast('void(__thiscall*)(SCActor*, float)', sampapi.GetAddress(0x97F70)),
    GetHealth = ffi.cast('float(__thiscall*)(SCActor*)', sampapi.GetAddress(0x97F50)),
    SetInvulnerable = ffi.cast('void(__thiscall*)(SCActor*, bool)', sampapi.GetAddress(0x980A0)),
    SetArmour = ffi.cast('void(__thiscall*)(SCActor*, float)', sampapi.GetAddress(0x97FD0)),
    GetArmour = ffi.cast('float(__thiscall*)(SCActor*)', sampapi.GetAddress(0x97FB0)),
    SetState = ffi.cast('void(__thiscall*)(SCActor*, int)', sampapi.GetAddress(0x98000)),
    GetState = ffi.cast('int(__thiscall*)(SCActor*)', sampapi.GetAddress(0x97FF0)),
    IsDead = ffi.cast('BOOL(__thiscall*)(SCActor*)', sampapi.GetAddress(0x98020)),
    SetStatus = ffi.cast('void(__thiscall*)(SCActor*, int)', sampapi.GetAddress(0x98060)),
    GetStatus = ffi.cast('int(__thiscall*)(SCActor*)', sampapi.GetAddress(0x98050)),
}
mt.set_handler('struct SCActor', '__index', SCActor_mt)

return {
    new = CActor_new,
}