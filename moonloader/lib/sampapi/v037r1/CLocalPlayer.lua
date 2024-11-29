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
shared.require 'v037r1.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.ControllerState'
shared.require 'v037r1.Animation'
shared.require 'v037r1.AimStuff'
shared.require 'v037r1.Synchronization'

shared.ffi.cdef[[
enum SSpectatingMode {
    SPECTATING_MODE_VEHICLE = 3,
    SPECTATING_MODE_PLAYER = 4,
    SPECTATING_MODE_FIXED = 15,
    SPECTATING_MODE_SIDE = 14,
};
typedef enum SSpectatingMode SSpectatingMode;

enum SSpectatingType {
    SPEC_TYPE_NONE = 0,
    SPEC_TYPE_PLAYER = 1,
    SPEC_TYPE_VEHICLE = 2,
};
typedef enum SSpectatingType SSpectatingType;

enum SSurfingMode {
    SURF_MODE_NONE = 0,
    SURF_MODE_UNFIXED = 1,
    SURF_MODE_FIXED = 2,
};
typedef enum SSurfingMode SSurfingMode;

typedef struct SSpawnInfo SSpawnInfo;
#pragma pack(push, 1)
struct SSpawnInfo {
    NUMBER m_nTeam;
    int m_nSkin;
    char field_c;
    SCVector m_position;
    float m_fRotation;
    int m_aWeapon[3];
    int m_aAmmo[3];
};
#pragma pack(pop)

typedef struct SCameraTarget SCameraTarget;
#pragma pack(push, 1)
struct SCameraTarget {
    ID m_nObject;
    ID m_nVehicle;
    ID m_nPlayer;
    ID m_nActor;
};
#pragma pack(pop)

typedef struct SCLocalPlayer SCLocalPlayer;
#pragma pack(push, 1)
struct SCLocalPlayer {
    SCPed* m_pPed;
    SAnimation m_animation;
    int field_8;
    BOOL m_bIsActive;
    BOOL m_bIsWasted;
    ID m_nCurrentVehicle;
    ID m_nLastVehicle;
    SOnfootData m_onfootData;
    SPassengerData m_passengerData;
    STrailerData m_trailerData;
    SIncarData m_incarData;
    SAimData m_aimData;
    SSpawnInfo m_spawnInfo;
    BOOL m_bHasSpawnInfo;
    BOOL m_bClearedToSpawn;
    TICK m_lastSelectionTick;
    TICK m_initialSelectionTick;
    BOOL m_bDoesSpectating;
    NUMBER m_nTeam;
    short int field_14b;
    TICK m_lastUpdate;
    TICK m_lastSpecUpdate;
    TICK m_lastAimUpdate;
    TICK m_lastStatsUpdate;
    TICK m_lastWeaponsUpdate;
    struct {
        ID m_nAimedPlayer;
        ID m_nAimedActor;
        NUMBER m_nCurrentWeapon;
        NUMBER m_aLastWeapon[13];
        int m_aLastWeaponAmmo[13];
    } m_weaponsData;
    BOOL m_bPassengerDriveBy;
    char m_nCurrentInterior;
    BOOL m_bInRCMode;
    SCameraTarget m_cameraTarget;
    struct {
        SCVector m_direction;
        TICK m_lastUpdate;
        TICK m_lastLook;
    } m_head;
    TICK m_lastHeadUpdate;
    TICK m_lastAnyUpdate;
    char m_szName[256];
    struct {
        BOOL m_bIsActive;
        SCVector m_position;
        int field_10;
        ID m_nEntityId;
        TICK m_lastUpdate;
        union {
            SCVehicle* m_pVehicle;
            SCObject* m_pObject;
        };
        BOOL m_bStuck;
        int m_nMode;
    } m_surfing;
    struct {
        BOOL m_bEnableAfterDeath;
        int m_nSelected;
        BOOL m_bWaitingForSpawnRequestReply;
        BOOL m_bIsActive;
    } m_classSelection;
    TICK m_zoneDisplayingEnd;
    struct {
        char m_nMode;
        char m_nType;
        int m_nObject;
        BOOL m_bProcessed;
    } m_spectating;
    struct {
        ID m_nVehicleUpdating;
        int m_nBumper;
        int m_nDoor;
        char m_bLight;
        char m_bWheel;
    } m_damage;
};
#pragma pack(pop)
]]

shared.validate_size('struct SSpawnInfo', 0x2e)
shared.validate_size('struct SCameraTarget', 0x8)
shared.validate_size('struct SCLocalPlayer', 0x324)

local AimStuff = {}

local CLocalPlayer_constructor = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', 0x4A50)
local function CLocalPlayer_new(...)
    local obj = ffi.new('struct SCLocalPlayer[1]')
    CLocalPlayer_constructor(obj, ...)
    return obj
end

