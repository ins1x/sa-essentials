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

local CCamera_constructor = ffi.cast('void(__thiscall*)(SCCamera*)', 0x9FF60)
local CCamera_destructor = ffi.cast('void(__thiscall*)(SCCamera*)', 0x9FF70)
local function CCamera_new(...)
    local obj = ffi.gc(ffi.new('struct SCCamera[1]'), CCamera_destructor)
    CCamera_constructor(obj, ...)
    return obj
end

local SCCamera_mt = {
    Fade = ffi.cast('void(__thiscall*)(SCCamera*, BOOL)', sampapi.GetAddress(0x9D440)),
    GetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix*)', sampapi.GetAddress(0x9D460)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCCamera*, SCMatrix)', sampapi.GetAddress(0x9D4E0)),
    TakeControl = ffi.cast('void(__thiscall*)(SCCamera*, struct CEntity*, short, short)', sampapi.GetAddress(0x9D570)),
    SetMoveVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, int, bool)', sampapi.GetAddress(0x9D590)),
    SetTrackVector = ffi.cast('void(__thiscall*)(SCCamera*, SCVector*, SCVector*, int, bool)', sampapi.GetAddress(0x9D600)),
    Attach = ffi.cast('void(__thiscall*)(SCCamera*, SCEntity*)', sampapi.GetAddress(0x9D660)),
    SetToOwner = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9D6B0)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCCamera*, SCVector*)', sampapi.GetAddress(0x9D700)),
    Restore = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9D740)),
    Set = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, SCVector)', sampapi.GetAddress(0x9D780)),
    PointAt = ffi.cast('void(__thiscall*)(SCCamera*, SCVector, int)', sampapi.GetAddress(0x9D7E0)),
    Detach = ffi.cast('void(__thiscall*)(SCCamera*)', sampapi.GetAddress(0x9D830)),
}
mt.set_handler('struct SCCamera', '__index', SCCamera_mt)

return {
    new = CCamera_new,
}