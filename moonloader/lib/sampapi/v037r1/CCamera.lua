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
typedef struct SCCamera SCCamera;
#pragma pack(push, 1)
struct SCCamera {
    SCEntity* m_pAttachedTo;
    SCMatrix* m_pMatrix;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCCamera', 0x8)

local CCamera_constructor = ffi.cast('void(__thiscall*)(SCCamera*)', 0x9B5A0)
local function CCamera_new(...)
    local obj = ffi.new('struct SCCamera[1]')
    CCamera_constructor(obj, ...)
    return obj
end

local SCCamera_mt = {
    Fade = ffi.cast('void(__thiscall*)(SCCamera*, bool)', sampapi.GetAddress(0x98DE0)),
    GetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix*)', sampapi.GetAddress(0x98E00)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix)', sampapi.GetAddress(0x98E80)),
    TakeControl = ffi.cast('void(__thiscall*)(SCCamera*, struct CEntity*, short, short)', sampapi.GetAddress(0x98F10)),
    SetMoveVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, unsigned int, bool)', sampapi.GetAddress(0x98F30)),
    SetTrackVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, unsigned int, bool)', sampapi.GetAddress(0x98FA0)),
    Attach = ffi.cast('void(__thiscall*)(SCCamera*, SCEntity*)', sampapi.GetAddress(0x99000)),
    SetToOwner = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x99050)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCCamera*, SCVector*)', sampapi.GetAddress(0x990A0)),
    Restore = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x991D0)),
    Set = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, SCVector)', sampapi.GetAddress(0x99120)),
    PointAt = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, int)', sampapi.GetAddress(0x99180)),
    Detach = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x990E0)),
}
mt.set_handler('struct SCCamera', '__index', SCCamera_mt)

return {
    new = CCamera_new,
}