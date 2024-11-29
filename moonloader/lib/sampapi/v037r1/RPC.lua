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
shared.require 'v037r1.CNetGame'
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
typedef struct SDeathNotification SDeathNotification;
#pragma pack(push, 1)
struct SDeathNotification {
    unsigned char m_nReason;
    short unsigned int m_nKiller;
};
#pragma pack(pop)

typedef struct SSpawn SSpawn;
#pragma pack(push, 1)
struct SSpawn {
};
#pragma pack(pop)

typedef struct SUpdateVehicleDamage SUpdateVehicleDamage;
#pragma pack(push, 1)
struct SUpdateVehicleDamage {
    short unsigned int m_nVehicle;
    unsigned int m_nPanels;
    unsigned int m_nDoors;
    unsigned char m_nLights;
    unsigned char m_nTyres;
};
#pragma pack(pop)

typedef struct SClassRequest SClassRequest;
#pragma pack(push, 1)
struct SClassRequest {
    int m_nClass;
};
#pragma pack(pop)

typedef struct SSpawnRequest SSpawnRequest;
#pragma pack(push, 1)
struct SSpawnRequest {
};
#pragma pack(pop)

typedef struct SInteriorChangeNotification SInteriorChangeNotification;
#pragma pack(push, 1)
struct SInteriorChangeNotification {
    unsigned char m_nId;
};
#pragma pack(pop)

typedef struct SEnterVehicleNotification SEnterVehicleNotification;
#pragma pack(push, 1)
struct SEnterVehicleNotification {
    short unsigned int m_nVehicle;
    bool m_bPassenger;
};
#pragma pack(pop)

typedef struct SExitVehicleNotification SExitVehicleNotification;
#pragma pack(push, 1)
struct SExitVehicleNotification {
    short unsigned int m_nVehicle;
};
#pragma pack(pop)

typedef struct SUpdatePlayersInfo SUpdatePlayersInfo;
#pragma pack(push, 1)
struct SUpdatePlayersInfo {
};
#pragma pack(pop)

typedef struct SClickPlayer SClickPlayer;
#pragma pack(push, 1)
struct SClickPlayer {
    short unsigned int m_nPlayer;
    char m_nSource;
};
#pragma pack(pop)
]]

shared.validate_size('struct SDeathNotification', 0x3)
shared.validate_size('struct SSpawn', 0x1)
shared.validate_size('struct SUpdateVehicleDamage', 0xc)
shared.validate_size('struct SClassRequest', 0x4)
shared.validate_size('struct SSpawnRequest', 0x1)
shared.validate_size('struct SInteriorChangeNotification', 0x1)
shared.validate_size('struct SEnterVehicleNotification', 0x3)
shared.validate_size('struct SExitVehicleNotification', 0x2)
shared.validate_size('struct SUpdatePlayersInfo', 0x1)
shared.validate_size('struct SClickPlayer', 0x3)

local Incoming = {}

local Outcoming = {}

local AimStuff = {}

local Synchronization = {}

return {
    Incoming = Incoming,
    Outcoming = Outcoming,
    AimStuff = AimStuff,
    Synchronization = Synchronization,
}