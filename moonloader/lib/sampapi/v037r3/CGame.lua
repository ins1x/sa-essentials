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
shared.require 'v037r3.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r3.CVehicle'
shared.require 'v037r3.ControllerState'
shared.require 'v037r3.CAudio'
shared.require 'v037r3.CCamera'
shared.require 'v037r3.AimStuff'

shared.ffi.cdef[[
enum SCursorMode {
    CURSOR_NONE = 0,
    CURSOR_LOCKKEYS_NOCURSOR = 1,
    CURSOR_LOCKCAMANDCONTROL = 2,
    CURSOR_LOCKCAM = 3,
    CURSOR_LOCKCAM_NOCURSOR = 4,
};
typedef enum SCursorMode SCursorMode;

typedef struct SCGame SCGame;
#pragma pack(push, 1)
struct SCGame {
    SCAudio* m_pAudio;
    SCCamera* m_pCamera;
    SCPed* m_pPlayerPed;
    struct {
        SCVector m_currentPosition;
        SCVector m_nextPosition;
        float m_fSize;
        char m_nType;
        BOOL m_bEnabled;
        GTAREF m_marker;
        GTAREF m_handle;
    } m_racingCheckpoint;
    struct {
        SCVector m_position;
        SCVector m_size;
        BOOL m_bEnabled;
        GTAREF m_handle;
    } m_checkpoint;
    int field_61;
    BOOL m_bHeadMove;
    int m_nFrameLimiter;
    int m_nCursorMode;
    unsigned int m_nInputEnableWaitFrames;
    BOOL m_bClockEnabled;
    char field_6d;
    bool m_aKeepLoadedVehicleModels[212];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCGame', 0x142)

local function RefGame() return ffi.cast('SCGame**', sampapi.GetAddress(0x26E8F4))[0] end
local CGame_constructor = ffi.cast('void(__thiscall*)(SCGame*)', 0x9F870)
local function CGame_new(...)
    local obj = ffi.new('struct SCGame[1]')
    CGame_constructor(obj, ...)
    return obj
end

local function RefGameTextMessage() return ffi.cast('char**', sampapi.GetAddress(0x150084))[0] end
local function ArrayUsedPlayerSlots() return ffi.cast('BOOL* ', sampapi.GetAddress(0x150090)) end

local SCGame_mt = {
    GetPlayerPed = ffi.cast('SCPed * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x1010)),
    FindGroundZ = ffi.cast('float(__thiscall*)(SCGame*, SCVector)', sampapi.GetAddress(0x9FCF0)),
    SetCursorMode = ffi.cast('void(__thiscall*)(SCGame*, int, BOOL)', sampapi.GetAddress(0x9FFE0)),
    InitGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0180)),
    StartGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA01D0)),
    IsMenuVisible = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0210)),
    IsStarted = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0220)),
    RequestModel = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0xA0230)),
    LoadRequestedModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0250)),
    IsModelAvailable = ffi.cast('BOOL(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0260)),
    ReleaseModel = ffi.cast('void(__thiscall*)(SCGame*, int, bool)', sampapi.GetAddress(0xA0290)),
    SetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char, char)', sampapi.GetAddress(0xA03A0)),
    GetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char*, char*)', sampapi.GetAddress(0xA03D0)),
    LetTimeGo = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA03F0)),
    SetWorldWeather = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0xA0430)),
    SetFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA04A0)),
    SetMaxStats = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA04D0)),
    DisableTrainTraffic = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0500)),
    RefreshRenderer = ffi.cast('void(__thiscall*)(SCGame*, float, float)', sampapi.GetAddress(0xA0510)),
    RequestAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0540)),
    IsAnimationLoaded = ffi.cast('BOOL(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0560)),
    ReleaseAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0580)),
    DisplayGameText = ffi.cast('void(__thiscall*)(SCGame*, const char*, int, int)', sampapi.GetAddress(0xA05D0)),
    DeleteRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0630)),
    CreateMarker = ffi.cast('GTAREF(__thiscall*)(SCGame*, int, SCVector, int, int)', sampapi.GetAddress(0xA0660)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCGame*, GTAREF)', sampapi.GetAddress(0xA0790)),
    GetCurrentInterior = ffi.cast('char(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA07B0)),
    UpdateFarClippingPlane = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA07D0)),
    IncreasePlayerMoney = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0840)),
    GetPlayerMoney = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0860)),
    GetWeaponName = ffi.cast('const char*(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0870)),
    CreatePickup = ffi.cast('void(__thiscall*)(SCGame*, int, int, SCVector, GTAREF*)', sampapi.GetAddress(0xA0AC0)),
    CreateWeaponPickup = ffi.cast('GTAREF(__thiscall*)(SCGame*, int, int, SCVector)', sampapi.GetAddress(0xA0BA0)),
    GetDevice = ffi.cast('IDirect3DDevice9 * (__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0C40)),
    Restart = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0C80)),
    GetWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0xA0CB0)),
    SetWorldGravity = ffi.cast('void(__thiscall*)(SCGame*, float)', sampapi.GetAddress(0xA0CD0)),
    SetWantedLevel = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0xA0CF0)),
    SetNumberOfIntroTextLinesThisFrame = ffi.cast('void(__thiscall*)(SCGame*, unsigned short)', sampapi.GetAddress(0xA0D00)),
    DrawGangZone = ffi.cast('void(__thiscall*)(SCGame*, float*, char)', sampapi.GetAddress(0xA0D10)),
    EnableZoneDisplaying = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA0DF0)),
    EnableStuntBonus = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA0E10)),
    LoadScene = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0E80)),
    GetUsedMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0EA0)),
    GetStreamingMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0EB0)),
    SetRequiredVehicleModels = ffi.cast('void(__thiscall*)(SCGame*, unsigned char*)', sampapi.GetAddress(0xA0EE0)),
    GetTimer = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1040)),
    LoadAnimationsAndModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1170)),
    LoadCollisionFile = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA1450)),
    LoadCullZone = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA1470)),
    UsingGamepad = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1490)),
    DisableAutoAiming = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA14A0)),
    EnableHUD = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0xA1680)),
    SetCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, SCVector*, SCVector*)', sampapi.GetAddress(0xA16B0)),
    CreateRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1770)),
    ProcessCheckpoints = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA17F0)),
    ResetMoney = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1990)),
    SetRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, int, SCVector*, SCVector*, float)', sampapi.GetAddress(0xA19D0)),
    EnableRadar = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0xA05B0)),
    GetWindowHandle = ffi.cast('void*(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2CF0)),
    GetAudio = ffi.cast('SCAudio * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D00)),
    GetCamera = ffi.cast('SCCamera * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D10)),
    DoesHeadMoves = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D20)),
    EnableClock = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA0D30)),
    Sleep = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0x9F980)),
    CreatePed = ffi.cast('SCPed * (__thiscall*)(SCGame*, int, SCVector, float, int, int)', sampapi.GetAddress(0x9FA00)),
    RemovePed = ffi.cast('BOOL(__thiscall*)(SCGame*, SCPed*)', sampapi.GetAddress(0x9FB00)),
    CreateVehicle = ffi.cast('SCVehicle * (__thiscall*)(SCGame*, int, SCVector, float, BOOL)', sampapi.GetAddress(0x9FB40)),
    CreateObject = ffi.cast('SCObject * (__thiscall*)(SCGame*, int, SCVector, SCVector, float, char, char)', sampapi.GetAddress(0x9FC20)),
    ProcessInputEnabling = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9FEC0)),
    ProcessFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA14E0)),
}
mt.set_handler('struct SCGame', '__index', SCGame_mt)

local AimStuff = {}

return {
    RefGame = RefGame,
    new = CGame_new,
    RefGameTextMessage = RefGameTextMessage,
    ArrayUsedPlayerSlots = ArrayUsedPlayerSlots,
    AimStuff = AimStuff,
}