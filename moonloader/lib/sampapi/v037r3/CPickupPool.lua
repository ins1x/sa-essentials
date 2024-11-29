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
typedef struct SPickup SPickup;
#pragma pack(push, 1)
struct SPickup {
    int m_nModel;
    int m_nType;
    SCVector m_position;
};
#pragma pack(pop)

typedef struct SWeaponPickup SWeaponPickup;
#pragma pack(push, 1)
struct SWeaponPickup {
    bool m_bExists;
    ID m_nExOwner;
};
#pragma pack(pop)

enum {
    MAX_PICKUPS = 4096,
};

typedef struct SCPickupPool SCPickupPool;
#pragma pack(push, 1)
struct SCPickupPool {
    int m_nCount;
    GTAREF m_handle[4096];
    int m_nId[4096];
    long unsigned int m_nTimer[4096];
    SWeaponPickup m_weapon[4096];
    SPickup m_object[4096];
};
#pragma pack(pop)
]]

shared.validate_size('struct SPickup', 0x14)
shared.validate_size('struct SWeaponPickup', 0x3)
shared.validate_size('struct SCPickupPool', 0x23004)

local CPickupPool_constructor = ffi.cast('void(__thiscall*)(SCPickupPool*)', 0x8130)
local CPickupPool_destructor = ffi.cast('void(__thiscall*)(SCPickupPool*)', 0x130C0)
local function CPickupPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCPickupPool[1]'), CPickupPool_destructor)
    CPickupPool_constructor(obj, ...)
    return obj
end

local SCPickupPool_mt = {
    Create = ffi.cast('void(__thiscall*)(SCPickupPool*, SPickup*, int)', sampapi.GetAddress(0x12F20)),
    CreateWeapon = ffi.cast('void(__thiscall*)(SCPickupPool*, int, SCVector, int, ID)', sampapi.GetAddress(0x12E30)),
    Delete = ffi.cast('void(__thiscall*)(SCPickupPool*, int)', sampapi.GetAddress(0x12FD0)),
    DeleteWeapon = ffi.cast('void(__thiscall*)(SCPickupPool*, ID)', sampapi.GetAddress(0x13030)),
    GetIndex = ffi.cast('int(__thiscall*)(SCPickupPool*, int)', sampapi.GetAddress(0x13090)),
    SendNotification = ffi.cast('void(__thiscall*)(SCPickupPool*, int)', sampapi.GetAddress(0x130F0)),
    Process = ffi.cast('void(__thiscall*)(SCPickupPool*)', sampapi.GetAddress(0x131D0)),
}
mt.set_handler('struct SCPickupPool', '__index', SCPickupPool_mt)

return {
    new = CPickupPool_new,
}