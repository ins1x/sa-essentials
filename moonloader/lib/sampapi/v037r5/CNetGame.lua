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
shared.require 'v037r5.CPlayerPool'
shared.require 'v037r5.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.CObjectPool'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.CActorPool'
shared.require 'v037r5.CActor'
shared.require 'v037r5.CTextDrawPool'
shared.require 'v037r5.CTextDraw'
shared.require 'v037r5.CMenuPool'
shared.require 'v037r5.CMenu'
shared.require 'v037r5.CLabelPool'
shared.require 'v037r5.CPickupPool'
shared.require 'v037r5.CGangZonePool'
shared.require 'v037r5.CVehiclePool'
shared.require 'v037r5.CLocalPlayer'
shared.require 'v037r5.CPlayerInfo'
shared.require 'v037r5.CRemotePlayer'
shared.require 'v037r5.Animation'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.Synchronization'
shared.require 'v037r5.AimStuff'

shared.ffi.cdef[[
enum SMarkersMode {
    MARKERS_MODE_OFF = 0,
    MARKERS_MODE_GLOBAL = 1,
    MARKERS_MODE_STREAMED = 2,
};
typedef enum SMarkersMode SMarkersMode;

enum SGameMode {
    GAME_MODE_WAITCONNECT = 1,
    GAME_MODE_CONNECTING = 2,
    GAME_MODE_CONNECTED = 5,
    GAME_MODE_WAITJOIN = 6,
    GAME_MODE_RESTARTING = 11,
};
typedef enum SGameMode SGameMode;

enum {
    NETMODE_STATS_UPDATE_DELAY = 1000,
    NETMODE_INCAR_SENDRATE = 30,
    NETMODE_ONFOOT_SENDRATE = 30,
    NETMODE_FIRING_SENDRATE = 30,
    LANMODE_INCAR_SENDRATE = 15,
    LANMODE_ONFOOT_SENDRATE = 15,
    NETMODE_SEND_MULTIPLIER = 2,
    NETMODE_AIM_UPDATE_DELAY = 500,
    NETMODE_HEAD_UPDATE_DELAY = 1000,
    NETMODE_TARGET_UPDATE_DELAY = 100,
    NETMODE_PLAYERS_UPDATE_DELAY = 3000,
};

typedef struct SPools SPools;
#pragma pack(push, 1)
struct SPools {
    SCVehiclePool* m_pVehicle;
    SCPlayerPool* m_pPlayer;
    SCPickupPool* m_pPickup;
    SCObjectPool* m_pObject;
    SCActorPool* m_pActor;
    SCGangZonePool* m_pGangZone;
    SCLabelPool* m_pLabel;
    SCTextDrawPool* m_pTextDraw;
    SCMenuPool* m_pMenu;
};
#pragma pack(pop)

typedef struct SNetSettings SNetSettings;
#pragma pack(push, 1)
struct SNetSettings {
    bool m_bUseCJWalk;
    unsigned int m_nDeadDropsMoney;
    float m_fWorldBoundaries[4];
    bool m_bAllowWeapons;
    float m_fGravity;
    bool m_bEnterExit;
    BOOL m_bVehicleFriendlyFire;
    bool m_bHoldTime;
    bool m_bInstagib;
    bool m_bZoneNames;
    bool m_bFriendlyFire;
    BOOL m_bClassesAvailable;
    float m_fNameTagsDrawDist;
    bool m_bManualVehicleEngineAndLight;
    unsigned char m_nWorldTimeHour;
    unsigned char m_nWorldTimeMinute;
    unsigned char m_nWeather;
    bool m_bNoNametagsBehindWalls;
    int m_nPlayerMarkersMode;
    float m_fChatRadius;
    bool m_bNameTags;
    bool m_bLtdChatRadius;
};
#pragma pack(pop)

typedef struct SCNetGame SCNetGame;
#pragma pack(push, 1)
struct SCNetGame {
    struct RakClientInterface* m_pRakClient;
    char pad_0[44];
    char m_szHostAddress[257];
    char m_szHostname[257];
    bool m_bDisableCollision;
    bool m_bUpdateCameraTarget;
    bool m_bNametagStatus;
    int m_nPort;
    BOOL m_bLanMode;
    GTAREF m_aMapIcons[100];
    int m_nGameState;
    TICK m_lastConnectAttempt;
    SNetSettings* m_pSettings;
    char pad_2[5];
    SPools* m_pPools;
};
#pragma pack(pop)
]]

