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
shared.require 'v037r1.CPlayerPool'
shared.require 'v037r1.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.CLabelPool'
shared.require 'v037r1.CActorPool'
shared.require 'v037r1.CActor'
shared.require 'v037r1.CObjectPool'
shared.require 'v037r1.CMenuPool'
shared.require 'v037r1.CMenu'
shared.require 'v037r1.CTextDrawPool'
shared.require 'v037r1.CTextDraw'
shared.require 'v037r1.CGangZonePool'
shared.require 'v037r1.CPickupPool'
shared.require 'v037r1.CVehiclePool'
shared.require 'v037r1.CLocalPlayer'
shared.require 'v037r1.CPlayerInfo'
shared.require 'v037r1.CRemotePlayer'
shared.require 'v037r1.SpecialAction'
shared.require 'v037r1.ControllerState'
shared.require 'v037r1.Animation'
shared.require 'v037r1.AimStuff'
shared.require 'v037r1.Synchronization'

shared.ffi.cdef[[
enum SMarkersMode {
    MARKERS_MODE_OFF = 0,
    MARKERS_MODE_GLOBAL = 1,
    MARKERS_MODE_STREAMED = 2,
};
typedef enum SMarkersMode SMarkersMode;

enum SGameMode {
    GAME_MODE_WAITCONNECT = 9,
    GAME_MODE_CONNECTING = 13,
    GAME_MODE_CONNECTED = 14,
    GAME_MODE_WAITJOIN = 15,
    GAME_MODE_RESTARTING = 18,
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
    SCActorPool* m_pActor;
    SCObjectPool* m_pObject;
    SCGangZonePool* m_pGangZone;
    SCLabelPool* m_pLabel;
    SCTextDrawPool* m_pTextDraw;
    SCMenuPool* m_pMenu;
    SCPlayerPool* m_pPlayer;
    SCVehiclePool* m_pVehicle;
    SCPickupPool* m_pPickup;
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
    char pad_0[32];
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
    struct RakClientInterface* m_pRakClient;
    SPools* m_pPools;
};
#pragma pack(pop)
]]

shared.validate_size('struct SPools', 0x24)
shared.validate_size('struct SNetSettings', 0x3a)
shared.validate_size('struct SCNetGame', 0x3d1)

local function RefNetGame() return ffi.cast('SCNetGame**', sampapi.GetAddress(0x21A0F8))[0] end
local function RefVehiclePoolProcessFlag() return ffi.cast('int*', sampapi.GetAddress(0x10496C))[0] end
local function RefPickupPoolProcessFlag() return ffi.cast('int*', sampapi.GetAddress(0x104970))[0] end
local function RefLastPlayersUpdateRequest() return ffi.cast('TICK*', sampapi.GetAddress(0x104978))[0] end

local SCNetGame_mt = {
    GetPickupPool = ffi.cast('SCPickupPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8130)),
    GetMenuPool = ffi.cast('SCMenuPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8140)),
    SetState = ffi.cast('void(__thiscall*)(SCNetGame*, int)', sampapi.GetAddress(0x8150)),
    InitializePools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8160)),
    InitialNotification = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8380)),
    InitializeGameLogic = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8510)),
    -- Connect = ...
    -- SpawnScreen = ...
    Packet_RSAPublicKeyMismatch = ffi.cast('void(__thiscall*)(SCNetGame*, Packet * pPacket)', sampapi.GetAddress(0x8850)),
    Packet_ConnectionBanned = ffi.cast('void(__thiscall*)(SCNetGame*, Packet * pPacket)', sampapi.GetAddress(0x8870)),
    Packet_ConnectionRequestAcepted = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x8890)),
    Packet_NoFreeIncomingConnections = ffi.cast('void(__thiscall*)(SCNetGame*, Packet * pPacket)', sampapi.GetAddress(0x88B0)),
    Packet_DisconnectionNotification = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x88E0)),
    Packet_InvalidPassword = ffi.cast('void(__thiscall*)(SCNetGame*, Packet * pPacket)', sampapi.GetAddress(0x8920)),
    Packet_ConnectionAttemptFailed = ffi.cast('void(__thiscall*)(SCNetGame*, Packet * pPacket)', sampapi.GetAddress(0x8960)),
    UpdatePlayers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8A10)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER)', sampapi.GetAddress(0x8AB0)),
    ResetPlayerPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8AE0)),
    ResetVehiclePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8B80)),
    ResetTextDrawPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8C20)),
    ResetObjectPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8CC0)),
    ResetGangZonePool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8D60)),
    ResetPickupPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8E00)),
    ResetMenuPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8E60)),
    ResetLabelPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8F00)),
    ResetActorPool = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8FA0)),
    Packet_UnoccupiedSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9550)),
    Packet_BulletSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9650)),
    Packet_AimSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9750)),
    Packet_PassengerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9840)),
    Packet_TrailerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9930)),
    Packet_MarkersSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9A20)),
    Packet_AuthKey = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0x9C10)),
    ResetMarkers = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x9DE0)),
    CreateMarker = ffi.cast('void(__thiscall*)(SCNetGame*, NUMBER, SCVector, char, int, int)', sampapi.GetAddress(0x9E20)),
    ResetPools = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA010)),
    ShutdownForRestart = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xA060)),
    Packet_PlayerSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA250)),
    Packet_VehicleSync = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA520)),
    Packet_ConnectionLost = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA800)),
    Packet_ConnectionSucceeded = ffi.cast('void(__thiscall*)(SCNetGame*, Packet*)', sampapi.GetAddress(0xA890)),
    UpdateNetwork = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0xAD70)),
    -- Process = ...
    ProcessGameStuff = ffi.cast('void(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8680)),
    GetPlayerPool = ffi.cast('SCPlayerPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1160)),
    GetObjectPool = ffi.cast('SCObjectPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E00)),
    GetActorPool = ffi.cast('SCActorPool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E10)),
    GetState = ffi.cast('int(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E20)),
    LanMode = ffi.cast('BOOL(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x2E30)),
    GetVehiclePool = ffi.cast('SCVehiclePool * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1170)),
    GetRakClient = ffi.cast('RakClientInterface * (__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x1A40)),
    GetCounter = ffi.cast('__int64(__thiscall*)(SCNetGame*)', sampapi.GetAddress(0x8500)),
}
mt.set_handler('struct SCNetGame', '__index', SCNetGame_mt)

local AimStuff = {}

local Synchronization = {}

return {
    RefNetGame = RefNetGame,
    RefVehiclePoolProcessFlag = RefVehiclePoolProcessFlag,
    RefPickupPoolProcessFlag = RefPickupPoolProcessFlag,
    RefLastPlayersUpdateRequest = RefLastPlayersUpdateRequest,
    AimStuff = AimStuff,
    Synchronization = Synchronization,
}