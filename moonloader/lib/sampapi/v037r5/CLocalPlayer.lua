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
shared.require 'v037r5.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.Animation'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.Synchronization'
shared.require 'v037r5.AimStuff'

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
    SURFING_MODE_NONE = 0,
    SURFING_MODE_UNFIXED = 1,
    SURFING_MODE_FIXED = 2,
};
typedef enum SSurfingMode SSurfingMode;

typedef struct SCameraTarget SCameraTarget;
#pragma pack(push, 1)
struct SCameraTarget {
    ID m_nObject;
    ID m_nVehicle;
    ID m_nPlayer;
    ID m_nActor;
};
#pragma pack(pop)

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

typedef struct SCLocalPlayer SCLocalPlayer;
#pragma pack(push, 1)
struct SCLocalPlayer {
    SIncarData m_incarData;
    SAimData m_aimData;
    STrailerData m_trailerData;
    SOnfootData m_onfootData;
    SPassengerData m_passengerData;
    BOOL m_bIsActive;
    BOOL m_bIsWasted;
    ID m_nCurrentVehicle;
    ID m_nLastVehicle;
    SAnimation m_animation;
    int field_100;
    SCPed* m_pPed;
    BOOL m_bDoesSpectating;
    NUMBER m_nTeam;
    short int field_10d;
    TICK m_lastUpdate;
    TICK m_lastSpecUpdate;
    TICK m_lastAimUpdate;
    TICK m_lastStatsUpdate;
    SCameraTarget m_cameraTarget;
    TICK m_lastCameraTargetUpdate;
    struct {
        SCVector m_direction;
        TICK m_lastUpdate;
        TICK m_lastLook;
    } m_head;
    TICK m_lastAnyUpdate;
    BOOL m_bClearedToSpawn;
    TICK m_lastSelectionTick;
    TICK m_initialSelectionTick;
    SSpawnInfo m_spawnInfo;
    BOOL m_bHasSpawnInfo;
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
    char m_szName[256];
    struct {
        ID m_nEntityId;
        TICK m_lastUpdate;
        union {
            SCVehicle* m_pVehicle;
            SCObject* m_pObject;
        };
        BOOL m_bStuck;
        BOOL m_bIsActive;
        SCVector m_position;
        int field_;
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
        bool m_bLight;
        bool m_bWheel;
    } m_damage;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCameraTarget', 0x8)
shared.validate_size('struct SSpawnInfo', 0x2e)
shared.validate_size('struct SCLocalPlayer', 0x324)

local CLocalPlayer_constructor = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', 0x4C50)
local function CLocalPlayer_new(...)
    local obj = ffi.new('struct SCLocalPlayer[1]')
    CLocalPlayer_constructor(obj, ...)
    return obj
end

local function RefIncarSendrate() return ffi.cast('int*', sampapi.GetAddress(0xFE0AC))[0] end
local function RefOnfootSendrate() return ffi.cast('int*', sampapi.GetAddress(0xFE0A8))[0] end
local function RefFiringSendrate() return ffi.cast('int*', sampapi.GetAddress(0xFE0B0))[0] end
local function RefSendMultiplier() return ffi.cast('int*', sampapi.GetAddress(0xFE0B4))[0] end

local SCLocalPlayer_mt = {
    GetPed = ffi.cast('SCPed * (__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2D70)),
    ResetData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2E90)),
    ProcessHead = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x2FA0)),
    SetSpecialAction = ffi.cast('void(__thiscall*)(SCLocalPlayer*, char)', sampapi.GetAddress(0x30F0)),
    GetSpecialAction = ffi.cast('char(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3410)),
    UpdateSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3570)),
    SetSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*, SCVehicle*, BOOL)', sampapi.GetAddress(0x3710)),
    ProcessSurfing = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3730)),
    NeedsToUpdate = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, const void*, const void*, unsigned int)', sampapi.GetAddress(0x3A60)),
    GetIncarSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3AB0)),
    GetOnfootSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3AF0)),
    GetUnoccupiedSendRate = ffi.cast('int(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3B30)),
    SetSpawnInfo = ffi.cast('void(__thiscall*)(SCLocalPlayer*, const SSpawnInfo*)', sampapi.GetAddress(0x3BE0)),
    Spawn = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3C20)),
    SetColor = ffi.cast('void(__thiscall*)(SCLocalPlayer*, D3DCOLOR)', sampapi.GetAddress(0x3ED0)),
    GetColorAsRGBA = ffi.cast('D3DCOLOR(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3F00)),
    GetColorAsARGB = ffi.cast('D3DCOLOR(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3F20)),
    ProcessOnfootWorldBounds = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3F50)),
    ProcessIncarWorldBounds = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x3FC0)),
    RequestSpawn = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4060)),
    PrepareForClassSelection = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4080)),
    PrepareForClassSelection_Outcome = ffi.cast('void(__thiscall*)(SCLocalPlayer*, BOOL)', sampapi.GetAddress(0x40E0)),
    EnableSpectating = ffi.cast('void(__thiscall*)(SCLocalPlayer*, BOOL)', sampapi.GetAddress(0x41C0)),
    SpectateForVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x4230)),
    SpectateForPlayer = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x4280)),
    NeedsToSendOnfootData = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, short, short, short)', sampapi.GetAddress(0x4300)),
    NeedsToSendIncarData = ffi.cast('BOOL(__thiscall*)(SCLocalPlayer*, short, short, short)', sampapi.GetAddress(0x4340)),
    DefineCameraTarget = ffi.cast('bool(__thiscall*)(SCLocalPlayer*, SCameraTarget*)', sampapi.GetAddress(0x4440)),
    UpdateCameraTarget = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4700)),
    DrawCameraTargetLabel = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4850)),
    SendUnoccupiedData = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID, char)', sampapi.GetAddress(0x4D30)),
    SendOnfootData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x4F00)),
    SendAimData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5210)),
    SendTrailerData = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x53D0)),
    SendPassengerData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5590)),
    WastedNotification = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5810)),
    RequestClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int)', sampapi.GetAddress(0x58D0)),
    ChangeInterior = ffi.cast('void(__thiscall*)(SCLocalPlayer*, char)', sampapi.GetAddress(0x5970)),
    Chat = ffi.cast('void(__thiscall*)(SCLocalPlayer*, const char*)', sampapi.GetAddress(0x5A10)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, BOOL)', sampapi.GetAddress(0x5AD0)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int)', sampapi.GetAddress(0x5BF0)),
    SendStats = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5D00)),
    UpdateVehicleDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, ID)', sampapi.GetAddress(0x5DE0)),
    NextClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x5FF0)),
    PrevClass = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6080)),
    ProcessClassSelection = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6100)),
    UpdateWeapons = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6290)),
    ProcessSpectating = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6540)),
    SendTakeDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, float, int, int)', sampapi.GetAddress(0x68A0)),
    SendGiveDamage = ffi.cast('void(__thiscall*)(SCLocalPlayer*, int, float, int, int)', sampapi.GetAddress(0x69B0)),
    ProcessUnoccupiedSync = ffi.cast('bool(__thiscall*)(SCLocalPlayer*, ID, SCVehicle*)', sampapi.GetAddress(0x6E00)),
    EnterVehicleAsPassenger = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x6FE0)),
    SendIncarData = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x7080)),
    Process = ffi.cast('void(__thiscall*)(SCLocalPlayer*)', sampapi.GetAddress(0x74C0)),
}
mt.set_handler('struct SCLocalPlayer', '__index', SCLocalPlayer_mt)

local Synchronization = {}

local AimStuff = {}

return {
    new = CLocalPlayer_new,
    RefIncarSendrate = RefIncarSendrate,
    RefOnfootSendrate = RefOnfootSendrate,
    RefFiringSendrate = RefFiringSendrate,
    RefSendMultiplier = RefSendMultiplier,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}