shared.validate_size('struct SPools', 0x24)
shared.validate_size('struct SNetSettings', 0x3a)
shared.validate_size('struct SCNetGame', 0x3e2)

local function RefNetGame() return ffi.cast('SCNetGame**', sampapi.GetAddress(0x26EB94))[0] end
local CNetGame_constructor = ffi.cast('void(__thiscall*)(SCNetGame*, const char*, int, const char*, const char*)', 0xB930)
local CNetGame_destructor = ffi.cast('void(__thiscall*)(SCNetGame*)', 0x9880)
local function CNetGame_new(...)
    local obj = ffi.gc(ffi.new('struct SCNetGame[1]'), CNetGame_destructor)
    CNetGame_constructor(obj, ...)
    return obj
end

local function RefLastPlayersUpdateRequest() return ffi.cast('TICK*', sampapi.GetAddress(0x118A10))[0] end

local SCNetGame_mt = {
    GetPickupPool = ffi.cast('SCPickupPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x84E0)),
    GetMenuPool = ffi.cast('SCMenuPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x84F0)),
    SetState = ffi.cast('void(__thiscall*)(SCNetGame*, int)', sampapi.GetAddress(0x8500)),
    InitializePools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8540)),
    InitialNotification = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8760)),
    InitializeGameLogic = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x88F0)),
    Connect = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8940)),
    SpawnScreen = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x89B0)),
    Packet_RSAPublicKeyMismatch = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8D50)),
    Packet_ConnectionBanned = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8D70)),
    Packet_ConnectionRequestAcepted = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8D90)),
    Packet_NoFreeIncomingConnections = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8DB0)),
    Packet_DisconnectionNotification = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8DE0)),
    Packet_InvalidPassword = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8E20)),
    Packet_ConnectionAttemptFailed = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8E60)),
    UpdatePlayers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8F10)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER)', sampapi.GetAddress(0x8FB0)),
    ResetPlayerPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8FE0)),
    ResetVehiclePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9080)),
    ResetTextDrawPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9110)),
    ResetObjectPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x91B0)),
    ResetGangZonePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9250)),
    ResetPickupPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x92F0)),
    ResetMenuPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9350)),
    ResetLabelPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9490)),
    ResetActorPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x93F0)),
    Packet_UnoccupiedSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9A40)),
    Packet_BulletSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9B40)),
    Packet_AimSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9C40)),
    Packet_PassengerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9D30)),
    Packet_TrailerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9E20)),
    Packet_MarkersSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9F10)),
    Packet_AuthKey = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA100)),
    ResetMarkers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA2C0)),
    CreateMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER, SCVector, char, int, int)', sampapi.GetAddress(0xA300)),
    ResetPools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA4F0)),
    ShutdownForRestart = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA540)),
    Packet_PlayerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA740)),
    Packet_VehicleSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xAA10)),
    Packet_ConnectionLost = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xACF0)),
    Packet_ConnectionSucceeded = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xAD80)),
    UpdateNetwork = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xB260)),
    Process = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xB5B0)),
    ProcessGameStuff = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8B20)),
    GetPlayerPool = ffi.cast('SCPlayerPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1170)),
    GetObjectPool = ffi.cast('SCObjectPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E10)),
    GetActorPool = ffi.cast('SCActorPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E20)),
    GetState = ffi.cast('int(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E30)),
    LanMode = ffi.cast('BOOL(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E40)),
    GetVehiclePool = ffi.cast('SCVehiclePool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1180)),
    GetRakClient = ffi.cast('RakClientInterface * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xBBC0)),
    GetCounter = ffi.cast('__int64(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x88E0)),
}
mt.set_handler('struct SCNetGame', '__index', SCNetGame_mt)

local Synchronization = {}

local AimStuff = {}

return {
    RefNetGame = RefNetGame,
    new = CNetGame_new,
    RefLastPlayersUpdateRequest = RefLastPlayersUpdateRequest,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}