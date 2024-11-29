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
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r3.ControllerState'
shared.require 'v037r3.AimStuff'

shared.ffi.cdef[[
typedef struct SCObject SCObject;
struct SCObject;

enum {
    MAX_ACCESSORIES = 10,
};

enum SStuffType {
    STUFF_TYPE_NONE = 0,
    STUFF_TYPE_BEER = 1,
    STUFF_TYPE_DYN_BEER = 2,
    STUFF_TYPE_PINT_GLASS = 3,
    STUFF_TYPE_CIGGI = 4,
};
typedef enum SStuffType SStuffType;

typedef struct SAccessory SAccessory;
#pragma pack(push, 1)
struct SAccessory {
    int m_nModel;
    int m_nBone;
    SCVector m_offset;
    SCVector m_rotation;
    SCVector m_scale;
    D3DCOLOR m_firstMaterialColor;
    D3DCOLOR m_secondMaterialColor;
};
#pragma pack(pop)

typedef struct SCPed SCPed;
#pragma pack(push, 1)
struct SCPed : SCEntity {
    BOOL m_bUsingCellphone;
    struct {
        BOOL m_bNotEmpty[10];
        SAccessory m_info[10];
        SCObject* m_pObject[10];
    } m_accessories;
    struct CPed* m_pGamePed;
    unsigned int pad_2a8[2];
    unsigned char m_nPlayerNumber;
    unsigned int pad_2b1[2];
    GTAREF m_parachuteObject;
    GTAREF m_urinatingParticle;
    struct {
        int m_nType;
        GTAREF m_object;
        unsigned int m_nDrunkLevel;
    } m_stuff;
    GTAREF m_arrow;
    unsigned char field_2de;
    BOOL m_bDoesDancing;
    unsigned int m_nDanceStyle;
    unsigned int m_nLastDanceMove;
    unsigned char pad_2de[20];
    BOOL m_bDoesUrinating;
    unsigned char pad[55];
};
#pragma pack(pop)
]]

shared.validate_size('struct SAccessory', 0x34)
shared.validate_size('struct SCPed', 0x32d)

local CPed_constructor = ffi.cast('void(__thiscall*)(SCPed*)', 0xAB1E0)
local function CPed_new(...)
    local obj = ffi.new('struct SCPed[1]')
    CPed_constructor(obj, ...)
    return obj
end

