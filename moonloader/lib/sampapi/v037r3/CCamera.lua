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
typedef struct SCCamera SCCamera;
#pragma pack(push, 1)
struct SCCamera {
    SCEntity* m_pAttachedTo;
    SCMatrix* m_pMatrix;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCCamera', 0x8)

local CCamera_constructor = ffi.cast('void(__thiscall*)(SCCamera*)', 0x9F850)
local CCamera_destructor = ffi.cast('void(__thiscall*)(SCCamera*)', 0x9F860)
local function CCamera_new(...)
    local obj = ffi.gc(ffi.new('struct SCCamera[1]'), CCamera_destructor)
    CCamera_constructor(obj, ...)
    return obj
end

local SCCamera_mt = {
    Fade = ffi.cast('void(__thiscall*)(SCCamera*, BOOL)', sampapi.GetAddress(0x9CD30)),
    GetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix*)', sampapi.GetAddress(0x9CD50)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix)', sampapi.GetAddress(0x9CDD0)),
    TakeControl = ffi.cast('void(__thiscall*)(SCCamera*, struct CEntity*, short, short)', sampapi.GetAddress(0x9CE60)),
    SetMoveVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, int, bool)', sampapi.GetAddress(0x9CE80)),
    SetTrackVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, int, bool)', sampapi.GetAddress(0x9CEF0)),
    Attach = ffi.cast('void(__thiscall*)(SCCamera*, SCEntity*)', sampapi.GetAddress(0x9CF50)),
    SetToOwner = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9CFA0)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCCamera*, SCVector*)', sampapi.GetAddress(0x9CFF0)),
    Restore = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9D030)),
    Set = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, SCVector)', sampapi.GetAddress(0x9D070)),
    PointAt = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, int)', sampapi.GetAddress(0x9D0D0)),
    Detach = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9D120)),
}
mt.set_handler('struct SCCamera', '__index', SCCamera_mt)

return {
    new = CCamera_new,
}