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
enum {
    MAX_LICENSE_PLATE_TEXT = 32,
};

typedef struct SCVehicle SCVehicle;
#pragma pack(push, 1)
struct SCVehicle : SCEntity {
    SCVehicle* m_pTrailer;
    struct CVehicle* m_pGameVehicle;
    BOOL m_bEngineOn;
    BOOL m_bIsLightsOn;
    BOOL m_bIsInvulnerable;
    int pad_5c;
    BOOL m_bIsLocked;
    bool m_bIsObjective;
    BOOL m_bObjectiveBlipCreated;
    TICK m_timeSinceLastDriven;
    BOOL m_bHasBeenDriven;
    int pad_71;
    BOOL m_bEngineState;
    unsigned char m_nPrimaryColor;
    unsigned char m_nSecondaryColor;
    BOOL m_bNeedsToUpdateColor;
    BOOL m_bUnoccupiedSync;
    BOOL m_bRemoteUnocSync;
    BOOL m_bKeepModelLoaded;
    BOOL m_bHasSiren;
    struct IDirect3DTexture9* m_pLicensePlate;
    char m_szLicensePlateText[33];
    GTAREF m_marker;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCVehicle', 0xb8)

local CVehicle_constructor = ffi.cast('void(__thiscall*)(SCVehicle*, int, SCVector, float, BOOL, BOOL)', 0xB7B30)
local function CVehicle_new(...)
    local obj = ffi.new('struct SCVehicle[1]')
    CVehicle_constructor(obj, ...)
    return obj
end

local SCVehicle_mt = {
    -- Add = ...
    -- Remove = ...
    ChangeInterior = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB6800)),
    ResetPointers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6830)),
    HasDriver = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6850)),
    IsOccupied = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB68A0)),
    SetInvulnerable = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB6900)),
    SetLocked = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB69A0)),
    GetHealth = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6A10)),
    SetHealth = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB6A30)),
    SetColor = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER, NUMBER)', sampapi.GetAddress(0xB6A50)),
    UpdateColor = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6AA0)),
    GetSubtype = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6B00)),
    IsSunk = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6B20)),
    IsWrecked = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6B40)),
    DriverIsPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6B60)),
    HasPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6B90)),
    IsTrainPart = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6BD0)),
    HasTurret = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6C10)),
    EnableSiren = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB6CB0)),
    SirenEnabled = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6CD0)),
    SetLandingGearState = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB6D10)),
    GetLandingGearState = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6DA0)),
    SetHydraThrusters = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB6E10)),
    GetHydraThrusters = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6E30)),
    ProcessMarkers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6E50)),
    Lock = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB6FB0)),
    UpdateLastDrivenTime = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB6FE0)),
    GetTrainSpeed = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7050)),
    SetTrainSpeed = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB7070)),
    SetTires = ffi.cast('void(__thiscall*)(SCVehicle*, char)', sampapi.GetAddress(0xB70B0)),
    GetTires = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB71A0)),
    UpdateDamage = ffi.cast('void(__thiscall*)(SCVehicle*, int, int, char)', sampapi.GetAddress(0xB7230)),
    GetPanelsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB72F0)),
    GetDoorsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7320)),
    GetLightsDamage = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7350)),
    AttachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7380)),
    DetachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB73A0)),
    SetTrailer = ffi.cast('void(__thiscall*)(SCVehicle*, SCVehicle*)', sampapi.GetAddress(0xB73F0)),
    GetTrailer = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7400)),
    GetTractor = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7460)),
    IsTrailer = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB74E0)),
    IsTowtruck = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7540)),
    IsRC = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7570)),
    EnableLights = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB75C0)),
    RemovePassengers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7650)),
    AddComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB7730)),
    RemoveComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB7810)),
    SetPaintjob = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB7850)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB78A0)),
    SetLicensePlateText = ffi.cast('void(__thiscall*)(SCVehicle*, const char*)', sampapi.GetAddress(0xB78B0)),
    SetRotation = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB78D0)),
    ConstructLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7900)),
    ShutdownLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7950)),
    HasSiren = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7A90)),
    GetMaxPassengers = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7AA0)),
    SetWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB7AD0)),
    ClearWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB7B00)),
    EnableEngine = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB81D0)),
}
mt.set_handler('struct SCVehicle', '__index', SCVehicle_mt)

return {
    new = CVehicle_new,
}