local SCPed_mt = {
    ResetPointers = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB320)),
    SetInitialState = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB340)),
    GetAim = ffi.cast('SAim * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB390)),
    SetAim = ffi.cast('void(__thiscall*)(SCPed*, const SAim*)', sampapi.GetAddress(0xAB3A0)),
    GetCurrentWeapon = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB3C0)),
    GetVehicleRef = ffi.cast('GTAREF(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB400)),
    DeleteArrow = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB420)),
    IsOnScreen = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB450)),
    SetImmunities = ffi.cast('void(__thiscall*)(SCPed*, BOOL, BOOL, BOOL, BOOL, BOOL)', sampapi.GetAddress(0xAB470)),
    GetHealth = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB4C0)),
    SetHealth = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAB4E0)),
    GetArmour = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB500)),
    SetArmour = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAB520)),
    GetFlags = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB540)),
    SetFlags = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAB560)),
    IsDead = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB580)),
    GetState = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB5B0)),
    SetState = ffi.cast('void(__thiscall*)(SCPed*, char)', sampapi.GetAddress(0xAB5C0)),
    GetRotation = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB600)),
    ForceRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAB680)),
    SetRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAB6D0)),
    IsPassenger = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB730)),
    GetVehicle = ffi.cast('struct CVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB770)),
    ClearWeapons = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB780)),
    SetArmedWeapon = ffi.cast('void(__thiscall*)(SCPed*, int, bool)', sampapi.GetAddress(0xAB7D0)),
    RemoveWeaponWhenEnteringVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB880)),
    GetCurrentWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB8B0)),
    CurrentWeaponHasAmmo = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB8D0)),
    GetDistanceToEntity = ffi.cast('float(__thiscall*)(SCPed*, const SCEntity*)', sampapi.GetAddress(0xAB910)),
    GetVehicleSeatIndex = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB970)),
    PutIntoVehicle = ffi.cast('void(__thiscall*)(SCPed*, GTAREF, int)', sampapi.GetAddress(0xABA00)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCPed*, GTAREF, BOOL)', sampapi.GetAddress(0xABB80)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABC50)),
    WarpFromVehicle = ffi.cast('void(__thiscall*)(SCPed*, SCVector)', sampapi.GetAddress(0xABCE0)),
    SetSpawnInfo = ffi.cast('void(__thiscall*)(SCPed*, const SCVector*, float)', sampapi.GetAddress(0xABEC0)),
    SetControllable = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xABF00)),
    GetDeathInfo = ffi.cast('char(__thiscall*)(SCPed*, ID*)', sampapi.GetAddress(0xABFC0)),
    GetFloor = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC180)),
    GetCurrentWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC230)),
    HandsUp = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC280)),
    DoesHandsUp = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC2D0)),
    HoldObject = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAC330)),
    EnableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC480)),
    DisableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC4D0)),
    HasJetpack = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC530)),
    EnablePassengerDrivebyMode = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC700)),
    Extinguish = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC860)),
    GetCurrentWeaponAmmo = ffi.cast('unsigned short(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC8C0)),
    GetWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAC900)),
    SetWalkStyle = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xAC940)),
    PerformAnimation = ffi.cast('void(__thiscall*)(SCPed*, const char*, const char*, float, int, int, int, int, int)', sampapi.GetAddress(0xAC9A0)),
    LinkToInterior = ffi.cast('void(__thiscall*)(SCPed*, char, BOOL)', sampapi.GetAddress(0xACAB0)),
    DestroyParachute = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACB50)),
    OpenParachute = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACC40)),
    ProcessParachuteEvent = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xACD90)),
    IsOnGround = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACFD0)),
    ResetDamageEntity = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACFF0)),
    RemoveWeaponModel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD020)),
    GetAimZ = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD060)),
    SetAimZ = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAD0A0)),
    GetContactEntity = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD110)),
    GetContactVehicle = ffi.cast('struct CVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD120)),
    GetStat = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD150)),
    PerformingCustomAnimation = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD170)),
    StartDancing = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD240)),
    StopDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD290)),
    DoesDancing = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD2D0)),
    GetAnimationForDance = ffi.cast('const char*(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD2E0)),
    DropStuff = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD370)),
    GetStuff = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD400)),
    ApplyStuff = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD410)),
    ProcessDrunk = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD560)),
    GetDrunkLevel = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD710)),
    SetDrunkLevel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD720)),
    ApplyCommandTask = ffi.cast('void(__thiscall*)(SCPed*, const char*, int, int, int, int, int, int, int, int, int)', sampapi.GetAddress(0xAD740)),
    DestroyCommandTask = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD790)),
    EnableCellphone = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xAD7E0)),
    UsingCellphone = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD810)),
    SetFightingStyle = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD840)),
    StartUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD870)),
    StopUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD950)),
    DoesUrinating = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD9D0)),
    GetLoadedShoppingDataSubsection = ffi.cast('const char*(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADA50)),
    LoadShoppingDataSubsection = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xADA70)),
    GetAimedPed = ffi.cast('struct CPed * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE6D0)),
    SetKeys = ffi.cast('void(__thiscall*)(SCPed*, short, short, short)', sampapi.GetAddress(0xAEAB0)),
    GetKeys = ffi.cast('short(__thiscall*)(SCPed*, short*, short*)', sampapi.GetAddress(0xAED40)),
    CreateArrow = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAEEA0)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAF6C0)),
    Kill = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAF740)),
    SetWeaponAmmo = ffi.cast('void(__thiscall*)(SCPed*, unsigned char, unsigned short)', sampapi.GetAddress(0xAF7F0)),
    ProcessDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAF820)),
    GiveStuff = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAFA40)),
    Destroy = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xB0710)),
    SetCameraMode = ffi.cast('void(__thiscall*)(SCPed*, char)', sampapi.GetAddress(0x13F70)),
    SetCameraExtZoomAndAspectRatio = ffi.cast('void(__thiscall*)(SCPed*, float, float)', sampapi.GetAddress(0x13F90)),
    HasAccessory = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE5A0)),
    DeleteAccessory = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAE5C0)),
    GetAccessoryState = ffi.cast('BOOL(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAE620)),
    DeleteAllAccessories = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xB0220)),
    AddAccessory = ffi.cast('void(__thiscall*)(SCPed*, int, const SAccessory*)', sampapi.GetAddress(0xB0280)),
    GetAccessory = ffi.cast('SCObject * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0x13330)),
    GetCameraMode = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0x2CB0)),
    GetBonePosition = ffi.cast('void(__thiscall*)(SCPed*, unsigned int, SCVector*)', sampapi.GetAddress(0xADBF0)),
}
mt.set_handler('struct SCPed', '__index', SCPed_mt)

local AimStuff = {}

return {
    new = CPed_new,
    AimStuff = AimStuff,
}