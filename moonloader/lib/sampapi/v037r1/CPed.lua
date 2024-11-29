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
shared.require 'v037r1.AimStuff'

shared.ffi.cdef[[
typedef struct SCObject SCObject;
struct SCObject;

enum {
    MAX_ACCESSORIES = 10,
};

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

enum SStuffType {
    STUFF_TYPE_NONE = 0,
    STUFF_TYPE_BEER = 1,
    STUFF_TYPE_DYN_BEER = 2,
    STUFF_TYPE_PINT_GLASS = 3,
    STUFF_TYPE_CIGGI = 4,
};
typedef enum SStuffType SStuffType;

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
    int pad_2a8[2];
    NUMBER m_nPlayerNumber;
    int pad_2b1[2];
    GTAREF m_parachuteObject;
    GTAREF m_urinatingParticle;
    struct {
        int m_nType;
        GTAREF m_object;
        int m_nDrunkLevel;
    } m_stuff;
    GTAREF m_arrow;
    char field_2de;
    BOOL m_bIsDancing;
    int m_nDanceStyle;
    int m_nLastDanceMove;
    char pad_2de[20];
    BOOL m_bIsUrinating;
    char pad[55];
};
#pragma pack(pop)
]]

shared.validate_size('struct SAccessory', 0x34)
shared.validate_size('struct SCPed', 0x32d)

local AimStuff = {}

local CPed_constructor = ffi.cast('void(__thiscall*)(SCPed*)', 0xA6330)
local function CPed_new(...)
    local obj = ffi.new('struct SCPed[1]')
    CPed_constructor(obj, ...)
    return obj
end

