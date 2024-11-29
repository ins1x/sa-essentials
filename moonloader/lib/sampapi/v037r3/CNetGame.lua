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
shared.require 'v037r3.CPed'
shared.require 'v037r3.CPlayerPool'
shared.require 'v037r3.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r3.CObjectPool'
shared.require 'v037r3.CVehicle'
shared.require 'v037r3.CActorPool'
shared.require 'v037r3.CActor'
shared.require 'v037r3.CTextDrawPool'
shared.require 'v037r3.CTextDraw'
shared.require 'v037r3.CMenuPool'
shared.require 'v037r3.CMenu'
shared.require 'v037r3.CLabelPool'
shared.require 'v037r3.CPickupPool'
shared.require 'v037r3.CGangZonePool'
shared.require 'v037r3.CVehiclePool'
shared.require 'v037r3.CLocalPlayer'
shared.require 'v037r3.CPlayerInfo'
shared.require 'v037r3.CRemotePlayer'
shared.require 'v037r3.Animation'
shared.require 'v037r3.ControllerState'
shared.require 'v037r3.Synchronization'
shared.require 'v037r3.AimStuff'

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
    SCMenuPool* m_pMenu;
    SCActorPool* m_pActor;
    SCPlayerPool* m_pPlayer;
    SCVehiclePool* m_pVehicle;
    SCPickupPool* m_pPickup;
    SCObjectPool* m_pObject;
    SCGangZonePool* m_pGangZone;
    SCLabelPool* m_pLabel;
    SCTextDrawPool* m_pTextDraw;
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
    char pad_0[44];
    struct RakClientInterface* m_pRakClient;
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

local function RefNetGame() return ffi.cast('SCNetGame**', sampapi.GetAddress(0x26E8DC))[0] end
local CNetGame_constructor = ffi.cast('void(__thiscall*)(SCNetGame*, const char*, int, const char*, const char*)', 0xB5F0)
local CNetGame_destructor = ffi.cast('void(__thiscall*)(SCNetGame*)', 0x9510)
local function CNetGame_new(...)
    local obj = ffi.gc(ffi.new('struct SCNetGame[1]'), CNetGame_destructor)
    CNetGame_constructor(obj, ...)
    return obj
end

local function RefLastPlayersUpdateRequest() return ffi.cast('TICK*', sampapi.GetAddress(0x1189F0))[0] end

local SCNetGame_mt = {
    GetPickupPool = ffi.cast('SCPickupPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8170)),
    GetMenuPool = ffi.cast('SCMenuPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8180)),
    SetState = ffi.cast('void(__thiscall*)(SCNetGame*, int)', sampapi.GetAddress(0x8190)),
    InitializePools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x81D0)),
    InitialNotification = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x83F0)),
    InitializeGameLogic = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8580)),
    Connect = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x85D0)),
    SpawnScreen = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8640)),
    Packet_RSAPublicKeyMismatch = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x89E0)),
    Packet_ConnectionBanned = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8A00)),
    Packet_ConnectionRequestAcepted = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8A20)),
    Packet_NoFreeIncomingConnections = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8A40)),
    Packet_DisconnectionNotification = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8A70)),
    Packet_InvalidPassword = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8AB0)),
    Packet_ConnectionAttemptFailed = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8AF0)),
    UpdatePlayers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8BA0)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER)', sampapi.GetAddress(0x8C40)),
    ResetPlayerPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8C70)),
    ResetVehiclePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8D10)),
    ResetTextDrawPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8DB0)),
    ResetObjectPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8E50)),
    ResetGangZonePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8EF0)),
    ResetPickupPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8F90)),
    ResetMenuPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8FF0)),
    ResetLabelPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9080)),
    ResetActorPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9120)),
    Packet_UnoccupiedSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x96D0)),
    Packet_BulletSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x97D0)),
    Packet_AimSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x98D0)),
    Packet_PassengerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x99C0)),
    Packet_TrailerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9AB0)),
    Packet_MarkersSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9BA0)),
    Packet_AuthKey = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9D90)),
    ResetMarkers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9F50)),
    CreateMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER, SCVector, char, int, int)', sampapi.GetAddress(0x9F90)),
    ResetPools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA190)),
    ShutdownForRestart = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA1E0)),
    Packet_PlayerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA3E0)),
    Packet_VehicleSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA6B0)),
    Packet_ConnectionLost = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA990)),
    Packet_ConnectionSucceeded = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xAA20)),
    UpdateNetwork = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xAF20)),
    Process = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xB270)),
    ProcessGameStuff = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x87B0)),
    GetPlayerPool = ffi.cast('SCPlayerPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1160)),
    GetObjectPool = ffi.cast('SCObjectPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2DF0)),
    GetActorPool = ffi.cast('SCActorPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E00)),
    GetState = ffi.cast('int(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E10)),
    LanMode = ffi.cast('BOOL(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E20)),
    GetVehiclePool = ffi.cast('SCVehiclePool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1170)),
    GetRakClient = ffi.cast('RakClientInterface * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1A40)),
    GetCounter = ffi.cast('__int64(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8570)),
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