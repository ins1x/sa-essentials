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
shared.require 'v037r5.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.CAudio'
shared.require 'v037r5.CCamera'
shared.require 'v037r5.AimStuff'

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

local function RefGame() return ffi.cast('SCGame**', sampapi.GetAddress(0x26EBAC))[0] end
local CGame_constructor = ffi.cast('void(__thiscall*)(SCGame*)', 0x9FF80)
local function CGame_new(...)
    local obj = ffi.new('struct SCGame[1]')
    CGame_constructor(obj, ...)
    return obj
end

local function RefGameTextMessage() return ffi.cast('char**', sampapi.GetAddress(0x150334))[0] end
local function ArrayUsedPlayerSlots() return ffi.cast('BOOL* ', sampapi.GetAddress(0x150340)) end

local SCGame_mt = {
    GetPlayerPed = ffi.cast('SCPed * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x1010)),
    FindGroundZ = ffi.cast('float(__thiscall*)(SCGame*, SCVector)', sampapi.GetAddress(0xA0400)),
    SetCursorMode = ffi.cast('void(__thiscall*)(SCGame*, int, BOOL)', sampapi.GetAddress(0xA06F0)),
    InitGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0890)),
    StartGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA08E0)),
    IsMenuVisible = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0920)),
    IsStarted = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0930)),
    RequestModel = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0xA0940)),
    LoadRequestedModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0960)),
    IsModelAvailable = ffi.cast('BOOL(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0970)),
    ReleaseModel = ffi.cast('void(__thiscall*)(SCGame*, int, bool)', sampapi.GetAddress(0xA09A0)),
    SetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char, char)', sampapi.GetAddress(0xA0AB0)),
    GetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char*, char*)', sampapi.GetAddress(0xA0AE0)),
    LetTimeGo = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA0B00)),
    SetWorldWeather = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0xA0B40)),
    SetFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0BB0)),
    SetMaxStats = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0BE0)),
    DisableTrainTraffic = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0C10)),
    RefreshRenderer = ffi.cast('void(__thiscall*)(SCGame*, float, float)', sampapi.GetAddress(0xA0C20)),
    RequestAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0C50)),
    IsAnimationLoaded = ffi.cast('BOOL(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0C70)),
    ReleaseAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA0C90)),
    DisplayGameText = ffi.cast('void(__thiscall*)(SCGame*, const char*, int, int)', sampapi.GetAddress(0xA0CE0)),
    DeleteRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0D60)),
    CreateMarker = ffi.cast('GTAREF(__thiscall*)(SCGame*, int, SCVector, int, int)', sampapi.GetAddress(0xA0D90)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCGame*, GTAREF)', sampapi.GetAddress(0xA0EC0)),
    GetCurrentInterior = ffi.cast('char(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0EE0)),
    UpdateFarClippingPlane = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0F00)),
    IncreasePlayerMoney = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0F70)),
    GetPlayerMoney = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA0F90)),
    GetWeaponName = ffi.cast('const char*(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0xA0FA0)),
    CreatePickup = ffi.cast('void(__thiscall*)(SCGame*, int, int, SCVector, GTAREF*)', sampapi.GetAddress(0xA11F0)),
    CreateWeaponPickup = ffi.cast('GTAREF(__thiscall*)(SCGame*, int, int, SCVector)', sampapi.GetAddress(0xA12D0)),
    GetDevice = ffi.cast('IDirect3DDevice9 * (__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1370)),
    Restart = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA13B0)),
    GetWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0xA13E0)),
    SetWorldGravity = ffi.cast('void(__thiscall*)(SCGame*, float)', sampapi.GetAddress(0xA1400)),
    SetWantedLevel = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0xA1420)),
    SetNumberOfIntroTextLinesThisFrame = ffi.cast('void(__thiscall*)(SCGame*, unsigned short)', sampapi.GetAddress(0xA1430)),
    DrawGangZone = ffi.cast('void(__thiscall*)(SCGame*, float*, char)', sampapi.GetAddress(0xA1440)),
    EnableZoneDisplaying = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA1520)),
    EnableStuntBonus = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA1540)),
    LoadScene = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA15B0)),
    GetUsedMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA15D0)),
    GetStreamingMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA15E0)),
    SetRequiredVehicleModels = ffi.cast('void(__thiscall*)(SCGame*, unsigned char*)', sampapi.GetAddress(0xA1610)),
    GetTimer = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1770)),
    LoadAnimationsAndModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA18A0)),
    LoadCollisionFile = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA1B80)),
    LoadCullZone = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0xA1BA0)),
    UsingGamepad = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1BC0)),
    DisableAutoAiming = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1BD0)),
    EnableHUD = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0xA1DB0)),
    SetCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, SCVector*, SCVector*)', sampapi.GetAddress(0xA1DE0)),
    CreateRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1EA0)),
    ProcessCheckpoints = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1F20)),
    ResetMoney = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA20C0)),
    SetRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, int, SCVector*, SCVector*, float)', sampapi.GetAddress(0xA2100)),
    EnableRadar = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0xA0CC0)),
    GetWindowHandle = ffi.cast('void*(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D10)),
    GetAudio = ffi.cast('SCAudio * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D20)),
    GetCamera = ffi.cast('SCCamera * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D30)),
    DoesHeadMoves = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D40)),
    EnableClock = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0xA1460)),
    Sleep = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0xA0090)),
    CreatePed = ffi.cast('SCPed * (__thiscall*)(SCGame*, int, SCVector, float, int, int)', sampapi.GetAddress(0xA0110)),
    RemovePed = ffi.cast('BOOL(__thiscall*)(SCGame*, SCPed*)', sampapi.GetAddress(0xA0210)),
    CreateVehicle = ffi.cast('SCVehicle * (__thiscall*)(SCGame*, int, SCVector, float, BOOL)', sampapi.GetAddress(0xA0250)),
    CreateObject = ffi.cast('SCObject * (__thiscall*)(SCGame*, int, SCVector, SCVector, float, char, char)', sampapi.GetAddress(0xA0330)),
    ProcessInputEnabling = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA05D0)),
    ProcessFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0xA1C10)),
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