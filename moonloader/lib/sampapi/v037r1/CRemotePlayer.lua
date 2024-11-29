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
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.SpecialAction'
shared.require 'v037r1.ControllerState'
shared.require 'v037r1.Animation'
shared.require 'v037r1.AimStuff'
shared.require 'v037r1.Synchronization'

shared.ffi.cdef[[
enum SPlayerState {
    PLAYER_STATE_NONE = 0,
    PLAYER_STATE_ONFOOT = 17,
    PLAYER_STATE_DRIVER = 19,
    PLAYER_STATE_PASSENGER = 18,
    PLAYER_STATE_WASTED = 32,
    PLAYER_STATE_SPAWNED = 33,
};
typedef enum SPlayerState SPlayerState;

enum SUpdateType {
    UPDATE_TYPE_NONE = 0,
    UPDATE_TYPE_ONFOOT = 16,
    UPDATE_TYPE_DRIVER = 17,
    UPDATE_TYPE_PASSENGER = 18,
};
typedef enum SUpdateType SUpdateType;

enum SPlayerStatus {
    PLAYER_STATUS_TIMEOUT = 2,
};
typedef enum SPlayerStatus SPlayerStatus;

typedef struct SCRemotePlayer SCRemotePlayer;
#pragma pack(push, 1)
struct SCRemotePlayer {
    SCPed* m_pPed;
    SCVehicle* m_pVehicle;
    NUMBER m_nTeam;
    NUMBER m_nState;
    NUMBER m_nSeatId;
    int field_b;
    BOOL m_bPassengerDriveBy;
    char pad_13[64];
    SCVector m_positionDifference;
    struct {
        float real;
        SCVector imag;
    } m_incarTargetRotation;
    int pad_6f[3];
    SCVector m_onfootTargetPosition;
    SCVector m_onfootTargetSpeed;
    SCVector m_incarTargetPosition;
    SCVector m_incarTargetSpeed;
    ID m_nId;
    ID m_nVehicleId;
    int field_af;
    BOOL m_bDrawLabels;
    BOOL m_bHasJetPack;
    NUMBER m_nSpecialAction;
    int pad_bc[3];
    SOnfootData m_onfootData;
    SIncarData m_incarData;
    STrailerData m_trailerData;
    SPassengerData m_passengerData;
    SAimData m_aimData;
    float m_fReportedArmour;
    float m_fReportedHealth;
    SAnimation m_animation;
    NUMBER m_nUpdateType;
    TICK m_lastUpdate;
    TICK m_lastTimestamp;
    BOOL m_bPerformingCustomAnimation;
    int m_nStatus;
    struct {
        SCVector m_direction;
        TICK m_lastUpdate;
        TICK m_lastLook;
    } m_head;
    BOOL m_bMarkerState;
    struct {
        int x;
        int y;
        int z;
    } m_markerPosition;
    GTAREF m_marker;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCRemotePlayer', 0x1fd)

local CRemotePlayer_constructor = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', 0x12E20)
local CRemotePlayer_destructor = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', 0x12EA0)
local function CRemotePlayer_new(...)
    local obj = ffi.gc(ffi.new('struct SCRemotePlayer[1]'), CRemotePlayer_destructor)
    CRemotePlayer_constructor(obj, ...)
    return obj
end

local SCRemotePlayer_mt = {
    Spawn = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*, int, int, SCVector*, float, D3DCOLOR, char)', sampapi.GetAddress(0x13890)),
    ProcessHead = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x10EA0)),
    SetMarkerState = ffi.cast('void(__thiscall*)(SCRemotePlayer*, BOOL)', sampapi.GetAddress(0x10FF0)),
    SetMarkerPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, int, int, int)', sampapi.GetAddress(0x11030)),
    Surfing = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x110D0)),
    SurfingOnObject = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11100)),
    ProcessSurfing = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11130)),
    OnEnterVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x112D0)),
    OnExitVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x113A0)),
    ProcessSpecialAction = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x113F0)),
    UpdateOnfootSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11840)),
    UpdateOnfootRotation = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11990)),
    SetOnfootTargetSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCVector*, SCVector*)', sampapi.GetAddress(0x11A60)),
    UpdateIncarSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11AC0)),
    UpdateIncarRotation = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x11DA0)),
    SetIncarTargetSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCMatrix*, SCVector*, SCVector*)', sampapi.GetAddress(0x11F10)),
    UpdateTrain = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCMatrix*, SCVector*, float)', sampapi.GetAddress(0x11F80)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    ResetData = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x12830)),
    GetDistanceToPlayer = ffi.cast('float(__thiscall*)(SCRemotePlayer*, SCRemotePlayer*)', sampapi.GetAddress(0x12930)),
    GetDistanceToLocalPlayer = ffi.cast('float(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x129A0)),
    SetColor = ffi.cast('void(__thiscall*)(SCRemotePlayer*, D3DCOLOR)', sampapi.GetAddress(0x129D0)),
    GetColorAsRGBA = ffi.cast('D3DCOLOR(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x129F0)),
    GetColorAsARGB = ffi.cast('D3DCOLOR(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x12A00)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*, ID, BOOL)', sampapi.GetAddress(0x12A20)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x12AB0)),
    ChangeState = ffi.cast('void(__thiscall*)(SCRemotePlayer*, char, char)', sampapi.GetAddress(0x12AE0)),
    GetStatus = ffi.cast('int(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x12BA0)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Process = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x12EF0)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x12080)),
    Remove = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x13C60)),
    Kill = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x13CA0)),
    Chat = ffi.cast('void(__thiscall*)(SCRemotePlayer*, const char*)', sampapi.GetAddress(0x13D30)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x1080)),
}
mt.set_handler('struct SCRemotePlayer', '__index', SCRemotePlayer_mt)

local AimStuff = {}

local Synchronization = {}

return {
    new = CRemotePlayer_new,
    AimStuff = AimStuff,
    Synchronization = Synchronization,
}