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

local CEntity_constructor = ffi.cast('void(__thiscall*)(SCEntity*)', 0x9BB50)
local function CEntity_new(...)
    local obj = ffi.new('struct SCEntity[1]')
    CEntity_constructor(obj, ...)
    return obj
end

local SCEntity_mt = {
    -- Add = ...
    -- Remove = ...
    GetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix*)', sampapi.GetAddress(0x9E400)),
    SetMatrix = ffi.cast('void(__thiscall*)(SCEntity*, SCMatrix)', sampapi.GetAddress(0x9E4B0)),
    GetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9E5D0)),
    SetSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9E600)),
    GetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9E720)),
    SetTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9E750)),
    ApplyTurnSpeed = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9E780)),
    GetDistanceFromCentreOfMassToBaseOfModel = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9E7A0)),
    GetBoundCentre = ffi.cast('void(__thiscall*)(SCEntity*, SCVector*)', sampapi.GetAddress(0x9E7E0)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCEntity*, int)', sampapi.GetAddress(0x9E840)),
    GetModelIndex = ffi.cast('int(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9E920)),
    Teleport = ffi.cast('void(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9E930)),
    GetDistanceToLocalPlayer = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9E9B0)),
    GetDistanceToCamera = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EA80)),
    GetDistanceToPoint = ffi.cast('float(__thiscall*)(SCEntity*, SCVector)', sampapi.GetAddress(0x9EBA0)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9ECC0)),
    EnforceWorldBoundries = ffi.cast('BOOL(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9ED10)),
    HasExceededWorldBoundries = ffi.cast('BOOL(__thiscall*)(SCEntity*, float, float, float, float)', sampapi.GetAddress(0x9EEB0)),
    GetEulerInverted = ffi.cast('void(__thiscall*)(SCEntity*, float*, float*, float*)', sampapi.GetAddress(0x9F1E0)),
    IsIgnored = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F5D0)),
    IsStationary = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F6D0)),
    GetCollisionFlag = ffi.cast('BOOL(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EF50)),
    SetCollisionFlag = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9EF20)),
    GetRwObject = ffi.cast('struct RwObject * (__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F350)),
    DeleteRwObject = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9F4A0)),
    UpdateRwFrame = ffi.cast('void(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9E570)),
    GetDistanceToLocalPlayerNoHeight = ffi.cast('float(__thiscall*)(SCEntity*)', sampapi.GetAddress(0x9EAE0)),
    SetCollisionProcessed = ffi.cast('void(__thiscall*)(SCEntity*, BOOL)', sampapi.GetAddress(0x9EF70)),
}
mt.set_handler('struct SCEntity', '__index', SCEntity_mt)

return {
    new = CEntity_new,
}