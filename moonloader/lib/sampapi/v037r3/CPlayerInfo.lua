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
shared.require 'v037r3.CRemotePlayer'
shared.require 'v037r3.CVehicle'
shared.require 'v037r3.Animation'
shared.require 'v037r3.ControllerState'
shared.require 'v037r3.Synchronization'
shared.require 'v037r3.AimStuff'

shared.ffi.cdef[[
typedef struct SCPlayerInfo SCPlayerInfo;
#pragma pack(push, 1)
struct SCPlayerInfo {
    SCRemotePlayer* m_pPlayer;
    int m_nPing;
    int __aling;
    string m_szNick;
    int m_nScore;
    BOOL m_bIsNPC;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerInfo', 0x2c)

local CPlayerInfo_constructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*, const char*, BOOL)', 0x13DE0)
local CPlayerInfo_destructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*)', 0x13B60)
local function CPlayerInfo_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerInfo[1]'), CPlayerInfo_destructor)
    CPlayerInfo_constructor(obj, ...)
    return obj
end

local Synchronization = {}

local AimStuff = {}

return {
    new = CPlayerInfo_new,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}