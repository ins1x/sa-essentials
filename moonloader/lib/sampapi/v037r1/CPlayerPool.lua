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
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.CLocalPlayer'
shared.require 'v037r1.CPlayerInfo'
shared.require 'v037r1.CRemotePlayer'
shared.require 'v037r1.SpecialAction'
shared.require 'v037r1.ControllerState'
shared.require 'v037r1.Animation'
shared.require 'v037r1.AimStuff'
shared.require 'v037r1.Synchronization'

shared.ffi.cdef[[
enum {
    MAX_PLAYERS = 1004,
};

typedef struct SCPlayerPool SCPlayerPool;
#pragma pack(push, 1)
struct SCPlayerPool {
    int m_nLargestId;
    struct {
        ID m_nId;
        int __align;
        string m_szName;
        SCLocalPlayer* m_pObject;
        int m_nPing;
        int m_nScore;
    } m_localInfo;
    SCPlayerInfo* m_pObject[1004];
    BOOL m_bNotEmpty[1004];
    BOOL m_bPrevCollisionFlag[1004];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerPool', 0x2f3e)

local CPlayerPool_constructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x10AD0)
local CPlayerPool_destructor = ffi.cast('void(__thiscall*)(SCPlayerPool*)', 0x10C20)
local function CPlayerPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerPool[1]'), CPlayerPool_destructor)
    CPlayerPool_constructor(obj, ...)
    return obj
end

local SCPlayerPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x102B0)),
    Process = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x10320)),
    Find = ffi.cast('ID(__thiscall*)(SCPlayerPool*, struct CPed*)', sampapi.GetAddress(0x10420)),
    Deactivate = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x10650)),
    ForceCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x107B0)),
    RestoreCollision = ffi.cast('void(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x10820)),
    Delete = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID, int)', sampapi.GetAddress(0x10B90)),
    Create = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID, const char*, BOOL)', sampapi.GetAddress(0x10D50)),
    GetPlayer = ffi.cast('SCRemotePlayer * (__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10F0)),
    GetLocalPlayerName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x13CD0)),
    -- IsDisconnected = ...
    IsConnected = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10B0)),
    SetLocalPlayerName = ffi.cast('void(__thiscall*)(SCPlayerPool*, const char*)', sampapi.GetAddress(0xB3E0)),
    SetAt = ffi.cast('void(__thiscall*)(SCPlayerPool*, ID, SCPlayerInfo*)', sampapi.GetAddress(0x10290)),
    GetScore = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6A190)),
    GetPing = ffi.cast('int(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x6A1C0)),
    GetName = ffi.cast('const char*(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x13CE0)),
    GetLocalPlayerPing = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6A200)),
    GetLocalPlayerScore = ffi.cast('int(__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x6A1F0)),
    GetCount = ffi.cast('int(__thiscall*)(SCPlayerPool*, BOOL)', sampapi.GetAddress(0x10520)),
    GetLocalPlayer = ffi.cast('SCLocalPlayer * (__thiscall*)(SCPlayerPool*)', sampapi.GetAddress(0x1A30)),
    FindAccessory = ffi.cast('SCObject * (__thiscall*)(SCPlayerPool*, struct CObject*)', sampapi.GetAddress(0x106A0)),
    GetAt = ffi.cast('SCPlayerInfo * (__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0x10D0)),
    IsNPC = ffi.cast('BOOL(__thiscall*)(SCPlayerPool*, ID)', sampapi.GetAddress(0xB680)),
    SetPing = ffi.cast('void(__thiscall*)(SCPlayerPool*, ID, int)', sampapi.GetAddress(0xB705)),
    SetScore = ffi.cast('void(__thiscall*)(SCPlayerPool*, ID, int)', sampapi.GetAddress(0xB6C0)),
}
mt.set_handler('struct SCPlayerPool', '__index', SCPlayerPool_mt)

local AimStuff = {}

local Synchronization = {}

return {
    new = CPlayerPool_new,
    AimStuff = AimStuff,
    Synchronization = Synchronization,
}