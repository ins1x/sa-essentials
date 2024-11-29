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
shared.require 'v037r5.CRemotePlayer'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.Animation'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.Synchronization'
shared.require 'v037r5.AimStuff'

shared.ffi.cdef[[
typedef struct SCPlayerInfo SCPlayerInfo;
#pragma pack(push, 1)
struct SCPlayerInfo {
    int pad_0;
    int m_nScore;
    BOOL m_bIsNPC;
    int m_nPing;
    SCRemotePlayer* m_pPlayer;
    int __aling;
    string m_szNick;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerInfo', 0x30)

local CPlayerInfo_constructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*, const char*, BOOL)', 0x141B0)
local CPlayerInfo_destructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*)', 0x13F60)
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