local SCPed_mt = {
    ResetPointers = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6470)),
    SetInitialState = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6490)),
    GetAim = ffi.cast('SAim * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA64E0)),
    SetAim = ffi.cast('void(__thiscall*)(SCPed*, const SAim*)', sampapi.GetAddress(0xA64F0)),
    GetCurrentWeapon = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6510)),
    GetVehicleRef = ffi.cast('GTAREF(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6550)),
    DeleteArrow = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6570)),
    IsOnScreen = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA65A0)),
    SetImmunities = ffi.cast('void(__thiscall*)(SCPed*, int, int, int, int, int)', sampapi.GetAddress(0xA65C0)),
    GetHealth = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6610)),
    SetHealth = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xA6630)),
    GetArmour = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6650)),
    SetArmour = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xA6670)),
    GetFlags = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6690)),
    SetFlags = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA66B0)),
    IsDead = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA66D0)),
    GetState = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6700)),
    SetState = ffi.cast('void(__thiscall*)(SCPed*, char)', sampapi.GetAddress(0xA6710)),
    GetRotation = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6750)),
    ForceRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xA6820)),
    SetRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xA67D0)),
    IsPassenger = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6880)),
    GetVehicle = ffi.cast('SCVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA68C0)),
    ClearWeapons = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA68D0)),
    SetArmedWeapon = ffi.cast('void(__thiscall*)(SCPed*, int, bool)', sampapi.GetAddress(0xA6920)),
    RemoveWeaponWhenEnteringVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA69D0)),
    GetCurrentWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6A00)),
    CurrentWeaponHasAmmo = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6A20)),
    GetDistanceToEntity = ffi.cast('float(__thiscall*)(SCPed*, const SCEntity*)', sampapi.GetAddress(0xA6A60)),
    GetVehicleSeatIndex = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6AC0)),
    PutIntoVehicle = ffi.cast('void(__thiscall*)(SCPed*, unsigned long, int)', sampapi.GetAddress(0xA6B50)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCPed*, unsigned long, bool)', sampapi.GetAddress(0xA6CD0)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6DA0)),
    WarpFromVehicle = ffi.cast('void(__thiscall*)(SCPed*, SCVector)', sampapi.GetAddress(0xA6E30)),
    SetSpawnInfo = ffi.cast('void(__thiscall*)(SCPed*, const SCVector*, float)', sampapi.GetAddress(0xA7010)),
    SetControllable = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xA7050)),
    GetDeathInfo = ffi.cast('unsigned char(__thiscall*)(SCPed*, ID*)', sampapi.GetAddress(0xA7110)),
    GetFloor = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA72D0)),
    GetCurrentWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7380)),
    HandsUp = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA73D0)),
    DoesHandsUp = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7420)),
    HoldObject = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA7480)),
    EnableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA75D0)),
    DisableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7620)),
    HasJetpack = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7680)),
    EnablePassengerDrivebyMode = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7850)),
    Extinguish = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA79B0)),
    GetCurrentWeaponAmmo = ffi.cast('unsigned short(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7A10)),
    GetWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA7A50)),
    SetWalkStyle = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xA7A90)),
    PerformAnimation = ffi.cast('void(__thiscall*)(SCPed*, const char*, const char*, float, int, int, int, int, int)', sampapi.GetAddress(0xA7AF0)),
    LinkToInterior = ffi.cast('void(__thiscall*)(SCPed*, char, BOOL)', sampapi.GetAddress(0xA7C00)),
    DestroyParachute = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7CA0)),
    OpenParachute = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA7D90)),
    ProcessParachuteEvent = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xA7EE0)),
    IsOnGround = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8120)),
    ResetDamageEntity = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8140)),
    RemoveWeaponModel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA817C)),
    GetAimZ = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA81B0)),
    SetAimZ = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xA81F0)),
    GetContactEntity = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8240)),
    GetContactVehicle = ffi.cast('struct CVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8250)),
    GetStat = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8260)),
    PerformingCustomAnimation = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA82A0)),
    StartDancing = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA8370)),
    StopDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA83C0)),
    DoesDancing = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8400)),
    GetAnimationForDance = ffi.cast('const char*(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA8410)),
    DropStuff = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA84A0)),
    GetStuff = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8530)),
    ApplyStuff = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8540)),
    ProcessDrunk = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8690)),
    GetDrunkLevel = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8840)),
    SetDrunkLevel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA8850)),
    ApplyCommandTask = ffi.cast('void(__thiscall*)(SCPed*, const char*, int, int, int, int, int, int, int, int, int)', sampapi.GetAddress(0xA8870)),
    DestroyCommandTask = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA88C0)),
    EnableCellphone = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xA8910)),
    UsingCellphone = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8940)),
    SetFightingStyle = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA8970)),
    StartUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA89A0)),
    StopUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8A80)),
    DoesUrinating = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8B00)),
    GetLoadedShoppingDataSubsection = ffi.cast('const char*(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA8B80)),
    LoadShoppingDataSubsection = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xA8BA0)),
    GetAimedPed = ffi.cast('struct CPed * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xA9800)),
    SetKeys = ffi.cast('void(__thiscall*)(SCPed*, short, short, short)', sampapi.GetAddress(0xA9BE0)),
    GetKeys = ffi.cast('short(__thiscall*)(SCPed*, short*, short*)', sampapi.GetAddress(0xA9E70)),
    CreateArrow = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAA000)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAA820)),
    Kill = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAA8A0)),
    SetWeaponAmmo = ffi.cast('void(__thiscall*)(SCPed*, unsigned char, unsigned short)', sampapi.GetAddress(0xAA950)),
    ProcessDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAA980)),
    GiveStuff = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAABA0)),
    Destroy = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB840)),
    -- SetCameraMode = ...
    SetCameraExtZoomAndAspectRatio = ffi.cast('void(__thiscall*)(SCPed*, float, float)', sampapi.GetAddress(0x10E60)),
    HasAccessory = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA96D0)),
    DeleteAccessory = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA96F0)),
    GetAccessoryState = ffi.cast('BOOL(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xA9750)),
    DeleteAllAccessories = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAB380)),
    AddAccessory = ffi.cast('void(__thiscall*)(SCPed*, int, const SAccessory*)', sampapi.GetAddress(0xAB3E0)),
    GetAccessory = ffi.cast('SCObject * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0x101E0)),
    GetBonePosition = ffi.cast('void(__thiscall*)(SCPed*, int, SCVector*)', sampapi.GetAddress(0xA8D70)),
    GiveWeapon = ffi.cast('void(__thiscall*)(SCPed*, int, int)', sampapi.GetAddress(0xAA060)),
    IsInVehicle = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xA6730)),
}
mt.set_handler('struct SCPed', '__index', SCPed_mt)

return {
    AimStuff = AimStuff,
    new = CPed_new,
}