local function RefTimeElapsedFromFPressed() return ffi.cast('unsigned long*', sampapi.GetAddress(0xEC0A4))[0] end
local function RefIncarSendrate() return ffi.cast('int*', sampapi.GetAddress(0xEC0AC))[0] end
local function RefOnfootSendrate() return ffi.cast('int*', sampapi.GetAddress(0xEC0A8))[0] end
local function RefFiringSendrate() return ffi.cast('int*', sampapi.GetAddress(0xEC0B0))[0] end
local function RefSendMultiplier() return ffi.cast('int*', sampapi.GetAddress(0xEC0B4))[0] end
local function RefDrawCameraTargetLabel() return ffi.cast('bool*', sampapi.GetAddress(0x104908))[0] end
local SendSpawnRequest = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x3A20))

local SCLocalPlayer_mt = {
    GetPed = ffi.cast('SCPed * (__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2D60)),
    ResetData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2E80)),
    ProcessHead = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2F80)),
    SetSpecialAction = ffi.cast('void(__thiscall*)(SCLocalPlayer*, char)', sampapi.GetAddress(0x30C0)),
    GetSpecialAction = ffi.cast('char(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3340)),
    UpdateSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3460)),
    SetSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*, SCVehicle*, BOOL)', sampapi.GetAddress(0x35E0)),
    ProcessSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3600)),
    EndSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0xB630)),
    NeedsToUpdate = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, const void*, const void*, unsigned int)', sampapi.GetAddress(0x3920)),
    GetIncarSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3970)),
    GetOnfootSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x39B0)),
    GetUnoccupiedSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x39F0)),
    SetSpawnInfo = ffi.cast('void(__thiscall*)(SCLocalPlayer*, const SSpawnInfo*)', sampapi.GetAddress(0x3AA0)),
    Spawn = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3AD0)),
    SetColor = ffi.cast('void(__thiscall*)(SCLocalPlayer*, D3DCOLOR)', sampapi.GetAddress(0x3D40)),
    GetColorAsRGBA = ffi.cast('D3DCOLOR(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3D70)),
    GetColorAsARGB = ffi.cast('D3DCOLOR(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3D90)),
    ProcessOnfootWorldBounds = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3DC0)),
    ProcessIncarWorldBounds = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3E20)),
    RequestSpawn = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3EC0)),
    PrepareForClassSelection = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3EE0)),
    PrepareForClassSelection_Outcome = ffi.cast('void(__thiscall*)(SCLocalPlayer*, BOOL)', sampapi.GetAddress(0x3F30)),
    EnableSpectating = ffi.cast('void(__thiscall*)(SCLocalPlayer*, BOOL)', sampapi.GetAddress(0x4000)),
    SpectateForVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x4060)),
    SpectateForPlayer = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x40B0)),
    NeedsToSendOnfootData = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, short, short, short)', sampapi.GetAddress(0x4120)),
    NeedsToSendIncarData = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, short, short, short)', sampapi.GetAddress(0x4150)),
    DefineCameraTarget = ffi.cast('bool(__thiscall*)(SCLocalPlayer*, SCameraTarget*)', sampapi.GetAddress(0x4260)),
    -- UpdateCameraTarget = ...
    DrawCameraTargetLabel = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4670)),
    SendUnoccupiedData = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID, int)', sampapi.GetAddress(0x4B30)),
    SendOnfootData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4D10)),
    SendAimData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4FF0)),
    SendTrailerData = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x51B0)),
    SendPassengerData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5380)),
    WastedNotification = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x55E0)),
    RequestClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int)', sampapi.GetAddress(0x56A0)),
    ChangeInterior = ffi.cast('void(__thiscall*)(SCLocalPlayer*, char)', sampapi.GetAddress(0x5740)),
    Chat = ffi.cast('void(__thiscall*)(SCLocalPlayer*, const char*)', sampapi.GetAddress(0x57F0)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, BOOL)', sampapi.GetAddress(0x58C0)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int)', sampapi.GetAddress(0x59E0)),
    SendStats = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5AF0)),
    UpdateVehicleDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x5BD0)),
    NextClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5DE0)),
    PrevClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5E70)),
    ProcessClassSelection = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5EF0)),
    UpdateWeapons = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6080)),
    ProcessSpectating = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6310)),
    SendTakeDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, float, int, int)', sampapi.GetAddress(0x6660)),
    SendGiveDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, float, int, int)', sampapi.GetAddress(0x6770)),
    ProcessUnoccupiedSync = ffi.cast('bool(__thiscall*)(SCLocalPlayer*, ID, SCVehicle*)', sampapi.GetAddress(0x6BC0)),
    EnterVehicleAsPassenger = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6D90)),
    SendIncarData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6E30)),
    Process = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x7280)),
}
mt.set_handler('struct SCLocalPlayer', '__index', SCLocalPlayer_mt)

local Synchronization = {}

return {
    AimStuff = AimStuff,
    new = CLocalPlayer_new,
    RefTimeElapsedFromFPressed = RefTimeElapsedFromFPressed,
    RefIncarSendrate = RefIncarSendrate,
    RefOnfootSendrate = RefOnfootSendrate,
    RefFiringSendrate = RefFiringSendrate,
    RefSendMultiplier = RefSendMultiplier,
    RefDrawCameraTargetLabel = RefDrawCameraTargetLabel,
    SendSpawnRequest = SendSpawnRequest,
    Synchronization = Synchronization,
}