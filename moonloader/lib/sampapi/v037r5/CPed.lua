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
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.AimStuff'

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

local CPed_constructor = ffi.cast('void(__thiscall*)(SCPed*)', 0xABA70)
local function CPed_new(...)
    local obj = ffi.new('struct SCPed[1]')
    CPed_constructor(obj, ...)
    return obj
end

local SCPed_mt = {
    ResetPointers = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABBB0)),
    SetInitialState = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABBD0)),
    GetAim = ffi.cast('SAim * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xABBF0)),
    SetAim = ffi.cast('void(__thiscall*)(SCPed*, const SAim*)', sampapi.GetAddress(0xABC30)),
    GetCurrentWeapon = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABC50)),
    GetVehicleRef = ffi.cast('GTAREF(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABC90)),
    DeleteArrow = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABCB0)),
    IsOnScreen = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABCE0)),
    SetImmunities = ffi.cast('void(__thiscall*)(SCPed*, BOOL, BOOL, BOOL, BOOL, BOOL)', sampapi.GetAddress(0xABD00)),
    GetHealth = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABD50)),
    SetHealth = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xABD70)),
    GetArmour = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABD90)),
    SetArmour = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xABDB0)),
    GetFlags = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABDD0)),
    SetFlags = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xABDF0)),
    IsDead = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABE10)),
    GetState = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABE40)),
    SetState = ffi.cast('void(__thiscall*)(SCPed*, char)', sampapi.GetAddress(0xABE50)),
    GetRotation = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABE90)),
    ForceRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xABF10)),
    SetRotation = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xABF60)),
    IsPassenger = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xABFC0)),
    GetVehicle = ffi.cast('struct CVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC000)),
    ClearWeapons = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC010)),
    SetArmedWeapon = ffi.cast('void(__thiscall*)(SCPed*, int, bool)', sampapi.GetAddress(0xAC060)),
    RemoveWeaponWhenEnteringVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC140)),
    GetCurrentWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC140)),
    CurrentWeaponHasAmmo = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC160)),
    GetDistanceToEntity = ffi.cast('float(__thiscall*)(SCPed*, const SCEntity*)', sampapi.GetAddress(0xAC1A0)),
    GetVehicleSeatIndex = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC200)),
    PutIntoVehicle = ffi.cast('void(__thiscall*)(SCPed*, GTAREF, int)', sampapi.GetAddress(0xAC290)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCPed*, GTAREF, BOOL)', sampapi.GetAddress(0xAC410)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAC4E0)),
    WarpFromVehicle = ffi.cast('void(__thiscall*)(SCPed*, SCVector)', sampapi.GetAddress(0xAC570)),
    SetSpawnInfo = ffi.cast('void(__thiscall*)(SCPed*, const SCVector*, float)', sampapi.GetAddress(0xAC750)),
    SetControllable = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xAC790)),
    GetDeathInfo = ffi.cast('char(__thiscall*)(SCPed*, ID*)', sampapi.GetAddress(0xAC850)),
    GetFloor = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xACA10)),
    GetCurrentWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xACAC0)),
    HandsUp = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACB10)),
    DoesHandsUp = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACB60)),
    HoldObject = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xACBC0)),
    EnableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACD10)),
    DisableJetpack = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACD60)),
    HasJetpack = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACDC0)),
    EnablePassengerDrivebyMode = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xACF90)),
    Extinguish = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD0F0)),
    GetCurrentWeaponAmmo = ffi.cast('unsigned short(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD150)),
    GetWeaponSlot = ffi.cast('struct CWeapon * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD190)),
    SetWalkStyle = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xAD1D0)),
    PerformAnimation = ffi.cast('void(__thiscall*)(SCPed*, const char*, const char*, float, int, int, int, int, int)', sampapi.GetAddress(0xAD230)),
    LinkToInterior = ffi.cast('void(__thiscall*)(SCPed*, char, BOOL)', sampapi.GetAddress(0xAD340)),
    DestroyParachute = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD3E0)),
    OpenParachute = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD4D0)),
    ProcessParachuteEvent = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xAD620)),
    IsOnGround = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD860)),
    ResetDamageEntity = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD880)),
    RemoveWeaponModel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAD8B0)),
    GetAimZ = ffi.cast('float(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD8F0)),
    SetAimZ = ffi.cast('void(__thiscall*)(SCPed*, float)', sampapi.GetAddress(0xAD930)),
    GetContactEntity = ffi.cast('struct CEntity * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD9A0)),
    GetContactVehicle = ffi.cast('struct CVehicle * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD9B0)),
    GetStat = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAD9E0)),
    PerformingCustomAnimation = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADA00)),
    StartDancing = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xADAD0)),
    StopDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADB20)),
    DoesDancing = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADB60)),
    GetAnimationForDance = ffi.cast('const char*(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xADB70)),
    DropStuff = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADC00)),
    GetStuff = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADC90)),
    ApplyStuff = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADCA0)),
    ProcessDrunk = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADDF0)),
    GetDrunkLevel = ffi.cast('int(__thiscall*)(SCPed*)', sampapi.GetAddress(0xADFA0)),
    SetDrunkLevel = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xADFB0)),
    ApplyCommandTask = ffi.cast('void(__thiscall*)(SCPed*, const char*, int, int, int, int, int, int, int, int, int)', sampapi.GetAddress(0xADFD0)),
    DestroyCommandTask = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE020)),
    EnableCellphone = ffi.cast('void(__thiscall*)(SCPed*, BOOL)', sampapi.GetAddress(0xAE070)),
    UsingCellphone = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE0A0)),
    SetFightingStyle = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAE0D0)),
    StartUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE100)),
    StopUrinating = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE1E0)),
    DoesUrinating = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE260)),
    GetLoadedShoppingDataSubsection = ffi.cast('const char*(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAE2E0)),
    LoadShoppingDataSubsection = ffi.cast('void(__thiscall*)(SCPed*, const char*)', sampapi.GetAddress(0xAE300)),
    GetAimedPed = ffi.cast('struct CPed * (__thiscall*)(SCPed*)', sampapi.GetAddress(0xAEF60)),
    SetKeys = ffi.cast('void(__thiscall*)(SCPed*, short, short, short)', sampapi.GetAddress(0xAF340)),
    GetKeys = ffi.cast('short(__thiscall*)(SCPed*, short*, short*)', sampapi.GetAddress(0xAF5D0)),
    CreateArrow = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAF730)),
    SetModelIndex = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAFF50)),
    Kill = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAFFD0)),
    SetWeaponAmmo = ffi.cast('void(__thiscall*)(SCPed*, unsigned char, unsigned short)', sampapi.GetAddress(0xB0080)),
    ProcessDancing = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xB00B0)),
    GiveStuff = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xB02D0)),
    Destroy = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xB0FA0)),
    SetCameraMode = ffi.cast('void(__thiscall*)(SCPed*, char)', sampapi.GetAddress(0x14340)),
    SetCameraExtZoomAndAspectRatio = ffi.cast('void(__thiscall*)(SCPed*, float, float)', sampapi.GetAddress(0x14360)),
    HasAccessory = ffi.cast('BOOL(__thiscall*)(SCPed*)', sampapi.GetAddress(0xAEE30)),
    DeleteAccessory = ffi.cast('void(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAEE50)),
    GetAccessoryState = ffi.cast('BOOL(__thiscall*)(SCPed*, int)', sampapi.GetAddress(0xAEEB0)),
    DeleteAllAccessories = ffi.cast('void(__thiscall*)(SCPed*)', sampapi.GetAddress(0xB0AB0)),
    AddAccessory = ffi.cast('void(__thiscall*)(SCPed*, int, const SAccessory*)', sampapi.GetAddress(0xB0B10)),
    GetAccessory = ffi.cast('SCObject * (__thiscall*)(SCPed*, int)', sampapi.GetAddress(0x13680)),
    GetCameraMode = ffi.cast('char(__thiscall*)(SCPed*)', sampapi.GetAddress(0x2CD0)),
    GetBonePosition = ffi.cast('void(__thiscall*)(SCPed*, unsigned int, SCVector*)', sampapi.GetAddress(0xAE480)),
}
mt.set_handler('struct SCPed', '__index', SCPed_mt)

local AimStuff = {}

return {
    new = CPed_new,
    AimStuff = AimStuff,
}