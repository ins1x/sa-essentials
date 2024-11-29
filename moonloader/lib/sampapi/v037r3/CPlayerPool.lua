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
shared.require 'v037r3.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r3.CLocalPlayer'
shared.require 'v037r3.CPlayerInfo'
shared.require 'v037r3.CRemotePlayer'
shared.require 'v037r3.CVehicle'
shared.require 'v037r3.Animation'
shared.require 'v037r3.ControllerState'
shared.require 'v037r3.Synchronization'
shared.require 'v037r3.AimStuff'

shared.ffi.cdef[[
enum {
    MAX_PLAYERS = 1004,
};

typedef struct SCPlayerPool SCPlayerPool;
#pragma pack(push, 1)
struct SCPlayerPool {
    int m_nLargestId;
    SCPlayerInfo* m_pObject[1004];
    BOOL m_bNotEmpty[1004];
    BOOL m_bPrevCollisionFlag[1004];
    struct {
        int m_nPing;
        int m_nScore;
        ID m_nId;
        int __align;
        string m_szName;
        SCLocalPlayer* m_pObject;
    } m_localInfo;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerPool', 0x2f3e)

local CPlayerPool_constructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x13BE0)
local CPlayerPool_destructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x13D40)
local function CPlayerPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerPool[1]'), CPlayerPool_destructor)
    CPlayerPool_constructor(obj, ...)
    return obj
end

local SCPlayerPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13400)),
    Process = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13470)),
    Find = ffi.cast('ID(__thiscall*)(SCPlayerPool*, struct CPed*)', sampapi.GetAddress(0x13570)),
    Deactivate = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13790)),
    ForceCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x138C0)),
    RestoreCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13930)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID, int)', sampapi.GetAddress(0x13CB0)),
    Create = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID, const char*, BOOL)', sampapi.GetAddress(0x13E80)),
    GetPlayer = ffi.cast('SCRemotePlayer * (__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10F0)),
    GetLocalPlayerName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0xA170)),
    IsDisconnected = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10D0)),
    IsConnected = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10B0)),
    SetLocalPlayerName = ffi.cast('void(__thiscall*)(SCPlayerPool*, const char*)', sampapi.GetAddress(0xB5C0)),
    SetAt = ffi.cast('void(__thiscall*)(SCPlayerPool*, ID, SCPlayerInfo*)', sampapi.GetAddress(0x133E0)),
    GetScore = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6E0E0)),
    GetPing = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6E110)),
    GetName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x16F00)),
    GetLocalPlayerPing = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6E150)),
    GetLocalPlayerScore = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6E140)),
    GetCount = ffi.cast('int(__thiscall*)(SCPlayerPool*, BOOL)', sampapi.GetAddress(0x13670)),
    GetLocalPlayer = ffi.cast('SCLocalPlayer * (__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x1A30)),
    FindAccessory = ffi.cast('SCObject * (__thiscall*)(SCPlayerPool*, struct CObject*)', sampapi.GetAddress(0x137F0)),
}
mt.set_handler('struct SCPlayerPool', '__index', SCPlayerPool_mt)

local Synchronization = {}

local AimStuff = {}

return {
    new = CPlayerPool_new,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}