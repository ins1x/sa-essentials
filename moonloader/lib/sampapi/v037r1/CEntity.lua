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

local CEntity_constructor = ffi.cast('void(__thiscall*)(SCEntity*)', 0x97C10)
local function CEntity_new(...)
    local obj = ffi.new('struct SCEntity[1]')
    CEntity_constructor(obj, ...)
    return obj
end

local SCEntity_mt = {
    -- Add = ...
    -- Remove = ...
    GetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix*)', sampapi.GetAddress(0x9A150)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix)', sampapi.GetAddress(0x9A200)),
    GetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9A320)),
    SetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9A350)),
    GetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9A470)),
    SetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9A4A0)),
    ApplyTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A4D0)),
    GetDistanceFromCentreOfMassToBaseOfModel = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A4F0)),
    GetBoundCentre = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9A530)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCEntity*, int)', sampapi.GetAddress(0x9A590)),
    GetModelIndex = ffi.cast('int(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A670)),
    Teleport = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9A680)),
    GetDistanceToLocalPlayer = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A700)),
    GetDistanceToCamera = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A7D0)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9A8F0)),
    DoesExist = ffi.cast('int(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9AA10)),
    EnforceWorldBoundries = ffi.cast('int(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9AA60)),
    HasExceededWorldBoundries = ffi.cast('int(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9AC00)),
    GetEulerInverted = ffi.cast('void(__thiscall*)(SCEntity*, float*, float*, float*)', sampapi.GetAddress(0x9AF30)),
    IsIgnored = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9B320)),
    IsStationary = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9B420)),
    GetCollisionFlag = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9ACA0)),
    SetCollisionFlag = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9AC70)),
    GetRwObject = ffi.cast('struct RwObject * (__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9B0A0)),
    DeleteRwObject = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9B1F0)),
    UpdateRwFrame = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A2C0)),
    GetDistanceToLocalPlayerNoHeight = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9A830)),
    SetCollisionProcessed = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9ACC0)),
    ApplyTurnForce = ffi.cast('void(__thiscall*)(SCEntity*, SCVector, SCVector)', sampapi.GetAddress(0x9B010)),
    SetFromEuler = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9AE30)),
    SetClumpAlpha = ffi.cast('void(__thiscall*)(SCEntity*, int)', sampapi.GetAddress(0x9ADD0)),
}
mt.set_handler('struct SCEntity', '__index', SCEntity_mt)

return {
    new = CEntity_new,
}