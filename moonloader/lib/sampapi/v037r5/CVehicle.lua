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

local CVehicle_constructor = ffi.cast('void(__thiscall*)(SCVehicle*, int, SCVector, float, BOOL, BOOL)', 0xB83D0)
local function CVehicle_new(...)
    local obj = ffi.new('struct SCVehicle[1]')
    CVehicle_constructor(obj, ...)
    return obj
end

local SCVehicle_mt = {
    -- Add = ...
    -- Remove = ...
    ChangeInterior = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB7090)),
    ResetPointers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB70C0)),
    HasDriver = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB70E0)),
    IsOccupied = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7130)),
    SetInvulnerable = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB7190)),
    SetLocked = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB7230)),
    GetHealth = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB72A0)),
    SetHealth = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB72C0)),
    SetColor = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER, NUMBER)', sampapi.GetAddress(0xB72E0)),
    UpdateColor = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7330)),
    GetSubtype = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7390)),
    IsSunk = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB73B0)),
    IsWrecked = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB73D0)),
    DriverIsPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB73F0)),
    HasPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7420)),
    IsTrainPart = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7460)),
    HasTurret = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB74A0)),
    EnableSiren = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB7540)),
    SirenEnabled = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7560)),
    SetLandingGearState = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB75A0)),
    GetLandingGearState = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7630)),
    SetHydraThrusters = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB76A0)),
    GetHydraThrusters = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB76C0)),
    ProcessMarkers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB76E0)),
    Lock = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB7840)),
    UpdateLastDrivenTime = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7870)),
    GetTrainSpeed = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB78E0)),
    SetTrainSpeed = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB7900)),
    SetTires = ffi.cast('void(__thiscall*)(SCVehicle*, char)', sampapi.GetAddress(0xB7940)),
    GetTires = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7A30)),
    UpdateDamage = ffi.cast('void(__thiscall*)(SCVehicle*, int, int, char)', sampapi.GetAddress(0xB7AC0)),
    GetPanelsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7B80)),
    GetDoorsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7BB0)),
    GetLightsDamage = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7BE0)),
    AttachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7C10)),
    DetachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7C30)),
    SetTrailer = ffi.cast('void(__thiscall*)(SCVehicle*, SCVehicle*)', sampapi.GetAddress(0xB7C80)),
    GetTrailer = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7C90)),
    GetTractor = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7CF0)),
    IsTrailer = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7D70)),
    IsTowtruck = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7DD0)),
    IsRC = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7E00)),
    EnableLights = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB7E50)),
    RemovePassengers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB7EE0)),
    AddComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB7FC0)),
    RemoveComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB80B0)),
    SetPaintjob = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB80F0)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB8140)),
    SetLicensePlateText = ffi.cast('void(__thiscall*)(SCVehicle*, const char*)', sampapi.GetAddress(0xB8150)),
    SetRotation = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB8170)),
    ConstructLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB81A0)),
    ShutdownLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB81F0)),
    HasSiren = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB8330)),
    GetMaxPassengers = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB8340)),
    SetWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB8370)),
    ClearWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB83A0)),
    EnableEngine = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB8A70)),
}
mt.set_handler('struct SCVehicle', '__index', SCVehicle_mt)

return {
    new = CVehicle_new,
}