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

shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
typedef struct SCEntity SCEntity;
#pragma pack(push, 1)
struct SCEntity {
    void **m_lpVtbl;
    char pad_4[60];
    struct CEntity* m_pGameEntity;
    GTAREF m_handle;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCEntity', 0x48)

local CEntity_constructor = ffi.cast('void(__thiscall*)(SCEntity*)', 0x9C260)
local function CEntity_new(...)
    local obj = ffi.new('struct SCEntity[1]')
    CEntity_constructor(obj, ...)
    return obj
end

local SCEntity_mt = {
    -- Add = ...
    -- Remove = ...
    GetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix*)', sampapi.GetAddress(0x9EB10)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix)', sampapi.GetAddress(0x9EBC0)),
    GetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9ECE0)),
    SetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9ED10)),
    GetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9EE30)),
    SetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9EE60)),
    ApplyTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EE90)),
    GetDistanceFromCentreOfMassToBaseOfModel = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EEB0)),
    GetBoundCentre = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9EEF0)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCEntity*, int)', sampapi.GetAddress(0x9EF50)),
    GetModelIndex = ffi.cast('int(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F030)),
    Teleport = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9F040)),
    GetDistanceToLocalPlayer = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F0C0)),
    GetDistanceToCamera = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F190)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9F2B0)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F3D0)),
    EnforceWorldBoundries = ffi.cast('BOOL(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9F420)),
    HasExceededWorldBoundries = ffi.cast('BOOL(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9F5C0)),
    GetEulerInverted = ffi.cast('void(__thiscall*)(SCEntity*, float*, float*, float*)', sampapi.GetAddress(0x9F8F0)),
    IsIgnored = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9FCE0)),
    IsStationary = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9FDE0)),
    GetCollisionFlag = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F660)),
    SetCollisionFlag = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9F630)),
    GetRwObject = ffi.cast('struct RwObject * (__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9FA60)),
    DeleteRwObject = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9FBB0)),
    UpdateRwFrame = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EC80)),
    GetDistanceToLocalPlayerNoHeight = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F1F0)),
    SetCollisionProcessed = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9F680)),
}
mt.set_handler('struct SCEntity', '__index', SCEntity_mt)

return {
    new = CEntity_new,
}