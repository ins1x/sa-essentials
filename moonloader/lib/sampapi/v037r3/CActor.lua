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

shared.require 'v037r3.CEntity'
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

local CActor_constructor = ffi.cast('void(__thiscall*)(SCActor*, int, SCVector, float)', 0x9BBA0)
local function CActor_new(...)
    local obj = ffi.new('struct SCActor[1]')
    CActor_constructor(obj, ...)
    return obj
end

local SCActor_mt = {
    Destroy = ffi.cast('void(__thiscall*)(SCActor*)', sampapi.GetAddress(0x9BCF0)),
    PerformAnimation = ffi.cast('void(__thiscall*)(SCActor*, const char*, const char*, float, int, int, int, int, int)', sampapi.GetAddress(0x9BD50)),
    SetRotation = ffi.cast('void(__thiscall*)(SCActor*, float)', sampapi.GetAddress(0x9BE60)),
    GetHealth = ffi.cast('float(__thiscall*)(SCActor*)', sampapi.GetAddress(0x9BEA0)),
    SetHealth = ffi.cast('void(__thiscall*)(SCActor*, float)', sampapi.GetAddress(0x9BEC0)),
    SetInvulnerable = ffi.cast('void(__thiscall*)(SCActor*, bool)', sampapi.GetAddress(0x9BFF0)),
}
mt.set_handler('struct SCActor', '__index', SCActor_mt)

return {
    new = CActor_new,
}