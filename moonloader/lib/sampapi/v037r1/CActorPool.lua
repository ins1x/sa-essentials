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
shared.require 'v037r1.CActor'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
typedef struct SActorInfo SActorInfo;
#pragma pack(push, 1)
struct SActorInfo {
    ID m_nId;
    int m_nModel;
    SCVector m_position;
    float m_fRotation;
    float m_fHealth;
    bool m_bInvulnerable;
};
#pragma pack(pop)

enum {
    MAX_ACTORS = 1000,
};

typedef struct SCActorPool SCActorPool;
#pragma pack(push, 1)
struct SCActorPool {
    int m_nLargestId;
    SCActor* m_pObject[1000];
    BOOL m_bNotEmpty[1000];
    struct CPed* m_pGameObject[1000];
    int pad_2ee4[1000];
    int pad_3e84[1000];
};
#pragma pack(pop)
]]

shared.validate_size('struct SActorInfo', 0x1b)
shared.validate_size('struct SCActorPool', 0x4e24)

local CActorPool_constructor = ffi.cast('void(__thiscall*)(SCActorPool*)', 0x16B0)
local CActorPool_destructor = ffi.cast('void(__thiscall*)(SCActorPool*)', 0x18D0)
local function CActorPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCActorPool[1]'), CActorPool_destructor)
    CActorPool_constructor(obj, ...)
    return obj
end

local SCActorPool_mt = {
    Get = ffi.cast('SCActor * (__thiscall*)(SCActorPool*, ID)', sampapi.GetAddress(0x1600)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCActorPool*, ID)', sampapi.GetAddress(0x1630)),
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCActorPool*)', sampapi.GetAddress(0x1650)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCActorPool*, ID)', sampapi.GetAddress(0x16E0)),
    Create = ffi.cast('BOOL(__thiscall*)(SCActorPool*, const SActorInfo*)', sampapi.GetAddress(0x18F0)),
    Find = ffi.cast('ID(__thiscall*)(SCActorPool*, struct CPed*)', sampapi.GetAddress(0x18A0)),
}
mt.set_handler('struct SCActorPool', '__index', SCActorPool_mt)

return {
    new = CActorPool_new,
}