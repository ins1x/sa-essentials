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

local CVehicle_constructor = ffi.cast('void(__thiscall*)(SCVehicle*, int, SCVector, float, BOOL, BOOL)', 0xB1E70)
local function CVehicle_new(...)
    local obj = ffi.new('struct SCVehicle[1]')
    CVehicle_constructor(obj, ...)
    return obj
end

local SCVehicle_mt = {
    -- Add = ...
    -- Remove = ...
    ChangeInterior = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB0B40)),
    ResetPointers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0B70)),
    HasDriver = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0B90)),
    IsOccupied = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0BE0)),
    SetInvulnerable = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB0C40)),
    SetLocked = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB0CE0)),
    GetHealth = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0D50)),
    SetHealth = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB0D70)),
    SetColor = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER, NUMBER)', sampapi.GetAddress(0xB0D90)),
    UpdateColor = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0DE0)),
    GetSubtype = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0E40)),
    IsSunk = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0E60)),
    IsWrecked = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0E80)),
    DriverIsPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0EA0)),
    HasPlayerPed = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0ED0)),
    IsTrainPart = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0F10)),
    HasTurret = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB0F50)),
    EnableSiren = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB0FF0)),
    SirenEnabled = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1010)),
    SetLandingGearState = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB1050)),
    GetLandingGearState = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB10E0)),
    SetHydraThrusters = ffi.cast('void(__thiscall*)(SCVehicle*, int)', sampapi.GetAddress(0xB1150)),
    GetHydraThrusters = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1170)),
    ProcessMarkers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1190)),
    Lock = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB12F0)),
    UpdateLastDrivenTime = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1320)),
    GetTrainSpeed = ffi.cast('float(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1390)),
    SetTrainSpeed = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB13B0)),
    SetTires = ffi.cast('void(__thiscall*)(SCVehicle*, char)', sampapi.GetAddress(0xB13F0)),
    GetTires = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB14E0)),
    UpdateDamage = ffi.cast('void(__thiscall*)(SCVehicle*, int, int, char)', sampapi.GetAddress(0xB1570)),
    GetPanelsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1630)),
    GetDoorsDamage = ffi.cast('int(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1660)),
    GetLightsDamage = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1690)),
    AttachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB16C0)),
    DetachTrailer = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB16E0)),
    SetTrailer = ffi.cast('void(__thiscall*)(SCVehicle*, SCVehicle*)', sampapi.GetAddress(0xB1730)),
    GetTrailer = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1740)),
    GetTractor = ffi.cast('SCVehicle * (__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB17A0)),
    IsTrailer = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1820)),
    IsTowtruck = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1880)),
    IsRC = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB18B0)),
    EnableLights = ffi.cast('void(__thiscall*)(SCVehicle*, bool)', sampapi.GetAddress(0xB1900)),
    RemovePassengers = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1990)),
    AddComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB1A70)),
    RemoveComponent = ffi.cast('BOOL(__thiscall*)(SCVehicle*, unsigned short)', sampapi.GetAddress(0xB1B50)),
    SetPaintjob = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB1B90)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1BE0)),
    SetLicensePlateText = ffi.cast('void(__thiscall*)(SCVehicle*, const char*)', sampapi.GetAddress(0xB1BF0)),
    SetRotation = ffi.cast('void(__thiscall*)(SCVehicle*, float)', sampapi.GetAddress(0xB1C10)),
    ConstructLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1C40)),
    ShutdownLicensePlate = ffi.cast('void(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1C90)),
    HasSiren = ffi.cast('BOOL(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1DD0)),
    GetMaxPassengers = ffi.cast('char(__thiscall*)(SCVehicle*)', sampapi.GetAddress(0xB1DE0)),
    SetWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB1E10)),
    ClearWindowOpenFlag = ffi.cast('void(__thiscall*)(SCVehicle*, NUMBER)', sampapi.GetAddress(0xB1E40)),
    EnableEngine = ffi.cast('void(__thiscall*)(SCVehicle*, BOOL)', sampapi.GetAddress(0xB2510)),
}
mt.set_handler('struct SCVehicle', '__index', SCVehicle_mt)

return {
    new = CVehicle_new,
}