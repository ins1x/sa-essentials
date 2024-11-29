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
shared.require 'v037r1.CRemotePlayer'
shared.require 'v037r1.SpecialAction'
shared.require 'v037r1.ControllerState'
shared.require 'v037r1.Animation'
shared.require 'v037r1.AimStuff'
shared.require 'v037r1.Synchronization'

shared.ffi.cdef[[
typedef struct SCPlayerInfo SCPlayerInfo;
#pragma pack(push, 1)
struct SCPlayerInfo {
    SCRemotePlayer* m_pPlayer;
    BOOL m_bIsNPC;
    unsigned int __align;
    string m_szNick;
    int m_nScore;
    unsigned int m_nPing;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerInfo', 0x2c)

local CPlayerInfo_constructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*, const char*, BOOL)', 0x10CB0)
local CPlayerInfo_destructor = ffi.cast('void(__thiscall*)(SCPlayerInfo*)', 0x10A50)
local function CPlayerInfo_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerInfo[1]'), CPlayerInfo_destructor)
    CPlayerInfo_constructor(obj, ...)
    return obj
end

local AimStuff = {}

local Synchronization = {}

return {
    new = CPlayerInfo_new,
    AimStuff = AimStuff,
    Synchronization = Synchronization,
}