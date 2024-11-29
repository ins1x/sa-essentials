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

shared.require 'CVector'
shared.require 'v037r1.Animation'
shared.require 'v037r1.ControllerState'

shared.ffi.cdef[[
typedef struct SOnfootData SOnfootData;
#pragma pack(push, 1)
struct SOnfootData {
    SControllerState m_controllerState;
    SCVector m_position;
    float m_fQuaternion[4];
    unsigned char m_nHealth;
    unsigned char m_nArmor;
    unsigned char m_nCurrentWeapon;
    unsigned char m_nSpecialAction;
    SCVector m_speed;
    SCVector m_surfingOffset;
    ID m_nSurfingVehicleId;
    SAnimation m_animation;
};
#pragma pack(pop)

typedef struct SIncarData SIncarData;
#pragma pack(push, 1)
struct SIncarData {
    ID m_nVehicle;
    SControllerState m_controllerState;
    float m_fQuaternion[4];
    SCVector m_position;
    SCVector m_speed;
    float m_fHealth;
    unsigned char m_nDriverHealth;
    unsigned char m_nDriverArmor;
    unsigned char m_nCurrentWeapon;
    bool m_bSirenEnabled;
    bool m_bLandingGear;
    ID m_nTrailerId;
    union {
        short unsigned int m_aHydraThrustAngle[2];
        float m_fTrainSpeed;
    };
};
#pragma pack(pop)

enum SWeaponState {
    WS_NO_BULLETS = 0,
    WS_LAST_BULLET = 1,
    WS_MORE_BULLETS = 2,
    WS_RELOADING = 3,
};
typedef enum SWeaponState SWeaponState;

typedef struct SAimData SAimData;
#pragma pack(push, 1)
struct SAimData {
    unsigned char m_nCameraMode;
    SCVector m_aimf1;
    SCVector m_aimPos;
    float m_fAimZ;
    unsigned char m_nCameraExtZoom : 6;
    unsigned char m_nWeaponState : 2;
    char m_nAspectRatio;
};
#pragma pack(pop)

typedef struct STrailerData STrailerData;
#pragma pack(push, 1)
struct STrailerData {
    ID m_nId;
    SCVector m_position;
    float m_fQuaternion[4];
    SCVector m_speed;
    SCVector m_turnSpeed;
};
#pragma pack(pop)

typedef struct SPassengerData SPassengerData;
#pragma pack(push, 1)
struct SPassengerData {
    ID m_nVehicleId;
    unsigned char m_nSeatId;
    unsigned char m_nCurrentWeapon;
    unsigned char m_nHealth;
    unsigned char m_nArmor;
    SControllerState m_controllerState;
    SCVector m_position;
};
#pragma pack(pop)

typedef struct SUnoccupiedData SUnoccupiedData;
#pragma pack(push, 1)
struct SUnoccupiedData {
    ID m_nVehicleId;
    unsigned char m_nSeatId;
    SCVector m_roll;
    SCVector m_direction;
    SCVector m_position;
    SCVector m_speed;
    SCVector m_turnSpeed;
    float m_fHealth;
};
#pragma pack(pop)

typedef struct SBulletData SBulletData;
#pragma pack(push, 1)
struct SBulletData {
    unsigned char m_nTargetType;
    ID m_nTargetId;
    SCVector m_origin;
    SCVector m_target;
    SCVector m_center;
    unsigned char m_nWeapon;
};
#pragma pack(pop)

typedef struct SSpectatorData SSpectatorData;
#pragma pack(push, 1)
struct SSpectatorData {
    SControllerState m_controllerState;
    SCVector m_position;
};
#pragma pack(pop)

typedef struct SStatsData SStatsData;
#pragma pack(push, 1)
struct SStatsData {
    int m_nMoney;
    int m_nDrunkLevel;
};
#pragma pack(pop)
]]

shared.validate_size('struct SOnfootData', 0x44)
shared.validate_size('struct SIncarData', 0x3f)
shared.validate_size('struct SAimData', 0x1f)
shared.validate_size('struct STrailerData', 0x36)
shared.validate_size('struct SPassengerData', 0x18)
shared.validate_size('struct SUnoccupiedData', 0x43)
shared.validate_size('struct SBulletData', 0x28)
shared.validate_size('struct SSpectatorData', 0x12)
shared.validate_size('struct SStatsData', 0x8)

-- CompressAspectRatio = ...
-- DecompressAspectRatio = ...
-- CompressCameraExtZoom = ...
-- DecompressCameraExtZoom = ...