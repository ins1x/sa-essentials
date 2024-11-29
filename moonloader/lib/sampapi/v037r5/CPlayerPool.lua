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

shared.require 'v037r5.CEntity'
shared.require 'v037r5.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.CLocalPlayer'
shared.require 'v037r5.CPlayerInfo'
shared.require 'v037r5.CRemotePlayer'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.Animation'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.Synchronization'
shared.require 'v037r5.AimStuff'

shared.ffi.cdef[[
enum {
    MAX_PLAYERS = 1004,
};

typedef struct SCPlayerPool SCPlayerPool;
#pragma pack(push, 1)
struct SCPlayerPool {
    struct {
        int m_nScore;
        ID m_nId;
        int __align;
        string m_szName;
        int m_nPing;
        SCLocalPlayer* m_pObject;
    } m_localInfo;
    BOOL m_bNotEmpty[1004];
    BOOL m_bPrevCollisionFlag[1004];
    SCPlayerInfo* m_pObject[1004];
    int m_nLargestId;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerPool', 0x2f3e)

local CPlayerPool_constructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x13FD0)
local CPlayerPool_destructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x14120)
local function CPlayerPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerPool[1]'), CPlayerPool_destructor)
    CPlayerPool_constructor(obj, ...)
    return obj
end

local SCPlayerPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13750)),
    Process = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x137C0)),
    Find = ffi.cast('ID(__thiscall*)(SCPlayerPool*, struct CPed*)', sampapi.GetAddress(0x138C0)),
    Deactivate = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13B10)),
    ForceCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13C90)),
    RestoreCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13D10)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID, int)', sampapi.GetAddress(0x14090)),
    Create = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID, const char*, BOOL)', sampapi.GetAddress(0x14250)),
    GetPlayer = ffi.cast('SCRemotePlayer * (__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10F0)),
    GetLocalPlayerName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0xA4E0)),
    IsDisconnected = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10D0)),
    IsConnected = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10B0)),
    SetLocalPlayerName = ffi.cast('void(__thiscall*)(SCPlayerPool*, const char*)', sampapi.GetAddress(0xB8A0)),
    SetAt = ffi.cast('void(__thiscall*)(SCPlayerPool*, ID, SCPlayerInfo*)', sampapi.GetAddress(0x13730)),
    GetScore = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6E850)),
    GetPing = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6E880)),
    GetName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x175C0)),
    GetLocalPlayerPing = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6E8C0)),
    GetLocalPlayerScore = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6E8B0)),
    GetCount = ffi.cast('int(__thiscall*)(SCPlayerPool*, BOOL)', sampapi.GetAddress(0x139F0)),
    GetLocalPlayer = ffi.cast('SCLocalPlayer * (__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x1A40)),
    FindAccessory = ffi.cast('SCObject * (__thiscall*)(SCPlayerPool*, struct CObject*)', sampapi.GetAddress(0x13B70)),
}
mt.set_handler('struct SCPlayerPool', '__index', SCPlayerPool_mt)

local Synchronization = {}

local AimStuff = {}

return {
    new = CPlayerPool_new,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}